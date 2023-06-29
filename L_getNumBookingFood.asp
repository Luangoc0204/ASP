<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    idBookingTable = Request.QueryString("idBookingTable")
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT Count(idBookingFood) from BookingFood where idBookingTable = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
        set result = cmdPrep.execute
        Response.write(CStr(result(0).Value))
    connDB.Close    
%>