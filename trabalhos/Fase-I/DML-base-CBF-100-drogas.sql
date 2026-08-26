-- Define o schema de trabalho
SET SEARCH_PATH TO cbf;

-- ==============================================================================
-- 1. TABELAS INDEPENDENTES
-- ==============================================================================

-- Categorias abrangendo medicamentos e equipamentos solicitados
INSERT INTO Categoria (IDCategoria, NomeCategoria) VALUES
(1, 'Medicamentos de Referência'),
(2, 'Medicamentos Genéricos'),
(3, 'Equipamentos Médicos'),
(4, 'Aparelhos Respiratórios'),
(5, 'Vacinas'),
(6, 'Higiene Pessoal'),
(7, 'Dermocosméticos'),
(8, 'Ortopedia'),
(9, 'Primeiros Socorros'),
(10, 'Nutrição e Suplementos');

-- Estoque com locais e quantidades variadas
INSERT INTO Estoque (IDEstoque, Quantidade, Prateleira) VALUES
(1, 150, 1), (2, 300, 1), (3, 50, 2), (4, 120, 2), (5, 80, 3),
(6, 200, 3), (7, 45, 4), (8, 60, 4), (9, 90, 5), (10, 400, 5),
(11, 20, 6), (12, 15, 6), (13, 30, 7), (14, 10, 7), (15, 5, 8),
(16, 50, 8), (17, 85, 9), (18, 110, 9), (19, 75, 10), (20, 250, 10),
(21, 60, 11), (22, 100, 11), (23, 40, 12), (24, 15, 12), (25, 20, 13),
(26, 150, 13), (27, 200, 14), (28, 90, 14), (29, 300, 15), (30, 50, 15);

-- Fornecedores com CNPJs únicos
INSERT INTO Fornecedor (IDFornecedor, CNPJ, NomeFornecedor) VALUES
(1, '11.111.111/0001-11', 'Pharma Distribuidora SA'),
(2, '22.222.222/0001-22', 'MedEquip Equipamentos Hospitalares'),
(3, '33.333.333/0001-33', 'NeoQuimica Genéricos'),
(4, '44.444.444/0001-44', 'Pfizer Brasil LTDA'),
(5, '55.555.555/0001-55', 'Bayer S.A.'),
(6, '66.666.666/0001-66', 'RespirAr Tecnologias Médicas'),
(7, '77.777.777/0001-77', 'Omron Healthcare'),
(8, '88.888.888/0001-88', 'Unilever Cuidados Pessoais'),
(9, '99.999.999/0001-99', 'Instituto Butantan'),
(10, '10.101.010/0001-10', 'Johnson & Johnson do Brasil');

-- Enfermidades comuns
INSERT INTO Enfermidades (IDEnfermidade, NomeEnferm, DescrEnferm) VALUES
(1, 'Hipertensão Arterial', 'Pressão arterial sistematicamente alta.'),
(2, 'Diabetes Tipo 2', 'Níveis elevados de glicose no sangue devido a resistência à insulina.'),
(3, 'Asma', 'Condição respiratória caracterizada por espasmos nos brônquios dos pulmões.'),
(4, 'COVID-19', 'Doença respiratória infecciosa causada pelo coronavírus SARS-CoV-2.'),
(5, 'Gripe (Influenza)', 'Infecção viral aguda do sistema respiratório.'),
(6, 'DPOC', 'Doença Pulmonar Obstrutiva Crônica, bloqueio do fluxo de ar.'),
(7, 'Rinite Alérgica', 'Inflamação da mucosa nasal em resposta a alérgenos.'),
(8, 'Insônia', 'Dificuldade para iniciar ou manter o sono.'),
(9, 'Hipotireoidismo', 'Produção insuficiente de hormônios da tireoide.'),
(10, 'Obesidade', 'Acúmulo excessivo de gordura corporal.');

-- Unidades Federativas
INSERT INTO UF (IDUF, NomeUF) VALUES
(1, 'São Paulo'), (2, 'Rio de Janeiro'), (3, 'Minas Gerais'), 
(4, 'Bahia'), (5, 'Paraná'), (6, 'Santa Catarina');

