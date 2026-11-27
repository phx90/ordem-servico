-- Tabelas do controle de ordens de serviço

create table clientes (
  id         number generated always as identity primary key,
  nome       varchar2(100) not null,
  telefone   varchar2(20)  not null,
  email      varchar2(100),
  ativo      char(1) default 'S' not null,
  criado_em  date    default sysdate not null,
  constraint ck_clientes_ativo check (ativo in ('S', 'N'))
);

create table tecnicos (
  id     number generated always as identity primary key,
  nome   varchar2(100) not null,
  ativo  char(1) default 'S' not null,
  constraint ck_tecnicos_ativo check (ativo in ('S', 'N'))
);

create table ordens_servico (
  id               number generated always as identity primary key,
  cliente_id       number        not null,
  tecnico_id       number,
  equipamento      varchar2(100) not null,
  numero_serie     varchar2(50),
  defeito_relatado varchar2(500) not null,
  diagnostico      varchar2(1000),
  valor_servico    number(12,2),
  valor_pecas      number(12,2),
  status           varchar2(15) default 'ABERTA' not null,
  aberta_em        date default sysdate not null,
  previsao         date,
  concluida_em     date,
  entregue_em      date,
  constraint fk_os_cliente foreign key (cliente_id) references clientes (id),
  constraint fk_os_tecnico foreign key (tecnico_id) references tecnicos (id),
  constraint ck_os_status check (status in ('ABERTA', 'EM_ANDAMENTO', 'PRONTA', 'ENTREGUE', 'CANCELADA')),
  constraint ck_os_valores check (nvl(valor_servico, 0) >= 0 and nvl(valor_pecas, 0) >= 0)
);

create index ix_os_cliente on ordens_servico (cliente_id);
create index ix_os_status  on ordens_servico (status);

-- toda troca de status fica registrada aqui
create table os_historico (
  id          number generated always as identity primary key,
  os_id       number       not null,
  status_de   varchar2(15),
  status_para varchar2(15) not null,
  observacao  varchar2(500),
  data        date default sysdate not null,
  constraint fk_hist_os foreign key (os_id) references ordens_servico (id)
);

create index ix_hist_os on os_historico (os_id);
