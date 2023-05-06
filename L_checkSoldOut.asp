<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "") then
        Response.redirect("logout.asp")
    end if
    connDB.Open
    idFood = Request.QueryString("idFood")
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "SELECT dbo.CheckSoldOutFunc(?)"   
    cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,CInt(idFood))
    set result = cmdPrep.execute
    Response.write(CStr(result(0).Value))
    
    connDB.Close
%>