-- ==============================================================================
-- 2. PRIMEIRO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Municípios vinculados as UFs
INSERT INTO Municipio (IDMunicipio, IDUF, NomeMunicipio) VALUES
(1, 1, 'São Paulo'), (2, 1, 'Campinas'), (3, 1, 'Ribeirão Preto'),
(4, 2, 'Rio de Janeiro'), (5, 2, 'Niterói'), (6, 2, 'Petrópolis'),
(7, 3, 'Belo Horizonte'), (8, 3, 'Uberlândia'), (9, 3, 'Juiz de Fora'),
(10, 4, 'Salvador'), (11, 4, 'Feira de Santana'),
(12, 5, 'Curitiba'), (13, 5, 'Londrina'),
(14, 6, 'Florianópolis'), (15, 6, 'Joinville');

-- Produtos contendo medicamentos, vacinas, equipamentos respiratórios e não-medicamentosos
INSERT INTO Produto (IDProduto, PrecVenda, NomeProduto, DescrProd, DtValidade, IDEstoque) VALUES
-- Medicamentos (1 a 15)
(1, 12.50, 'Losartana Potássica 50mg', 'Anti-hipertensivo em comprimidos.', '2027-05-10', 1),
(2, 8.90, 'Metformina 850mg', 'Controle glicêmico para diabetes.', '2028-01-15', 2),
(3, 22.00, 'Salbutamol Spray (Aerolin)', 'Broncodilatador para asma.', '2026-11-20', 3),
(4, 15.30, 'Paracetamol 750mg', 'Analgésico e antitérmico.', '2027-12-01', 4),
(5, 18.50, 'Ibuprofeno 400mg', 'Anti-inflamatório não esteroide.', '2028-03-11', 5),
(6, 25.90, 'Omeprazol 20mg', 'Inibidor de bomba de prótons para estômago.', '2027-08-30', 6),
(7, 45.00, 'Amoxicilina 500mg', 'Antibiótico de amplo espectro.', '2026-10-15', 7),
(8, 32.10, 'Azitromicina 500mg', 'Antibiótico macrolídeo.', '2026-09-22', 8),
(9, 12.00, 'Dipirona Sódica 500mg', 'Analgésico e antitérmico em gotas.', '2028-05-14', 9),
(10, 65.00, 'Ritalina 10mg', 'Estimulante do sistema nervoso central.', '2026-06-01', 10),
(11, 28.90, 'Clonazepam 2mg', 'Tranquilizante e ansiolítico.', '2027-11-18', 11),
(12, 14.50, 'Sinvastatina 20mg', 'Redutor de colesterol.', '2028-02-25', 12),
(13, 9.80, 'Atenolol 50mg', 'Betabloqueador para pressão alta.', '2027-07-09', 13),
(14, 21.00, 'Levotiroxina Sódica 50mcg', 'Reposição hormonal para tireoide.', '2026-12-30', 14),
(15, 38.50, 'Loratadina 10mg', 'Anti-histamínico para alergias.', '2028-08-15', 15),

-- Vacinas (16 a 20)
(16, 85.00, 'Vacina Influenza Quadrivalente', 'Prevenção contra a gripe.', '2026-05-01', 16),
(17, 150.00, 'Vacina HPV Bivalente', 'Prevenção contra vírus HPV.', '2027-02-10', 17),
(18, 90.00, 'Vacina Hepatite B', 'Imunização contra o vírus da Hepatite B.', '2028-10-10', 18),
(19, 120.00, 'Vacina COVID-19 Pfizer', 'Imunização contra SARS-CoV-2.', '2026-08-15', 19),
(20, 60.00, 'Vacina Febre Amarela', 'Imunização contra febre amarela.', '2029-01-20', 20),

-- Equipamentos Médicos e Aparelhos Respiratórios (21 a 26) - Itens não-medicamentosos
(21, 145.90, 'Oxímetro de Pulso Digital Dellamed', 'Medidor de saturação de oxigênio no sangue (SpO2).', '2035-12-31', 21),
(22, 199.50, 'Inalador e Nebulizador Ultrassônico Omron', 'Aparelho respiratório para inalação rápida.', '2035-12-31', 22),
(23, 3590.00, 'Aparelho CPAP Automático ResMed', 'Equipamento respiratório para apneia do sono.', '2035-12-31', 23),
(24, 750.00, 'Cilindro de Oxigênio Portátil Alumínio', 'Cilindro para oxigenoterapia complementar.', '2040-01-01', 24),
(25, 210.00, 'Esfigmomanômetro Digital de Braço', 'Aparelho medidor de pressão arterial.', '2035-12-31', 25),
(26, 35.00, 'Termômetro Digital Infravermelho', 'Medição rápida de temperatura corporal sem contato.', '2035-12-31', 26),

