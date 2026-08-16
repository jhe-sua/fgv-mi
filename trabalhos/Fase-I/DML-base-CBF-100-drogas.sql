SET SEARCH_PATH TO cbf;

-----------------------------------------------------------
-- NÍVEL 0: TABELAS INDEPENDENTES
-----------------------------------------------------------

-- Inserindo Categorias
INSERT INTO Categoria (IDCategoria, NomeCategoria) VALUES
(1, 'Analgésicos'),
(2, 'Antibióticos'),
(3, 'Anti-inflamatórios'),
(4, 'Antialérgicos'),
(5, 'Antitérmicos'),
(6, 'Vacinas Virais'),
(7, 'Vacinas Bacterianas'),
(8, 'Vitaminas e Suplementos'),
(9, 'Dermatológicos'),
(10, 'Cardiovasculares');

-- Inserindo Estoques (30 Prateleiras/Lotes diferentes)
INSERT INTO Estoque (IDEstoque, Quantidade, Prateleira) VALUES
(1, 150, 1), (2, 300, 1), (3, 50, 2), (4, 120, 2), (5, 80, 3),
(6, 400, 3), (7, 60, 4), (8, 200, 4), (9, 90, 5), (10, 110, 5),
(11, 20, 6), (12, 45, 6), (13, 75, 7), (14, 300, 7), (15, 85, 8),
(16, 130, 8), (17, 210, 9), (18, 500, 9), (19, 25, 10), (20, 15, 10),
(21, 60, 11), (22, 90, 11), (23, 110, 12), (24, 70, 12), (25, 40, 13),
(26, 120, 13), (27, 250, 14), (28, 30, 14), (29, 10, 15), (30, 80, 15);

-- Inserindo Fornecedores
INSERT INTO Fornecedor (IDFornecedor, CNPJ, NomeFornecedor) VALUES
(1, '11.111.111/0001-11', 'Pharma Distribuidora S/A'),
(2, '22.222.222/0001-22', 'MedLife Suprimentos'),
(3, '33.333.333/0001-33', 'BioTech Imunológicos'),
(4, '44.444.444/0001-44', 'Saúde Global Logística'),
(5, '55.555.555/0001-55', 'Nacional Medicamentos LTDA');

-- Inserindo Enfermidades
INSERT INTO Enfermidades (IDEnfermidade, NomeEnferm, DescrEnferm) VALUES
(1, 'Hipertensão Arterial', 'Pressão sanguínea persistentemente alta.'),
(2, 'Diabetes Mellitus Tipo 2', 'Níveis elevados de glicose no sangue.'),
(3, 'Asma', 'Inflamação das vias aéreas causando dificuldade de respiração.'),
(4, 'Gripe (Influenza)', 'Infecção viral aguda do sistema respiratório.'),
(5, 'Covid-19', 'Infecção respiratória causada pelo vírus SARS-CoV-2.'),
(6, 'Dengue', 'Doença viral transmitida pelo mosquito Aedes aegypti.'),
(7, 'Pneumonia', 'Infecção inflamatória que afeta os pulmões.'),
(8, 'Rinite Alérgica', 'Inflamação da mucosa nasal por alérgenos.'),
(9, 'Artrose', 'Desgaste da cartilagem das articulações.'),
(10, 'Enxaqueca', 'Dor de cabeça intensa e pulsante.');

-- Inserindo UFs
INSERT INTO UF (IDUF, NomeUF) VALUES
(1, 'São Paulo'), (2, 'Rio de Janeiro'), (3, 'Minas Gerais'), 
(4, 'Rio Grande do Sul'), (5, 'Paraná');


-----------------------------------------------------------
-- NÍVEL 1: PRIMEIRO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Municípios (IDMunicipio é único por UF)
INSERT INTO Municipio (IDMunicipio, IDUF, NomeMunicipio) VALUES
(1, 1, 'São Paulo'), (2, 1, 'Campinas'), (3, 1, 'Ribeirão Preto'),
(1, 2, 'Rio de Janeiro'), (2, 2, 'Niterói'), (3, 2, 'Nova Iguaçu'),
(1, 3, 'Belo Horizonte'), (2, 3, 'Uberlândia'), (3, 3, 'Juiz de Fora'),
(1, 4, 'Porto Alegre'), (2, 4, 'Caxias do Sul'), (3, 4, 'Pelotas'),
(1, 5, 'Curitiba'), (2, 5, 'Londrina'), (3, 5, 'Maringá');

