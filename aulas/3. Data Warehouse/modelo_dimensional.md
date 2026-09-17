# Modelo Dimensional

Ele possui uma tabela **Fato** e tabelas **Dimensão** que se conectam aos fatos seguindo dois principios: Cada informação de cada dimensão deve ser unica para cada linha da tabela fato (pois se um fato aconteceu com dois parametros diferentes, por exemplo um cliente foi atendido por dois atendentes na mesma tranção, então não podemos colocar um atendente ou outro, ou os dois, devemos realizar outra abordagem) e cada informação de cada dimensão deve existir no momento atual do registro de uma linha na tabela fato (pois o fato registra o acontecido, não tem como registrar informações que ainda não existem. como por exemplo quando um cliente faz uma compra e fica na tabela fato, entãoa depois de duas semanas o entregador faz a entrega e coloca o estatus como enviado. NÃO podemos modificar a compra do cliente e colocar o estatus como entregue pois esse registro é de duas semanas atras e nesse momento não tinha sido entregue, nesse caso é criado o Fato_entregas tambem). Cotinuamos tendo conceitos de chave primaria e estrangeira apenas muda conceitualmente na parte da PK

**Star Schema** <br>
É o modelo dimensional que possui um fato e dimensões ao redor do fato, cada dimensão não possui tabelas filhas. não segue a terceira forma normal.

**Galaxy Schema** <br>
É o modelo dimensional que possui dois fato e dimensões ao redor dos fatos, cada dimensão não possui tabelas filhas. não segue a terceira forma normal.

**Snowflake model**
É o modelo dimensional que possui um fato e dimensões ao redor do fato, cada dimensão pode possuir tabelas filhas. Pode seguir a terceira forma normal.


## Dimensão
Conceitualmente são caracteristicas de um fato, são os dados que me permitem analizar o fato. Existem perguntas que o fato quer responder, a traves dessas perguntas podemos escolher as dimensões. Geralmente são tabelas mais fixas, não são atualizadas com tanta frequencia.

_Dimensões legais_: Calendario

_Surrogate Key (Chave substituta):_ é uma outra PK gerada de forma "Aleatoria" que as dimensões usam para evitar os seguintes problemas: (1) evitar quebrar a integridade por mudanças no negocio o que mudaria PKs existentes, (2) Perda da maquina do Tempo, (3) Falta de padronização e chaves compostas complexas, (4) Queda de performace por usar strings como PKs, (5) Registros temporariamente sem identificação. isto é, a PK natural não foi informada ainda. 

**Slowed Changed Dimension** <br>

_Type 1_: (Nada) Simplesmente atualizar, não há historico preservado
_Type 2_: (Linhas) Aqui é feito um crescimento das linhas, crescimento vertical e ao aumentar a quantidade das linhas adicionamos 1 nova coluna para indicar qual o mais atual e uma nova coluna com o timestamp.
_Type 3_: (Colunas) Não temos uma expansão vertical, temos uma expansão de colunas adicionando por exemplo colunas dos valores anteriores e valores correntes, o numero de colunas extras define o numero de passos que podemos voltar.


## Fato
Contem as FKs das Sugorrates Keys, e as metrificações que servem para responder as perguntas pelas quais o Fato foi criado. Alem disso em geral há duas medidas mais na tabela fato, o identificador de transação e a hora da transação.

> NOTE: Como definir a PK de um fato? quais são os erros que podem acontecer?
> É definida uma PK composta, aqui não criamos uma sugorrate key, pois isso traria mais problemas, queremos que a tabela fato seja o fato mesmo, então as informações não mudam,é informacao imutavel, logo não é necessario criar uma SK.
> 
> 
_Fatos legais_: Fato_defeito, Fato_agregado, Fato_vendas, Fato_compras

**Fato detalhado vs Fato agregado**

O fato detalhado tem uma granularidade maior por transação, muitas vezes com mais de uma linha por transação, ja no fato agregado cada linha do fato representa mais de uma transação.

**Granularidade do Fato**

