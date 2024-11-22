USE [SUSHI_RESTAURANT]
GO
/****** Object:  Table [dbo].[TABLE_]    Script Date: 22/11/2024 13:34:43 ******/
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
ALTER TABLE [dbo].[TABLE_]  WITH CHECK ADD  CONSTRAINT [FK_TABLE__RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[TABLE_] CHECK CONSTRAINT [FK_TABLE__RESTAURANT_BRANCH]
GO
