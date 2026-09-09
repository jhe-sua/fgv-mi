# ETL

*E*: Extrair os dados do banco de dados operacional, tudo de acordo com os requisitos e o que importa para o DW
*T*: Transforma os dados obtidos para que fiquem de acordo com a estrutura do DW, existem transformações _passivas_ (Por exemplo: gerando surrogate key, atributos derivados, etc.) onde o numero de linhas de entrada é o mesmo de saida, as _ativas_ (Por exemplo: eliminando duplicatas, agregando linhas, dimensões de mudança lenta do Tipo 2, et) o numero de linhas de saida são maiores.
*L*: Carga os dados transformados dentro do DW, ele possui as seguintes etapas:
    - Carga inicial: Tabelas do DW vazias são preenchidas
    - Carga de atualização: é a carga que atualiza o DW com os dados gerados no tempo do _ciclo de atualização_ que é o tempo que define a frequencia de atualização. Pode ser FULL (a carga toda atualizada) ou INCREMENTAL (apenas a diferenca do atualizado e os dados do ultimo ciclo de atualização)

Quais os erros mais comuns e o que deve ser evitado em cada fase?

*L*: Não deve ser um processo demorado, se demorar 1 dia+ então os dados do DW sempre estarão desatualizados. Pode ser evitado usando Carga incremental, devemos nos preocupar com o incremento desde o inicio.

## Changue Data Capture (CDC)

Ele permite que possamos fazer as cargas incrementais pois ele diz ao SDBG quais arquivos ja foram carregados e quais ainda não foram carregados ao DW

# OLAP

Online Transaction Processing (OLTP): mexer nos banco de dados operacional, são operações de inserir, modificar e excluir, consultar, tudo para fins operacionais.

Online Analitical Processing (OLAP): consultar e apresentar dados de DW para fins analiticos
