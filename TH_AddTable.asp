<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "ADMIN") Then
        Response.redirect("logout.asp")
    End If
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idTable = Request.QueryString("idTable")
        If (isnull(idTable) OR trim(idTable) = "") then 
            idTable = 0
        End if
        If (Len(idTable)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM [Table] WHERE idTable=?"
            cmdPrep.Parameters(0) = idTable
            Set result = cmdPrep.execute

            If not result.EOF then
                idTable = result("idTable")
                typeTable = result("typeTable")
                amountTable = result("amountTable")
                imgTable = result("imgTable")
            End If
            result.Close()
        End if
    Else

        idTable = Request.QueryString("idTable")
        if (isnull (idTable) OR trim(idTable) = "") then idTable=0 end if
        typeTable = Request.form("typeTable")
        amountTable = Request.form("amountTable")
        imgTable = Request.form("imgTable")

        connDB.Open()  
        On Error resume next   
        connDB.BeginTrans ' Bắt đầu Transaction
        if (cint(idTable) = 0) then
            if (NOT isnull(typeTable) and TRIM(typeTable) <> "" and NOT isnull(amountTable) and TRIM(amountTable)<>"" and NOT isnull(imgTable) and TRIM(imgTable)<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO [Table] (typeTable, amountTable, imgTable) VALUES ('"&typeTable&"','"&amountTable&"','"&imgTable&"')"
                cmdPrep.execute
                If Err.Number = 0 Then  
                    '*** Commit Transaction ***'  
                    connDB.CommitTrans
                    Session("Success") = "New Table added!"
                    Response.redirect("./TH_listTable.asp")
                Else  
                    '*** Rollback Transaction ***'  
                    connDB.RollbackTrans  
                    Session("Error") = "Add Table Failed!"
                End If 
            else
                Session("Error") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(typeTable) and TRIM(typeTable)<> "" and NOT isnull(amountTable) and TRIM(amountTable)<>"" and NOT isnull(imgTable) and TRIM(imgTable)<>"") then
                
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE [Table] SET typeTable= '"&typeTable&"', amountTable= '"&amountTable&"', imgTable= '"&imgTable&"' WHERE idTable = '"&idTable&"'"
                cmdPrep.execute
                If Err.Number = 0 Then  
                    '*** Commit Transaction ***'  
                    connDB.CommitTrans
                    Session("Success") = "The Table was edited!"
                    Response.redirect("./TH_listTable.asp")
                Else  
                    '*** Rollback Transaction ***' 
                    Response.write("Có lỗi xảy ra") 
                    connDB.RollbackTrans  
                    Session("Error") = "Edit Table Failed!"
                    '  Response.redirect("./TH_listTable.asp")
                End If 
            else
                Session("Error") = "You have to input enough info"
            end if   
        end if
    End if         
    connDB.Close         
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/TH_AddTable.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <div class="div_container">
        <form action="" method="post" >
            <div class="container_0">
                <%
                    ' true
                    if (cint(idTable) = 0) then
                %>
                    <h1 class="header_0"> Add Table</h1> 
                <%    
                    ' false
                    Else
                %>
                    <h1 class="header_0"> Add Table</h1> 
                <%
                    End if
                %>
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title" style="padding-left: 11%;">Type:</p>
                        <div class="type_input">
                            <input type="number" min="1" class="header_21" id="typeTable" name="typeTable" value="<%=typeTable%>">
                            <p class="header_title"style="padding-left: 5%;">people</p>
                        </div>
                        
                    </div>
                    <div class="header_1">
                        <p class="header_title">Amount:</p>
                        <input type="number" class="header_2" id="amountTable" name="amountTable" value="<%=amountTable%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Image link:</p>
                        <input type="text" class="header_2" id="imgTable" name="imgTable" value="<%=imgTable%>">
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
                <%
                    ' true
                    if (cint(idTable) = 0) then
                %>
                    <button id="btn-submit" type="submit" class="btn btn-primary key" style="padding: 0px 46px;">Add</button>
                <%    
                    ' false
                    Else
                %>
                    <button id="btn-submit" type="submit" class="btn btn-primary key" style="padding: 0px 46px;">Set</button>
                <%
                    End if
                %>
                        <a href="TH_listTable.asp" type="button" class="btn btn-primary key">Cancel</a>
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
    <script src="./assets/javascript/TH_AddTable.js"></script>
</body>
</html>