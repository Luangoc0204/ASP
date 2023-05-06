<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<!DOCTYPE html>

<!--#include file="connect.asp"-->

<%  
    Session.Contents.RemoveAll()
    Dim username, password
    username = Request.Form("username")
    password = Request.Form("password")
    'Response.write("username: " + CStr(username) + " password: " + CStr(password))
    If (NOT isnull(username) AND NOT isnull(password) and trim(username) <>"" and trim(password)<>"") then
        ' true
        dim sql
        sql = "select * from Account where username = ? and password = ?"
        set cmdPrep = Server.CreateObject("ADODB.Command")
        connDB.Open
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = true
        cmdPrep.CommandText = sql
        cmdPrep.Parameters(0) = username
        cmdPrep.Parameters(1) = password
        
        set result = cmdPrep.execute
        'Kiểm tra kết quả result ở đây
        if not result.EOF then
            'đăng nhập thành công
            Session("idUser") = result("idUser")
            Session("role") = result("role")
            Session("Success") = "Login Successfully"
            Response.redirect("L_home.asp")
            connDB.Close()
        Else 
            'đăng nhập không thành công
            Session("Error") = "Wrong username or password!"
        end if  

    Else
    ' false
    
    End if  
'Lay ve thong tin dang nhap gom email va password

'Validate thong tin dang nhap

'Kiem tra thong tin xem co ton tai trong bang taikhoan hay khong

'Neu ton tai thi dang nhap thanh cong, tao Session, redirect toi trang quan tri

'Neu dang nhap ko thanh cong, thi thong bao loi.  
%>
<%

    Dim name, birthday, address, avatar, email_signUp
    name = Request.Form("name")
    birthday = Request.Form("birthday")
    'Response.write(CStr(birthday))
    address = Request.Form("address")
    avatar = Request.Form("avatar")
    phone = Request.Form("phone")
    email_signUp = Request.Form("email_signUp")
    If (NOT isnull(email_signUp) AND NOT isnull(name) AND NOT isnull(birthday) AND NOT isnull(address) AND NOT isnull(avatar) and trim(email_signUp) <>"" and trim(name)<>"" and trim(birthday)<>"" and trim(address)<>"" and trim(avatar)<>"") then
        ' true
        connDB.Open
        sql = "select * from Account where username = ?"
        set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = true
        cmdPrep.CommandText = sql
        cmdPrep.Parameters(0) = phone
        set result = cmdPrep.execute
        'Kiểm tra kết quả result ở đây
        if not result.EOF then
            'nếu có tồn tại phone
            Session("SU_Error") = "Phone is existed!"
            result.Close()
        else 
            'nếu phone chưa tồn tại
            Dim sql_insertTAIKHOAN, sql_insertUSER
            
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1 ' 1: adCmdText - câu lệnh SQL văn bản
            cmdPrep.Prepared = true ' Sử dụng truy vấn chuẩn bị

            ' Truy vấn INSERT USER_INFO
            sql_insertUSER = "SET NOCOUNT ON; INSERT INTO [USER](nameUser, birthday, phone, [address], email, avatar) VALUES(?, ?, ?, ?, ?, ?); SELECT SCOPE_IDENTITY() as ID"
            cmdPrep.CommandText = sql_insertUSER
            cmdPrep.parameters.Append cmdPrep.createParameter("name",202,1,255,name)
            cmdPrep.parameters.Append cmdPrep.createParameter("birthday",202,1,255,birthday)
            cmdPrep.parameters.Append cmdPrep.createParameter("phone",202,1,255,phone)
            cmdPrep.parameters.Append cmdPrep.createParameter("address",202,1,255,address)
            cmdPrep.parameters.Append cmdPrep.createParameter("email",202,1,255,email_signUp)
            cmdPrep.parameters.Append cmdPrep.createParameter("avatar",202,1,255,avatar)

            'cmdPrep.execute
            ' Lấy ID vừa thêm vào USER_INFO
            set result = cmdPrep.execute()
            'Response.write("passsssssssssss")
            if not result.EOF then
                Dim newId
                newId = result(0).Value
                Dim formattedPass
                formattedPass = FormatDateTime(birthday, 2)
                'Response.write("formattedPass: " + formattedPass)
                password2 = Replace(formattedPass, "/", "")
                'Response.write("pass: " + password2)
                ' Truy vấn INSERT TAIKHOAN
                set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1 ' 1: adCmdText - câu lệnh SQL văn bản
                cmdPrep.Prepared = true ' Sử dụng truy vấn chuẩn bị
                sql_insertTAIKHOAN = "INSERT INTO Account(idUser, username, [password], [role]) VALUES(?, ?, ?, 'CUSTOMER')"
                cmdPrep.CommandText = sql_insertTAIKHOAN
                cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1 , ,newId)
                cmdPrep.parameters.Append cmdPrep.createParameter("username",202,1,255,phone)
                cmdPrep.parameters.Append cmdPrep.createParameter("password",202,1,255,password2)
                cmdPrep.execute
                Session("idUser") = newId
                Session("Success") = "Create Account Successfully with username: " + phone + " , password: " + password2
                connDB.Close()
                Response.redirect("L_home.asp")
            else
                Session("SU_Error") = "Không có dữ liệu"
            end if    
        end if  

    Else
    ' false
    
    End if  
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="./assets/css/loginPage.css">
    
    <title>Login Page</title>
