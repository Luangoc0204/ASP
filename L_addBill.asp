<!--#include file="connect.asp"-->
<%
    Dim arrIdCartFood, discount_user, discount_giftcode, totalPrice, idCart
    arrIdCartFood = Request.QueryString("arrIdCartFood")
    'Response.write("Type: " + TypeName(arrIdCartFood))
    'Response.write(arrIdCartFood)
    discount_user = CStr(Request.QueryString("discountUser"))
    discount_giftcode = CStr(Request.QueryString("discountGF"))
    totalPrice = CStr(Request.QueryString("totalPrice"))
    'Response.write("discount_user: "+ TypeName(discount_user) + CStr(discount_user) + "<br>")
    'Response.write("discount_user: " + CStr(discount_user) + "<br>")
    'Response.write("discount_giftcode: "+ TypeName(discount_giftcode) + CStr(discount_giftcode) + "<br>")
    'Response.write("totalPrice: "+ TypeName(totalPrice) + CStr(totalPrice) + "<br>")
    idCart = Request.QueryString("idCart")
    idFoodBuyNow = Request.QueryString("idFoodBuyNow")
    amountFoodBuyNow = Request.QueryString("amountFoodBuyNow")
    'Response.write("idCart: "+ TypeName(idCart) + CStr(idCart) + "<br>")
    connDB.Open
    If (isnull(idFoodBuyNow) or trim(idFoodBuyNow) = "") Then
        ' true
        arrIdCartFood = split(arrIdCartFood,",")
        For Each idCartFood in arrIdCartFood
            'Response.write("idCartFood: " & idCartFood & "<br>")
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SET NOCOUNT ON;UPDATE CartFood SET datetimeCF = getDate(), isPay = 1 WHERE idCartFood = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood", 3, 1, , CInt(idCartFood))
            cmdPrep.execute
        Next
        
    Else
        ' false
        Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "INSERT INTO CartFood(idCart, idFood, amountCF, isPay) VALUES(?, ?, ? , 1)"
            cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood", 3, 1, , CInt(idCart))
            cmdPrep.parameters.Append cmdPrep.createParameter("idFood", 3, 1, , CInt(idFoodBuyNow))
            cmdPrep.parameters.Append cmdPrep.createParameter("amountFood", 3, 1, , CInt(amountFoodBuyNow))
            cmdPrep.execute
    End if
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "DECLARE @idBill INT;exec insertBill @idCart = ?, @sumPrice = ?, @discount = ?, @discountGiftCode = ?, @idBill = @idBill OUTPUT; select @idBill "
    cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,CInt(idCart))
    cmdPrep.parameters.Append cmdPrep.createParameter("sumPrice",202,1, 255,CStr(totalPrice))
    cmdPrep.parameters.Append cmdPrep.createParameter("discount",202,1, 255,CStr(discount_user))
    cmdPrep.parameters.Append cmdPrep.createParameter("discountGiftCode",202,1, 255,CStr(discount_giftcode))
    set result = cmdPrep.execute
    idBill = result(0).Value
    Response.write(CStr(idBill))
    Session("Success") = "Purchase cart successfully"
%>