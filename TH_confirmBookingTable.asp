<!--#include file="connect.asp"-->
<%
    idBookingTable = Request.QueryString("idBookingTable")
    connDB.Open()
    Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE BookingTable SET isCheckin = 1 WHERE idBookingTable = ?"
                cmdPrep.parameters.Append cmdPrep.createParameter("nameFood",3,1, ,CInt(idBookingTable))
                cmdPrep.execute
    Response.redirect("TH_listDBByDate.asp")              
%>
