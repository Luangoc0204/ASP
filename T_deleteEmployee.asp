<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    idEmployee = Request.QueryString("idEmployee")
    Set cmdPrep = Server.CreateObject("ADODB.Command")
    connDB.Open()
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.CommandText = "delete from [User] where idUser=(select idUser from Employee where idEmployee=?)"
    cmdPrep.parameters.Append cmdPrep.createParameter("idEmployee",3,1,,Cint(idEmployee))
    cmdPrep.execute
    Session("Success") = "Delete employee successfully!"
    Response.redirect("TH_QL_quanlyNV.asp")
%>