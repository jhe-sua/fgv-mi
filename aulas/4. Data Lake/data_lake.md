# Big Data


## Historia

A Nasa foi a primeira entidade a usar o conceito de Big Data quando num projeto o volume e a velocidade dos dados era maior que a capacidade que eles tinham e um cientista em 1998 fez um artigo relatando esse problema referenciandolo como Big Data.

## Caracteristicas
- Volume
- Variedade
- Velocidade
- Veracidade
- Variabilidade
- Valor -> obtido quando analizamos os dados
- Visualização

Quando o problema tem essas caracteristicas quando comparado com o banco de dados operacional temos um problema de Big Data.
Muitas empressas não colocam os dados do Big Data no Data Warehouse perdendo o valor que poderia gerar todos esses dados.

## Uso Corporativo



## Topics
- MapReduce: Para cada valor mapeamos um ID unico então reduzimos os dados pela frequencia
- Hadoop (HDFS):
- Spark -> Databriks 

# Data Lake

Ambiente preparado para lidar com um problema de Big Data

## Medallion

Bronce: Zona de Entrada, dado no seu estado bruto
Prata: Tratamento e normalização dos dados
Ouro: Dados agragados para aplicação pratica de IA e Dashboards

## Arquiteturas

*Stack*: Cloud e On-premisses -> Storage -> Compute -> Data Management -> Avanced Analytics Enterprise Reporting Applications
    - Cloud e On-premisses
    - Storage: Camada de armazenamento, onde todos os arquivos permanecem, geralmente separada
    - Compute: Camada computacional para ler e usar os dados
    - Data Management: Gestão de acesso e Governança

## Ferramentas

- Databricks: Plataforma de Datalake House

# Nomenclatura

On-premisses: o datacenter sobre o controle da empresa