-- Inserindo Produtos (Medicamentos: 1 a 15 | Vacinas: 16 a 30)
INSERT INTO Produto (IDProduto, PrecVenda, NomeProduto, DescrProd, DtValidade, IDEstoque) VALUES
(1, 15.50, 'Dipirona 500mg', 'Analgésico e antitérmico.', '2028-12-31', 1),
(2, 25.00, 'Ibuprofeno 400mg', 'Anti-inflamatório não esteroide.', '2027-10-15', 2),
(3, 45.90, 'Amoxicilina 500mg', 'Antibiótico de amplo espectro.', '2026-08-20', 3),
(4, 18.20, 'Loratadina 10mg', 'Antialérgico para rinite e urticária.', '2029-01-10', 4),
(5, 89.90, 'Losartana 50mg', 'Anti-hipertensivo.', '2027-11-05', 5),
(6, 60.50, 'Metformina 850mg', 'Controle de diabetes tipo 2.', '2028-04-30', 6),
(7, 35.00, 'Omeprazol 20mg', 'Protetor gástrico.', '2027-02-28', 7),
(8, 12.00, 'Paracetamol 750mg', 'Analgésico leve a moderado.', '2029-05-15', 8),
(9, 140.00, 'Azitromicina 500mg', 'Antibiótico macrolídeo.', '2026-12-01', 9),
(10, 55.30, 'Salbutamol Spray', 'Broncodilatador para asma.', '2028-09-10', 10),
(11, 28.40, 'Vitamina C 1g', 'Suplemento vitamínico e imunológico.', '2029-03-25', 11),
(12, 110.00, 'Rosuvastatina 10mg', 'Redutor de colesterol.', '2027-07-14', 12),
(13, 22.90, 'Diclofenaco 50mg', 'Anti-inflamatório muscular.', '2026-11-20', 13),
(14, 19.50, 'Cefalexina 500mg', 'Antibiótico cefalosporínico.', '2027-05-30', 14),
(15, 32.10, 'Cetirizina 10mg', 'Antialérgico de segunda geração.', '2028-06-18', 15),
-- Vacinas a partir do ID 16
(16, 120.00, 'Vacina Influenza Trivalente', 'Prevenção contra o vírus da gripe.', '2026-05-30', 16),
(17, 250.00, 'Vacina HPV Quadrivalente', 'Prevenção contra o Papilomavírus Humano.', '2027-12-15', 17),
(18, 85.00, 'Vacina Hepatite B', 'Imunização contra o vírus da Hepatite B.', '2028-10-10', 18),
(19, 195.50, 'Vacina Covid-19 Bivalente', 'Reforço imunológico contra SARS-CoV-2.', '2026-09-01', 19),
(20, 310.00, 'Vacina Pneumocócica 13', 'Prevenção contra pneumonia.', '2029-02-28', 20),
(21, 60.00, 'Vacina Antitetânica', 'Prevenção contra o tétano.', '2030-01-15', 21),
(22, 150.00, 'Vacina Tríplice Viral', 'Sarampo, caxumba e rubéola.', '2028-08-20', 22),
(23, 95.00, 'Vacina Febre Amarela', 'Imunização contra o vírus da febre amarela.', '2031-11-30', 23),
(24, 450.00, 'Vacina Herpes Zoster', 'Prevenção de cobreiro.', '2027-04-10', 24),
(25, 210.00, 'Vacina Meningocócica ACWY', 'Prevenção contra meningite.', '2028-12-05', 25),
(26, 130.00, 'Vacina Rotavírus', 'Prevenção de diarreia grave em bebês.', '2026-07-25', 26),
(27, 80.00, 'Vacina DTPa', 'Difteria, Tétano e Coqueluche.', '2029-06-15', 27),
(28, 175.00, 'Vacina Hepatite A', 'Imunização contra o vírus da Hepatite A.', '2028-03-22', 28),
(29, 290.00, 'Vacina Dengue (Qdenga)', 'Prevenção contra os 4 sorotipos da Dengue.', '2027-09-18', 29),
(30, 110.00, 'Vacina Poliomielite (VIP)', 'Imunização inativada contra pólio.', '2029-11-11', 30);

