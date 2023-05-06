<!-- #include file="connect.asp" --> 
<%
    idCartFood = CInt(Request.QueryString("idCartFood"))
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "delete from CartFood where idCartFood = ?"
    cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,idCartFood)
    set result = cmdPrep.execute
    connDB.Close    
    Session("Success") = "Remove food from cart successfully!"
    Response.redirect("L_purchaseCart.asp")
%>