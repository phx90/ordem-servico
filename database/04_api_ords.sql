-- API de consulta usada pela página web.
-- Precisa do ORDS instalado e rodando apontando pro banco.
--
-- GET /ords/os/consulta/:numero?telefone=1234
-- O cliente informa o número da OS e os 4 últimos dígitos do telefone,
-- assim ninguém consegue ver a OS dos outros só chutando número.

begin
  ords.enable_schema(
    p_enabled             => true,
    p_schema              => user,
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'os',
    p_auto_rest_auth      => false
  );

  ords.define_module(
    p_module_name    => 'consulta',
    p_base_path      => '/consulta/',
    p_items_per_page => 0
  );

  ords.define_template(
    p_module_name => 'consulta',
    p_pattern     => ':numero'
  );

  ords.define_handler(
    p_module_name    => 'consulta',
    p_pattern        => ':numero',
    p_method         => 'GET',
    p_source_type    => ords.source_type_collection_item,
    p_source         => q'[
      select v.id          as numero,
             v.status,
             v.equipamento,
             v.diagnostico,
             v.valor_total,
             to_char(v.aberta_em,    'YYYY-MM-DD') as aberta_em,
             to_char(v.previsao,     'YYYY-MM-DD') as previsao,
             to_char(v.concluida_em, 'YYYY-MM-DD') as concluida_em,
             to_char(v.entregue_em,  'YYYY-MM-DD') as entregue_em
        from vw_os v
       where v.id = :numero
         and substr(regexp_replace(v.telefone, '[^0-9]'), -4) = :telefone
    ]'
  );

  commit;
end;
/
