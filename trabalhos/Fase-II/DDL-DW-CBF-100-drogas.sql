DROP SCHEMA IF EXISTS dw_cbf CASCADE;

CREATE SCHEMA dw_cbf;

SET search_path TO dw_cbf;

CREATE TABLE DimCalendario
(
  SKCalendario VARCHAR NOT NULL,
  DtAno INT NOT NULL,
  DtMes INT NOT NULL,
  DtDia INT NOT NULL,
  DtCompleta DATE NOT NULL,
  PRIMARY KEY (SKCalendario)
);

CREATE TABLE DimProduto
(
  SKProduto VARCHAR NOT NULL,
  NomeProduto VARCHAR(200) NOT NULL,
  IDProduto INT NOT NULL,
  PrecVenda FLOAT NOT NULL,
  IDPrateleira INT NOT NULL,
  PRIMARY KEY (SKProduto)
);

CREATE TABLE DimCliente
(
  SKCliente VARCHAR NOT NULL,
  IDCliente INT NOT NULL,
  NomeCliente VARCHAR(200) NOT NULL,
  BairroCliente VARCHAR(200) NOT NULL,
  RuaCliente VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKCliente)
);

CREATE TABLE FatoReceita
(
  IDReceita INT NOT NULL,
  Quantidade INT NOT NULL,
  SKCalendario VARCHAR NOT NULL,
  SKProduto VARCHAR NOT NULL,
  SKCliente VARCHAR NOT NULL,
  PRIMARY KEY (IDReceita),
  FOREIGN KEY (SKCalendario) REFERENCES DimCalendario(SKCalendario),
  FOREIGN KEY (SKProduto) REFERENCES DimProduto(SKProduto),
  FOREIGN KEY (SKCliente) REFERENCES DimCliente(SKCliente)
);

CREATE TABLE DimFornecedor
(
  SKFornecedor VARCHAR NOT NULL,
  IDFornecedor INT NOT NULL,
  CNPJ VARCHAR(200) NOT NULL,
  NomeFornecedor VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKFornecedor)
);

CREATE TABLE FatoDespesa
(
  IDDespesa INT NOT NULL,
  Quantidade INT NOT NULL,
  PrecoCompra INT NOT NULL,
  SKFornecedor VARCHAR NOT NULL,
  SKCalendario VARCHAR NOT NULL,
  SKProduto VARCHAR NOT NULL,
  PRIMARY KEY (IDDespesa),
  FOREIGN KEY (SKFornecedor) REFERENCES DimFornecedor(SKFornecedor),
  FOREIGN KEY (SKCalendario) REFERENCES DimCalendario(SKCalendario),
  FOREIGN KEY (SKProduto) REFERENCES DimProduto(SKProduto)
);