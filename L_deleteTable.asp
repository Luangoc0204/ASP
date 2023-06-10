<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    idTable = Request.QueryString("idTable")
    if (not isnull(idTable) or trim(idTable) <> "") then
        connDB.Open
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM [Table] where idTable = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idTable",3,1,,CInt(idTable))
        set result = cmdPrep.execute     
        if result.EOF then 
            Session("Error") = "Table is not exist!!!"
            Response.redirect("TH_listTable.asp")
        else
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "update [Table] set isActive = 0 where idTable = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idTable",3,1,,CInt(idTable))
            cmdPrep.execute
            Session("Success") = "Delete table successfully!"
            connDB.Close
            Response.redirect("TH_listTable.asp")
        end if    
    else
        'nếu không có idEmployee -> thông báo lỗi
        Session("Error") = "ID Table is not empty!!!"
        Response.redirect("TH_listTable.asp")
    end if                             
%>