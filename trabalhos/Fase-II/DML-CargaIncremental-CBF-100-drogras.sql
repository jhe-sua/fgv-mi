SET search_path TO oper_cbf;

-- Carga Incremental: Cliente
-- Seguindo as colunas exatas do schema fornecido
INSERT INTO Cliente (IDCliente, NomeCliente, EmailCliente, Senha, Rua, Bairro, IDMunicipio, IDUF) VALUES
(3001, 'Carlos Silva', 'carlos.silva@email.com', 'senha123', 'Avenida Paulista, 1000', 'Bela Vista', 1, 'MS'),
(3002, 'Mariana Costa', 'mariana.costa@email.com', 'senha456', 'Rua Domingos Ferreira, 120', 'Copacabana', 1, 'MS'),
(3003, 'Felipe Oliveira', 'felipe.oliveira@email.com', 'senha789', 'Rua da Bahia, 500', 'Centro', 1, 'MS'),
(3004, 'Juliana Mendes', 'juliana.mendes@email.com', 'senha012', 'Avenida Boa Viagem, 200', 'Boa Viagem', 1, 'MS'),
(3005, 'Ricardo Alves', 'ricardo.alves@email.com', 'senha345', 'Rua 24 de Outubro, 300', 'Moinhos de Vento', 1, 'MS');

SET search_path TO oper_cbf;

UPDATE Cliente AS c
SET 
    Bairro       = v.Bairro,
    Rua          = v.Rua,
    NomeCliente  = v.NomeCliente,
    Senha        = v.Senha,
    EmailCliente = v.EmailCliente,
    IDMunicipio  = v.IDMunicipio,
    IDUF         = v.IDUF
FROM (VALUES
    ('Suzana', 'Avenida das Esmeraldas, 150', 'Elisa Vargas', 'Ld4w58*d@V2uYpB', 1, 'elisa.vargas@novaempresa.com.br', 113, 'AL'),
    ('Jardim América', 'Rua das Flores, 88', 'Diego Alves', 'OG4^#w%(Eu8Sebu', 2, 'diego.alves.dev@dominio.com', 125, 'RN'),
    ('Conjunto Lagoa', 'Rua dos Pinheiros, 44', 'Dra. Ana Vitória Câmara', '#JETNireT(U@&8B', 3, 'anavitoria.camara@medicina.com', 63, 'PE'),
    ('União', 'Avenida Central, 1024', 'Bruno Vieira', '3NMCe_Dh%(4%79X', 4, 'bruno.vieira99@emailpessoal.net', 178, 'SP'),
    ('Vila Da Ária', 'Praça da Matriz, S/N', 'Dr. Antônio Lima', 'Hw$mEdX_+wDn9T1', 5, 'antonio.lima.med@hospital.org', 184, 'AP'),
    ('São João Batista', 'Alameda dos Anjos, 99', 'Léo Aparecida', 'j0%4rDT+^ggdOky', 6, 'leo.aparecida@provedor.net', 126, 'AP'),
    ('Aparecida', 'Boulevard das Acácias, 300', 'Natália Porto', '+dH3D1p+bF$3ik1', 7, 'nporto.adv@juridico.com', 158, 'MG'),
    ('Nova Gameleira', 'Avenida Brasil, 4500', 'João Lucas Albuquerque', 'iI8A0V)V!Rs$ra8', 8, 'joaolucas.albuquerque@empresa.org', 149, 'AC'),
    ('Boa Esperança', 'Rodovia do Sol, Km 10', 'Dr. Kaique Monteiro', '!4uWMVC^FQqJtsu', 9, 'contato.kaique@clinica.org', 154, 'PA'),
    ('Universo', 'Estrada Velha, 55', 'Henry Gabriel da Rosa', '^HG8)NZ5_*8D^6y', 10, 'henry.g.rosa@techmail.com', 84, 'MT')
) AS v(Bairro, Rua, NomeCliente, Senha, IDCliente, EmailCliente, IDMunicipio, IDUF)
WHERE c.IDCliente = v.IDCliente;

-- Carga Incremental: Produto
-- Sequenciamento a partir do ID 601
INSERT INTO Produto (IDProduto, PrecVenda, NomeProduto, DescrProd, DtValidade, IDPratileira) VALUES
(601, 145.90, 'Losartana Potássica 100mg - 30 Comprimidos', 'Medicamento indicado para hipertensão.', '2028-12-01', 14),
(602, 35.50, 'Dipirona Sódica 1g - 10 Comprimidos', 'Analgésico e antitérmico.', '2027-10-15', 33),
(603, 89.90, 'Protetor Solar Corporal FPS 70 200ml', 'Proteção solar avançada. Nova embalagem.', '2029-01-20', 45),
(604, 120.00, 'Suplemento Vitamínico C e D - 60 Cápsulas', 'Suplemento alimentar diário.', '2027-05-10', 7),
(605, 15.75, 'Soro Fisiológico 500ml', 'Uso externo e inalação. Reposição.', '2028-03-01', 22),
(606, 210.30, 'Aparelho Medidor de Pressão Digital', 'Equipamento médico para uso doméstico.', '2030-01-01', 72),
(607, 45.99, 'Shampoo Dermatológico Anticaspa 200ml', 'Tratamento capilar intensivo.', '2027-11-20', 10),
(608, 12.50, 'Curativos Transparentes (Band-Aid) 40 un', 'Primeiros socorros. Material flexível.', '2029-12-31', 15),
(609, 88.40, 'Fralda Geriátrica Tamanho G (20 un)', 'Absorção intensa para uso noturno.', '2028-07-07', 56),
(610, 54.00, 'Colágeno Hidrolisado em Pó 250g', 'Saúde das articulações e pele.', '2027-09-15', 31);