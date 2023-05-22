<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "ADMIN") Then
        Response.redirect("logout.asp")
    End If
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idEmployee = Request.QueryString("idEmployee")
        If (isnull(idEmployee) OR trim(idEmployee) = "") then 
            idEmployee = 0
        End if
        If (Len(idEmployee)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM Employee inner join [User] on Employee.idUser = [User].idUser WHERE idEmployee=?"
            cmdPrep.Parameters(0) = idEmployee    
            Set result = cmdPrep.execute

            If not result.EOF then
                idUser = result("idUser")
                nameUser = result("nameUser")
                birthday = result("birthday")
                phone = result("phone")
                address = result("address")
                email = result("email")
                avatar = result("avatar")
                salary = result("salary")
                position = result("position")
            End If
            result.Close()
            connDB.close
        End if
    Else

        idEmployee = Request.QueryString("idEmployee")
        if (isnull (idEmployee) OR trim(idEmployee) = "") then idEmployee=0 end if
        nameUser = Request.form("nameUser")
        birthday = Request.form("birthday")  
        phone = Request.form("phone")   
        address = Request.form("address")
        email = Request.form("email")
        avatar = Request.form("avatar")
        salary = Request.form("salary")
        position = Request.form("position")

        if (cint(idEmployee) = 0) then
            if (NOT isnull(nameUser) and nameUser <> "" and NOT isnull(birthday) and birthday<>"" and NOT isnull(phone) and phone<>"" and NOT isnull(address) and address<>"" and NOT isnull(email) and email<>"" and NOT isnull(avatar) and avatar<>"" and NOT isnull(salary) and salary<>"" and NOT isnull(position) and position<>"") then

                Dim formattedPass
                formattedPass = FormatDateTime(birthday, 2)
                password2 = Replace(formattedPass, "/", "")
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "SET NOCOUNT ON; INSERT INTO [User](nameUser, birthday, phone, address, email, avatar) VALUES ('"&nameUser&"','"&birthday&"','"&phone&"','"&address&"','"&email&"','"&avatar&"'); SELECT SCOPE_IDENTITY() as ID"
                set result = cmdPrep.execute
                
                Dim newId
                newId = result(0).Value
                Response.write("New id: " + CStr(newId))
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "EXEC insertEmployee @idUser = '"&CInt(newId)&"', @salary = '"&salary&"', @position = '"&position&"'"
                set result = cmdPrep.execute

                set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1 
                cmdPrep.Prepared = true 
                sql_insertTAIKHOAN = "INSERT INTO Account(idUser, username, [password], [role]) VALUES('"&newId&"', '"&phone&"', '"&password2&"', 'EMPLOYEE')"
                cmdPrep.CommandText = sql_insertTAIKHOAN
                cmdPrep.execute
                Session("idUser") = newId
                Session("Success") = "Add employee successfully"
                Response.redirect("TH_QL_quanlyNV.asp")
            else
                Session("Error") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(nameUser) and nameUser <> "" and NOT isnull(birthday) and birthday<>"" and NOT isnull(phone) and phone<>"" and NOT isnull(address) and address<>"" and NOT isnull(email) and email<>"" and NOT isnull(avatar) and avatar<>"" and NOT isnull(salary) and salary<>"" and NOT isnull(position) and position<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "SET NOCOUNT ON; UPDATE [User] SET nameUser= '"&nameUser&"', birthday='"&birthday&"', phone='"&phone&"', address='"&address&"', email='"&email&"', avatar='"&avatar&"' WHERE idUser=(select idUser from Employee where idEmployee = '"&CInt(idEmployee)&"' )"                
                cmdPrep.execute
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "EXEC updateEmployee @idEmployee = '"&CInt(idEmployee)&"', @salary = '"&salary&"', @position = '"&position&"'"
                cmdPrep.execute
                Session("Success") = "The employee was edited!"
                Response.redirect("TH_QL_quanlyNV.asp")
            else
                Session("Error") = "You have to input enough info"
            end if   
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
    <link rel="stylesheet" href="./assets/css/T_AddEmployee.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <div class="div_container">
        <form action="" method="post" style="width: 25%">
            <div class="container_0">
                <h1 class="header_0">Add Employee</h1>
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title">Name:</p>
                        <input type="text" class="header_2" id="nameUser" name="nameUser" value="<%=nameUser%>">
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
                        <p class="header_title">Avatar:</p>
                        <input type="text" class="header_2" id="avatar" name="avatar" value="<%=avatar%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Salary:</p>
                        <input type="text" class="header_2" id="salary" name="salary" value="<%=salary%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Position:</p>
                        <select class="ais-SortBy-select" id="position" name="position" value="<%=position%>">
                            <option class="ais-SortBy-option" value="Employee">Employee</option>
                            <option class="ais-SortBy-option" value="Chef">Chef</option>
                        </select>
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
                        <button type="submit" class="btn btn-primary key" id="btn-submit" style="padding: 0px 46px;">Set</button>
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
    <script src="./assets/javascript/L_header.js"></script>
    <script src="./assets/javascript/T_AddEmployee.js"></script>
</body>
</html>