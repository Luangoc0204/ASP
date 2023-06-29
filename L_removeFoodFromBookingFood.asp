<!-- #include file="connect.asp" --> 
<%
    idBookingFood = CInt(Request.QueryString("idBookingFood"))
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "delete from BookingFood where idBookingFood = ?"
    cmdPrep.parameters.Append cmdPrep.createParameter("idBookingFood",3,1, ,idBookingFood)
    set result = cmdPrep.execute
    connDB.Close    
    Session("Success") = "Remove food from cart successfully!"
    Response.redirect("L_purchaseCart.asp")
%>