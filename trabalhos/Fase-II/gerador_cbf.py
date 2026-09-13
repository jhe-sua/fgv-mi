import random
from datetime import datetime, timedelta
from faker import Faker

# Inicializa o Faker configurado para o Brasil
fake = Faker('pt_BR')

# Configurações de Quantidade
QTD_CLIENTES = 1200       # > 1000
QTD_PRODUTOS = 600        # > 500
QTD_FORNECEDORES = 150    # > 100
QTD_ENFERMIDADES = 60     # > 50
QTD_MUNICIPIOS = 200
QTD_PRATELEIRAS = 80
QTD_CATEGORIAS = 20
QTD_COMPRAS = 3000

# Listas de dados reais para fazer sentido no contexto de farmácia
UFS = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO']
NOMES_UFS = ['Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal', 'Espírito Santo', 'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 'Minas Gerais', 'Pará', 'Paraíba', 'Paraná', 'Pernambuco', 'Piauí', 'Rio de Janeiro', 'Rio Grande do Norte', 'Rio Grande do Sul', 'Rondônia', 'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe', 'Tocantins']

DOENCAS = [
    "Gripe", "Resfriado", "COVID-19", "Dengue", "Zika", "Chikungunya", "Asma", "Bronquite", "Pneumonia", "Tuberculose",
    "Diabetes Tipo 1", "Diabetes Tipo 2", "Hipertensão", "Hipotensão", "Colesterol Alto", "Arritmia", "Insuficiência Cardíaca",
    "Gastrite", "Úlcera", "Refluxo", "Hepatite A", "Hepatite B", "Hepatite C", "Cirrose", "Insuficiência Renal",
    "Pedra nos Rins", "Infecção Urinária", "Anemia", "Leucemia", "Linfoma", "Câncer de Pulmão", "Câncer de Mama",
    "Câncer de Próstata", "Melanoma", "Artrite", "Artrose", "Osteoporose", "Gota", "Lúpus", "Psoríase",
    "Vitiligo", "Dermatite", "Acne", "Depressão", "Ansiedade", "Esquizofrenia", "Bipolaridade", "Alzheimer",
    "Parkinson", "Epilepsia", "Enxaqueca", "Insônia", "Obesidade", "Desnutrição", "Hipertireoidismo", "Hipotireoidismo",
    "Glaucoma", "Catarata", "Conjuntivite", "Otite", "Sinusite", "Rinite", "Trombose", "Embolia"
]

CATEGORIAS = [
    "Analgésicos", "Antitérmicos", "Anti-inflamatórios", "Antibióticos", "Antialérgicos", "Antidepressivos",
    "Vitaminas e Suplementos", "Primeiros Socorros", "Higiene Pessoal", "Cuidados com o Cabelo", "Dermocosméticos",
    "Saúde Bucal", "Fraldas e Infantis", "Nutrição Infantil", "Produtos Ortopédicos", "Aparelhos Médicos",
    "Fitoterápicos", "Homeopatia", "Vacinas", "Genéricos"
]

# Função auxiliar para gravar em lotes (evita travar o SGBD com milhares de INSERTS únicos)
def write_batches(f, table_name, columns, data, batch_size=200):
    if not data: return
    for i in range(0, len(data), batch_size):
        batch = data[i:i+batch_size]
        f.write(f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES\n")
        values = []
        for row in batch:
            row_str = []
            for val in row:
                if val is None:
                    row_str.append('NULL')
                elif isinstance(val, (int, float)):
                    row_str.append(str(val))
                else:
                    # Escapar aspas simples no SQL
                    val_clean = str(val).replace("'", "''")
                    row_str.append(f"'{val_clean}'")
            values.append(f"({', '.join(row_str)})")
        f.write(",\n".join(values) + ";\n\n")

def main():
    print("Gerando dados, aguarde...")
    with open('DML-CBF-100-drogas.sql', 'w', encoding='utf-8') as f:
        f.write("SET SEARCH_PATH TO oper_cbf;\n\n")

        # 1. UF
        dados_uf = [(UFS[i], NOMES_UFS[i]) for i in range(len(UFS))]
        write_batches(f, 'UF', ['IDUF', 'NomeUF'], dados_uf)

        # 2. Pratileira (Descricao é INT no schema original)
        dados_pratileira = []
        ids_pratileira = list(range(1, QTD_PRATELEIRAS + 1))
        for i in ids_pratileira:
            dados_pratileira.append((random.randint(50, 300), i, random.randint(1, 15))) # Corredor/Seção como INT
        write_batches(f, 'Pratileira', ['Capacidade', 'IDPratileira', 'Descricao'], dados_pratileira)

        # 3. Fornecedor
        dados_fornecedor = []
        ids_forn = list(range(1, QTD_FORNECEDORES + 1))
        for i in ids_forn:
            # Gerando CNPJ sem pontuação, mas legível
            cnpj = fake.cnpj().replace('.', '').replace('/', '').replace('-', '')
            dados_fornecedor.append((cnpj, fake.company(), i))
        write_batches(f, 'Fornecedor', ['CNPJ', 'NomeFornecedor', 'IDFornecedor'], dados_fornecedor)

        # 4. Categoria
        dados_categoria = []
        ids_cat = list(range(1, len(CATEGORIAS) + 1))
        for i, cat in enumerate(CATEGORIAS):
            dados_categoria.append((i + 1, cat))
        write_batches(f, 'Categoria', ['IDCategoria', 'NomeCategoria'], dados_categoria)

        # 5. Enfermidades
        dados_enfermidade = []
        ids_enf = list(range(1, QTD_ENFERMIDADES + 1))
        for i, enf in enumerate(DOENCAS[:QTD_ENFERMIDADES]):
            dados_enfermidade.append((i + 1, enf, fake.sentence(nb_words=10)))
        write_batches(f, 'Enfermidades', ['IDEnfermidade', 'NomeEnferm', 'DescrEnferm'], dados_enfermidade)

        # 6. Municipio
        dados_municipio = []
        municipios_gerados = []
        for i in range(1, QTD_MUNICIPIOS + 1):
            uf = random.choice(UFS)
            dados_municipio.append((i, fake.city(), uf))
            municipios_gerados.append((i, uf))
        write_batches(f, 'Municipio', ['IDMunicipio', 'NomeMunicipio', 'IDUF'], dados_municipio)

        # 7. Produto
        dados_produto = []
        medicamentos_ids = list(range(1, 351))          # 350 medicamentos
        vacinas_ids = list(range(351, 421))             # 70 vacinas
        
        # --- Listas de dados reais para Medicamentos ---
        PRINCIPIOS_ATIVOS = [
            "Paracetamol", "Dipirona Sódica", "Ibuprofeno", "Nimesulida", "Losartana Potássica", 
            "Omeprazol", "Pantoprazol", "Amoxicilina", "Cefalexina", "Azitromicina", "Clonazepam", 
            "Sinvastatina", "Metformina", "Tadalafila", "Sildenafila", "Loratadina", "Diclofenaco",
            "Escitalopram", "Sertralina", "Fluoxetina", "Enalapril", "Atenolol", "Hidroclorotiazida"
        ]
        MARCAS_MED = ["Medley (Genérico)", "EMS (Genérico)", "Neo Química (Genérico)", "Eurofarma", "Aché", "Bayer"]
        DOSAGENS = ["500mg - 20 Comprimidos", "1g - 10 Comprimidos", "Gotas 20ml", "Xarope 120ml", "Pomada 30g", "Suspensão Oral 50ml", "25mg - 30 Comprimidos", "50mg - 30 Comprimidos"]

        # --- Listas de dados reais para Produtos Comuns ---
        BASE_COMUNS = [
            "Protetor Solar Facial", "Protetor Solar Corporal", "Creme Hidratante", "Sabonete Líquido",
            "Água Micelar", "Sérum Vitamina C", "Desodorante Aerosol", "Desodorante Roll-on",
            "Shampoo Anticaspa", "Condicionador Hidratação", "Creme Dental", "Enxaguante Bucal",
            "Fio Dental", "Hastes Flexíveis (Cotonetes)", "Fralda Descartável", "Lenço Umedecido",
            "Pomada para Assaduras", "Leite em Pó Infantil", "Absorvente com Abas", "Sabonete em Barra",
            "Curativos (Band-Aid)", "Soro Fisiológico", "Álcool em Gel 70%", "Termômetro Digital"
        ]
        MARCAS_COMUNS = [
            "La Roche-Posay", "CeraVe", "Vichy", "Nivea", "Rexona", "Dove", "Clear", "Colgate",
            "Listerine", "Pampers", "Huggies", "Johnson's", "Bepantol", "Aptamil", "Sempre Livre",
            "Needs", "G-Tech", "Mió", "Panvel"
        ]
        TAMANHOS = ["FPS 50", "FPS 70", "200ml", "400ml", "50g", "150ml", "90g", "Tamanho M (40 un)", "Tamanho G (32 un)", "50 Metros", "500ml"]

        print("Gerando combinações de produtos...")
        # 1. Gera TODAS as combinações possíveis de forma rápida
        todas_combinacoes_meds = [f"{p} {d} - {m}" for p in PRINCIPIOS_ATIVOS for d in DOSAGENS for m in MARCAS_MED]
        
        # Adicionamos "Dose Única" e "Reforço" para garantir que teremos mais de 70 opções de vacinas únicas (evita travar)
        todas_combinacoes_vacinas = [f"Vacina contra {d} - Dose Única" for d in DOENCAS] + \
                                    [f"Vacina contra {d} - Reforço" for d in DOENCAS]
                                    
        todas_combinacoes_comuns = [f"{b} {m} {t}" for b in BASE_COMUNS for m in MARCAS_COMUNS for t in TAMANHOS]

        # 2. Sorteia exatamente a quantidade que precisamos (random.sample já garante que não haverá repetições)
        nomes_meds = random.sample(todas_combinacoes_meds, 350)
        nomes_vacinas = random.sample(todas_combinacoes_vacinas, 70)
        nomes_comuns = random.sample(todas_combinacoes_comuns, QTD_PRODUTOS - 420)

        # 3. Junta tudo numa lista final contínua para preencher as linhas do banco
        fila_nomes = nomes_meds + nomes_vacinas + nomes_comuns

        for i in range(1, QTD_PRODUTOS + 1):
            preco = round(random.uniform(5.5, 250.0), 2)
            dt_validade = fake.date_between(start_date='today', end_date='+3y')
            prateleira = random.choice(ids_pratileira)
            
            # Pega o nome já garantido como único na nossa fila
            nome = fila_nomes[i - 1]
            
            # Define a descrição com base na categoria
            if i <= 350:
                descr = "Medicamento indicado para tratamento. Consulte a bula."
            elif i <= 420:
                descr = "Imunizante de conservação refrigerada."
            else:
                descr = "Produto de uso pessoal/higiene. Testado dermatologicamente."

            dados_produto.append((i, preco, nome, descr, dt_validade, prateleira))
            
        write_batches(f, 'Produto', ['IDProduto', 'PrecVenda', 'NomeProduto', 'DescrProd', 'DtValidade', 'IDPratileira'], dados_produto)

        # 8. FornEstoque (Chave Primaria Dupla: Fornecedor e Prateleira)
        dados_fornestoque = []
        id_compra_seq = 1 # Incremento único para a Chave Primária
        
        QTD_TRANSACOES = 300 # Simulando 300 notas fiscais/pedidos de compra
        ids_produtos = list(range(1, QTD_PRODUTOS + 1))
        
        for _ in range(QTD_TRANSACOES):
            # 1. Dados do "Cabeçalho" da transação (iguais para todas as linhas)
            f_id = random.choice(ids_forn)
            dt_compra = fake.date_between(start_date='-1y', end_date='today')
            
            # 2. Sorteia quantos produtos diferentes essa transação terá (ex: 1 a 12 produtos)
            qtd_linhas = random.randint(1, 12)
            
            # Garante que não haja produtos repetidos na mesma transação usando sample
            produtos_da_transacao = random.sample(ids_produtos, qtd_linhas)
            
            for p_id in produtos_da_transacao:
                # 3. Dados da "Linha" do produto
                preco_c = round(abs(random.gauss(2000, 1000)),2)
                qtd_compra = random.randint(10, 500)
                
                # Anexa a linha mantendo a data e fornecedor da transação atual
                dados_fornestoque.append((
                    id_compra_seq, 
                    preco_c, 
                    dt_compra, 
                    qtd_compra, 
                    f_id, 
                    p_id
                ))
                
                # Incrementa o ID da compra para a próxima linha
                id_compra_seq += 1

        write_batches(
            f, 
            'FornEstoque', 
            ['IDCompra', 'PrecoCompra', 'DataCompra', 'QtdCompra', 'IDFornecedor', 'IDProduto'], 
            dados_fornestoque
        )

        # 9. FornTelefone
        dados_forntelefone = []
        for f_id in ids_forn:
            # Usando random.randint para ficar dentro do limite do INT (máx 2147483647)
            # Geraremos um telefone fictício de 9 dígitos para caber no INT
            tel1 = random.randint(900000000, 999999999)
            dados_forntelefone.append((tel1, f_id))
        write_batches(f, 'FornTelefone', ['Telefone', 'IDFornecedor'], dados_forntelefone)

        # 10. Cliente
        dados_cliente = []
        emails_usados = set()
        ids_clientes = list(range(1, QTD_CLIENTES + 1))
        for i in ids_clientes:
            email = fake.unique.email()
            bairro = fake.neighborhood()
            rua = fake.street_name()
            nome = fake.name()
            senha = fake.password(length=15)
            mun_id, mun_uf = random.choice(municipios_gerados)
            dados_cliente.append((bairro, rua, nome, senha, i, email, mun_id, mun_uf))
        write_batches(f, 'Cliente', ['Bairro', 'Rua', 'NomeCliente', 'Senha', 'IDCliente', 'EmailCliente', 'IDMunicipio', 'IDUF'], dados_cliente)

        # 11. Medicamento
        dados_medicamento = []
        for m_id in medicamentos_ids:
            indicacao = f"Indicado para tratamento de {random.choice(DOENCAS).lower()}."
            contra = "Hipersensibilidade aos componentes da fórmula."
            dados_medicamento.append((indicacao, contra, m_id))
        write_batches(f, 'Medicamento', ['Indicacao', 'Contraindicacao', 'IDProduto'], dados_medicamento)

        # 12. Vacina
        dados_vacina = []
        fabricantes = ["Fiocruz", "Butantan", "Pfizer", "AstraZeneca", "Sanofi", "GSK"]
        for v_id in vacinas_ids:
            dados_vacina.append((random.choice(fabricantes), v_id))
        write_batches(f, 'Vacina', ['FabricanteVac', 'IDProduto'], dados_vacina)

        # 13. ProdCateg
        dados_prodcateg = []
        for p_id in range(1, QTD_PRODUTOS + 1):
            cat_id = random.choice(ids_cat)
            dados_prodcateg.append((p_id, cat_id))
        write_batches(f, 'ProdCateg', ['IDProduto', 'IDCategoria'], dados_prodcateg)

        # 14. CliCompraProd
        dados_clicompra = []

        for i in range(QTD_COMPRAS):
            # Usar i + 1 garante um ID único e sequencial para cada compra (1, 2, 3...)
            id_compra = i + 1 
            
            id_prod = random.randint(1, QTD_PRODUTOS)
            qtd = random.randint(1, 5)
            dt_compra = fake.date_between(start_date='-2y', end_date='today')
            id_cli = random.choice(ids_clientes)
            
            dados_clicompra.append((qtd, id_compra, dt_compra, id_cli, id_prod))

        write_batches(f, 'CliCompraProd', ['Quantidade', 'IDCompra', 'DataCompra', 'IDCliente', 'IDProduto'], dados_clicompra)

        # 15. CliEnferm
        dados_clienferm = []
        pares_cli_enf = set()
        for _ in range(1800):
            c_id = random.choice(ids_clientes)
            e_id = random.choice(ids_enf)
            if (c_id, e_id) not in pares_cli_enf:
                pares_cli_enf.add((c_id, e_id))
                dt_cad = fake.date_between(start_date='-5y', end_date='today')
                dados_clienferm.append((dt_cad, c_id, e_id))
        write_batches(f, 'CliEnferm', ['DtCadEnferm', 'IDCliente', 'IDEnfermidade'], dados_clienferm)

        # 16. CliTelefone
        dados_clitelefone = []
        for c_id in ids_clientes:
            tel = random.randint(900000000, 999999999) # Ajuste para caber em 32-bit INT
            dados_clitelefone.append((tel, c_id))
        write_batches(f, 'CliTelefone', ['TelefoneCliente', 'IDCliente'], dados_clitelefone)

        # 17. InteracaoMedicamentosa
        dados_interacao = []
        pares_interacao = set()
        for _ in range(400):
            m1 = random.choice(medicamentos_ids)
            m2 = random.choice(medicamentos_ids)
            if m1 != m2 and (m1, m2) not in pares_interacao and (m2, m1) not in pares_interacao:
                pares_interacao.add((m1, m2))
                descr = "Risco de toxicidade hepática aumentada se coadministrados."
                dados_interacao.append((descr, m1, m2))
        write_batches(f, 'InteracaoMedicamentosa', ['DescrInteracaoMedicam', 'IDProdutoX', 'IDProdutoY'], dados_interacao)

        # 18. CliLembrete 
        # Nova PK: (IDCliente, IDProduto). Um cliente pode ter vários lembretes para produtos distintos.
        dados_lembrete = []
        
        # Sorteia 400 clientes para criarem lembretes
        clientes_com_lembrete = random.sample(ids_clientes, 400)
        
        for c_id in clientes_com_lembrete:
            # Sorteia de 1 a 5 lembretes (produtos diferentes) para este cliente
            qtd_lembretes = random.randint(1, 5)
            
            # random.sample garante que o cliente não terá o mesmo IDProduto repetido, 
            # evitando erro de violação da Chave Primária Composta.
            produtos_lembrete = random.sample(medicamentos_ids, qtd_lembretes)
            
            for p_id in produtos_lembrete:
                # Gera uma data/hora real de alarme para os próximos 30 dias
                dt_alarme = fake.future_datetime(end_date='+30d')
                
                dados_lembrete.append((dt_alarme, c_id, p_id))
                
        write_batches(f, 'CliLembrete', ['DtPAlarme', 'IDCliente', 'IDProduto'], dados_lembrete)

        # 19. CliVacina
        dados_clivacina = []
        pares_vacinacao = set()
        for _ in range(1200):
            c_id = random.choice(ids_clientes)
            v_id = random.choice(vacinas_ids)
            dt_aplic = fake.date_between(start_date='-3y', end_date='today')
            
            if (c_id, v_id, dt_aplic) not in pares_vacinacao:
                pares_vacinacao.add((c_id, v_id, dt_aplic))
                dt_prox = dt_aplic + timedelta(days=random.choice([30, 90, 180, 365]))
                dados_clivacina.append((dt_aplic, dt_prox, c_id, v_id))
        write_batches(f, 'CliVacina', ['VacDtAplic', 'VacDtProx', 'IDCliente', 'IDProduto'], dados_clivacina)

    print("Arquivo 'popular_banco_cbf.sql' gerado com sucesso!")

if __name__ == "__main__":
    main()