-- Outros Produtos (Higiene, Dermocosméticos, etc) (27 a 30)
(27, 18.50, 'Sabonete Líquido Íntimo 200ml', 'Higiene diária com pH balanceado.', '2027-03-10', 27),
(28, 89.90, 'Protetor Solar Facial La Roche 60FPS', 'Alta proteção UVA/UVB.', '2026-09-05', 28),
(29, 45.00, 'Fralda Geriátrica Tamanho G (30 un)', 'Fraldas descartáveis para incontinência.', '2030-01-01', 29),
(30, 22.90, 'Creme Dental Para Dentes Sensíveis', 'Alívio rápido para sensibilidade.', '2028-11-22', 30);

-- Telefones dos Fornecedores
INSERT INTO FornTelefone (Telefone, IDFornecedor) VALUES
('11-3000-1000', 1), ('11-3000-1001', 1),
('21-4000-2000', 2), ('19-3500-3000', 3),
('11-5000-4000', 4), ('11-6000-5000', 5),
('41-3200-6000', 6), ('11-3800-7000', 7),
('11-2000-8000', 8), ('11-9000-9000', 9),
('12-3300-1010', 10);

-- ==============================================================================
-- 3. SEGUNDO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Clientes consistentes com Municípios e UFs (IDMunicipio, IDUF)
INSERT INTO Cliente (IDCliente, Bairro, Rua, NomeCliente, Senha, EmailCliente, IDMunicipio, IDUF) VALUES
(1, 'Centro', 'Rua Augusta', 'Ana Silva', 'senha123', 'ana.silva@email.com', 1, 1),
(2, 'Pinheiros', 'Rua Teodoro Sampaio', 'Carlos Sousa', 'senha456', 'carlos.s@email.com', 1, 1),
(3, 'Cambuí', 'Av. Orosimbo Maia', 'Marcos Santos', 'senha789', 'marcos.santos@email.com', 2, 1),
(4, 'Copacabana', 'Av. Atlântica', 'Fernanda Lima', 'senhasegura', 'fernanda.lima@email.com', 4, 2),
(5, 'Icaraí', 'Rua Gavião Peixoto', 'Bruno Costa', 'senha1011', 'bruno.c@email.com', 5, 2),
(6, 'Savassi', 'Av. do Contorno', 'Patrícia Rocha', 'senha1213', 'patricia.r@email.com', 7, 3),
(7, 'Barra', 'Av. Oceânica', 'Roberto Almeida', 'senha1415', 'roberto.a@email.com', 10, 4),
(8, 'Batel', 'Rua Bispo Dom José', 'Luciana Mendes', 'senha1617', 'luciana.mendes@email.com', 12, 5),
(9, 'Trindade', 'Rua Lauro Linhares', 'Rafael Ferreira', 'senha1819', 'rafael.f@email.com', 14, 6),
(10, 'Jardins', 'Av. Paulista', 'Juliana Castro', 'senha2021', 'juliana.c@email.com', 1, 1),
(11, 'Leblon', 'Av. Delfim Moreira', 'Gustavo Pereira', 'senha2223', 'gustavo.p@email.com', 4, 2),
(12, 'Pampulha', 'Av. Otacílio Negrão', 'Marina Ribeiro', 'senha2425', 'marina.r@email.com', 7, 3),
(13, 'Centro', 'Rua XV de Novembro', 'Diego Martins', 'senha2627', 'diego.m@email.com', 12, 5),
(14, 'Boa Viagem', 'Av. Conselheiro Aguiar', 'Camila Neves', 'senha2829', 'camila.neves@email.com', 1, 1), 
(15, 'Mooca', 'Rua da Mooca', 'Thiago Gomes', 'senha3031', 'thiago.gomes@email.com', 1, 1);

-- Subtipos de Produto: Vacina
INSERT INTO Vacina (IDProduto, FabricanteVac) VALUES
(16, 'Instituto Butantan'), (17, 'GlaxoSmithKline'), 
(18, 'Sanofi Pasteur'), (19, 'Pfizer/BioNTech'), 
(20, 'Fiocruz');

