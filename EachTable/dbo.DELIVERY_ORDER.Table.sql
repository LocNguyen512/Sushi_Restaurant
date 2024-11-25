USE [SUSHI_RESTAURANT]
GO
/****** Object:  Table [dbo].[DELIVERY_ORDER]    Script Date: 22/11/2024 13:34:43 ******/
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
