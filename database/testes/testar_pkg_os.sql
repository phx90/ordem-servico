-- Testes das regras da pkg_os.
-- Não depende de framework: cada cenário roda e no fim tudo é desfeito com rollback.
--   sql os/os@localhost:1521/FREEPDB1 @testes/testar_pkg_os.sql

set serveroutput on
set feedback off
whenever sqlerror exit failure rollback

declare
  v_cliente  number;
  v_inativo  number;
  v_tecnico  number;
  v_os       number;
  v_qtd      number;
  v_passou   pls_integer := 0;
  v_falhou   pls_integer := 0;

  procedure ok(p_cenario in varchar2) is
  begin
    v_passou := v_passou + 1;
    dbms_output.put_line('  ok     ' || p_cenario);
  end;

  procedure falhou(p_cenario in varchar2, p_detalhe in varchar2) is
  begin
    v_falhou := v_falhou + 1;
    dbms_output.put_line('  FALHOU ' || p_cenario || ' -> ' || p_detalhe);
  end;

  procedure confere(p_cenario in varchar2, p_esperado in varchar2, p_obtido in varchar2) is
  begin
    if p_esperado = p_obtido then
      ok(p_cenario);
      return;
    end if;

    falhou(p_cenario, 'esperado ' || p_esperado || ', veio ' || nvl(p_obtido, '(nulo)'));
  end;

  -- roda um bloco que deveria dar erro e confere o código
  procedure espera_erro(p_cenario in varchar2, p_codigo in pls_integer, p_bloco in varchar2) is
  begin
    execute immediate 'begin ' || p_bloco || ' end;';
    falhou(p_cenario, 'não deu erro');
  exception
    when others then
      confere(p_cenario, to_char(p_codigo), to_char(sqlcode));
  end;

  function status_de(p_os in number) return varchar2 is
    v ordens_servico.status%type;
  begin
    select status into v from ordens_servico where id = p_os;
    return v;
  end;

  function nova_os return number is
  begin
    return pkg_os.abrir(v_cliente, 'Notebook teste', 'Não liga');
  end;
begin
  savepoint inicio_testes;

  insert into clientes (nome, telefone) values ('Cliente Teste', '(18) 90000-0001')
  returning id into v_cliente;
  insert into clientes (nome, telefone, ativo) values ('Cliente Inativo', '(18) 90000-0002', 'N')
  returning id into v_inativo;
  insert into tecnicos (nome) values ('Técnico Teste')
  returning id into v_tecnico;

  dbms_output.put_line('pkg_os');

  -- fluxo completo
  v_os := nova_os;
  confere('abre a OS como ABERTA', 'ABERTA', status_de(v_os));

  pkg_os.iniciar(v_os, v_tecnico);
  confere('iniciar passa para EM_ANDAMENTO', 'EM_ANDAMENTO', status_de(v_os));

  pkg_os.registrar_diagnostico(v_os, 'Fonte queimada', 150, 90.5);
  confere('valor total soma serviço e peças', '240.5', to_char(pkg_os.valor_total(v_os), 'FM9999990.0'));

  pkg_os.concluir(v_os);
  confere('concluir passa para PRONTA', 'PRONTA', status_de(v_os));

  pkg_os.entregar(v_os);
  confere('entregar passa para ENTREGUE', 'ENTREGUE', status_de(v_os));

  select count(*) into v_qtd from os_historico where os_id = v_os;
  confere('histórico tem uma linha por status', '4', to_char(v_qtd));

  -- regras de abertura
  espera_erro('não abre OS pra cliente inativo', -20003,
    'declare n number; begin n := pkg_os.abrir(' || v_inativo || ', ''PC'', ''x''); end;');
  espera_erro('não abre OS pra cliente que não existe', -20001,
    'declare n number; begin n := pkg_os.abrir(-1, ''PC'', ''x''); end;');
  espera_erro('exige o defeito relatado', -20005,
    'declare n number; begin n := pkg_os.abrir(' || v_cliente || ', ''PC'', ''  ''); end;');
  espera_erro('não aceita previsão no passado', -20006,
    'declare n number; begin n := pkg_os.abrir(' || v_cliente || ', ''PC'', ''x'', null, trunc(sysdate) - 1); end;');

  -- transições inválidas
  v_os := nova_os;
  espera_erro('não conclui OS que nem começou', -20002, 'pkg_os.concluir(' || v_os || ');');
  espera_erro('não entrega OS que não está pronta', -20002, 'pkg_os.entregar(' || v_os || ');');

  pkg_os.iniciar(v_os, v_tecnico);
  espera_erro('não conclui sem diagnóstico', -20005, 'pkg_os.concluir(' || v_os || ');');
  espera_erro('não aceita valor negativo', -20006,
    'pkg_os.registrar_diagnostico(' || v_os || ', ''x'', -10);');

  -- cancelamento
  espera_erro('cancelar exige motivo', -20005, 'pkg_os.cancelar(' || v_os || ', null);');
  pkg_os.cancelar(v_os, 'Cliente desistiu');
  confere('cancela OS em andamento', 'CANCELADA', status_de(v_os));
  espera_erro('não mexe em OS cancelada', -20002, 'pkg_os.iniciar(' || v_os || ', ' || v_tecnico || ');');

  v_os := nova_os;
  pkg_os.iniciar(v_os, v_tecnico);
  pkg_os.registrar_diagnostico(v_os, 'ok', 50);
  pkg_os.concluir(v_os);
  espera_erro('não cancela OS pronta', -20002, 'pkg_os.cancelar(' || v_os || ', ''x'');');

  espera_erro('OS inexistente', -20001, 'pkg_os.entregar(-1);');

  rollback to inicio_testes;

  dbms_output.put_line(chr(10) || v_passou || ' passaram, ' || v_falhou || ' falharam');

  if v_falhou > 0 then
    raise_application_error(-20999, 'Tem teste falhando.');
  end if;
end;
/
