<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") = "CUSTOMER") Then
        Response.redirect("logout.asp")
    End If
    idBookingTable = Request.QueryString("idBookingTable")
    if (not isnull(idEmployee) or trim(idEmployee) <> "") then
        connDB.Open
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM BookingTable where idBookingTable = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1,,CInt(idBookingTable))
        set result = cmdPrep.execute     
        if result.EOF then 
            Session("Error") = "Booking Table is not exist!!!"
            'Response.redirect("TH_QL_quanlyNV.asp")
        else
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "delete from [BookingTable] where idBookingTable = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1,,CInt(idBookingTable))
            cmdPrep.execute
            Session("Success") = "Delete booking table successfully!"
            connDB.Close
            'Response.redirect("TH_QL_quanlyNV.asp")
        end if    
    else
        'nếu không có idEmployee -> thông báo lỗi
        Session("Error") = "ID Booking Table is not empty!!!"
        'Response.redirect("TH_QL_quanlyNV.asp")
    end if                             
%>