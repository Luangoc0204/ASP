<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    idGiftCode = Request.QueryString("idGiftCode")
    if (not isnull(idGiftCode) or trim(idGiftCode) <> "") then
        connDB.Open
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM [GiftCode] where idGiftCode = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idGiftCode",3,1,,CInt(idGiftCode))
        set result = cmdPrep.execute     
        if result.EOF then 
            Session("Error") = "Giftcode is not exist!!!"
            Response.redirect("T_Giftcode.asp")
        else
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "delete from GiftCode where idGiftCode = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idGiftCode",3,1,,CInt(idGiftCode))
            cmdPrep.execute
            Session("Success") = "Delete giftcode successfully!"
            connDB.Close
            Response.redirect("T_Giftcode.asp")
        end if    
    else
        'nếu không có idEmployee -> thông báo lỗi
        Session("Error") = "ID giftcode is not empty!!!"
        Response.redirect("T_Giftcode.asp")
    end if                             
%>