<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "ADMIN") Then
        Response.redirect("logout.asp")
    End If
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idFood = Request.QueryString("idFood")
        If (isnull(idFood) OR trim(idFood) = "") then 
            idFood = 0
        End if
        If (Len(idFood)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM Food WHERE idFood=?"
            cmdPrep.Parameters(0) = idFood    
            Set result = cmdPrep.execute

            If not result.EOF then
                nameFood = result("nameFood")
                imgFood = result("imgFood")
                typeFood = result("typeFood")
                forPerson = result("forPerson")
                priceFood = result("priceFood")
                amountFood = result("amountFood")
            End If
            result.Close()
        End if
    Else

        idFood = Request.QueryString("idFood")
        if (isnull (idFood) OR trim(idFood) = "") then idFood=0 end if
        nameFood = Request.form("nameFood")
        imgFood = Request.form("imgFood")  
        typeFood = Request.form("typeFood")
        if (typeFood = "MainCourse") then
            typeFood = "Main Course"
        end if    
        forPerson = Request.form("forPerson")
        priceFood = Request.form("priceFood")
        amountFood = Request.form("amountFood")
        if (cint(idFood) = 0) then
            if (NOT isnull(nameFood) and nameFood <> "" and NOT isnull(imgFood) and imgFood<>"" and NOT isnull(typeFood) and typeFood<>"" and NOT isnull(forPerson) and forPerson<>"" and NOT isnull(priceFood) and priceFood<>"" and NOT isnull(amountFood) and amountFood<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO Food(nameFood, imgFood, typeFood, forPerson, priceFood, amountFood) VALUES ('"&nameFood&"','"&imgFood&"','"&typeFood&"','"&forPerson&"','"&priceFood&"','"&amountFood&"')"
                cmdPrep.execute
                Session("Success") = "New food added!"
                Response.redirect("L_menu.asp")
            else
                Session("Error") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(nameFood) and nameFood <> "" and NOT isnull(imgFood) and imgFood<>"" and NOT isnull(typeFood) and typeFood<>"" and NOT isnull(forPerson) and forPerson<>"" and NOT isnull(priceFood) and priceFood<>"" and NOT isnull(amountFood) and amountFood<>"") then
                
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE Food SET nameFood='"&nameFood&"', imgFood='"&imgFood&"', typeFood='"&typeFood&"', forPerson='"&forPerson&"', priceFood='"&priceFood&"', amountFood='"&amountFood&"' WHERE idFood='"&idFood&"'"
                cmdPrep.execute
                Session("Success") = "The food was edited!"
                Response.redirect("L_menu.asp")
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
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/T_AddFood.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <div class="div_container">
    
        <form method="post" style="width: 25%">
            <div class="container_0">
                <h1 class="header_0">Add Food</h1>
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title">Name:</p>
                        <input type="text" class="header_2" id="name" name="nameFood" value="<%=nameFood%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Image link:</p>
                        <input type="text" class="header_2" id="imgFood" name="imgFood" value="<%=imgFood%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Type:</p>
                        <select class="ais-SortBy-select" id="typer" name="typeFood" value="<%=typeFood%>">
                            <option class="ais-SortBy-option" value="Breakfast">Breakfast</option>
                            <option class="ais-SortBy-option" value="Lunch">Lunch</option>
                            <option class="ais-SortBy-option" value="Dinner">Dinner</option>
                        </select>
                    </div>
                    <div class="header_1">
                        <p class="header_title">For person:</p>
                        <input type="number" min="1" class="header_2" id="forPerson" name="forPerson" value="<%=forPerson%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Price:</p>
                        <input type="text" class="header_2" id="priceFood" name="priceFood" value="<%=priceFood%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Amount:</p>
                        <input type="number" min="1" class="header_2" id="amountFood" name="amountFood" value="<%=amountFood%>"> 
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
                        <button type="submit" id="btn-submit" class="btn btn-primary key" style="padding: 0px 46px;">Set</button>
                        <a href="L_menu.asp" type="button" class="btn btn-primary">Cancel</a>
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
    <script src="./assets/javascript/TH_AddFood.js"></script>
</body>
</html>