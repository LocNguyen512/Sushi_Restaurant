USE [SUSHI_RESTAURANT]
GO
/****** Object:  Table [dbo].[WORK_HISTORY]    Script Date: 22/11/2024 13:34:43 ******/
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
