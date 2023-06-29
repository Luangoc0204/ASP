<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="" OR (Session("role")="EMPLOYEE")) Then
        Response.redirect("logout.asp")
    End If
    connDB.Open()
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        ' idGiftCode = Request.QueryString("idGiftCode")
        ' If (isnull(idGiftCode) OR trim(idGiftCode) = "") then 
        '     idGiftCode = 0
        ' End if
        ' If (Len(idGiftCode)<>0) Then
        '     Set cmdPrep = Server.CreateObject("ADODB.Command")
        '     cmdPrep.ActiveConnection = connDB
        '     cmdPrep.CommandType = 1
        '     cmdPrep.CommandText = "SELECT * FROM GiftCode WHERE idGiftCode=?"
        '     cmdPrep.Parameters(0) = idGiftCode    
        '     Set result = cmdPrep.execute

        '     If not result.EOF then
        '         nameGiftCode = result("nameGiftCode")
        '         discountGiftCode = result("discountGiftCode")
        '         isActive = result("isActive")
        '     End If
        '     result.Close()
        ' End if
    Else

        connDB.Open()
        idGiftCode = Request.Form("idGiftCode")
        if (isnull (idGiftCode) OR trim(idGiftCode) = "") then idGiftCode=0 end if 
        nameGiftCode = Request.form("nameGiftCode")
        discountGiftCode = Request.form("discountGiftCode")
        isActive = Request.form("isActive")
        if (not isnull(isActive) and trim(isActive) <> "") then 
            isActive = 1
        end if 
        if (cint(idGiftCode) = 0) then
            if (NOT isnull(nameGiftCode) and nameGiftCode <> "" and NOT isnull(discountGiftCode) and discountGiftCode<>"" and NOT isnull(isActive) and isActive<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO GiftCode(nameGiftCode, discountGiftCode, isActive) VALUES (?,?,?)"
                cmdPrep.parameters.Append cmdPrep.createParameter("nameGiftCode",202,1,255,nameGiftCode)
                cmdPrep.parameters.Append cmdPrep.createParameter("discountGiftCode",202,1,255,discountGiftCode)
                cmdPrep.parameters.Append cmdPrep.createParameter("isActive",202,1,255,isActive)

                cmdPrep.execute
                Session("Success") = "New GiftCode added!"
                ' Response.redirect("L_menu.asp")
            else
                Session("Error") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(nameGiftCode) and nameGiftCode <> "" and NOT isnull(discountGiftCode) and discountGiftCode<>"" and NOT isnull(isActive) and isActive<>"") then
                
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "EXEC updateGiftCode @idGiftCode = ?, @nameGiftCode = ?, @discountGiftCode = ?, @isActive = ?"
                cmdPrep.parameters.Append cmdPrep.createParameter("idGiftCode",3,1,,CInt(idGiftCode))
                cmdPrep.parameters.Append cmdPrep.createParameter("nameGiftCode",202,1,255,nameGiftCode)
                cmdPrep.parameters.Append cmdPrep.createParameter("discountGiftCode",202,1,255,discountGiftCode)
                cmdPrep.parameters.Append cmdPrep.createParameter("isActive",3,1,,CInt(isActive))

                cmdPrep.execute
                Session("Success") = "The GiftCode was edited!"
                ' Response.redirect("L_menu.asp")
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
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <link rel="stylesheet" href="./assets/css/T_Giftcode.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp"-->
    <div class="div_giftcode" style="margin-top: 100px; background-image: url(./assets/images/menu-bg.png);">
        <form action="test.asp" method="post">
            <div class="container_gc">
                <h1 class="namecode">Gift Code</h1>
                <div class="info_list" style="margin-right: 20px; margin-left: 20px;">
                    <div class="info-list-wrap" style="color: #ff8243;">
                        <table class="table table-hover table-scroll">
                            <thead style="color: #ff8243;border-bottom: 2px solid #ff8243;">
                                <tr>
                                    <th scope="col" style="min-width: 50px;width: 4.5%; height: 60px; text-align: center;">No</th>
                                    <th scope="col" style="min-width: 70px; width: 4.5%;height: 60px;">Code</th>
                                    <th scope="col" style="min-width: 80px; width: 5%; height: 60px;">Discount</th>
                                    <th scope="col" style="min-width: 110px; width: 5%; height: 60px; text-align: center;">Active</th>
                                    <th scope="col" style="min-width: 80px; width: 10%; height: 60px; text-align: center;">Action</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True
                                    cmdPrep.CommandText = "SELECT * FROM GiftCode"
                                    Set result = cmdPrep.execute
                                    Dim i
                                    i = 0
                                    do while not result.EOF
                                %>
                                <tr>
                                    <input type="hidden" name="idGiftCode" value="<%=result("idGiftCode")%>">
                                    <td style="min-width: 50px; height: 60px; padding-top: 15px; text-align: center;"><%=(i+1)%></td>
                                    <td style="min-width: 60px; width: 100%;  height: 61.7px; display: flex; align-items: center;"><%=result("nameGiftCode")%></td>
                                    <td style="min-width: 80px; height: 60px; padding-top: 15px; "><%=result("discountGiftCode")%>%</td>
                                    <td style="min-width: 60px; width: 100%; height: 61.7px; padding-top: 1px; display: flex; justify-content: center; align-items: center;">
                                        <%
                                            if (result("isActive") = true) then
                                        %>
                                        <i class="fa-solid fa-circle-check fa-lg icon-active" style="padding: 15px 15px; color: #09c820; font-size: 25px;"></i>
                                        <input type="checkbox" name="isActive" style="display:none; margin: 0 10px; transform: scale(1.9);" class="input-checkbox" checked>
                                        <span>Active</span>
                                        <%
                                            else 
                                        %>
                                        <i class="fa-solid fa-circle-xmark fa-lg icon-active" style="padding: 15px 15px; color: red; font-size: 25px;"></i>
                                        <input type="checkbox" name="isActive" style="display:none; margin: 0 10px; transform: scale(1.92);" class="input-checkbox">
                                        <span>Not Active</span>
                                        <%
                                            end if
                                        %>
                                    </td>
                                    <td style="min-width: 60px; width: 10%; text-align: center; height: 60px;" class="group-edit-delete">
                                        
                                        <button type="button" class="btn btn-success edit-button" style="width: 85px;"><i class="fa-solid fa-pen" style="font-size: 15px;"></i> Edit</button>
                                        <button type="button" class="btn btn-danger" style="padding: 7.5px 5px;  margin-left: 50px;"><i class="fa-solid fa-trash"></i> Delete</button>
                                    </td>
                                </tr>
                                <%  
                                    i = i + 1
                                    result.MoveNext
                                    LOOP
                                %>
                            </tbody>
                            <tbody>
                                <tr>
                                    <td style="min-width: 50px;width: 4.5%; text-align: center;"><%=i%></td>
                                    <td style="min-width: 70px;width: 6.5%;"></td>
                                    <td style="min-width: 80px; width: 5%;"></td>
                                    <td style="min-width: 60px; width: 5%; text-align: center;"></td>
                                    <td style="min-width: 60px; width: 10%; text-align: center;">
                                        <button type="button" class="btn btn-success add-button" style="padding: 5px 15px;"><i class="fa-solid fa-plus" style="font-size: 15px;"></i> Add</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </form>
    </div>   

    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    
    <!-- header js -->
    <script src="./assets/javascript/L_header.js"></script>
    <script src="./assets/javascript/T_GiftCode.js"></script>

</body>
</html>