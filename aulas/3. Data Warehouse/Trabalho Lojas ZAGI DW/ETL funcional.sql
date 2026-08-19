
/************************************************************            
						ATENÇÃO!
Por favor, leia cuidadosamente todo o código antes deexecutá-lo.

1. Você precisa substituir a string "197990112" pelo seu código
de matrícula.

2. Rode o script em partes e valide cada ponto. Faço isso 
selecionando os pedaços de código e clicando em "execute".

3. Leia as referências passadas como comentários.

************************************************************/

/*****

Depois de rodar os scripts: 

DDL create tables Lojas ZAGI PT BR.sql
DML insert Lojas ZAGI PT BR.sql
DW ZAGI PT BR.sql

Siga atentamente os passos abaixo.

*****/

use DB197990112
go

-- Truncar todas as tabelas do DW, caso já existam

truncate table [DW197990112].[dbo].[Vendas];
delete from [DW197990112].[dbo].[Calendario];
delete from [DW197990112].[dbo].[Cliente];
delete from [DW197990112].[dbo].[Loja];
delete from [DW197990112].[dbo].[Produto];




---carga da tabela do censo (fonte externa)
CREATE TABLE [dbo].[CensoCliente](
	[IDCliente] [int] NOT NULL,
	[Genero] [char](1) NOT NULL,
	[EstadoCivil] [varchar](20) NOT NULL,
	[NivelEducacional] [varchar](50) NOT NULL,
	[CreditoPraca] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[CensoCliente] values
(1,'M','Solteiro','Graduação',700),
(2,'F','Solteiro','Mestrado',650),
(3,'F','Casado','Graduação',623),
(4,'F','Casado','Doutorado',750),
(5,'M','Solteiro','Primário',680),
(6,'F','Casado','Graduação',500),
(7,'M','Solteiro','Mestrado',560),
(8,'M','Casado','Graduação',640),
(9,'M','Solteiro','Graduação',590),
(10,'F','Solteiro','Primário',680)





INSERT INTO [DW197990112].[dbo].[Cliente]
select 
	newid(),
	c.ClienteID,
	c.ClienteNome,
	c.ClienteCEP,
	cc.Genero,
	cc.EstadoCivil,
	cc.NivelEducacional,
	cc.CreditoPraca
from
	CensoCliente cc inner join Cliente c on c.ClienteID = cc.IDCliente;

/****

Observe o erro com full join.

Por que ocorre?

Rode o select em separado.
Substitua pelo inner.


*****/


select * from [DW197990112].[dbo].Loja;

/****

Base da carga da base operacional.

****/

CREATE TABLE [dbo].[Layout](
	[IDLayout] [char](1) NOT NULL,
	[DescricaoLayout] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDLayout] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[Layout]
     VALUES
	('M','Moderno'),
	('T','Tradicional')
go

CREATE TABLE [dbo].[SistemaCheckout](
	[IDSCheckout] [char](3) NOT NULL,
	[SistemaCheckout] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDSCheckout] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[SistemaCheckout]
     VALUES
('AS','Auto-serviço'),
('CX','Caixa'),
('MX','Misto')
go

CREATE TABLE [dbo].[LojaDBOper](
	[IDLoja] [int] NOT NULL,
	[Tamanhom2] [int] NOT NULL,
	[IDSCheckout] [char](3) NOT NULL,
	[IDLayout] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDLoja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LojaDBOper]  WITH CHECK ADD FOREIGN KEY([IDLayout])
REFERENCES [dbo].[Layout] ([IDLayout])
GO

ALTER TABLE [dbo].[LojaDBOper]  WITH CHECK ADD FOREIGN KEY([IDSCheckout])
REFERENCES [dbo].[SistemaCheckout] ([IDSCheckout])
GO

INSERT INTO [dbo].[LojaDBOper]
     VALUES
	(1,51000,'CX','M'),
	(2,35000,'AS','T'),
	(3,55000,'MX','T')
GO


INSERT INTO [DW197990112].[dbo].Loja
select
	newid(),
	l.LojaID,
	l.LojaCEP,
	r.RegiaoNome,
	lo.Tamanhom2,
	sc.sistemacheckout,
	lt.DescricaoLayout
from
	Loja l left join Regiao r on r.RegiaoID=l.RegiaoID
	full join LojaDBOper lo on lo.IDLoja=l.LojaID
	full join SistemaCheckout sc on sc.IDSCheckout = lo.IDSCheckout
	full join Layout lt on lt.IDLayout=lo.IDLayout;

-- Produto

select * from [DW197990112].[dbo].Produto;

INSERT INTO [DW197990112].[dbo].Produto
select
	newid(),
	p.ProdID,
	p.ProdNome,
	p.ProdPreco,
	f.FornNome,
	c.CategNome
from
	Produto p left outer join Fornecedor f on f.FornID=p.FornID
	left outer join Categoria c on c.CategID=p.CategID;

-- Calendário, insere com valores distintos de transação , para facilitar


select * from [DW197990112].[dbo].Calendario;
-- carregar apenas as datas novas
insert into [DW197990112].[dbo].Calendario
select
	newid(),
	a.datacompleta,
	a.diasemana,
	a.dia,
	a.mes,
	a.trimestre,
	a.ano
from (
select distinct
	cast(t.TRNVendaData as date) as datacompleta,
	datename(weekday,t.TRNVendaData) as diasemana,
	datepart(day,t.TRNVendaData) as dia,
	datepart(month,t.TRNVendaData) as mes,
	datepart(quarter,t.TRNVendaData) as trimestre,
	datepart(year,t.TRNVendaData) as ano
from 
	Trans_de_Venda t 
where cast(t.TRNVendaData as date) not in (select [DataCompleta] from [DW197990112].[dbo].Calendario)
	) as a;


-- Vendas

-- transação de venda não tem hora

alter table Trans_de_Venda alter column [TRNVendaData] datetime;
-- mudar valores pra trazer hora

-- #21

select * from DW197990112.dbo.Vendas;

insert into DW197990112.dbo.Vendas
select
	t.[TRNVendaID],
	datepart(hour,t.TRNVendaData) as hora,
	(ie.[QTDProdTransV] * p.[ProdPreco]) as ReaisVendidos,
	ie.[QTDProdTransV],
	dwp.ChaveProduto,
	dwc.ChaveCliente,
	dwcal.ChaveCalendario as ChaveCalendario,
	dwl.ChaveLoja
from
	Trans_de_Venda t inner join Incluido_em ie on t.[TRNVendaID]=ie.[TRNVendaID]
	inner join Produto p on p.[ProdID]=ie.[ProdID]
	inner join Fornecedor f on f.[FornID]=p.[FornID]
	inner join Categoria c on c.[CategID]=p.[CategID]
	inner join Loja l on l.[LojaID]=t.[LojaID]
	inner join Cliente cli on cli.[ClienteID]=t.[ClienteID]
	inner join DW197990112.dbo.Produto dwp on dwp.IDProduto=p.[ProdID]
	inner join DW197990112.dbo.Loja dwl on dwl.IDLoja=l.[LojaID]
	inner join DW197990112.dbo.Cliente dwc on dwc.IDCliente=cli.[ClienteID]
	inner join [DW197990112].[dbo].Calendario dwcal on dwcal.DataCompleta=cast(t.TRNVendaData as date)
EXCEPT
SELECT [TID]
      ,[Hora]
      ,[ReaisVendidos]
      ,[UnidadesVendidas]
      ,[ChaveProduto]
      ,[ChaveCliente]
      ,[ChaveCalendario]
      ,[ChaveLoja]
  FROM [DW197990112].[dbo].[Vendas]
GO

---- validando ....

select
	t.[TRNVendaID],
	datepart(hour,t.TRNVendaData) as hora,
	(ie.[QTDProdTransV] * p.[ProdPreco]) as ReaisVendidos,
	ie.[QTDProdTransV],
	dwp.ChaveProduto,
	dwc.ChaveCliente,
	dwcal.ChaveCalendario as ChaveCalendario,
	dwl.ChaveLoja
from
	Trans_de_Venda t inner join Incluido_em ie on t.[TRNVendaID]=ie.[TRNVendaID]
	inner join Produto p on p.[ProdID]=ie.[ProdID]
	inner join Fornecedor f on f.[FornID]=p.[FornID]
	inner join Categoria c on c.[CategID]=p.[CategID]
	inner join Loja l on l.[LojaID]=t.[LojaID]
	inner join Cliente cli on cli.[ClienteID]=t.[ClienteID]
	inner join DW197990112.dbo.Produto dwp on dwp.IDProduto=p.[ProdID]
	inner join DW197990112.dbo.Loja dwl on dwl.IDLoja=l.[LojaID]
	inner join DW197990112.dbo.Cliente dwc on dwc.IDCliente=cli.[ClienteID]
	inner join [DW197990112].[dbo].Calendario dwcal on dwcal.DataCompleta=cast(t.TRNVendaData as date)
GO

Select * from DW197990112.dbo.Vendas

/*****

PARTE INCREMENTAL

****/

-- ETL
-- habilitar o cdc em todos os DBs - já feito pelo prof
/*
DECLARE @command varchar(1000) 
SELECT @command = 'USE ? EXEC sys.sp_cdc_enable_db' 
EXEC sp_MSforeachdb @command */


-- como fazer a carga incremental usando o CDC?
-- capturar as alterações em Transacao_de_Venda
/****

DECLARE @begin_time DATETIME;
DECLARE @end_time DATETIME;
DECLARE @begin_lsn BINARY(10); 
DECLARE @end_lsn BINARY(10);

SELECT @begin_time = GETDATE()-10, @end_time = GETDATE();
SELECT @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time); 
SELECT @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);
SELECT * FROM [cdc].[fn_cdc_get_all_changes_dbo_Transacao_de_Venda]
(
@begin_lsn,@end_lsn,'all'
);

*****/



-- Como será carga incremental?
-- Adicionar atributo de data/hora de carga em cada tabela?
-- Fazer validação de where em cada carga?
-- Habilitar CDC - Change Data Capture (https://medium.com/etl4devtips/habilitar-cdc-no-sql-server-bac7ef030f35#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImMzMTA0YzY4OGMxNWU2YjhlNThlNjdhMzI4NzgwOTUyYjIxNzQwMTciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2MzI1OTk1NjUsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjExMDMzNDA1MjE4MzA5MzE1MTA3NSIsImVtYWlsIjoianVsaW8uMDEwMTAxQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJuYW1lIjoiSnVsaW8gQ2VzYXIgQ2hhdmVzIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdpUFdlN2JsS0Vib2ZxMmlnTEZ6ZzdGQ3pkTWlzS3E3ZTZyeDc0Ujh2MD1zOTYtYyIsImdpdmVuX25hbWUiOiJKdWxpbyBDZXNhciIsImZhbWlseV9uYW1lIjoiQ2hhdmVzIiwiaWF0IjoxNjMyNTk5ODY1LCJleHAiOjE2MzI2MDM0NjUsImp0aSI6ImM2ODdkOGU4ZGM5NDI5MThkMDA3YmQ3NTY1NmE5OThiOWJiMWMyNWIifQ.m-X7f2w9y8s4BPTMp8NVKo-TLHl-PKYfS6fIgpnZA33VcgoaYKZfYz5LtYF6DDTCr--FwD9wFpRYdqe49wY3ayM3_U1PjYD4tAFtxeqZJWyvEgfT5BQs6Gz77eoVjN3u2hO5lnrGZ_k1t4viD2Mvz9-A8Y5dSL2vY_7Cp1kwzdGLiIG29XVf_fXLcLEJiH1w2KlrFygTO_4MTkM20NZjkE1qi2Imjiu24968XWSTjn09HgdKuB_dGPildUtVxQblpuHnoOnekLD3672q7xD7W0JkOEw-w-gvOHQbJ9xJCaXVdFzyaYQ2x_YuArgL9lk_yLdt0au6vBomesKeufknAQ)

--- Habilitar CDC para o seu DB transacional
/*use DB197990112;

*** Professor já fez para todos os bancos ***

EXEC sys.sp_cdc_enable_db;
EXEC sys.sp_cdc_disable_db;*/

--- confirmar que CDC está habilitado para o DB
select is_cdc_enabled,* from sys.databases where name in ('DB197990112');

--- agora habilitar por tabela
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Incluido_em',
@role_name     = NULL,
@supports_net_changes = 1
go

/***

Veja como desabilita o CDC para a tabela

EXEC sys.sp_cdc_disable_table  
@source_schema = N'dbo',  
@source_name   = N'Incluido_em',
@capture_instance = N'dbo_Incluido_em'
go

****/

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Trans_de_Venda',
@role_name     = NULL,
@supports_net_changes = 1
go


/***

Veja como desabilita o CDC para a tabela


EXEC sys.sp_cdc_disable_table  
@source_schema = N'dbo',  
@source_name   = N'Trans_de_Venda',
@capture_instance = N'dbo_Trans_de_Venda'
go  

****/
-- ver as tabelas com o recurso habilitado
exec sys.sp_cdc_help_change_data_capture

SELECT capture_instance FROM cdc.change_tables;
SELECT * FROM cdc.change_tables;

-- Cliente

use DB197990112;

select * from [DW197990112].[dbo].[Cliente];

SELECT * FROM [cdc].[dbo_Incluido_em_CT];

select * from [dbo].[Incluido_em] order by TRNVendaID;

-- no caso apenas de inserir item em transação
--INSERT INTO [DB197990112].[dbo].[Incluido_em] values(1, 3, 2);

select * from [dbo].[Trans_de_Venda];

insert into [dbo].[Trans_de_Venda] values (6,GETDATE(),3,2);

select * from [dbo].[Produto];

INSERT INTO [dbo].[Incluido_em] values(1, 2, 6);
INSERT INTO [dbo].[Incluido_em] values(2, 7, 6);



/******

Após inserir um item na transação o que ocorre na tabela de
CDC correspondente?

**********/

SELECT * FROM [cdc].[dbo_Incluido_em_CT];

-- vemos todas as alterações 
-- a título de simplicidade, consideremos apenas inclusões
SELECT [QTDProdTransV], [ProdID], [TRNVendaID] FROM [cdc].[dbo_Incluido_em_CT];

--- criando uma tabela de staging para incluido em
SELECT [QTDProdTransV], [ProdID], [TRNVendaID] into DW197990112.dbo.staging_dbo_Incluido_em FROM [cdc].[dbo_Incluido_em_CT];

--- criando uma tabela de staging para Trans_de_Venda
SELECT * FROM [cdc].[dbo_Trans_de_Venda_CT];
SELECT TRNVendaID, TRNVendaData, LojaID, ClienteID into DW197990112.dbo.staging_Trans_de_Venda FROM [cdc].[dbo_Trans_de_Venda_CT];

/*****

Atualizar calendário

******/

insert into [DW197990112].[dbo].Calendario
select
	newid(),
	a.datacompleta,
	a.diasemana,
	a.dia,
	a.mes,
	a.trimestre,
	a.ano
from (
select distinct
	cast(t.TRNVendaData as date) as datacompleta,
	datename(weekday,t.TRNVendaData) as diasemana,
	datepart(day,t.TRNVendaData) as dia,
	datepart(month,t.TRNVendaData) as mes,
	datepart(quarter,t.TRNVendaData) as trimestre,
	datepart(year,t.TRNVendaData) as ano
from 
	Trans_de_Venda t 
where cast(t.TRNVendaData as date) not in (select [DataCompleta] from [DW197990112].[dbo].Calendario)
	) as a;


-- atualização de acordo com o CDC

select * from DW197990112.dbo.Vendas;

-- só funciona se inserir nas duas tabelas, includes e salestransaction

insert into DW197990112.dbo.Vendas
select
	t.[TRNVendaID],
	datepart(hour,t.TRNVendaData) as hora,
	(ie.[QTDProdTransV] * p.[ProdPreco]) as ReaisVendidos,
	ie.[QTDProdTransV],
	dwp.ChaveProduto,
	dwc.ChaveCliente,
	dwcal.ChaveCalendario as ChaveCalendario,
	dwl.ChaveLoja
from
	DW197990112.[dbo].[staging_Trans_de_Venda] t 
	inner join DW197990112.dbo.staging_dbo_Incluido_em ie on t.[TRNVendaID]=ie.[TRNVendaID]
	inner join Produto p on p.[ProdID]=ie.[ProdID]
	inner join Fornecedor f on f.[FornID]=p.[FornID]
	inner join Categoria c on c.[CategID]=p.[CategID]
	inner join Loja l on l.[LojaID]=t.[LojaID]
	inner join Cliente cli on cli.[ClienteID]=t.[ClienteID]
	inner join DW197990112.dbo.Produto dwp on dwp.[IDProduto]=p.[ProdID]
	inner join DW197990112.dbo.Loja dwl on dwl.IDLoja=l.LojaID
	inner join DW197990112.dbo.Cliente dwc on dwc.[IDCliente]=cli.[ClienteID]
	inner join [DW197990112].[dbo].Calendario dwcal on dwcal.DataCompleta=cast(t.[TRNVendaData] as date);
	
/****

se não vier nada, conferir se as tabelas de staging correspondem ao conteúdo incremental.

*****/


-- agora que já carreguei, desabilitar e re-habilitar o CDC
SELECT * FROM cdc.change_tables;

EXEC sys.sp_cdc_disable_table  
@source_schema = N'dbo',  
@source_name   = N'Incluido_em',
@capture_instance = N'dbo_Incluido_em'
go

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Incluido_em',
@role_name     = NULL,
@supports_net_changes = 1
go

EXEC sys.sp_cdc_disable_table  
@source_schema = N'dbo',  
@source_name   = N'Trans_de_Venda',
@capture_instance = N'dbo_Trans_de_Venda'
go

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Trans_de_Venda',
@role_name     = NULL,
@supports_net_changes = 1
go

/****

conferir que agora a lista de mudanças está zerada!

*****/

SELECT [QTDProdTransV], [ProdID], [TRNVendaID] FROM [cdc].[dbo_Incluido_em_CT];
SELECT TRNVendaID, TRNVendaData, LojaID, ClienteID  FROM [cdc].[dbo_Trans_de_Venda_CT];


--- montar uma consulta para o fato vendas
use DW197990112
go

create view FatoVendas as
select 
	v.Hora,v.ReaisVendidos,v.TID,v.UnidadesVendidas,
	p.NomeProduto,p.NomeCategoriaProduto,p.NomeFornecedorProduto,p.PrecoProduto,
	c.Ano,c.DataCompleta,c.DiaMes,c.DiaSemana,c.Mes,c.Trimestre,
	cli.CEPCliente,cli.CreditoPracaCliente,cli.EstadoMaritalCliente,cli.GeneroCliente,cli.NivelEducacionalCliente,cli.NomeCliente,
	l.CEPLoja,l.CheckoutLoja,l.LayoutLoja,l.NomeRegiaoLoja,l.TamanhoLoja
from
	[DW197990112].[dbo].[Vendas] v inner join [DW197990112].[dbo].Calendario c on v.ChaveCalendario=c.ChaveCalendario
	inner join [DW197990112].[dbo].Cliente cli on cli.ChaveCliente = v.ChaveCliente
	inner join [DW197990112].[dbo].Produto p on p.ChaveProduto = v.ChaveProduto
	inner join [DW197990112].[dbo].Loja l on l.ChaveLoja = v.ChaveLoja
go

use DB197990112
go

select * from DW197990112.dbo.FatoVendas;

/******

Partir para a parte de dashboard no excel

******/