set search_path to dw_cbf;

TRUNCATE TABLE
    dimcalendario,
    dimcliente,
    dimfornecedor,
    dimproduto,
    fatodespesa,
    fatoreceita
CASCADE;

INSERT INTO dw_cbf.dimcliente
select
    gen_random_uuid(),
    c.idcliente,
    c.nomecliente,
    c.bairro,
    c.rua
from
    oper_cbf.cliente c;

INSERT INTO dimfornecedor
select
    gen_random_uuid(),
    f.idfornecedor,
    f.cnpj,
    f.nomefornecedor
from
    oper_cbf.fornecedor f;

INSERT INTO dimproduto
select
    gen_random_uuid(),
    p.nomeproduto,
    p.idproduto,
    p.precvenda,
    p.idpratileira
from
    oper_cbf.produto p;

INSERT INTO dimcalendario
select
    gen_random_uuid(),
    a.dtano,
    a.dtmes,
    a.dtdia,
    a.dtcompleta
from (
    select distinct
        extract(year from cp.datacompra) as dtano,
        extract(month from cp.datacompra)     as dtmes,
        extract(day from cp.datacompra)  as dtdia,
        cast(cp.datacompra as date)      as dtcompleta
    from
        oper_cbf.clicompraprod cp 
) as a;

-- Segunda inserção na dimcalendario
INSERT INTO dimcalendario
select
    gen_random_uuid(),
    a.dtano,
    a.dtmes,
    a.dtdia,
    a.dtcompleta
from (
    select distinct
        extract(year from fe.datacompra) as dtano,
        extract(month from fe.datacompra)     as dtmes,
        extract(day from fe.datacompra)  as dtdia,
        cast(fe.datacompra as date)      as dtcompleta
    from
        oper_cbf.fornestoque fe
    where 
        cast(fe.datacompra as date) not in (select dtcompleta from dw_cbf.dimcalendario)
) as a;

INSERT INTO fatoreceita
select
    cp.idcompra as idreceita,
    cp.quantidade,
    dwa.SKCalendario,
    dwp.SKProduto,
    dwc.SKCliente
from
    oper_cbf.clicompraprod cp
    inner join oper_cbf.produto p on p.idproduto = cp.idproduto
    inner join oper_cbf.cliente c on c.idcliente = cp.idcliente
    inner join dw_cbf.dimproduto dwp on dwp.idproduto = p.idproduto
    inner join dw_cbf.dimcliente dwc on dwc.idcliente = c.idcliente
    inner join dw_cbf.dimcalendario dwa on dwa.dtcompleta = cast(cp.datacompra as date);

INSERT INTO fatodespesa
select
    fe.idcompra,
    fe.qtdcompra,
    fe.precocompra,
    dwf.SKFornecedor,
    dwa.SKCalendario,
    dwp.SKProduto
from
    oper_cbf.fornestoque fe
    inner join oper_cbf.fornecedor f on f.idfornecedor = fe.idfornecedor
    inner join oper_cbf.produto p on p.idproduto = fe.idproduto
    inner join dw_cbf.dimfornecedor dwf on dwf.idfornecedor = f.idfornecedor
    inner join dw_cbf.dimproduto dwp on dwp.idproduto = p.idproduto
    inner join dw_cbf.dimcalendario dwa on dwa.dtcompleta = cast(fe.datacompra as date);

-- View para Receitas
CREATE OR REPLACE VIEW vw_fatoreceita AS
SELECT 
    fr.idreceita,
    dc.dtcompleta AS data_transacao,
    cli.nomecliente,
    dp.nomeproduto,
    fr.quantidade,
    dp.precvenda AS preco_unitario,
    (fr.quantidade * dp.precvenda) AS valor_total_receita
FROM dw_cbf.fatoreceita fr
JOIN dw_cbf.dimcalendario dc ON fr.SKCalendario = dc.SKCalendario
JOIN dw_cbf.dimproduto dp ON fr.SKProduto = dp.SKProduto
JOIN dw_cbf.dimcliente cli ON fr.SKCliente = cli.SKCliente;

-- View para Despesas
CREATE OR REPLACE VIEW vw_fatodespesa AS
SELECT 
    fd.iddespesa,
    dc.dtcompleta AS data_transacao,
    df.nomefornecedor,
    dp.nomeproduto,
    fd.quantidade,
    (fd.precocompra / fd.quantidade) AS preco_unitario,
    fd.precocompra AS valor_total_despesa
FROM dw_cbf.fatodespesa fd
JOIN dw_cbf.dimcalendario dc ON fd.SKCalendario = dc.SKCalendario
JOIN dw_cbf.dimproduto dp ON fd.SKProduto = dp.SKProduto
JOIN dw_cbf.dimfornecedor df ON fd.SKFornecedor = df.SKFornecedor;