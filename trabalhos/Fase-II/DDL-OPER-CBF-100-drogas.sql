DROP SCHEMA IF EXISTS oper_cbf CASCADE;

CREATE SCHEMA oper_cbf;

SET search_path TO oper_cbf;

-- 1. TABELAS SEM DEPENDÊNCIAS (Chaves Estrangeiras)
CREATE TABLE UF
(
  IDUF VARCHAR(2) NOT NULL,
  NomeUF VARCHAR(100) NOT NULL,
  PRIMARY KEY (IDUF)
);

CREATE TABLE Pratileira
(
  Capacidade INT NOT NULL,
  IDPratileira INT NOT NULL,
  Descricao INT NOT NULL,
  PRIMARY KEY (IDPratileira)
);

CREATE TABLE Fornecedor
(
  CNPJ VARCHAR(25) NOT NULL,
  NomeFornecedor VARCHAR(255) NOT NULL,
  IDForncecedor INT NOT NULL,
  PRIMARY KEY (IDForncecedor)
);

CREATE TABLE Categoria
(
  IDCategoria INT NOT NULL,
  NomeCategoria VARCHAR(255) NOT NULL,
  PRIMARY KEY (IDCategoria)
);

CREATE TABLE Enfermidades
(
  IDEnfermidade INT NOT NULL,
  NomeEnferm VARCHAR(255) NOT NULL,
  DescrEnferm VARCHAR(500) NOT NULL,
  PRIMARY KEY (IDEnfermidade)
);

-- 2. TABELAS COM DEPENDÊNCIAS DE 1º NÍVEL
CREATE TABLE Municipio
(
  IDMunicipio INT NOT NULL,
  NomeMunicipio VARCHAR(255) NOT NULL,
  IDUF VARCHAR(2) NOT NULL, -- Corrigido de INT para VARCHAR(2) para bater com a tabela UF
  PRIMARY KEY (IDMunicipio, IDUF),
  FOREIGN KEY (IDUF) REFERENCES UF(IDUF)
);

CREATE TABLE Produto
(
  IDProduto INT NOT NULL,
  PrecVenda FLOAT NOT NULL,
  NomeProduto VARCHAR(255) NOT NULL,
  DescrProd VARCHAR(500) NOT NULL,
  DtValidade DATE NOT NULL,
  IDPratileira INT NOT NULL,
  PRIMARY KEY (IDProduto),
  FOREIGN KEY (IDPratileira) REFERENCES Pratileira(IDPratileira)
);

CREATE TABLE FornTelefone
(
  Telefone INT NOT NULL,
  IDForncecedor INT NOT NULL,
  PRIMARY KEY (Telefone, IDForncecedor),
  FOREIGN KEY (IDForncecedor) REFERENCES Fornecedor(IDForncecedor)
);

-- 3. TABELAS COM DEPENDÊNCIAS DE 2º NÍVEL
CREATE TABLE Cliente
(
  Bairro VARCHAR(255) NOT NULL,
  Rua VARCHAR(255) NOT NULL,
  NomeCliente VARCHAR(255) NOT NULL,
  Senha VARCHAR(20) NOT NULL,
  IDCliente INT NOT NULL,
  EmailCliente VARCHAR(200) NOT NULL,
  IDMunicipio INT NOT NULL,
  IDUF VARCHAR(2) NOT NULL, -- Corrigido de INT para VARCHAR(2) para bater com a tabela Municipio
  PRIMARY KEY (IDCliente),
  FOREIGN KEY (IDMunicipio, IDUF) REFERENCES Municipio(IDMunicipio, IDUF),
  UNIQUE (EmailCliente)
);

CREATE TABLE Medicamento
(
  Indicacao VARCHAR(255) NOT NULL,
  Contraindicacao VARCHAR(255) NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDProduto),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE Vacina
(
  FabricanteVac VARCHAR(255) NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDProduto),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE ProdCateg
(
  IDProduto INT NOT NULL,
  IDCategoria INT NOT NULL,
  PRIMARY KEY (IDProduto, IDCategoria),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto),
  FOREIGN KEY (IDCategoria) REFERENCES Categoria(IDCategoria)
);

CREATE TABLE FornEstoque
(
  PrecoCompra FLOAT NOT NULL,
  DataCompra DATE NOT NULL,
  QtdCompra INT NOT NULL,
  IDCompra INT NOT NULL,
  IDForncecedor INT NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDCompra),
  FOREIGN KEY (IDForncecedor) REFERENCES Fornecedor(IDForncecedor),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

-- 4. TABELAS COM DEPENDÊNCIAS DE 3º NÍVEL (Exigem clientes, vacinas ou medicamentos)
CREATE TABLE CliTelefone
(
  TelefoneCliente INT NOT NULL,
  IDCliente INT NOT NULL,
  PRIMARY KEY (TelefoneCliente, IDCliente),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

CREATE TABLE CliCompraProd
(
  Quantidade INT NOT NULL,
  IDCompra INT NOT NULL,
  DataCompra DATE NOT NULL,
  IDCliente INT NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDProduto, IDCompra),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE CliEnferm
(
  DtCadEnferm DATE NOT NULL,
  IDCliente INT NOT NULL,
  IDEnfermidade INT NOT NULL,
  PRIMARY KEY (IDCliente, IDEnfermidade),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDEnfermidade) REFERENCES Enfermidades(IDEnfermidade)
);

CREATE TABLE InteracaoMedicamentosa
(
  DescrInteracaoMedicam VARCHAR(255) NOT NULL,
  IDProdutoX INT NOT NULL,
  IDProdutoY INT NOT NULL,
  PRIMARY KEY (IDProdutoX, IDProdutoY),
  FOREIGN KEY (IDProdutoX) REFERENCES Medicamento(IDProduto),
  FOREIGN KEY (IDProdutoY) REFERENCES Medicamento(IDProduto)
);

CREATE TABLE CliLembrete
(
  DtPAlarme DATE NOT NULL,
  IDCliente INT NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDCliente, IDProduto),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE CliVacina
(
  VacDtAplic DATE NOT NULL,
  VacDtProx DATE,
  IDCliente INT NOT NULL,
  IDProduto INT NOT NULL,
  PRIMARY KEY (IDCliente, IDProduto, VacDtAplic),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDProduto) REFERENCES Vacina(IDProduto) -- Adicionado IDProduto que estava faltando
);