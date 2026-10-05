DROP SCHEMA IF EXISTS audit_cbf CASCADE;
CREATE SCHEMA audit_cbf;

-- Espelho para Cliente
CREATE TABLE audit_cbf.inc_cliente (
    id_audit SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acao CHAR(1), 
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
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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