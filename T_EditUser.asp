<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "") Then
        Response.redirect("logout.asp")
    End If
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idUser = Request.QueryString("idUser")
        
        ' If (Len(idUser)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM [User] inner join Account on [User].idUser = Account.idUser WHERE [User].idUser=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))   
            Set result = cmdPrep.execute

            If not result.EOF then
                nameUser = result("nameUser")
                birthday = result("birthday")
                phone = result("phone")
                address = result("address")
                email = result("email")
                avatar = result("avatar")
                password = result("password")
            End If
        ' End if
    Else
        idUser = Request.QueryString("idUser")
        nameUser = Request.form("nameUser")
        birthday = Request.form("birthday")  
        phone = Request.form("phone")   
        address = Request.form("address")
        email = Request.form("email")
        avatar = Request.form("avatar")
        password = Request.form("password")
        ' Tạo một Function để sử dụng lại
        Function updateUser()
            ' Do Something...
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE [User] SET nameUser=?, birthday=?, phone=?, address=?, email=?, avatar = ? WHERE idUser=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("nameUser",202,1,255,nameUser)
            cmdPrep.parameters.Append cmdPrep.createParameter("birthday",202,1,255,birthday)
            cmdPrep.parameters.Append cmdPrep.createParameter("phone",202,1,255,phone)
            cmdPrep.parameters.Append cmdPrep.createParameter("address",202,1,255,address)
            cmdPrep.parameters.Append cmdPrep.createParameter("email",202,1,255,email)
            cmdPrep.parameters.Append cmdPrep.createParameter("avatar",202,1,255,avatar)
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
                        
            set result = cmdPrep.execute

            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE [Account] SET password=? WHERE idUser=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("password",202,1,255,password)
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
            cmdPrep.execute
            Session("Success") = "The user was edited!"
            Response.redirect("L_home.asp")
        End Function
        if (NOT isnull(nameUser) and TRIM(nameUser)<> "" and NOT isnull(birthday) and TRIM(birthday)<>"" and NOT isnull(phone) and TRIM(phone)<>"" and NOT isnull(address) and TRIM(address)<>"" and NOT isnull(email) and TRIM(email)<>"" and NOT isnull(password) and TRIM(password)<>"") then

            connDB.Open()
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True

            cmdPrep.CommandText = "select * from [User] where phone = '"&phone&"'"
            set result = cmdPrep.execute
            ' Kiểm tra kết quả result
            ' nếu có tồn tại
            if not result.EOF then
                'nếu có tồn tại phone
                phoneTemp = result("phone")
                If (Cint(idUser) <> 0) Then
                    Set cmdPrep = Server.CreateObject("ADODB.Command")
                    cmdPrep.ActiveConnection = connDB
                    cmdPrep.CommandType = 1
                    cmdPrep.Prepared = True
                    cmdPrep.CommandText = "select [User].*, [password] from [User] inner join [Account] on [User].idUser = [Account].idUser where [User].idUser = '"&idUser&"'"
                    set result = cmdPrep.execute
                    If (result("phone") = phoneTemp) Then
                        ' true -> nếu phone của Employee = phone gửi theo form -> chính là Employee đó đang dùng phone -> update
                        updateUser()
                        connDB.Close
                        '''''
                        Response.redirect("TH_QL_quanlyNV.asp")
                    Else
                        ' false -> ngược lại thì không phải phone của Employee
                        Session("ErrorTitle") = "Phone is existed!"
                        connDB.Close
                    End if
                End if     
            End if  
        else
            Session("Error") = "You have to input enough info"
        End if    
    End if     
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/T_EditUser.css">

    <title>Document</title>
</head>
<body>

    <div class="div_container">
        <form action="" method="post">
            <div class="container_0">
                <h1 class="header_0">Edit User</h1>
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title">Name:</p>
                        <input type="text" class="header_2" id="nameUser" name="nameUser" value="<%=nameUser%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Image link:</p>
                        <input type="text" class="header_2" id="avatar" name="avatar" value="<%=avatar%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Birthday:</p>
                        <input type="date" class="header_2" id="birthday" name="birthday" value="<%=birthday%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Phone:</p>
                        <input type="number" class="header_2" id="phone" name="phone" value="<%=phone%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Address:</p>
                        <input type="text" class="header_2" id="address" name="address" value="<%=address%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Email:</p>
                        <input type="text" class="header_2" id="email" name="email" value="<%=email%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Password:</p>
                        <input type="text" class="header_2" id="password" name="password" value="<%=password%>">
                    </div>
                </div>
                <%
                    If (NOT isnull(Session("ErrorTitle"))) AND (TRIM(Session("ErrorTitle"))<>"") Then
                %>
                <p class="p_error" style="padding: 5px 10px; height: 24px; text-align: center; color: red; width: 100%; white-space: break-spaces;"><%=Session("ErrorTitle")%></p>                <%
                    Session.Contents.Remove("ErrorTitle")
                    else
                %>
                <p class="p_error" style="padding: 5px 10px; height: 24px; text-align: center; color: red;width: 100%; white-space: break-spaces;"></p>                <%
                    end if
                %>
                <div class="controls">
                    <div class="controls_1">
                        <button type="submit" class="btn btn-primary key">Set</button>
                        <a href="TH_QL_quanlyNV.asp" type="button" class="btn btn-primary key">Cancel</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <!-- header ends  -->
    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    <script src="./assets/javascript/TH_EditUser.js"></script>
    
    <!-- header js -->

    
</body>
</html>