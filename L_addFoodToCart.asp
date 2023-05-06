<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = ""  or Session("role") <> "CUSTOMER") then
        Response.redirect("logout.asp")
    end if
    idFood = CInt(Request.Form("idFood"))
    connDB.Open()
    'function insert food to cart
    Function insertCartFood(idCart)
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM CartFood WHERE idCart = ? AND idFood = ? and isPay = 0"
        cmdPrep.parameters.Append cmdPrep.createParameter("idCart",3,1, ,idCart)
        cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
        set result = cmdPrep.execute
        if not result.EOF then
            'nếu tồn tại cart food
            set idCartFood = result("idCartFood")
            'Update lại tăng thêm amountCF + 1
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE CartFood SET amountCF = (amountCF + 1) WHERE idCartFood = ?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idCartFood",3,1, ,idCartFood)
            cmdPrep.execute
            Response.write("Update CardFood successfully!")
        else 
            'nếu chưa tồn tại cart food
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "INSERT INTO CartFood(idCart, idFood, amountCF) VALUES(?, ?, 1 ) "
            cmdPrep.parameters.Append cmdPrep.createParameter("idCart",3,1, ,CInt(idCart))
            cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,idFood)
            cmdPrep.execute
            Response.write("Insert CardFood successfully!")
        end if   
    End function
    ''end function
    'kiểm tra xem food có tồn tại hay không
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
        'nếu food tồn tại -> kiểm tra xem đã có cart chưa
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT * FROM Cart where idUser = ?"
        cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
        set result = cmdPrep.execute
        Dim idCart
        if result.EOF then
            'nếu cart chưa tồn tại -> tạo mới cart
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1 ' 1: adCmdText - câu lệnh SQL văn bản
            cmdPrep.Prepared = true ' Sử dụng truy vấn chuẩn bị
            ' Truy vấn INSERT Cart
            cmdPrep.CommandText = "SET NOCOUNT ON; INSERT INTO Cart(idUser) VALUES(?); SELECT SCOPE_IDENTITY() as ID"
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
            set result_cart = cmdPrep.execute
            if result_cart.EOF then
                'tạo cart thất bại
                Response.write("Create cart faild!!!")
            else    
                'lấy idCart
                set idCart = result(0).Value
                insertCartFood(CInt(idCart))
            end if 
        else 
            set idCart = result("idCart")
            insertCartFood(CInt(idCart))
        end if           
    end if    
    '
    connDB.Close()
%>