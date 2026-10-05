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
    oper_cbf.dimfornecedor f;

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
        to_char(cp.datacompra, 'MM')     as dtmes, -- Trocado "MM" por 'MM'
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
        to_char(fe.datacompra, 'MM')     as dtmes, -- Trocado "MM" por 'MM'
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
    fe.iddespesa,
    fe.quantidade,
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