</head>
<body>
    <!--#include file="header.asp"-->
    <div class="container animate__animated animate__fadeInDown" id="container" style="position: fixed;top: 125px; left:50%; transform: translateX(-50%);">
        <div class="form-container sign-up-container">
            <form action="loginPage.asp" method="post">
                <h2 style="font-weight: bold;">Create Account</h2>
                <input name="name" type="text" placeholder="Name" />
                <input name="birthday" type="date" placeholder="Birthday" />
                <input name="address" type="text" placeholder="Address" />
                <input name="avatar" type="text" placeholder="Avatar Link" />
                <input name="phone" type="text" placeholder="Phone" />
                <input name="email_signUp" type="email" placeholder="Email" />
                <%
                    If (NOT isnull(Session("SU_Error"))) AND (TRIM(Session("SU_Error"))<>"") Then
                %>
                <p style="color:red; height:24px; margin:0"><%=Session("SU_Error")%></p>
                <script>
                    $(document).ready(function() {
                        $('#container').removeClass('animate__animated animate__fadeInDown').addClass('right-panel-active')
                    
                    })
                </script>
                <%
                    Session.Contents.Remove("SU_Error")
                    Else          
                %>
                <p style="color:red; height:24px; margin:0"></p>

                <%

                    End If
                %>
                <button id="btn-signUp" style="margin-top: 10px;background-image: linear-gradient(to right, #1FA2FF 0%, #12D8FA 51%, #1FA2FF 100%);">Sign Up</button>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="loginPage.asp" method="post">
                <h1>Sign in</h1>
                <input name="username" type="text" placeholder="Username" />
                <div class="div_password">
                    <input name="password" id="password_signIn" type="password" placeholder="Password" />
                    <img onClick="showPass('password_signIn', 'icon_eye_signIn')" id="icon_eye_signIn" src="./assets/images/icon_eye_open.png">
                </div>
                
                <%
                    If (NOT isnull(Session("Error"))) AND (TRIM(Session("Error"))<>"") Then
                %>
                <p style="color:red; height:24px; margin:0"><%=Session("Error")%></p>
                <script>
                    $(document).ready(function() {
                        $('#container').removeClass('animate__animated animate__fadeInDown')
                    })
                </script>
                <%
                    Session.Contents.Remove("Error")
                    Else          
                %>
                <p style="color:red; height:24px; margin:0"></p>
                <%
                    
                    End If
                %>
                
                <button type="submit" style="margin-top: 10px;">Sign In</button>
                
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1>Welcome Back!</h1>
                    <p>To keep connected with us please login with your personal info</p>
                    <button style="background-image: linear-gradient(to right, #1FA2FF 0%, #12D8FA 51%, #1FA2FF 100%);" class="ghost" id="signIn">Sign In</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h1>Hello, Friend!</h1>
                    <p>Enter your personal details and start journey with us</p>
                    <button class="ghost" id="signUp">Sign Up</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        function showPass(idName, idIcon) {
            const btnEye = document.querySelector('#' + idIcon);
            const btnPass = document.querySelector('#' + idName);
            if (btnPass.type === 'password') {
                btnPass.type = "text"
                btnEye.src = './assets/images/icon_eye_close.png'
            } else{
                btnPass.type = 'password'
                btnEye.src = './assets/images/icon_eye_open.png'
            }
        }
        const signUpButton = document.getElementById('signUp');
        const signInButton = document.getElementById('signIn');
        const container = document.getElementById('container');

        signUpButton.addEventListener('click', () => {
            container.classList.add('right-panel-active');
        });

        signInButton.addEventListener('click', () => {
            container.classList.remove('right-panel-active');
        });
    </script>
    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
</body>
</html>