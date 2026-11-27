-- Visão usada na listagem do Delphi e na API
create or replace view vw_os as
select os.id,
       os.status,
       os.equipamento,
       os.numero_serie,
       os.defeito_relatado,
       os.diagnostico,
       nvl(os.valor_servico, 0)                            as valor_servico,
       nvl(os.valor_pecas, 0)                              as valor_pecas,
       nvl(os.valor_servico, 0) + nvl(os.valor_pecas, 0)   as valor_total,
       os.aberta_em,
       os.previsao,
       os.concluida_em,
       os.entregue_em,
       trunc(nvl(os.entregue_em, sysdate)) - trunc(os.aberta_em) as dias_em_aberto,
       c.id       as cliente_id,
       c.nome     as cliente,
       c.telefone as telefone,
       t.nome     as tecnico
  from ordens_servico os
  join clientes c      on c.id = os.cliente_id
  left join tecnicos t on t.id = os.tecnico_id;

-- OS que passaram da previsão e ainda não ficaram prontas
create or replace view vw_os_atrasadas as
select *
  from vw_os
 where status in ('ABERTA', 'EM_ANDAMENTO')
   and previsao < trunc(sysdate);
