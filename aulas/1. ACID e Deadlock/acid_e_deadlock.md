# Mecanismos transacionais

**ACID**

_Atomicidade_: Ou uma transação é finalizada ou completamente cancelada

_Concistencia_: A transação deve sair de um estado valido a outro estado valido, de acordo com o que esta modelado

_Isolamento_: Cada transação tem um nivel de isolamento em relação as outras, se espera que sejam totalmente independentes

_Durabilidade_: Refere-se a vida da transação e a sobrevivencia dela frente a falhas do sitema, o que permite a replicação

**Niveis de Concistencia**

_Read uncommitted_: O banco de dados pode realizar transações mesmo com transações que não tenham sido finalizadas.

_Read committed_: O banco de dados so realiza transações depois que transações em andamento sejam comitadas.

_Repetable read_: Quer dizer que dada uma transação realizada os dados lidos por essa transação são congelados e não conseguem ser modificados por nenhuma outra transação ate que a transação atual seja finalizada.

_Serializable_: Bloqueia intervalos, definidos pela minha transação, os quais não podem ser modificados (adicionar ou subtrair linhas) ate que a transação que definiu o intervalo seja finalizada.

Perceba tambem que cada nivel de concistencia é muito mais restritivo que o anterior, solucionando "problemas" que acontecem com niveis menos restritivos

1 -> 2, podemos visualizar informações falsas se fizerem um rolback

2 -> 3, podemos obter mais de um resultado para a mesma transação pois mesmo depois de comitado de um momento a outro podem mudar os dados que limos

3 -> 4, podem ser acresentados novos dados na nossa leitura.

Ao definir o nivel de consistencia mexemos diretamente no _Isolamento_ de nossas transações

**Deadlock**

![alt text](img/CAP.png)

# Controle de Corncorrencia

É a forma de controlar transações que acontecem ao mesmo tempo como se tivessem acontecido uma apos a outra. Serve para impor o isolamento (I do ACID)

**Principais Problemas de concorrencia**

- _Leitura suja_: Uma transação T1 baseou sua logica numa outra transação T2 que ainda não foi comitada, consequentemente se acontecer um rollback em T2 a T1 baseu sua logica em dados que nunca existiram. 

- _Atualização perdida_: Acontece quando uma transação sobreescreve a outra, uma transação grava nova informação sem considerar a transação concorrente.

- _Leitura não repetivel_: Dentro de uma mesma transação T1 acontece duas vezes a leitura de uma linha, entre a primeira e a segunda leitura outra transação modificou o estado da linha. Isso quebra qualquer logica que dependa de estados estaveis ou seja que precise o mesmo estado no inicio e no final da transação.

- _Leitura Fantasma_: Um transação re-executa uma consulta que pega um intervalo de linhas, então receve um intervalo diferente porque outra transação adicionou ou removeu linhas

## Controle de concorrencia baseado em bloqueio

**Bloqueios compartilhados e exvlusivos**

Existem bloqueios compartilhados, isto é açoes que varias transações podem executar pois não causam anomalias, como leitura compartilhada. Existem bloqueios exclusivos, apenas uma transação pode acessar aos dados para não gerar anomalias, como escrita

Esses bloqueios podem acontecer a nivel de linha bloando linhas, ou de tabela bloqueando tabelas inteiras. A granularidade do bloqueio induz uma compensação importante, ou o sistema fica mais sobrecarregado por ter que acompanhar muitos bloqueios (linha) ou a concorrencia do sistema é baixa por conta do bloqueio de tabelas

**Bloqueio de duas fases 2PL**

Aqui cada transação ao momento de iniciar faz todos os bloqueios que precise fazer chamada faze crescente, a medida que a transação não precisa bloquear mais os dados ela começa a liberar os bloqueios e entra na fase decresente nesta fase ela somente pode liberar bloqueios, este tipo de bloqueio garante a serializabilidade

Tambem existe o 2PL estrito, a diferença é que ela não libera os bloqueios aos poucos apenas libera depois de que a transação foi commitada.

A desvantagemé que transações ainda precisam esperar por bloqueios e pode gerar condições para Deadlock.

**Controle de concorrencia multi-versão (MVCC)**

Aqui cada transação cria um isolamento de snapshot do banco de dados no inicio da transação. isso garante que leitores não bloqueiem escritores e vice-versa, evitando tambem leituras sujas e leituras não repetiveis.

**Controle otimista vs. pessimista**

_Pessimista_: Assume que os conflitos são provaveis e os previne criando bloqueios. Reduz a taxa de transferencia.
_Otimista_: Assume que os conflitos são raros, deixando as transaões acontecerem em suas proprias copias privadas de dados, depois valida se não a nenhum conflito e então realizaa escrita, se ouver conflito realiza um rollback e tenta de novo. O problema aqui é quando os conflitos são frequentes pois há muito trabalho desperdiçado.


