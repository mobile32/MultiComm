USE [Contacts]
GO
/****** Object:  StoredProcedure [dbo].[AddContact]    Script Date: 01/24/2016 17:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[SelectContacts]
(@UserName nvarchar(50))
as
begin
declare @id integer;
set @id = (Select top 1 IdUser From UserLogin Where UserLogin.Name = @UserName);
Select Contact.Name, CallerName, ImageType, Image FROM Contact 
INNER JOIN UserLogin on Contact.IdUser = UserLogin.IdUser 
Where UserLogin.IdUser = @id
end
