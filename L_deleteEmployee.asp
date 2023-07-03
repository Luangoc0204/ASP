<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    idEmployee = Request.QueryString("idEmployee")
    if (not isnull(idEmployee) or trim(idEmployee) <> "") then
        connDB.Open
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT [User].* FROM Employee inner join [User] on Employee.idUser = [User].idUser where idEmployee = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idEmployee",3,1,,CInt(idEmployee))
        set result = cmdPrep.execute     
        if result.EOF then 
            Session("Error") = "Employee is not exist!!!"
            Response.redirect("TH_QL_quanlyNV.asp")
        else
            url = "upload\user\"
            oldFileName = result("avatar")
            Dim FSO
            Set FSO = Server.CreateObject("Scripting.FileSystemObject")
            If FSO.FileExists(Server.MapPath(".")&"\" & url & oldFileName) Then
                ' Nếu tệp tin tồn tại, thực hiện xóa
                FSO.DeleteFile(Server.MapPath(".")&"\"  & url & oldFileName)
                ' Response.Write "File " & oldFileName & " deleted. <br />"
            End If
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "delete from [User] where idUser = (select idUser from Employee where idEmployee = ?)"
            cmdPrep.parameters.Append cmdPrep.createParameter("idEmployee",3,1,,CInt(idEmployee))
            cmdPrep.execute
            Session("Success") = "Delete employee successfully!"
            connDB.Close
            Response.redirect("TH_QL_quanlyNV.asp")
        end if    
    else
        'nếu không có idEmployee -> thông báo lỗi
        Session("Error") = "ID Employee is empty!!!"
        Response.redirect("TH_QL_quanlyNV.asp")
    end if                             
%>