# Casos de Uso

**Diagrama Casos de Uso**: É um diagrama que descreve de forma superficial o sistema, os atores e os casos de uso, refletindo as expectativas dos stakeholders

- _Sistema_: É o aplicativo que esta sendo criado, é o projeto no que queremos trabalhar.
- _Atores_: São todos os papeis que devem interagir com o sistema. podem ser pessoas, entidades, o proprio sistema
- _Caso de Uso_: são o passo a passo parar cumprir com os objetivos informacionais que seguem niveis informacionas, integrando Sistema e Atores.

**Descrição de caso de uso**

Nome:
Descrição curta:
Precondições: pré-requisitos para que a execução inicie com 
sucesso.
Póscondições: estado esperado do sistema após uma execução 
com sucesso.
Situações de erro: erros relevantes ao domínio do problema.
Estado do sistema na decorrência de um erro:
Atores que se comunicam com o caso de uso:
Gatilho de acionamento: eventos que irão iniciar o caso de uso.
Processo principal:
Processos alternativos: desvios que podem ocorrer a partir do 
processo principal

# Matriz de Zanchman

Colunas: Dados, Processos, Localização, Pessoas, Tempo, Motivação

perceba que não deve ser algo que se memoriza, deve ser algo que se entende e faz sentido, para eu realizar qualquer modelagem informacional preciso de dados, sem dados não faço nada. Dado que tenho os dados preciso saber as funeções deles, como são os processos que faço com eles. Dado que sei essas duas coisas é importantte saber onde os dados estão realmente armazenados fisicamente, eu preciso saber como guardar eles. Então sei quais dados, sei o que fazer com eles, sei onde estão fisicamente porem de nada serve sem um ator ou atores preciso saber quem que mexe com isso quem que da os dados disso, quem que mantem. Agora que sei o ator preciso saber a frequencia com que os atores realização todo esse processo, sem frequencia fica ambiguo quando o processo deve ser realizado. Finalmente motivação: o processo pode estar acontecendo todo de maneira perfeita porem a motivação não o justifica.

# MIR

O MIR (Modelagem informacional de Requisitos) surgiu para facilitar e guiar o processo de modelagem sem deixar tudo burocratico.

Aqui temos, Informação, Atores, obejtivos de um Ator, Processos e Comportamento de um Processo

A partir dos dados e dos atores podemos definir os objetivos dos atores, a partir da lista de objetivos informacionais definidos criamos os processos que são nada mais que o passo a passo para alcançar esses objetivos ja o comportamento do processo é a ação occorida ou a descrição do acontecido junto com o fluxo da informação ao realizar cada passo do processo.

**Principios da solução**

Ao solucionar devemos forcar nos objetivos pois eles expressam as demandas iniciais, atribuindo niveis de abstração a eles se são informacionais ou organizacionais, então devemos focar no detalhamento de cada objetivo, falaremos a seguir o detalhamento de objetivos informacionais

**Objetivos informacionais**

- Interface de um objetivo informacional
- Diccinario de itens elementares

**Objetivos Organizacionais**

É um conjunto de sequencias admissiveis de objetivos informacionais que  representa um objetivo maior relevante para a aplicação ou para os atores

**Sequencias admissiveis de Objetivos informacionais**

# Dicas

**Identificação de Atores**
Quem usa os principais casos 
de uso ?
Quem precisa de apoio para as 
tarefas de trabalho do 
cotidiano ?
Quem é responsável pela 
administração do sistema ?
Quais são os dispositivos ou 
sistemas externos com os 
quais o sistema em análise 
precisa se comunicar ?
Quem está interessado nos 
resultados do sistema ?

**Identificação de Casos de Uso**
Quais são as principais tarefas 
que o ator precisa executar ?
O ator deseja consultar ou 
modificar uma informação 
contida no sistema ?
O ator deseja informar no 
sistema alguma mudança 
realizada em outros sistemas ?
O ator deveria ser informado 
sobre eventos inesperados 
dentro do sistema ?

