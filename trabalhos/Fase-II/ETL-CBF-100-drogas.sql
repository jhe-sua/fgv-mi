set search_path to dw_cbf;

TRUNCATE TABLE
    dimcalendario,
    dimcliente,
    dimfornecedor,
    dimproduto,
    fatodespesa,
    FatoReceitaDetalhada,
    FatoReceitaAgregada
CASCADE;

INSERT INTO dw_cbf.dimcliente (
    SKCliente,
    IDCliente,
    NomeCliente,
    BairroCliente,
    RuaCliente,
    MunicipioCliente,
    UFCliente,
    DtInicioCliente,
    DtFimCliente,
    FlagAtualCliente
)
SELECT
    gen_random_uuid()::varchar, -- Gera a Surrogate Key única em texto
    c.idcliente,
    c.nomecliente,
    c.bairro,
    c.rua,
    m.NomeMunicipio,
    m.IDUF AS Estado,
    CURRENT_DATE,               -- DtInicioCliente: Data atual do carregamento
    '9999-12-31'::date,         -- DtFimCliente: Data limite para registro ativo
    TRUE                        -- FlagAtualCliente: TRUE/1 (registro ativo)
FROM
    oper_cbf.cliente c
    LEFT JOIN oper_cbf.Municipio m
        ON  c.IDMunicipio = m.IDMunicipio 
        AND c.IDUF = m.IDUF;

INSERT INTO dimfornecedor
select
    gen_random_uuid(),
    f.idfornecedor,
    f.cnpj,
    f.nomefornecedor
from
    oper_cbf.fornecedor f;

with CategoriaUnica AS (
    SELECT 
        pc.IDProduto,
        c.NomeCategoria,
        ROW_NUMBER() OVER(PARTITION BY pc.IDProduto ORDER BY pc.IDCategoria) as rn
    FROM oper_cbf.ProdCateg pc
    INNER JOIN oper_cbf.Categoria c ON pc.IDCategoria = c.IDCategoria
)

INSERT INTO dimproduto
select
    gen_random_uuid(),
    p.nomeproduto,
    p.idproduto,
    p.precvenda,
    p.idpratileira,
    cu.NomeCategoria
from
    oper_cbf.produto p
    LEFT JOIN CategoriaUnica cu ON p.IDProduto = cu.IDProduto AND cu.rn = 1;
    

INSERT INTO dimcalendario
select
    gen_random_uuid(),
    a.dtano,
    a.dtmes,
    a.dtdia,
    a.dtcompleta,
    a.dttrimeste,
    a.dtsemana
from (
    select distinct
        extract(year from cp.datacompra)    as dtano,
        extract(month from cp.datacompra)   as dtmes,
        extract(day from cp.datacompra)     as dtdia,
        cast(cp.datacompra as date)         as dtcompleta,
        extract(quarter from cp.datacompra) as dttrimeste,
        to_char(cp.datacompra, 'Day')       as dtSemana
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
    a.dtcompleta,
    a.dttrimeste,
    a.dtsemana
from (
    select distinct
        extract(year from fe.datacompra)    as dtano,
        extract(month from fe.datacompra)   as dtmes,
        extract(day from fe.datacompra)     as dtdia,
        cast(fe.datacompra as date)         as dtcompleta,
        extract(quarter from fe.datacompra) as dttrimeste,
        to_char(fe.datacompra, 'Day')       as dtSemana
    from
        oper_cbf.fornestoque fe
    where 
        cast(fe.datacompra as date) not in (select dtcompleta from dw_cbf.dimcalendario)
) as a;

INSERT INTO FatoReceitaDetalhada
select
    cp.idcompra as idreceitadet,
    CAST(cp.datacompra as TIME) as hora,
    cp.quantidade,
    cp.quantidade * p.PrecVenda as Valor,
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

INSERT INTO FatoReceitaAgregada
select
    SUM(quantidade) AS QuantidadeTotal,
    SUM(Valor) AS ValorTotal,
    SKCalendario,
    SKProduto,
    SKCliente
from
    FatoReceitaDetalhada
group by
    SKCalendario,
    SKProduto,
    SKCliente;

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
CREATE OR REPLACE VIEW vw_fatoreceita_detalhada AS
SELECT 
    fr.Valor AS valor_total_receita,
    fr.quantidade,
    fr.idcompra AS id_pedido,
    fr.hora,
    cli.nomecliente,
    cli.RuaCliente,
    cli.BairroCliente,
    cli.MunicipioCliente,
    cli.UFCliente,
    dp.nomeproduto,
    dp.categproduto,
    dp.precvenda,
    dc.dtcompleta AS data_transacao,
    dc.dtsemana AS dia_da_semana,
    dc.dtdia AS dia,
    dc.dtmes AS mes,
    dc.dttrimestre AS trismeste,
    dc.dtano AS ano
FROM dw_cbf.FatoReceitaDetalhada fr
JOIN dw_cbf.dimcalendario dc ON fr.SKCalendario = dc.SKCalendario
JOIN dw_cbf.dimproduto dp ON fr.SKProduto = dp.SKProduto
JOIN dw_cbf.dimcliente cli ON fr.SKCliente = cli.SKCliente;

CREATE OR REPLACE VIEW vw_fatoreceita_agregada AS
SELECT 
    fa.ValorTotal AS valor_total_receita,
    fa.QuantidadeTotal AS quantidade_vendida_dia,
    cli.nomecliente,
    cli.RuaCliente,
    cli.BairroCliente,
    cli.MunicipioCliente,
    cli.UFCliente,
    dp.nomeproduto,
    dp.categproduto,
    dp.precvenda,
    dc.dtcompleta AS data_transacao,
    dc.dtsemana AS dia_da_semana,
    dc.dtdia AS dia,
    dc.dtmes AS mes,
    dc.dttrimestre AS trismeste,
    dc.dtano AS ano
FROM dw_cbf.FatoReceitaAgregada fa
JOIN dw_cbf.dimcalendario dc ON fa.SKCalendario = dc.SKCalendario
JOIN dw_cbf.dimproduto dp ON fa.SKProduto = dp.SKProduto
JOIN dw_cbf.dimcliente cli ON fa.SKCliente = cli.SKCliente;

-- View para Despesas
CREATE OR REPLACE VIEW vw_fatodespesa AS
SELECT 
    fd.iddespesa,
    dc.dtcompleta AS data_transacao,
    dc.dtsemana AS dia_da_semana,
    dc.dtdia AS dia,
    dc.dtmes AS mes,
    dc.dttrimestre AS trismeste,
    dc.dtano AS ano,
    df.nomefornecedor,
    dp.nomeproduto,
    dp.categproduto,
    fd.quantidade,
    (fd.precocompra / fd.quantidade) AS preco_unitario,
    fd.precocompra AS valor_total_despesa
FROM dw_cbf.fatodespesa fd
JOIN dw_cbf.dimcalendario dc ON fd.SKCalendario = dc.SKCalendario
JOIN dw_cbf.dimproduto dp ON fd.SKProduto = dp.SKProduto
JOIN dw_cbf.dimfornecedor df ON fd.SKFornecedor = df.SKFornecedor;