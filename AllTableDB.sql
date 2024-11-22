USE [master]
GO
/****** Object:  Database [SUSHI_RESTAURANT]    Script Date: 22/11/2024 13:29:37 ******/
CREATE DATABASE [SUSHI_RESTAURANT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SUSHI_RESTAURANT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SUSHI_RESTAURANT.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SUSHI_RESTAURANT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SUSHI_RESTAURANT_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SUSHI_RESTAURANT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ARITHABORT OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET  MULTI_USER 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET QUERY_STORE = ON
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [SUSHI_RESTAURANT]
GO
/****** Object:  Table [dbo].[AREA]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AREA](
	[AREA_ID] [char](3) NOT NULL,
	[AREA_NAME] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_AREA] PRIMARY KEY CLUSTERED 
(
	[AREA_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BRANCH_RATING]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BRANCH_RATING](
	[RATING_ID] [char](6) NOT NULL,
	[SERVICE_RATING] [int] NOT NULL,
	[LOCATION_RATING] [int] NOT NULL,
	[PRICE_RATING] [int] NOT NULL,
	[DISH_QUALITY_RATING] [int] NOT NULL,
	[ENVIRONMENT_RATING] [int] NOT NULL,
	[COMMENT] [nvarchar](100) NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
	[RATING_DATE] [date] NOT NULL,
	[INVOICE_ID] [char](6) NOT NULL,
 CONSTRAINT [PK_BRANCH_RATING] PRIMARY KEY CLUSTERED 
(
	[RATING_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CARD_TYPE]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARD_TYPE](
	[TYPE] [nvarchar](20) NOT NULL,
	[DISCOUNT_AMOUNT] [float] NOT NULL,
 CONSTRAINT [PK_CARD_TYPE] PRIMARY KEY CLUSTERED 
(
	[TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CUSTOMER]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUSTOMER](
	[CUSTOMER_ID] [char](6) NOT NULL,
	[FULL_NAME] [nvarchar](50) NOT NULL,
	[PHONE_NUMBER] [char](10) NOT NULL,
	[EMAIL] [varchar](40) NOT NULL,
	[IDENTITY_CARD] [char](12) NOT NULL,
	[GENDER] [nvarchar](4) NOT NULL,
 CONSTRAINT [PK_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[CUSTOMER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DELIVERY_ORDER]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DELIVERY_ORDER](
	[DORDER_ID] [char](6) NOT NULL,
	[DATE_DELIVERY] [date] NOT NULL,
	[TIME_DELIVERY] [date] NOT NULL,
 CONSTRAINT [PK_DELIVERY_ORDER] PRIMARY KEY CLUSTERED 
(
	[DORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DEPARTMENT]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPARTMENT](
	[DEPARTMENT_ID] [char](3) NOT NULL,
	[DEPARTMENT_NAME] [nvarchar](50) NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_DEPARTMENT_1] PRIMARY KEY CLUSTERED 
(
	[DEPARTMENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DISH]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DISH](
	[DISH_ID] [char](3) NOT NULL,
	[DISH_NAME] [nvarchar](30) NOT NULL,
	[DISH_PRICE] [int] NOT NULL,
	[CATEGORY_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_DISH] PRIMARY KEY CLUSTERED 
(
	[DISH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DISH_AVAILABLE]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DISH_AVAILABLE](
	[BRANCH_ID] [char](3) NOT NULL,
	[DISH_ID] [char](3) NOT NULL,
	[IS_AVAILABLE] [bit] NOT NULL,
	[ABLE_DELIVERIED] [bit] NOT NULL,
 CONSTRAINT [PK_DISH_AVAILABLE] PRIMARY KEY CLUSTERED 
(
	[BRANCH_ID] ASC,
	[DISH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLOYEE]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYEE](
	[EMPLOYEE_ID] [char](6) NOT NULL,
	[FULL_NAME] [nvarchar](50) NOT NULL,
	[DATE_OF_BIRTH] [date] NOT NULL,
	[GENDER] [nvarchar](3) NOT NULL,
	[SALARY] [int] NOT NULL,
	[START_DATE] [date] NOT NULL,
	[TERMINATION_DATE] [date] NOT NULL,
	[DEPARTMENT_ID] [char](3) NOT NULL,
	[POSITION] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVOICE]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVOICE](
	[INVOICE_ID] [char](6) NOT NULL,
	[TOTAL_AMOUNT] [int] NOT NULL,
	[DISCOUNT] [float] NOT NULL,
	[ISSUE_DATE] [date] NOT NULL,
	[ORDER_ID] [char](6) NOT NULL,
 CONSTRAINT [PK_INVOICE] PRIMARY KEY CLUSTERED 
(
	[INVOICE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MEMBERSHIP_CARD]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEMBERSHIP_CARD](
	[CARD_ID] [char](6) NOT NULL,
	[CARD_TYPE] [nvarchar](20) NOT NULL,
	[CUSTOMER_ID] [char](6) NOT NULL,
	[DATE_ISSUED] [date] NOT NULL,
	[EMPLOYEE_ID] [char](6) NOT NULL,
	[POINTS] [int] NOT NULL,
	[CARD_STATUS] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_MEMBERSHIP_CARD] PRIMARY KEY CLUSTERED 
(
	[CARD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MENU_CATEGORY]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENU_CATEGORY](
	[CATEGORY_ID] [char](3) NOT NULL,
	[CATEGORY_NAME] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_MENU_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[CATEGORY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OFFLINE_ORDER]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OFFLINE_ORDER](
	[OFORDER_ID] [char](6) NOT NULL,
	[TABLE_NUMBER] [int] NOT NULL,
	[EMPLOYEE_ID] [char](6) NOT NULL,
	[EMPLOYEE_RATING] [int] NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_OFFLINE_ORDER] PRIMARY KEY CLUSTERED 
(
	[OFORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ONLINE_ACCESS_HISTORY]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONLINE_ACCESS_HISTORY](
	[DATE_ACCESSED] [date] NOT NULL,
	[TIME_ACCESSED] [time](7) NOT NULL,
	[CUSTOMER_ID] [char](6) NOT NULL,
	[ACCESS_DURATION] [time](7) NOT NULL,
 CONSTRAINT [PK_ONLINE_ACCESS_HISTORY] PRIMARY KEY CLUSTERED 
(
	[DATE_ACCESSED] ASC,
	[TIME_ACCESSED] ASC,
	[CUSTOMER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ONLINE_ORDER]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONLINE_ORDER](
	[OORDER_ID] [char](6) NOT NULL,
	[ARRIVAL_DATE] [date] NOT NULL,
	[ARRIVAL_TIME] [time](7) NOT NULL,
	[TABLE_NUMBER] [int] NOT NULL,
	[CUSTOMER_QUANTITY] [int] NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_ONLINE_ORDER] PRIMARY KEY CLUSTERED 
(
	[OORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ORDER]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDER](
	[ORDER_ID] [char](6) NOT NULL,
	[ORDER_DATE] [date] NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
	[CUSTOMER_ID] [char](6) NOT NULL,
	[ORDER_TYPE] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_ORDER] PRIMARY KEY CLUSTERED 
(
	[ORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ORDER_DISH]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDER_DISH](
	[ORDER_ID] [char](6) NOT NULL,
	[DISH_ID] [char](3) NOT NULL,
	[QUANTITY] [int] NOT NULL,
 CONSTRAINT [PK_ORDER_DISH] PRIMARY KEY CLUSTERED 
(
	[ORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RESTAURANT_BRANCH]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RESTAURANT_BRANCH](
	[BRANCH_ID] [char](3) NOT NULL,
	[BRANCH_PHONE] [char](10) NOT NULL,
	[BRANCH_NAME] [nvarchar](40) NOT NULL,
	[BRANCH_ADDRESS] [nvarchar](70) NOT NULL,
	[OPEN_TIME] [time](7) NOT NULL,
	[CLOSE_TIME] [time](7) NOT NULL,
	[CAR_PARK] [varchar](3) NOT NULL,
	[MOTORBIKE_PARK] [varchar](3) NOT NULL,
	[MANAGER_ID] [char](6) NOT NULL,
	[AREA_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_RESTAURANT_BRANCH] PRIMARY KEY CLUSTERED 
(
	[BRANCH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TABLE_]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TABLE_](
	[TABLE_NUM] [int] NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
	[TABLE_STATUS] [nvarchar](50) NOT NULL,
	[SEAT_AVILABLE] [int] NOT NULL,
 CONSTRAINT [PK_TABLE] PRIMARY KEY CLUSTERED 
(
	[TABLE_NUM] ASC,
	[BRANCH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WORK_HISTORY]    Script Date: 22/11/2024 13:29:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WORK_HISTORY](
	[BRANCH_START_DATE] [date] NOT NULL,
	[BRANCH_END_DATE] [date] NOT NULL,
	[EMPLOYEE_ID] [char](6) NOT NULL,
	[BRANCH_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_WORK_HISTORY] PRIMARY KEY CLUSTERED 
(
	[BRANCH_START_DATE] ASC,
	[EMPLOYEE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BRANCH_RATING]  WITH CHECK ADD  CONSTRAINT [FK_BRANCH_RATING_INVOICE] FOREIGN KEY([INVOICE_ID])
REFERENCES [dbo].[INVOICE] ([INVOICE_ID])
GO
ALTER TABLE [dbo].[BRANCH_RATING] CHECK CONSTRAINT [FK_BRANCH_RATING_INVOICE]
GO
ALTER TABLE [dbo].[BRANCH_RATING]  WITH CHECK ADD  CONSTRAINT [FK_BRANCH_RATING_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[BRANCH_RATING] CHECK CONSTRAINT [FK_BRANCH_RATING_RESTAURANT_BRANCH]
GO
ALTER TABLE [dbo].[DEPARTMENT]  WITH CHECK ADD  CONSTRAINT [FK_DEPARTMENT_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[DEPARTMENT] CHECK CONSTRAINT [FK_DEPARTMENT_RESTAURANT_BRANCH]
GO
ALTER TABLE [dbo].[DISH]  WITH CHECK ADD  CONSTRAINT [FK_DISH_MENU_CATEGORY] FOREIGN KEY([CATEGORY_ID])
REFERENCES [dbo].[MENU_CATEGORY] ([CATEGORY_ID])
GO
ALTER TABLE [dbo].[DISH] CHECK CONSTRAINT [FK_DISH_MENU_CATEGORY]
GO
ALTER TABLE [dbo].[DISH_AVAILABLE]  WITH CHECK ADD  CONSTRAINT [FK_DISH_AVAILABLE_DISH] FOREIGN KEY([DISH_ID])
REFERENCES [dbo].[DISH] ([DISH_ID])
GO
ALTER TABLE [dbo].[DISH_AVAILABLE] CHECK CONSTRAINT [FK_DISH_AVAILABLE_DISH]
GO
ALTER TABLE [dbo].[DISH_AVAILABLE]  WITH CHECK ADD  CONSTRAINT [FK_DISH_AVAILABLE_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[DISH_AVAILABLE] CHECK CONSTRAINT [FK_DISH_AVAILABLE_RESTAURANT_BRANCH]
GO
ALTER TABLE [dbo].[EMPLOYEE]  WITH CHECK ADD  CONSTRAINT [FK_EMPLOYEE_DEPARTMENT] FOREIGN KEY([DEPARTMENT_ID])
REFERENCES [dbo].[DEPARTMENT] ([DEPARTMENT_ID])
GO
ALTER TABLE [dbo].[EMPLOYEE] CHECK CONSTRAINT [FK_EMPLOYEE_DEPARTMENT]
GO
ALTER TABLE [dbo].[INVOICE]  WITH CHECK ADD  CONSTRAINT [FK_INVOICE_ORDER] FOREIGN KEY([ORDER_ID])
REFERENCES [dbo].[ORDER] ([ORDER_ID])
GO
ALTER TABLE [dbo].[INVOICE] CHECK CONSTRAINT [FK_INVOICE_ORDER]
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD]  WITH CHECK ADD  CONSTRAINT [FK_MEMBERSHIP_CARD_CARD_TYPE] FOREIGN KEY([CARD_TYPE])
REFERENCES [dbo].[CARD_TYPE] ([TYPE])
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD] CHECK CONSTRAINT [FK_MEMBERSHIP_CARD_CARD_TYPE]
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD]  WITH CHECK ADD  CONSTRAINT [FK_MEMBERSHIP_CARD_CUSTOMER] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD] CHECK CONSTRAINT [FK_MEMBERSHIP_CARD_CUSTOMER]
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD]  WITH CHECK ADD  CONSTRAINT [FK_MEMBERSHIP_CARD_EMPLOYEE] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [dbo].[MEMBERSHIP_CARD] CHECK CONSTRAINT [FK_MEMBERSHIP_CARD_EMPLOYEE]
GO
ALTER TABLE [dbo].[OFFLINE_ORDER]  WITH CHECK ADD  CONSTRAINT [FK_OFFLINE_ORDER_EMPLOYEE1] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [dbo].[OFFLINE_ORDER] CHECK CONSTRAINT [FK_OFFLINE_ORDER_EMPLOYEE1]
GO
ALTER TABLE [dbo].[OFFLINE_ORDER]  WITH CHECK ADD  CONSTRAINT [FK_OFFLINE_ORDER_TABLE_] FOREIGN KEY([TABLE_NUMBER], [BRANCH_ID])
REFERENCES [dbo].[TABLE_] ([TABLE_NUM], [BRANCH_ID])
GO
ALTER TABLE [dbo].[OFFLINE_ORDER] CHECK CONSTRAINT [FK_OFFLINE_ORDER_TABLE_]
GO
ALTER TABLE [dbo].[ONLINE_ACCESS_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_ONLINE_ACCESS_HISTORY_CUSTOMER] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[ONLINE_ACCESS_HISTORY] CHECK CONSTRAINT [FK_ONLINE_ACCESS_HISTORY_CUSTOMER]
GO
ALTER TABLE [dbo].[ONLINE_ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ONLINE_ORDER_TABLE_] FOREIGN KEY([TABLE_NUMBER], [BRANCH_ID])
REFERENCES [dbo].[TABLE_] ([TABLE_NUM], [BRANCH_ID])
GO
ALTER TABLE [dbo].[ONLINE_ORDER] CHECK CONSTRAINT [FK_ONLINE_ORDER_TABLE_]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_CUSTOMER] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[CUSTOMER] ([CUSTOMER_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_CUSTOMER]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_DELIVERY_ORDER1] FOREIGN KEY([ORDER_ID])
REFERENCES [dbo].[DELIVERY_ORDER] ([DORDER_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_DELIVERY_ORDER1]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_OFFLINE_ORDER] FOREIGN KEY([ORDER_ID])
REFERENCES [dbo].[OFFLINE_ORDER] ([OFORDER_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_OFFLINE_ORDER]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_ONLINE_ORDER] FOREIGN KEY([ORDER_ID])
REFERENCES [dbo].[ONLINE_ORDER] ([OORDER_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_ONLINE_ORDER]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_ORDER_DISH] FOREIGN KEY([ORDER_ID])
REFERENCES [dbo].[ORDER_DISH] ([ORDER_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_ORDER_DISH]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_RESTAURANT_BRANCH]
GO
ALTER TABLE [dbo].[ORDER_DISH]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_DISH_DISH] FOREIGN KEY([DISH_ID])
REFERENCES [dbo].[DISH] ([DISH_ID])
GO
ALTER TABLE [dbo].[ORDER_DISH] CHECK CONSTRAINT [FK_ORDER_DISH_DISH]
GO
ALTER TABLE [dbo].[RESTAURANT_BRANCH]  WITH CHECK ADD  CONSTRAINT [FK_RESTAURANT_BRANCH_AREA] FOREIGN KEY([AREA_ID])
REFERENCES [dbo].[AREA] ([AREA_ID])
GO
ALTER TABLE [dbo].[RESTAURANT_BRANCH] CHECK CONSTRAINT [FK_RESTAURANT_BRANCH_AREA]
GO
ALTER TABLE [dbo].[RESTAURANT_BRANCH]  WITH CHECK ADD  CONSTRAINT [FK_RESTAURANT_BRANCH_EMPLOYEE] FOREIGN KEY([MANAGER_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [dbo].[RESTAURANT_BRANCH] CHECK CONSTRAINT [FK_RESTAURANT_BRANCH_EMPLOYEE]
GO
ALTER TABLE [dbo].[TABLE_]  WITH CHECK ADD  CONSTRAINT [FK_TABLE__RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[TABLE_] CHECK CONSTRAINT [FK_TABLE__RESTAURANT_BRANCH]
GO
ALTER TABLE [dbo].[WORK_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_WORK_HISTORY_EMPLOYEE] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [dbo].[WORK_HISTORY] CHECK CONSTRAINT [FK_WORK_HISTORY_EMPLOYEE]
GO
ALTER TABLE [dbo].[WORK_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_WORK_HISTORY_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[WORK_HISTORY] CHECK CONSTRAINT [FK_WORK_HISTORY_RESTAURANT_BRANCH]
GO
USE [master]
GO
ALTER DATABASE [SUSHI_RESTAURANT] SET  READ_WRITE 
GO
