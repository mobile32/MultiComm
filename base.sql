USE [Contacts]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 13.12.2015 17:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[IdContact] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CallerName] [nvarchar](max) NULL,
	[IdUser] [int] NOT NULL,
	[Age] [int] NULL,
	[Email] [nvarchar](max) NULL,
	[Gender] [nvarchar](max) NULL,
	[Telephon] [int] NULL,
	[City] [nvarchar](max) NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[IdContact] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 13.12.2015 17:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogin](
	[IdUser] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_UserLogin] FOREIGN KEY([IdUser])
REFERENCES [dbo].[UserLogin] ([IdUser])
GO
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [FK_Contact_UserLogin]
GO
/****** Object:  StoredProcedure [dbo].[AddContact]    Script Date: 13.12.2015 17:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddContact]
(@Name nvarchar(50), @CallerName nvarchar(50))
as
begin
if not exists(select Contact.CallerName from Contact where Contact.Name like @Name)
insert into Contact(Name, CallerName, IdUser)
values(@Name, @CallerName, 1)
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateContact]    Script Date: 13.12.2015 17:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[UpdateContact]
(@Name nvarchar(50), @CallerName nvarchar(50))
as
begin
if  exists(select Contact.CallerName from Contact where Contact.Name like @Name)
update Contact
set Contact.CallerName=@CallerName where Contact.Name like @Name
end

GO
