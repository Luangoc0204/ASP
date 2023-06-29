<!--#include file="connect.asp"-->
<%
    If (isnull(Session("role")) and Session("role") <> "ADMIN") Then
        ' true
        Response.redirect("logout.asp")

    End if
    idBill = CStr(Request.QueryString("idBill"))
    discount_user = CStr(Request.QueryString("discountUser"))
    discount_giftcode = CStr(Request.QueryString("discountGF"))
    totalPrice = CStr(Request.QueryString("totalPrice"))
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "update Bill set sumPrice = ' "&totalPrice&"', discount = '"&discount_user&"' , discountGiftCode = '"&discount_giftcode&"' where idBill = '"&idBill&"'"
    cmdPrep.execute
    Session("Success") = "Update Bill successfully"
    connDB.Close
%>