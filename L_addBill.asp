<!--#include file="connect.asp"-->
<%
    Dim arrIdCartFood, discount_user, discount_giftcode, totalPrice, idCart, idBookingTable
    idBookingTable = Request.QueryString("idBookingTable")
    discount_user = CStr(Request.QueryString("discountUser"))
    discount_giftcode = CStr(Request.QueryString("discountGF"))
    totalPrice = CStr(Request.QueryString("totalPrice"))
    'lấy date hiện tại
    dim currentDate
    currentDate = Date()
    'dim year, month, day
    yearTemp = Year(currentDate)
    monthTemp = Right("0" & Month(currentDate), 2)
    dayTemp = Right("0" & Day(currentDate), 2)
    dim formattedDate
    formattedDate = yearTemp & "/" & monthTemp & "/" & dayTemp
    timeCF = CStr(FormatDateTime(Now(), 3))
    datetimeCF = formattedDate & " " & timeCF
    datetimeCF = Replace(datetimeCF, "SA", "AM")
    datetimeCF = Replace(datetimeCF, "CH", "PM")
    connDB.Open
    If (not isnull(idBookingTable) and trim(idBookingTable) <> "") Then
        'Response.write("nhảy vào idBookingTable")
        ' true
        arrIdBookingFood = Request.QueryString("arrIdBookingFood")
        arrIdBookingFood = split(arrIdBookingFood,",")
        For Each idBookingFood in arrIdBookingFood
            'Response.write("idCartFood: " & idCartFood & "<br>")
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SET NOCOUNT ON;DELETE from BookingFood WHERE idBookingFood = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood", 3, 1, , CInt(idBookingFood))
            cmdPrep.execute
        Next
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "DECLARE @idBill INT;exec insertBillBookingTable @idBookingTable = ?, @datetime = ?, @sumPrice = ?, @discount = ?, @discountGiftCode = ?, @idBill = @idBill OUTPUT; select @idBill "
        cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,CInt(idBookingTable))
        cmdPrep.parameters.Append cmdPrep.createParameter("datetimeCF",202,1,255,datetimeCF)
        cmdPrep.parameters.Append cmdPrep.createParameter("sumPrice",202,1, 255,CStr(totalPrice))
        cmdPrep.parameters.Append cmdPrep.createParameter("discount",202,1, 255,CStr(discount_user))
        cmdPrep.parameters.Append cmdPrep.createParameter("discountGiftCode",202,1, 255,CStr(discount_giftcode))
        set result = cmdPrep.execute
        idBill = result(0).Value
        Response.write(CStr(idBill))
        Session("Success") = "Purchase BookingTable successfully"
    Else
        ' false
        'Response.write("nhảy vào idCart")

        arrIdCartFood = Request.QueryString("arrIdCartFood")
        idCart = Request.QueryString("idCart")
        idFoodBuyNow = Request.QueryString("idFoodBuyNow")
        amountFoodBuyNow = Request.QueryString("amountFoodBuyNow")
        If (isnull(idFoodBuyNow) or trim(idFoodBuyNow) = "") Then
            ' true
            arrIdCartFood = split(arrIdCartFood,",")
            For Each idCartFood in arrIdCartFood
                'Response.write("idCartFood: " & idCartFood & "<br>")
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "SET NOCOUNT ON;UPDATE CartFood SET datetimeCF = convert(datetime, ?), isPay = 1 WHERE idCartFood = ?"
                cmdPrep.parameters.Append cmdPrep.createParameter("datetimeCF",202,1,255,datetimeCF)
                cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood", 3, 1, , CInt(idCartFood))
                cmdPrep.execute
            Next
            
        Else
            ' false
            Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO CartFood(idCart, idFood, amountCF,datetimeCF, isPay) VALUES(?, ?, ?, CAST(CONVERT(varchar, ? , 120) AS DATETIME) , 1)"
                cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood", 3, 1, , CInt(idCart))
                cmdPrep.parameters.Append cmdPrep.createParameter("idFood", 3, 1, , CInt(idFoodBuyNow))
                cmdPrep.parameters.Append cmdPrep.createParameter("amountFood", 3, 1, , CInt(amountFoodBuyNow))
                cmdPrep.parameters.Append cmdPrep.createParameter("datetimeCF",202,1,255,datetimeCF)
                cmdPrep.execute
        End if
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "DECLARE @idBill INT;exec insertBill @idCart = ?, @datetime = ?, @sumPrice = ?, @discount = ?, @discountGiftCode = ?, @idBill = @idBill OUTPUT; select @idBill "
        cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,CInt(idCart))
        cmdPrep.parameters.Append cmdPrep.createParameter("datetimeCF",202,1,255,datetimeCF)
        cmdPrep.parameters.Append cmdPrep.createParameter("sumPrice",202,1, 255,CStr(totalPrice))
        cmdPrep.parameters.Append cmdPrep.createParameter("discount",202,1, 255,CStr(discount_user))
        cmdPrep.parameters.Append cmdPrep.createParameter("discountGiftCode",202,1, 255,CStr(discount_giftcode))
        set result = cmdPrep.execute
        idBill = result(0).Value
        Response.write(CStr(idBill))
        Session("Success") = "Purchase cart successfully"
    End if
    
    connDB.Close
%>