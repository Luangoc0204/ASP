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

            if (NOT isnull(nameUser) and nameUser <> "" and NOT isnull(birthday) and birthday<>"" and NOT isnull(phone) and phone<>"" and NOT isnull(address) and address<>"" and NOT isnull(email) and email<>"" and NOT isnull(avatar) and avatar<>"" and NOT isnull(password) and password<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
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
            else
                Session("Error") = "You have to input enough info"
            end if   
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
                <p class="p_error" style="padding: 5px 10px; height: 18px;"></p>
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
    
    <!-- header js -->

    
</body>
</html>