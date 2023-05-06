<!--#include file="connect.asp"-->
<%
    idFood = Request.Querystring("idFood")
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "update Food set isActive = 0 where idFood = ?"
    cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
    cmdPrep.execute
    connDB.close
    Session("Success") = "Delete food successfully"
    Response.redirect("L_menu.asp")
%>