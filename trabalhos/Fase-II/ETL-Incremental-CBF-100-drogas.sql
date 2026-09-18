
-- 1. ESQUEMA E TABELAS ESPECIFICAS DE AUDITORIA
 
DROP SCHEMA IF EXISTS audit_cbf CASCADE;
CREATE SCHEMA audit_cbf;

-- Espelho para Cliente
CREATE TABLE audit_cbf.inc_cliente (
    id_audit SERIAL PRIMARY KEY,
    acao CHAR(1), -- 'I' (Insert), 'U' (Update)
    processado BOOLEAN DEFAULT FALSE,
    idcliente INT,
    nomecliente VARCHAR(255),
    bairro VARCHAR(255),
    rua VARCHAR(255),
    idmunicipio INT,
    iduf VARCHAR(2)
);

-- Espelho para Produto
CREATE TABLE audit_cbf.inc_produto (
    id_audit SERIAL PRIMARY KEY,
    acao CHAR(1),
    processado BOOLEAN DEFAULT FALSE,
    idproduto INT,
    precvenda FLOAT,
    nomeproduto VARCHAR(255),
    idpratileira INT
);


-- 2. FUNCOES E TRIGGERS NO OPERACIONAL

CREATE OR REPLACE FUNCTION audit_cbf.fn_inc_cliente() RETURNS trigger AS $$
BEGIN
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        INSERT INTO audit_cbf.inc_cliente (acao, idcliente, nomecliente, bairro, rua, idmunicipio, iduf)
        VALUES (SUBSTRING(TG_OP, 1, 1), NEW.idcliente, NEW.nomecliente, NEW.bairro, NEW.rua, NEW.idmunicipio, NEW.iduf);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inc_cliente AFTER INSERT OR UPDATE ON oper_cbf.Cliente
FOR EACH ROW EXECUTE PROCEDURE audit_cbf.fn_inc_cliente();

CREATE OR REPLACE FUNCTION audit_cbf.fn_inc_produto() RETURNS trigger AS $$
BEGIN
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        INSERT INTO audit_cbf.inc_produto (acao, idproduto, precvenda, nomeproduto, idpratileira)
        VALUES (SUBSTRING(TG_OP, 1, 1), NEW.idproduto, NEW.precvenda, NEW.nomeproduto, NEW.idpratileira);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inc_produto AFTER INSERT OR UPDATE ON oper_cbf.Produto
FOR EACH ROW EXECUTE PROCEDURE audit_cbf.fn_inc_produto();


-- 3. ETL INCREMENTAL (RODAR NO DW)

SET search_path TO dw_cbf;

DO $$
BEGIN
    -- ---------------------------------------------------
    -- DIMENSAO CLIENTE (SCD TIPO 2)
    -- ---------------------------------------------------
    -- 1. Desativa o registro atual em caso de Update
    UPDATE dw_cbf.DimCliente dwc
    SET DtFimCliente = CURRENT_DATE - INTERVAL '1 day', FlagAtualCliente = FALSE
    FROM (
        SELECT idcliente FROM audit_cbf.inc_cliente WHERE processado = FALSE AND acao = 'U'
    ) log
    WHERE log.idcliente = dwc.IDCliente AND dwc.FlagAtualCliente = TRUE;

    -- 2. Insere os novos registros (Inserts e Updates viram novas linhas)
    INSERT INTO dw_cbf.DimCliente (SKCliente, IDCliente, NomeCliente, BairroCliente, RuaCliente, MunicipioCliente, UFCliente, DtInicioCliente, DtFimCliente, FlagAtualCliente)
    SELECT
        gen_random_uuid()::varchar, log.idcliente, log.nomecliente, log.bairro, log.rua, m.NomeMunicipio, m.IDUF, CURRENT_DATE, '9999-12-31'::date, TRUE
    FROM audit_cbf.inc_cliente log
    LEFT JOIN oper_cbf.Municipio m ON log.idmunicipio = m.IDMunicipio AND log.iduf = m.IDUF
    WHERE log.processado = FALSE;

    -- Marca como processado
    UPDATE audit_cbf.inc_cliente SET processado = TRUE WHERE processado = FALSE;

    -- ---------------------------------------------------
    -- DIMENSAO PRODUTO (SCD TIPO 1)
    -- ---------------------------------------------------
    -- 1. Atualiza registros existentes (Sobrescreve)
    UPDATE dw_cbf.DimProduto dwp
    SET NomeProduto = log.nomeproduto, PrecVenda = log.precvenda, IDPrateleira = log.idpratileira,
        CategProduto = cu.NomeCategoria
    FROM audit_cbf.inc_produto log
    LEFT JOIN (
        SELECT pc.IDProduto, c.NomeCategoria, ROW_NUMBER() OVER (PARTITION BY pc.IDProduto ORDER BY pc.IDCategoria) rn
        FROM oper_cbf.ProdCateg pc INNER JOIN oper_cbf.Categoria c ON pc.IDCategoria = c.IDCategoria
    ) cu ON cu.IDProduto = log.idproduto AND cu.rn = 1
    WHERE log.processado = FALSE AND log.acao = 'U' AND dwp.IDProduto = log.idproduto;

    -- 2. Insere novos registros
    INSERT INTO dw_cbf.DimProduto (SKProduto, NomeProduto, IDProduto, PrecVenda, IDPrateleira, CategProduto)
    SELECT
        gen_random_uuid()::varchar, log.nomeproduto, log.idproduto, log.precvenda, log.idpratileira, cu.NomeCategoria
    FROM audit_cbf.inc_produto log
    LEFT JOIN (
        SELECT pc.IDProduto, c.NomeCategoria, ROW_NUMBER() OVER (PARTITION BY pc.IDProduto ORDER BY pc.IDCategoria) rn
        FROM oper_cbf.ProdCateg pc INNER JOIN oper_cbf.Categoria c ON pc.IDCategoria = c.IDCategoria
    ) cu ON cu.IDProduto = log.idproduto AND cu.rn = 1
    WHERE log.processado = FALSE AND log.acao = 'I'
    AND NOT EXISTS (SELECT 1 FROM dw_cbf.DimProduto d WHERE d.IDProduto = log.idproduto);

    -- Marca como processado
    UPDATE audit_cbf.inc_produto SET processado = TRUE WHERE processado = FALSE;

END $$;