-- Subtipos de Produto: Medicamento (Contém Indicação e Contraindicação)
INSERT INTO Medicamento (IDProduto, Indicacao, Contraindicacao) VALUES
(1, 'Controle da pressão arterial alta.', 'Gravidez e lactação.'),
(2, 'Controle de glicemia em Diabetes Tipo 2.', 'Insuficiência renal grave.'),
(3, 'Alívio do broncoespasmo em asma.', 'Hipersensibilidade ao salbutamol.'),
(4, 'Redução da febre e alívio de dor leve a moderada.', 'Doença hepática grave.'),
(5, 'Alívio de dor e inflamação.', 'Úlcera péptica ativa.'),
(6, 'Tratamento de úlceras gástricas e refluxo.', 'Uso conjunto com nelfinavir.'),
(7, 'Tratamento de infecções bacterianas.', 'Alergia a penicilina.'),
(8, 'Infecções respiratórias inferiores e superiores.', 'Hipersensibilidade a macrolídeos.'),
(9, 'Febre intensa e dor severa.', 'Porfiria hepática aguda.'),
(10, 'Transtorno de Déficit de Atenção e Hiperatividade (TDAH).', 'Glaucoma, hipertireoidismo.'),
(11, 'Crises convulsivas e distúrbios de pânico.', 'Miastenia gravis.'),
(12, 'Redução do colesterol LDL.', 'Doença hepática ativa.'),
(13, 'Hipertensão e angina.', 'Bradicardia sinusal.'),
(14, 'Hipotireoidismo crônico.', 'Insuficiência adrenal não corrigida.'),
(15, 'Alívio de sintomas de rinite alérgica.', 'Insuficiência hepática grave.');

-- Controle de Fornecimento ao Estoque (Relacionando Fornecedor N:N Estoque)
INSERT INTO FornEstoque (IDFornecedor, IDEstoque, PrecoCompra) VALUES
(1, 1, 5.00), (3, 2, 3.50), (1, 3, 10.00), (5, 4, 6.00),
(5, 5, 8.00), (3, 6, 12.00), (4, 7, 20.00), (4, 8, 15.00),
(1, 9, 4.50), (1, 10, 30.00), (5, 11, 12.00), (1, 12, 6.00),
(1, 13, 3.50), (1, 14, 8.00), (5, 15, 15.00),
(9, 16, 40.00), (4, 17, 80.00), (9, 18, 45.00), (4, 19, 60.00), (9, 20, 30.00),
(7, 21, 85.00), (7, 22, 110.00), (6, 23, 2500.00), (6, 24, 450.00), (7, 25, 120.00),
(2, 26, 18.00), (8, 27, 8.00), (10, 28, 45.00), (10, 29, 20.00), (8, 30, 10.00);

-- ==============================================================================
-- 4. TERCEIRO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Lembretes de uso para Clientes (Ex: avisos para compra contínua)
INSERT INTO CliLembrete (IDCliente, DtPAlarme, IDProduto) VALUES
(1, '2026-08-30', 1), -- Lembrete para comprar Losartana
(2, '2026-09-01', 2), -- Lembrete para Metformina
(3, '2026-08-25', 23), -- Manutenção do CPAP
(4, '2026-10-10', 14), -- Lembrete Levotiroxina
(5, '2026-08-28', 11);

-- Telefones dos Clientes
INSERT INTO CliTelefone (TelefoneCliente, IDCliente) VALUES
('11-99999-1111', 1), ('11-98888-2222', 2), ('19-97777-3333', 3),
('21-96666-4444', 4), ('21-95555-5555', 5), ('31-94444-6666', 6),
('71-93333-7777', 7), ('41-92222-8888', 8), ('48-91111-9999', 9),
('11-90000-0000', 10), ('21-99111-1111', 11), ('31-98222-2222', 12),
('41-97333-3333', 13), ('11-96444-4444', 14), ('11-95555-5555', 15);

-- Classificação dos Produtos nas Categorias (N:N)
INSERT INTO ProdCateg (IDProduto, IDCategoria) VALUES
-- Medicamentos
(1, 2), (2, 2), (3, 1), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2),
(9, 2), (10, 1), (11, 1), (12, 2), (13, 2), (14, 1), (15, 2),
-- Vacinas
(16, 5), (17, 5), (18, 5), (19, 5), (20, 5),
-- Equipamentos e Aparelhos Respiratórios
(21, 3), (21, 4), -- Oxímetro serve como Equipamento e está na seara respiratória
(22, 3), (22, 4), -- Inalador Nebulizador
(23, 3), (23, 4), -- CPAP
(24, 3), (24, 4), -- Cilindro de Oxigênio
(25, 3),          -- Aparelho de Pressão
(26, 3),          -- Termômetro
-- Diversos
(27, 6), (28, 7), (29, 8), (30, 6);

