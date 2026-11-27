-- Cria tudo na ordem. Rodar conectado no schema do sistema:
--   sql os/os@localhost:1521/FREEPDB1 @instalar.sql

set define off
whenever sqlerror exit failure rollback

prompt Criando tabelas...
@@01_tabelas.sql

prompt Criando package...
@@02_pkg_os.sql

prompt Criando views...
@@03_views.sql

prompt Carregando dados de exemplo...
@@05_dados_exemplo.sql

prompt Pronto. A API (04_api_ords.sql) só roda se tiver ORDS.
