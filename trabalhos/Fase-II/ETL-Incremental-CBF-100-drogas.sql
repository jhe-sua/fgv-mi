SET search_path TO dw_cbf;

DO $$
BEGIN
    -- ---------------------------------------------------
    -- DIMENSAO CLIENTE (SCD TIPO 2)
    -- ---------------------------------------------------
    UPDATE dw_cbf.DimCliente
    SET DtFimCliente = CURRENT_DATE - INTERVAL '1 day', FlagAtualCliente = FALSE
    WHERE FlagAtualCliente = TRUE 
      AND IDCliente IN (
          SELECT idcliente FROM audit_cbf.inc_cliente WHERE processado = FALSE
      );

    INSERT INTO dw_cbf.DimCliente (SKCliente, IDCliente, NomeCliente, BairroCliente, RuaCliente, MunicipioCliente, UFCliente, DtInicioCliente, DtFimCliente, FlagAtualCliente)
    SELECT
        gen_random_uuid()::varchar, log.idcliente, log.nomecliente, log.bairro, log.rua, m.NomeMunicipio, m.IDUF, log.data_operacao::date, '9999-12-31'::date, TRUE
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY id_audit DESC) as rn
        FROM audit_cbf.inc_cliente
        WHERE processado = FALSE
    ) log
    LEFT JOIN oper_cbf.Municipio m ON log.idmunicipio = m.IDMunicipio AND log.iduf = m.IDUF
    WHERE log.rn = 1;

    UPDATE audit_cbf.inc_cliente SET processado = TRUE WHERE processado = FALSE;

    -- ---------------------------------------------------
    -- DIMENSAO PRODUTO (SCD TIPO 1)
    -- ---------------------------------------------------
    DROP TABLE IF EXISTS tmp_log_produto;

    CREATE TEMP TABLE tmp_log_produto AS (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY idproduto ORDER BY id_audit DESC) as rn
        FROM audit_cbf.inc_produto
        WHERE processado = FALSE
    );

    -- 1. Atualiza registros existentes (Sobrescreve)
    -- Adicionado COALESCE para evitar erro de NOT NULL se o produto perder a categoria
    UPDATE dw_cbf.DimProduto dwp
    SET NomeProduto = log.nomeproduto, 
        PrecVenda = log.precvenda, 
        IDPrateleira = log.idpratileira,
        CategProduto = COALESCE(cu.NomeCategoria, 'Sem Categoria') 
    FROM tmp_log_produto log
    LEFT JOIN (
        SELECT pc.IDProduto, c.NomeCategoria, ROW_NUMBER() OVER (PARTITION BY pc.IDProduto ORDER BY pc.IDCategoria) rn_cat
        FROM oper_cbf.ProdCateg pc INNER JOIN oper_cbf.Categoria c ON pc.IDCategoria = c.IDCategoria
    ) cu ON cu.IDProduto = log.idproduto AND cu.rn_cat = 1
    WHERE log.rn = 1 AND dwp.IDProduto = log.idproduto;

    -- 2. Insere novos registros
    -- Adicionado COALESCE no SELECT para garantir que CategProduto nunca seja nulo
    INSERT INTO dw_cbf.DimProduto (SKProduto, NomeProduto, IDProduto, PrecVenda, IDPrateleira, CategProduto)
    SELECT
        gen_random_uuid()::varchar, 
        log.nomeproduto, 
        log.idproduto, 
        log.precvenda, 
        log.idpratileira, 
        COALESCE(cu.NomeCategoria, 'Sem Categoria') 
    FROM tmp_log_produto log
    LEFT JOIN (
        SELECT pc.IDProduto, c.NomeCategoria, ROW_NUMBER() OVER (PARTITION BY pc.IDProduto ORDER BY pc.IDCategoria) rn_cat
        FROM oper_cbf.ProdCateg pc INNER JOIN oper_cbf.Categoria c ON pc.IDCategoria = c.IDCategoria
    ) cu ON cu.IDProduto = log.idproduto AND cu.rn_cat = 1
    WHERE log.rn = 1
      AND NOT EXISTS (SELECT 1 FROM dw_cbf.DimProduto d WHERE d.IDProduto = log.idproduto);

    -- Descarta a tabela temporária
    DROP TABLE tmp_log_produto;

    -- Marca como processado
    UPDATE audit_cbf.inc_produto SET processado = TRUE WHERE processado = FALSE;

END $$;