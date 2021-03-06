USE [Contacts]
GO
/****** Object:  User [HAPEK-PC\Jasiek]    Script Date: 2015-12-13 20:16:54 ******/
CREATE USER [HAPEK-PC\Jasiek] FOR LOGIN [HAPEK-PC\Jasiek] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HAPEK-PC\Jasiek]
GO
/****** Object:  StoredProcedure [dbo].[AddContact]    Script Date: 2015-12-13 20:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddContact]
(@Name nvarchar(50), @CallerName nvarchar(50))
as
begin
if not exists(select Contact.CallerName from Contact where Contact.Name like @Name)
insert into Contact(Name, CallerName)
values(@Name, @CallerName)
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteContact]    Script Date: 2015-12-13 20:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DeleteContact]
(@Name nvarchar(50))
as
begin
if exists(select Contact.CallerName from Contact where Contact.Name like @Name)
delete from Contact
where Contact.Name like @Name
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateContact]    Script Date: 2015-12-13 20:16:54 ******/
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
/****** Object:  Table [dbo].[Contact]    Script Date: 2015-12-13 20:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[IdContact] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CallerName] [nvarchar](max) NULL,
	[IdUser] [int] NULL,
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
/****** Object:  Table [dbo].[UserLogin]    Script Date: 2015-12-13 20:16:54 ******/
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