-- Interações Medicamentosas (Avisos Farmacêuticos entre IDProdutoX e Y)
INSERT INTO InteracaoMedicamentosa (IDProdutoX, IDProdutoY, DescInteracaoMedicamentosa) VALUES
(1, 5, 'Uso de ibuprofeno pode diminuir o efeito anti-hipertensivo da losartana.'),
(6, 11, 'O omeprazol pode prolongar a eliminação do clonazepam, aumentando sedação.'),
(8, 12, 'Azitromicina em conjunto com sinvastatina pode aumentar o risco de miopatia.'),
(13, 3, 'Atenolol (betabloqueador) é antagonista do salbutamol (broncodilatador).'),
(2, 6, 'Risco reduzido de absorção de B12; monitoramento recomendado.');

-- ==============================================================================
-- 5. QUARTO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Relacionamento Cliente com Enfermidade (Histórico Clínico do Paciente)
INSERT INTO CliEnferm (IDCliente, IDENfermidade, DtCadEnferm) VALUES
(1, 1, '2023-05-10'), -- Hipertensão
(2, 2, '2021-08-22'), -- Diabetes Tipo 2
(3, 3, '2020-01-15'), -- Asma
(4, 9, '2019-11-05'), -- Hipotireoidismo
(5, 8, '2024-02-20'), -- Insônia
(6, 4, '2025-06-12'), -- COVID-19 (Histórico)
(7, 1, '2022-09-30'), -- Hipertensão
(8, 6, '2018-04-10'), -- DPOC (Usa Cilindro / CPAP)
(9, 7, '2023-03-25'), -- Rinite
(10, 10, '2021-12-12'); -- Obesidade

-- ==============================================================================
-- 6. QUINTO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Compras realizadas pelos clientes (Note a compra de equipamentos médicos/respiratórios)
INSERT INTO CliCompraProd (IDCompra, Quantidade, DataCompra, IDCliente, IDProduto) VALUES
(1, 2, '2026-08-01', 1, 1),   -- Ana compra Losartana
(2, 1, '2026-08-01', 1, 25),  -- Ana compra Aparelho de Pressão (Eq. Médico)
(3, 3, '2026-08-05', 2, 2),   -- Carlos compra Metformina
(4, 1, '2026-08-07', 3, 3),   -- Marcos compra Salbutamol
(5, 1, '2026-08-07', 3, 22),  -- Marcos compra Inalador Nebulizador (Aparelho Respiratório)
(6, 1, '2026-08-10', 4, 14),  -- Fernanda compra Levotiroxina
(7, 1, '2026-08-11', 5, 11),  -- Bruno compra Clonazepam
(8, 1, '2026-08-12', 6, 21),  -- Patrícia compra Oxímetro de Pulso
(9, 1, '2026-08-13', 6, 26),  -- Patrícia compra Termômetro Digital
(10, 1, '2026-08-14', 8, 23), -- Luciana (com DPOC) compra Aparelho CPAP (Aparelho Respiratório)
(11, 2, '2026-08-15', 8, 24), -- Luciana compra Refis de Cilindro de Oxigênio
(12, 1, '2026-08-16', 9, 15), -- Rafael compra Loratadina
(13, 4, '2026-08-17', 10, 27),-- Juliana compra Sabonetes
(14, 2, '2026-08-18', 11, 28),-- Gustavo compra Protetor Solar
(15, 5, '2026-08-19', 12, 29);-- Marina compra Fraldas

-- ==============================================================================
-- 7. SEXTO NÍVEL DE DEPENDÊNCIA
-- ==============================================================================

-- Registro de Aplicação de Vacinas na Farmácia
INSERT INTO CliVacina (IDCliente, VacDtAplic, VacDtProx, IDProduto) VALUES
(13, '2026-05-10', '2027-05-10', 16), -- Diego tomou Vacina Gripe (Retorno em 1 ano)
(14, '2026-02-15', '2026-08-15', 17), -- Camila tomou HPV (Dose 1, retorno em 6 meses)
(15, '2026-01-20', '2036-01-20', 20), -- Thiago tomou Febre Amarela (Retorno em 10 anos)
(10, '2026-08-01', '2027-08-01', 19); -- Juliana tomou COVID-19 (Reforço anual)