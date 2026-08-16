CREATE schema cbf;

SET SEARCH_PATH TO cbf;

--Tabelas Independentes--

CREATE TABLE Categoria (
    IDCategoria INT NOT NULL,
    NomeCategoria VARCHAR(128) NOT NULL,
    PRIMARY KEY (IDCategoria)
);

CREATE TABLE Estoque (
    IDEstoque INT NOT NULL,
    Quantidade INT NOT NULL,
    Prateleira INT NOT NULL,
    PRIMARY KEY (IDEstoque)
);

CREATE TABLE Fornecedor (
    IDFornecedor INT NOT NULL,
    CNPJ VARCHAR(18) NOT NULL UNIQUE,
    NomeFornecedor VARCHAR(128) NOT NULL,
    PRIMARY KEY (IDFornecedor)
);

CREATE TABLE Enfermidades (
    IDEnfermidade INT NOT NULL,
    NomeEnferm VARCHAR(255) NOT NULL,
    DescrEnferm TEXT NOT NULL,
    PRIMARY KEY (IDEnfermidade)
);

CREATE TABLE UF (
    IDUF INT NOT NULL,
    NomeUF VARCHAR(25) NOT NULL,
    PRIMARY KEY (IDUF)
);

--Primeiro nivel de dependencia-

CREATE TABLE Municipio (
    IDMunicipio INT NOT NULL,
    IDUF INT NOT NULL,
    NomeMunicipio VARCHAR(255) NOT NULL,
    PRIMARY KEY (IDMunicipio, IDUF),
    FOREIGN KEY (IDUF) REFERENCES UF(IDUF) ON DELETE SET NULL
);

CREATE TABLE Produto (
    IDProduto INT NOT NULL,
    PrecVenda FLOAT NOT NULL,
    NomeProduto VARCHAR(255) NOT NULL,
    DescrProd TEXT NOT NULL,
    DtValidade DATE NOT NULL,
    IDEstoque INT NOT NULL,
    PRIMARY KEY (IDProduto),
    FOREIGN KEY (IDEstoque) REFERENCES Estoque(IDEstoque) ON DELETE SET NULL
);

CREATE TABLE FornTelefone (
    Telefone VARCHAR(15),
    IDFornecedor INT NOT NULL,
    PRIMARY KEY (Telefone),
    FOREIGN KEY (IDFornecedor) REFERENCES Fornecedor(IDFornecedor)
);

--Segundo nivel de dependencia--

CREATE TABLE Cliente (
    IDCliente INT NOT NULL,
    Bairro VARCHAR(255) NOT NULL,
    Rua VARCHAR(255) NOT NULL,
    NomeCliente VARCHAR(255) NOT NULL,
    Senha VARCHAR(255) NOT NULL,
    EmailCliente VARCHAR(255) NOT NULL UNIQUE,
    IDMunicipio INT NOT NULL,
    IDUF INT NOT NULL,
    PRIMARY KEY (IDCliente),
    FOREIGN KEY (IDMunicipio, IDUF) REFERENCES Municipio(IDMunicipio, IDUF) ON DELETE SET NULL

);

CREATE TABLE Vacina (
    IDProduto INT NOT NULL,
    FabricanteVac VARCHAR(255),
    PRIMARY KEY (IDProduto),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto) ON DELETE CASCADE
);

CREATE TABLE Medicamento (
    IDProduto INT NOT NULL,
    Indicacao TEXT,
    Contraindicacao TEXT,
    PRIMARY KEY (IDProduto),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto) ON DELETE CASCADE
);

CREATE TABLE FornEstoque (
    IDFornecedor INT NOT NULL,
    IDEstoque INT NOT NULL,
    PrecoCompra FLOAT NOT NULL,
    PRIMARY KEY (IDFornecedor, IDEstoque),
    FOREIGN KEY (IDFornecedor) REFERENCES Fornecedor(IDFornecedor),
    FOREIGN KEY (IDEstoque) REFERENCES Estoque(IDEstoque)
);

-- Terceiro nivel de dependencia--

CREATE TABLE CliLembrete (
    IDCliente INT NOT NULL,
    DtPAlarme DATE,
    IDProduto INT NOT NULL,
    PRIMARY KEY (IDCliente),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) ON DELETE CASCADE,
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto) ON DELETE CASCADE 
);

CREATE TABLE CliTelefone (
    TelefoneCliente VARCHAR(15) NOT NULL,
    IDCliente INT NOT NULL,
    PRIMARY KEY (TelefoneCliente),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) ON DELETE CASCADE
);

CREATE TABLE ProdCateg (
    IDProduto INT NOT NULL,
    IDCategoria INT NOT NULL,
    PRIMARY KEY (IDProduto, IDCategoria),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto) ON DELETE CASCADE,
    FOREIGN KEY (IDCategoria) REFERENCES Categoria(IDCategoria) ON DELETE CASCADE
);

CREATE TABLE InteracaoMedicamentosa (
    IDProdutoX INT NOT NULL,
    IDProdutoY INT NOT NULL,
    DescInteracaoMedicamentosa TEXT NOT NULL,
    PRIMARY KEY (IDProdutoX, IDProdutoY),
    FOREIGN KEY (IDProdutoX) REFERENCES Medicamento(IDProduto),
    FOREIGN KEY (IDProdutoY) REFERENCES Medicamento(IDProduto)
);

-- Quarto nivel de dependencia--

CREATE TABLE CliEnferm (
    IDCliente INT NOT NULL,
    IDENfermidade INT NOT NULL,
    DtCadEnferm DATE NOT NULL,
    PRIMARY KEY (IDCliente, IDEnfermidade),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) ON DELETE CASCADE,
    FOREIGN KEY (IDEnfermidade) REFERENCES Enfermidades(IDEnfermidade) ON DELETE SET NULL
);

-- Quinto nivel de dependencia--

CREATE TABLE CliCompraProd (
    IDCompra INT NOT NULL,
    Quantidade INT NOT NULL,
    DataCompra DATE NOT NULL,
    IDCliente INT NOT NULL,
    IDProduto INT NOT NULL,
    PRIMARY KEY (IDCompra),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

-- Sexto nivel de dependencia--

CREATE TABLE CliVacina (
    IDCliente INT NOT NULL,
    VacDtAplic DATE NOT NULL,
    VacAplic BOOLEAN NOT NULL,
    IDProduto INT NOT NULL,
    PRIMARY KEY (IDCliente),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) ON DELETE CASCADE,
    FOREIGN KEY (IDProduto) REFERENCES Vacina(IDProduto)
);