create or replace package pkg_os as

  function abrir(
    p_cliente_id   in number,
    p_equipamento  in varchar2,
    p_defeito      in varchar2,
    p_numero_serie in varchar2 default null,
    p_previsao     in date     default null
  ) return number;

  procedure iniciar(p_os_id in number, p_tecnico_id in number);

  procedure registrar_diagnostico(
    p_os_id         in number,
    p_diagnostico   in varchar2,
    p_valor_servico in number,
    p_valor_pecas   in number default 0
  );

  procedure concluir(p_os_id in number);

  procedure entregar(p_os_id in number);

  procedure cancelar(p_os_id in number, p_motivo in varchar2);

  function valor_total(p_os_id in number) return number;

end pkg_os;
/

create or replace package body pkg_os as

  c_aberta       constant varchar2(15) := 'ABERTA';
  c_em_andamento constant varchar2(15) := 'EM_ANDAMENTO';
  c_pronta       constant varchar2(15) := 'PRONTA';
  c_entregue     constant varchar2(15) := 'ENTREGUE';
  c_cancelada    constant varchar2(15) := 'CANCELADA';

  e_nao_encontrada     constant pls_integer := -20001;
  e_status_invalido    constant pls_integer := -20002;
  e_cliente_inativo    constant pls_integer := -20003;
  e_tecnico_inativo    constant pls_integer := -20004;
  e_campo_obrigatorio  constant pls_integer := -20005;
  e_valor_invalido     constant pls_integer := -20006;

  -- trava a OS enquanto muda o status, pra duas telas não mexerem juntas
  function status_com_lock(p_os_id in number) return varchar2 is
    v_status ordens_servico.status%type;
  begin
    select status
      into v_status
      from ordens_servico
     where id = p_os_id
       for update;

    return v_status;
  exception
    when no_data_found then
      raise_application_error(e_nao_encontrada, 'OS ' || p_os_id || ' não encontrada.');
  end;

  procedure exigir_status(p_os_id in number, p_permitidos in varchar2) is
    v_status ordens_servico.status%type := status_com_lock(p_os_id);
  begin
    if instr(',' || p_permitidos || ',', ',' || v_status || ',') > 0 then
      return;
    end if;

    raise_application_error(e_status_invalido,
      'OS ' || p_os_id || ' está ' || v_status || ' e não permite essa operação.');
  end;

  procedure exigir_texto(p_valor in varchar2, p_campo in varchar2) is
  begin
    if trim(p_valor) is null then
      raise_application_error(e_campo_obrigatorio, 'Informe ' || p_campo || '.');
    end if;
  end;

  procedure mudar_status(
    p_os_id      in number,
    p_novo       in varchar2,
    p_observacao in varchar2 default null
  ) is
    v_anterior ordens_servico.status%type;
  begin
    select status into v_anterior from ordens_servico where id = p_os_id;

    update ordens_servico set status = p_novo where id = p_os_id;

    insert into os_historico (os_id, status_de, status_para, observacao)
    values (p_os_id, v_anterior, p_novo, p_observacao);
  end;

  function abrir(
    p_cliente_id   in number,
    p_equipamento  in varchar2,
    p_defeito      in varchar2,
    p_numero_serie in varchar2 default null,
    p_previsao     in date     default null
  ) return number is
    v_ativo clientes.ativo%type;
    v_os_id ordens_servico.id%type;
  begin
    exigir_texto(p_equipamento, 'o equipamento');
    exigir_texto(p_defeito, 'o defeito relatado');

    begin
      select ativo into v_ativo from clientes where id = p_cliente_id;
    exception
      when no_data_found then
        raise_application_error(e_nao_encontrada, 'Cliente ' || p_cliente_id || ' não encontrado.');
    end;

    if v_ativo <> 'S' then
      raise_application_error(e_cliente_inativo, 'Cliente inativo não pode abrir OS.');
    end if;

    if p_previsao < trunc(sysdate) then
      raise_application_error(e_valor_invalido, 'A previsão não pode ser no passado.');
    end if;

    insert into ordens_servico (cliente_id, equipamento, numero_serie, defeito_relatado, previsao)
    values (p_cliente_id, trim(p_equipamento), trim(p_numero_serie), trim(p_defeito), p_previsao)
    returning id into v_os_id;

    insert into os_historico (os_id, status_para, observacao)
    values (v_os_id, c_aberta, 'OS aberta');

    return v_os_id;
  end;

  procedure iniciar(p_os_id in number, p_tecnico_id in number) is
    v_ativo tecnicos.ativo%type;
  begin
    exigir_status(p_os_id, c_aberta);

    begin
      select ativo into v_ativo from tecnicos where id = p_tecnico_id;
    exception
      when no_data_found then
        raise_application_error(e_nao_encontrada, 'Técnico ' || p_tecnico_id || ' não encontrado.');
    end;

    if v_ativo <> 'S' then
      raise_application_error(e_tecnico_inativo, 'Técnico inativo não pode assumir OS.');
    end if;

    update ordens_servico set tecnico_id = p_tecnico_id where id = p_os_id;
    mudar_status(p_os_id, c_em_andamento);
  end;

  procedure registrar_diagnostico(
    p_os_id         in number,
    p_diagnostico   in varchar2,
    p_valor_servico in number,
    p_valor_pecas   in number default 0
  ) is
  begin
    exigir_status(p_os_id, c_em_andamento);
    exigir_texto(p_diagnostico, 'o diagnóstico');

    if p_valor_servico is null or p_valor_servico < 0 or nvl(p_valor_pecas, 0) < 0 then
      raise_application_error(e_valor_invalido, 'Valores do serviço e das peças não podem ser negativos.');
    end if;

    update ordens_servico
       set diagnostico   = trim(p_diagnostico),
           valor_servico = p_valor_servico,
           valor_pecas   = nvl(p_valor_pecas, 0)
     where id = p_os_id;
  end;

  procedure concluir(p_os_id in number) is
    v_diagnostico ordens_servico.diagnostico%type;
  begin
    exigir_status(p_os_id, c_em_andamento);

    select diagnostico into v_diagnostico from ordens_servico where id = p_os_id;

    if v_diagnostico is null then
      raise_application_error(e_campo_obrigatorio, 'Registre o diagnóstico antes de concluir a OS.');
    end if;

    update ordens_servico set concluida_em = sysdate where id = p_os_id;
    mudar_status(p_os_id, c_pronta);
  end;

  procedure entregar(p_os_id in number) is
  begin
    exigir_status(p_os_id, c_pronta);
    update ordens_servico set entregue_em = sysdate where id = p_os_id;
    mudar_status(p_os_id, c_entregue);
  end;

  procedure cancelar(p_os_id in number, p_motivo in varchar2) is
  begin
    exigir_status(p_os_id, c_aberta || ',' || c_em_andamento);
    exigir_texto(p_motivo, 'o motivo do cancelamento');
    mudar_status(p_os_id, c_cancelada, trim(p_motivo));
  end;

  function valor_total(p_os_id in number) return number is
    v_total number;
  begin
    select nvl(valor_servico, 0) + nvl(valor_pecas, 0)
      into v_total
      from ordens_servico
     where id = p_os_id;

    return v_total;
  exception
    when no_data_found then
      raise_application_error(e_nao_encontrada, 'OS ' || p_os_id || ' não encontrada.');
  end;

end pkg_os;
/
