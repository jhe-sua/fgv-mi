# Modelo Dimensional

Ele possui uma tabela **Fato** e tabelas **Dimensão** que se conectam aos fatos. Cotinuamos tendo conceitos de chave primaria e estrangeira apenas muda conceitualmente na parte da PK

**Dimensão** <br>
Conceitualmente são caracteristicas de um fato, são os dados que me permitem analizar o fato. Existem perguntas que o fato quer responder, a traves dessas perguntas podemos escolher as dimensões. Geralmente são tabelas mais fixas, não são atualizadas com tanta frequencia.

_Dimensões legais_: Calendario

_Surrogate Key (Chave substituta):_ é uma outra PK que as dimensões usam para criar a "Maquina do tempo"

_Slowed Changed Dimension_: 

**Fato** <br>
Contem metrificações que servem para responder as perguntas pelas quais o Fato foi criado.

> NOTE: Como definir a PK de um fato? quais são os erros que podem acontecer?

**Star Schema** <br>
é o modelo dimensional que possui um fato e dimensões ao redor do fato, cada dimensão não possui tabelas filhas. não segue a terceira forma normal.


