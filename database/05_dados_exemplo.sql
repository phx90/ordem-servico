-- Alguns dados pra testar as telas

insert into clientes (nome, telefone, email) values ('Marcos Antônio Silva', '(18) 99712-4580', 'marcos.silva@email.com');
insert into clientes (nome, telefone, email) values ('Juliana Ferreira',     '(18) 98144-2231', null);
insert into clientes (nome, telefone, email) values ('Padaria Pão Quente',   '(18) 3623-1190',  'contato@paoquente.com.br');
insert into clientes (nome, telefone, email) values ('Roberto Nakamura',     '(18) 99620-0073', null);

insert into tecnicos (nome) values ('Carlos');
insert into tecnicos (nome) values ('Fernanda');

declare
  v_os number;

  function cliente(p_nome in varchar2) return number is
    v_id number;
  begin
    select id into v_id from clientes where nome = p_nome;
    return v_id;
  end;

  function tecnico(p_nome in varchar2) return number is
    v_id number;
  begin
    select id into v_id from tecnicos where nome = p_nome;
    return v_id;
  end;
begin
  v_os := pkg_os.abrir(cliente('Marcos Antônio Silva'), 'Notebook Dell Inspiron 15', 'Não liga, só pisca a luz do carregador', 'DL3501-88A2');
  pkg_os.iniciar(v_os, tecnico('Carlos'));
  pkg_os.registrar_diagnostico(v_os, 'Conector de carga solto na placa. Ressoldado.', 180, 35);
  pkg_os.concluir(v_os);
  pkg_os.entregar(v_os);

  v_os := pkg_os.abrir(cliente('Juliana Ferreira'), 'Celular Samsung A54', 'Tela quebrada', null, trunc(sysdate) + 3);
  pkg_os.iniciar(v_os, tecnico('Fernanda'));
  pkg_os.registrar_diagnostico(v_os, 'Troca do display completo.', 120, 480);
  pkg_os.concluir(v_os);

  v_os := pkg_os.abrir(cliente('Padaria Pão Quente'), 'Impressora térmica Elgin i9', 'Imprimindo falhado', 'EL-I9-20211', trunc(sysdate) + 2);
  pkg_os.iniciar(v_os, tecnico('Carlos'));

  v_os := pkg_os.abrir(cliente('Roberto Nakamura'), 'PC gamer (gabinete)', 'Desliga sozinho jogando', null, trunc(sysdate) + 5);

  v_os := pkg_os.abrir(cliente('Padaria Pão Quente'), 'Monitor LG 22"', 'Sem imagem');
  pkg_os.cancelar(v_os, 'Cliente achou mais barato comprar um novo');
end;
/

commit;
