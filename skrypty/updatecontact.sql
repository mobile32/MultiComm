USE [Contacts]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContact]    Script Date: 01/24/2016 09:53:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[UpdateContact]
(@Name nvarchar(50), @CallerName nvarchar(50),@ImageType int,@Image varbinary(MAX))
as
begin
if  exists(select Contact.CallerName from Contact where Contact.Name = @Name)
update Contact
set Contact.CallerName = @CallerName, Contact.ImageType = @ImageType, Contact.Image = @Image where Contact.Name = @Name
end