-- Inserindo Telefones de Fornecedores
INSERT INTO FornTelefone (Telefone, IDFornecedor) VALUES
('(11) 9999-8888', 1), ('(11) 4444-5555', 1),
('(21) 3333-2222', 2), ('(31) 8888-7777', 3),
('(41) 9876-5432', 4), ('(51) 3456-7890', 5);


-----------------------------------------------------------
-- NÍVEL 2: SEGUNDO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Clientes
INSERT INTO Cliente (IDCliente, Bairro, Rua, NomeCliente, Senha, EmailCliente, IDMunicipio, IDUF) VALUES
(1, 'Jardins', 'Rua Augusta, 100', 'Carlos Almeida', 'senha123', 'carlos.almeida@email.com', 1, 1),
(2, 'Botafogo', 'Rua Voluntários da Pátria, 50', 'Mariana Costa', 'senha456', 'mariana.costa@email.com', 1, 2),
(3, 'Savassi', 'Av. Getúlio Vargas, 200', 'Fernando Silva', 'senha789', 'fernando.silva@email.com', 1, 3),
(4, 'Moinhos de Vento', 'Rua Padre Chagas, 80', 'Lucia Mendes', 'senha012', 'lucia.mendes@email.com', 1, 4),
(5, 'Batel', 'Av. do Batel, 300', 'Roberto Nunes', 'senha345', 'roberto.nunes@email.com', 1, 5),
(6, 'Cambui', 'Rua Conceição, 400', 'Juliana Rocha', 'senha678', 'juliana.rocha@email.com', 2, 1),
(7, 'Icaraí', 'Rua Moreira César, 150', 'Diego Martins', 'senha901', 'diego.martins@email.com', 2, 2),
(8, 'Centro', 'Av. Afonso Pena, 100', 'Aline Ferreira', 'senha234', 'aline.ferreira@email.com', 2, 3),
(9, 'Lourdes', 'Rua da Bahia, 500', 'Thiago Gomes', 'senha567', 'thiago.gomes@email.com', 1, 3),
(10, 'Leblon', 'Av. Delfim Moreira, 250', 'Beatriz Souza', 'senha890', 'beatriz.souza@email.com', 1, 2),
(11, 'Pinheiros', 'Rua Teodoro Sampaio, 600', 'Eduardo Lima', 'senhaabc', 'eduardo.lima@email.com', 1, 1),
(12, 'Boa Vista', 'Rua 15 de Novembro, 70', 'Fernanda Alves', 'senhacde', 'fernanda.alves@email.com', 2, 5),
(13, 'Centro', 'Rua Júlio de Castilhos, 90', 'Rodrigo Castro', 'senhafgh', 'rodrigo.castro@email.com', 2, 4),
(14, 'Nova Aliança', 'Av. Braz Olaia, 30', 'Camila Ribeiro', 'senhaijk', 'camila.ribeiro@email.com', 3, 1),
(15, 'Centro', 'Rua Halfeld, 40', 'Marcelo Pinto', 'senhalmn', 'marcelo.pinto@email.com', 3, 3);

-- Inserindo Vacinas (Relacionadas aos Produtos 16 a 30)
INSERT INTO Vacina (IDProduto, FabricanteVac) VALUES
(16, 'Instituto Butantan'), (17, 'MSD'), (18, 'GlaxoSmithKline (GSK)'),
(19, 'Pfizer/BioNTech'), (20, 'Pfizer'), (21, 'Sanofi Pasteur'),
(22, 'Fiocruz'), (23, 'Bio-Manguinhos'), (24, 'GSK'), (25, 'Novartis'),
(26, 'GSK'), (27, 'Sanofi Pasteur'), (28, 'MSD'), (29, 'Takeda'), (30, 'Fiocruz');

