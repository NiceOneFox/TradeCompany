USE [MainDB]
GO
/****** Object:  StoredProcedure [dbo].[create_order]    Script Date: 14.04.2021 13:49:45 ******/
DROP PROCEDURE IF EXISTS [dbo].[create_order]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_list]') AND type in (N'U'))
ALTER TABLE [dbo].[Order_list] DROP CONSTRAINT IF EXISTS [FK_Order_list_Goods]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_list]') AND type in (N'U'))
ALTER TABLE [dbo].[Order_list] DROP CONSTRAINT IF EXISTS [FK_Order_list_CreditOrder]
GO
/****** Object:  Table [dbo].[Order_list]    Script Date: 14.04.2021 13:49:45 ******/
DROP TABLE IF EXISTS [dbo].[Order_list]
GO
/****** Object:  Table [dbo].[Goods]    Script Date: 14.04.2021 13:49:45 ******/
DROP TABLE IF EXISTS [dbo].[Goods]
GO
/****** Object:  Table [dbo].[Entrys]    Script Date: 14.04.2021 13:49:45 ******/
DROP TABLE IF EXISTS [dbo].[Entrys]
GO
/****** Object:  Table [dbo].[CreditOrder]    Script Date: 14.04.2021 13:49:45 ******/
DROP TABLE IF EXISTS [dbo].[CreditOrder]
GO
/****** Object:  Table [dbo].[Cages]    Script Date: 14.04.2021 13:49:45 ******/
DROP TABLE IF EXISTS [dbo].[Cages]
GO
USE [master]
GO
/****** Object:  Database [MainDB]    Script Date: 14.04.2021 13:49:45 ******/
DROP DATABASE IF EXISTS [MainDB]
GO
/****** Object:  Database [MainDB]    Script Date: 14.04.2021 13:49:45 ******/
CREATE DATABASE [MainDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MainDB', FILENAME = N'F:\SQLExpressServer\MSSQL15.MSSQLSERVER\MSSQL\DATA\MainDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MainDB_log', FILENAME = N'F:\SQLExpressServer\MSSQL15.MSSQLSERVER\MSSQL\DATA\MainDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MainDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MainDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MainDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MainDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MainDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MainDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MainDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MainDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MainDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MainDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MainDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MainDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MainDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MainDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MainDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MainDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MainDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MainDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MainDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MainDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MainDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MainDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MainDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MainDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MainDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MainDB] SET  MULTI_USER 
GO
ALTER DATABASE [MainDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MainDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MainDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MainDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MainDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MainDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MainDB] SET QUERY_STORE = OFF
GO
USE [MainDB]
GO
/****** Object:  Table [dbo].[Cages]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cages](
	[id] [int] NOT NULL,
	[Cage_num] [int] NOT NULL,
	[Cage_date] [date] NOT NULL,
	[Summary] [decimal](18, 2) NOT NULL,
	[Type] [char](1) NOT NULL,
	[Note] [varchar](120) NULL,
 CONSTRAINT [PK_Cages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CreditOrder]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditOrder](
	[document_num] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[contract] [nvarchar](max) NULL,
	[vendor] [varchar](200) NOT NULL,
	[warehouse] [varchar](250) NOT NULL,
 CONSTRAINT [PK_CreditOrder_1] PRIMARY KEY CLUSTERED 
(
	[document_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Entrys]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entrys](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Debit] [int] NOT NULL,
	[Credit] [int] NOT NULL,
	[Summary] [decimal](18, 2) NOT NULL,
	[Month] [date] NOT NULL,
	[Source] [varchar](40) NOT NULL,
	[Source_id] [int] NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_Entrys] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Goods]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Goods](
	[id] [int] NOT NULL,
	[name] [varchar](120) NOT NULL,
	[description] [nvarchar](255) NULL,
	[price] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Goods] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order_list]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_list](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_order] [int] NOT NULL,
	[id_good] [int] NOT NULL,
	[total] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Cages] ([id], [Cage_num], [Cage_date], [Summary], [Type], [Note]) VALUES (134565, 34, CAST(N'2009-07-03' AS Date), CAST(1200.00 AS Decimal(18, 2)), N'R', N'---')
INSERT [dbo].[Cages] ([id], [Cage_num], [Cage_date], [Summary], [Type], [Note]) VALUES (156478, 145, CAST(N'2009-07-15' AS Date), CAST(700.00 AS Decimal(18, 2)), N'R', N'Расходы')
INSERT [dbo].[Cages] ([id], [Cage_num], [Cage_date], [Summary], [Type], [Note]) VALUES (164579, 248, CAST(N'2009-07-24' AS Date), CAST(900.00 AS Decimal(18, 2)), N'P', NULL)
GO
SET IDENTITY_INSERT [dbo].[CreditOrder] ON 

INSERT [dbo].[CreditOrder] ([document_num], [date], [contract], [vendor], [warehouse]) VALUES (1, CAST(N'2019-07-01' AS Date), N'Договор ..', N'Газпром', N'г. Санкт-петербург адрес..')
SET IDENTITY_INSERT [dbo].[CreditOrder] OFF
GO
SET IDENTITY_INSERT [dbo].[Entrys] ON 

INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (1, 7101, 5001, CAST(50.00 AS Decimal(18, 2)), CAST(N'2009-06-01' AS Date), N'CAGES', 134565, CAST(N'2009-07-03' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (2, 7103, 5001, CAST(500.00 AS Decimal(18, 2)), CAST(N'2009-07-01' AS Date), N'CAGES', 156478, CAST(N'2009-07-24' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (3, 1003, 6007, CAST(1200.00 AS Decimal(18, 2)), CAST(N'2009-07-01' AS Date), N'INCOME', 103456, CAST(N'2009-07-30' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (4, 701, 6007, CAST(15207.00 AS Decimal(18, 2)), CAST(N'2009-07-01' AS Date), N'INCOME', 106546, CAST(N'2009-08-02' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (5, 2001, 1003, CAST(250.00 AS Decimal(18, 2)), CAST(N'2009-07-01' AS Date), N'SEBEST', 45641, CAST(N'2009-08-03' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (6, 2001, 1003, CAST(300.00 AS Decimal(18, 2)), CAST(N'2009-07-01' AS Date), N'SEBEST', 49846, CAST(N'2009-08-03' AS Date))
INSERT [dbo].[Entrys] ([id], [Debit], [Credit], [Summary], [Month], [Source], [Source_id], [Date]) VALUES (7, 801, 1003, CAST(800.00 AS Decimal(18, 2)), CAST(N'2009-08-01' AS Date), N'OUTCOME', 90878, CAST(N'2009-08-01' AS Date))
SET IDENTITY_INSERT [dbo].[Entrys] OFF
GO
INSERT [dbo].[Goods] ([id], [name], [description], [price]) VALUES (1, N'Печенье', N'печенье с арахисом', CAST(350.25 AS Decimal(18, 2)))
INSERT [dbo].[Goods] ([id], [name], [description], [price]) VALUES (2, N'Вафли', N'состав: сахар, мука', CAST(20.35 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[Order_list] ON 

INSERT [dbo].[Order_list] ([id], [id_order], [id_good], [total]) VALUES (1, 1, 1, 15)
INSERT [dbo].[Order_list] ([id], [id_order], [id_good], [total]) VALUES (2, 1, 1, 7)
INSERT [dbo].[Order_list] ([id], [id_order], [id_good], [total]) VALUES (3, 1, 2, 5)
SET IDENTITY_INSERT [dbo].[Order_list] OFF
GO
ALTER TABLE [dbo].[Order_list]  WITH CHECK ADD  CONSTRAINT [FK_Order_list_CreditOrder] FOREIGN KEY([id_order])
REFERENCES [dbo].[CreditOrder] ([document_num])
GO
ALTER TABLE [dbo].[Order_list] CHECK CONSTRAINT [FK_Order_list_CreditOrder]
GO
ALTER TABLE [dbo].[Order_list]  WITH CHECK ADD  CONSTRAINT [FK_Order_list_Goods] FOREIGN KEY([id_good])
REFERENCES [dbo].[Goods] ([id])
GO
ALTER TABLE [dbo].[Order_list] CHECK CONSTRAINT [FK_Order_list_Goods]
GO
/****** Object:  StoredProcedure [dbo].[create_order]    Script Date: 14.04.2021 13:49:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[create_order]
@good_name varchar(120),
@order_id int,
@total int
AS
BEGIN

IF NOT EXISTS (SELECT g.id FROM [Goods] g
WHERE g.name = @good_name) 
  ROLLBACK TRANSACTION

DECLARE @id_good int = (SELECT g.id FROM [Goods] g
WHERE g.name = @good_name)

INSERT INTO Order_list(id_order, id_good, total)
VALUES(@order_id, @id_good, @total);

END
GO
USE [master]
GO
ALTER DATABASE [MainDB] SET  READ_WRITE 
GO
