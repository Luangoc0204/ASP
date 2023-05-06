<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "") then
        Response.redirect("logout.asp")
    end if
    id = CInt(Request.Form("id"))
    amount = Request.Form("amount")
    file = Request.Form("file")
    'Response.write("id: " + CStr(id))
    'Response.write("amount: " + CStr(amount))
    'Response.write("file: " + CStr(file))
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    if file = "CF" then
        cmdPrep.CommandText = "update CartFood set amountCF = ? where idCartFood = ?"
        Response.write("Update idCartFood " + CStr(id) + " successfully")
    else 
        cmdPrep.CommandText = "update BookingFood set amountBF = ? where idBookingFood = ?"
        Response.write("Update idBookingFood " + CStr(id) + " successfully")
    end if    
    cmdPrep.parameters.Append cmdPrep.createParameter("amountCF",3,1, ,amount)
    cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,id)
    cmdPrep.execute
    connDB.Close
%>