-- Inserindo Medicamentos (Relacionados aos Produtos 1 a 15)
INSERT INTO Medicamento (IDProduto, Indicacao, Contraindicacao) VALUES
(1, 'Dores e febre', 'Alergia à dipirona.'),
(2, 'Inflamações e dores', 'Úlcera gástrica ativa.'),
(3, 'Infecções bacterianas', 'Alergia a penicilinas.'),
(4, 'Sintomas de alergia', 'Gravidez no primeiro trimestre.'),
(5, 'Hipertensão', 'Insuficiência hepática grave.'),
(6, 'Diabetes Tipo 2', 'Insuficiência renal grave.'),
(7, 'Refluxo e gastrite', 'Uso concomitante com clopidogrel.'),
(8, 'Dores leves a moderadas', 'Problemas hepáticos severos.'),
(9, 'Infecções do trato respiratório', 'Hipersensibilidade a macrolídeos.'),
(10, 'Crises de asma', 'Arritmias cardíacas severas.'),
(11, 'Deficiência de vitamina C', 'Cálculos renais de oxalato.'),
(12, 'Hipercolesterolemia', 'Doença hepática ativa.'),
(13, 'Inflamações articulares e dores', 'Pacientes com asma induzida por AINEs.'),
(14, 'Infecções cutâneas e urinárias', 'Alergia a cefalosporinas.'),
(15, 'Rinite e coceira', 'Insuficiência renal terminal.');

-- Inserindo FornEstoque (Relaciona Fornecedores e Estoques)
INSERT INTO FornEstoque (IDFornecedor, IDEstoque, PrecoCompra) VALUES
(1, 1, 8.50), (1, 2, 12.00), (2, 3, 22.00), (3, 16, 60.00), (3, 17, 120.00),
(4, 5, 45.00), (5, 6, 30.00), (1, 7, 15.00), (2, 8, 5.50), (4, 9, 70.00),
(5, 10, 25.00), (2, 11, 12.00), (1, 12, 55.00), (3, 18, 40.00), (3, 19, 100.00),
(4, 20, 150.00), (5, 21, 30.00), (2, 22, 75.00), (1, 23, 40.00), (3, 29, 145.00);


-----------------------------------------------------------
-- NÍVEL 3: TERCEIRO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Lembretes de Clientes (PK é IDCliente -> Max 1 por cliente)
INSERT INTO CliLembrete (IDCliente, DtPAlarme, IDProduto) VALUES
(1, '2026-08-20', 5),  -- Lembrar o Carlos de comprar Losartana
(2, '2026-08-22', 6),  -- Lembrar a Mariana de comprar Metformina
(3, '2026-09-01', 12), -- Lembrar Fernando de comprar Rosuvastatina
(4, '2026-10-15', 7),  -- Lembrar Lucia de comprar Omeprazol
(5, '2026-11-10', 10); -- Lembrar Roberto de comprar Salbutamol

-- Inserindo Telefones de Clientes
INSERT INTO CliTelefone (TelefoneCliente, IDCliente) VALUES
('(11) 91111-1111', 1), ('(11) 91111-2222', 1),
('(21) 92222-2222', 2), ('(31) 93333-3333', 3),
('(51) 94444-4444', 4), ('(41) 95555-5555', 5),
('(19) 96666-6666', 6), ('(21) 97777-7777', 7),
('(31) 98888-8888', 8), ('(31) 99999-9999', 9),
('(21) 90000-0000', 10), ('(11) 91234-5678', 11),
('(43) 98765-4321', 12), ('(54) 95678-1234', 13),
('(16) 94321-8765', 14), ('(32) 99887-7665', 15);

-- Inserindo Produtos nas Categorias (N x N)
INSERT INTO ProdCateg (IDProduto, IDCategoria) VALUES
(1, 1), (1, 5), (2, 1), (2, 3), (3, 2),
(4, 4), (5, 10), (6, 10), (7, 10), (8, 1), 
(8, 5), (9, 2), (10, 4), (11, 8), (12, 10),
(13, 1), (13, 3), (14, 2), (15, 4),
(16, 6), (17, 6), (18, 6), (19, 6), (20, 7),
(21, 7), (22, 6), (23, 6), (24, 6), (25, 7),
(26, 6), (27, 7), (28, 6), (29, 6), (30, 6);

-- Inserindo Interações Medicamentosas (IDProdutoX e IDProdutoY devem ser Medicamentos 1-15)
INSERT INTO InteracaoMedicamentosa (IDProdutoX, IDProdutoY, DescInteracaoMedicamentosa) VALUES
(2, 5, 'O Ibuprofeno pode reduzir o efeito anti-hipertensivo da Losartana.'),
(7, 14, 'Omeprazol pode diminuir a absorção da Cefalexina no trato gastrointestinal.'),
(2, 13, 'Uso concomitante aumenta o risco de sangramento gastrointestinal.'),
(3, 9, 'Potencial antagonismo na ação antibacteriana se usados juntos sem indicação.'),
(5, 12, 'Nenhuma interação grave conhecida, porém monitorar função hepática.');


