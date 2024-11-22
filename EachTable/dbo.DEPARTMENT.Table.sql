USE [SUSHI_RESTAURANT]
GO
/****** Object:  Table [dbo].[DEPARTMENT]    Script Date: 22/11/2024 13:34:43 ******/
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
ALTER TABLE [dbo].[DEPARTMENT]  WITH CHECK ADD  CONSTRAINT [FK_DEPARTMENT_RESTAURANT_BRANCH] FOREIGN KEY([BRANCH_ID])
REFERENCES [dbo].[RESTAURANT_BRANCH] ([BRANCH_ID])
GO
ALTER TABLE [dbo].[DEPARTMENT] CHECK CONSTRAINT [FK_DEPARTMENT_RESTAURANT_BRANCH]
GO
