USE [Contacts]
GO
/****** Object:  StoredProcedure [dbo].[AddContact]    Script Date: 01/27/2016 14:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[AddContact]
(@Name nvarchar(50), @CallerName nvarchar(50),@ImageType int,@Image varbinary(MAX), @UserName nvarchar(50))
as
begin
declare @id integer;
set @id = (Select top 1 IdUser From UserLogin Where UserLogin.Name = @UserName);

if not exists(select Contact.CallerName from Contact 
	where Contact.Name = @Name and Contact.IdUser = @id )
	
insert into Contact(Name, CallerName,ImageType,Image,IdUser)
values(@Name, @CallerName,@ImageType,@Image,@id)
end