-----------------------------------------------------------
-- NÍVEL 4: QUARTO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Enfermidades dos Clientes
INSERT INTO CliEnferm (IDCliente, IDEnfermidade, DtCadEnferm) VALUES
(1, 1, '2025-01-15'), (1, 2, '2025-06-20'), -- Carlos tem Hipertensão e Diabetes
(2, 3, '2024-03-10'), -- Mariana tem Asma
(3, 10, '2026-02-05'), -- Fernando tem Enxaqueca
(4, 7, '2026-05-18'), -- Lucia teve Pneumonia
(5, 1, '2023-11-25'), (5, 9, '2024-08-14'), -- Roberto tem Hipertensão e Artrose
(6, 8, '2025-12-01'), -- Juliana tem Rinite Alérgica
(8, 2, '2026-01-10'), -- Aline tem Diabetes
(10, 5, '2026-07-20'), -- Beatriz teve Covid
(12, 6, '2026-04-10'); -- Fernanda teve Dengue


-----------------------------------------------------------
-- NÍVEL 5: QUINTO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Compras de Produtos pelos Clientes
INSERT INTO CliCompraProd (IDCompra, Quantidade, DataCompra, IDCliente, IDProduto) VALUES
(1, 2, '2026-08-01', 1, 5),   -- Carlos comprou Losartana
(2, 1, '2026-08-05', 1, 6),   -- Carlos comprou Metformina
(3, 3, '2026-08-02', 2, 10),  -- Mariana comprou Salbutamol
(4, 1, '2026-08-10', 3, 1),   -- Fernando comprou Dipirona
(5, 1, '2026-08-12', 4, 3),   -- Lucia comprou Amoxicilina
(6, 2, '2026-07-25', 5, 13),  -- Roberto comprou Diclofenaco
(7, 5, '2026-07-28', 6, 4),   -- Juliana comprou Loratadina
(8, 1, '2026-08-14', 7, 8),   -- Diego comprou Paracetamol
(9, 2, '2026-08-15', 8, 6),   -- Aline comprou Metformina
(10, 1, '2026-08-03', 9, 2),  -- Thiago comprou Ibuprofeno
(11, 4, '2026-08-08', 10, 11),-- Beatriz comprou Vitamina C
(12, 1, '2026-07-30', 11, 14),-- Eduardo comprou Cefalexina
(13, 2, '2026-08-11', 12, 1), -- Fernanda comprou Dipirona
(14, 1, '2026-08-16', 13, 15),-- Rodrigo comprou Cetirizina
(15, 3, '2026-08-09', 14, 7), -- Camila comprou Omeprazol
(16, 1, '2026-08-13', 15, 12),-- Marcelo comprou Rosuvastatina
(17, 1, '2026-08-15', 1, 8),  -- Carlos comprou Paracetamol
(18, 1, '2026-08-05', 2, 16), -- Mariana comprou Vacina Influenza (compra apenas)
(19, 1, '2026-07-20', 10, 19),-- Beatriz comprou Vacina Covid
(20, 2, '2026-08-02', 12, 29);-- Fernanda comprou Vacina Dengue


-----------------------------------------------------------
-- NÍVEL 6: SEXTO NÍVEL DE DEPENDÊNCIA
-----------------------------------------------------------

-- Inserindo Aplicação de Vacinas nos Clientes 
-- (PK é IDCliente -> Max 1 por cliente nesta estrutura. 
-- IDProduto deve ser uma Vacina (16 a 30))
INSERT INTO CliVacina (IDCliente, VacDtAplic, VacAplic, IDProduto) VALUES
(2, '2026-08-05', TRUE, 16),  -- Mariana tomou a vacina da gripe
(4, '2026-08-12', TRUE, 20),  -- Lucia tomou vacina pneumocócica
(6, '2026-07-15', TRUE, 17),  -- Juliana tomou vacina HPV
(10, '2026-07-20', TRUE, 19), -- Beatriz tomou reforço Covid
(12, '2026-08-02', FALSE, 29); -- Fernanda agendou/comprou mas ainda não aplicou a da Dengue