<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "") then
        Response.redirect("logout.asp")
    end if
    idFood = CInt(Request.Form("idFood"))
    idBookingTable = Cint(Request.Form("idBookingTable"))
    ' Response.write("idFood: " + CStr(idFood))
    ' Response.write("idBookingTable: " + CStr(idBookingTable))
    connDB.Open()
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "SELECT * FROM Food where idFood = ?"
    cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
    set result = cmdPrep.execute
    if result.EOF then
        'nếu food không tồn tại
        Response.write("Food is not exists!!!")
    else
        'nếu food tồn tại -> kiểm tra xem đã có bookingFood chưa
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM BookingFood WHERE idBookingTable = ? AND idFood = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,idBookingTable)
        cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
        set result = cmdPrep.execute
        if not result.EOF then
            'nếu tồn tại booking food
            set idBookingFood = result("idBookingFood")
            'Update lại tăng thêm amountCF + 1
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE BookingFood SET amountBF = (amountBF + 1) WHERE idBookingFood = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingFood",3,1, ,idBookingFood)
            cmdPrep.execute
            Response.write("Update BookingFood successfully!")
        else 
            'nếu chưa tồn tại booking food
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "insert into BookingFood(idBookingTable, idFood, amountBF) values(?, ?, 1)"
            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,idBookingTable)
            cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
            cmdPrep.execute
            Response.write("Insert BookingFood successfully!")
        end if   
    end if    
    '
    connDB.Close()
%>