DROP SCHEMA IF EXISTS dw_cbf CASCADE;

CREATE SCHEMA dw_cbf;

SET search_path TO dw_cbf;

CREATE TABLE DimCalendario
(
  SKCalendario CHAR(200) NOT NULL,
  DtAno INT NOT NULL,
  DtMes INT NOT NULL,
  DtDia INT NOT NULL,
  DtCompleta DATE NOT NULL,
  DtTrimestre INT NOT NULL,
  DtSemana VARCHAR(20) NOT NULL,
  PRIMARY KEY (SKCalendario)
);

CREATE TABLE DimProduto
(
  SKProduto VARCHAR(200) NOT NULL,
  NomeProduto VARCHAR(200) NOT NULL,
  IDProduto INT NOT NULL,
  PrecVenda FLOAT NOT NULL,
  IDPrateleira INT NOT NULL,
  CategProduto VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKProduto)
);

CREATE TABLE DimCliente
(
  SKCliente VARCHAR(200) NOT NULL,
  IDCliente INT NOT NULL,
  NomeCliente VARCHAR(200) NOT NULL,
  BairroCliente VARCHAR(200) NOT NULL,
  RuaCliente VARCHAR(200) NOT NULL,
  MunicipioCliente VARCHAR(200) NOT NULL,
  UFCliente VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKCliente)
);

CREATE TABLE DimFornecedor
(
  SKFornecedor VARCHAR(200) NOT NULL,
  IDFornecedor INT NOT NULL,
  CNPJ VARCHAR(200) NOT NULL,
  NomeFornecedor VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKFornecedor)
);

CREATE TABLE FatoDespesa
(
  IDDespesa INT NOT NULL,
  Quantidade INT NOT NULL,
  PrecoCompra FLOAT NOT NULL,
  SKFornecedor VARCHAR(200) NOT NULL,
  SKCalendario CHAR(200) NOT NULL,
  SKProduto VARCHAR(200) NOT NULL,
  PRIMARY KEY (IDDespesa),
  FOREIGN KEY (SKFornecedor) REFERENCES DimFornecedor(SKFornecedor),
  FOREIGN KEY (SKCalendario) REFERENCES DimCalendario(SKCalendario),
  FOREIGN KEY (SKProduto) REFERENCES DimProduto(SKProduto)
);

CREATE TABLE FatoReceitaDetalhada
(
  IDCompra INT NOT NULL,
  Hora TIME NOT NULL,
  Quantidade INT NOT NULL,
  Valor FLOAT NOT NULL,
  SKCalendario CHAR(200) NOT NULL,
  SKProduto VARCHAR(200) NOT NULL,
  SKCliente VARCHAR(200) NOT NULL,
  PRIMARY KEY (IDCompra, SKProduto),
  FOREIGN KEY (SKCalendario) REFERENCES DimCalendario(SKCalendario),
  FOREIGN KEY (SKProduto) REFERENCES DimProduto(SKProduto),
  FOREIGN KEY (SKCliente) REFERENCES DimCliente(SKCliente)
);

CREATE TABLE FatoReceitaAgregada
(
  QuantidadeTotal INT NOT NULL,
  ValorTotal FLOAT NOT NULL,
  SKCalendario CHAR(200) NOT NULL,
  SKProduto VARCHAR(200) NOT NULL,
  SKCliente VARCHAR(200) NOT NULL,
  PRIMARY KEY (SKCalendario, SKProduto, SKCliente),
  FOREIGN KEY (SKCalendario) REFERENCES DimCalendario(SKCalendario),
  FOREIGN KEY (SKProduto) REFERENCES DimProduto(SKProduto),
  FOREIGN KEY (SKCliente) REFERENCES DimCliente(SKCliente)
);