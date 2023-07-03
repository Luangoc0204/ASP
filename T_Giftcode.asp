<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="" OR (Session("role")="EMPLOYEE")) Then
        Response.redirect("logout.asp")
    End If
    connDB.Open()
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idGiftCode = Request.QueryString("idGiftCode")
        If (isnull(idGiftCode) OR trim(idGiftCode) = "") then 
            idGiftCode = 0
        End if
        If (Len(idGiftCode)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM GiftCode WHERE idGiftCode = ?"
            cmdPrep.Parameters(0) = idGiftCode    
            Set result = cmdPrep.execute

            If not result.EOF then
                nameGiftCode = result("nameGiftCode")
                discountGiftCode = result("discountGiftCode")
                isActive = result("isActive")
            End If
            result.Close()
        End if
    Else
        idGiftCode = Request.Form("idGiftCode")
        if (isnull (idGiftCode) OR trim(idGiftCode) = "") then idGiftCode=0 end if 
        nameGiftCode = Request.form("nameGiftCode")
        discountGiftCode = Request.form("discountGiftCode")
        isActive = Request.form("isActive")
        if (not isnull(isActive) and trim(isActive) <> "") then 
            isActive = 1
        else
            isActive = 0
        end if

        if (NOT isnull(nameGiftCode) and trim(nameGiftCode) <> "" and NOT isnull(discountGiftCode) and trim(discountGiftCode) <>"" and NOT isnull(isActive) and trim(isActive)<>"") then

            if (CInt(idGiftCode) = 0) then
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "select * from GiftCode where nameGiftCode = ?"
                cmdPrep.parameters.Append cmdPrep.createParameter("nameGiftCode",202,1,255,nameGiftCode)
                set result = cmdPrep.execute
                if not result.EOF then
                    Session("Error") = "Name GiftCode is existed!!!"
                else
                    Set cmdPrep = Server.CreateObject("ADODB.Command")
                    cmdPrep.ActiveConnection = connDB
                    cmdPrep.CommandType = 1
                    cmdPrep.Prepared = True
                    cmdPrep.CommandText = "insert into GiftCode(nameGiftCode, discountGiftCode) values ('"&nameGiftCode&"', '"&discountGiftCode&"')"

                    cmdPrep.execute
                    Session("Success") = "New GiftCode added!"
                    Response.redirect("T_GiftCode.asp")
                end if
            else          
                
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "update GiftCode set nameGiftCode = '"&nameGiftCode&"', discountGiftCode = '"&discountGiftCode&"', isActive='"&isActive&"' where idGiftCode='"&idGiftCode&"'"
                cmdPrep.execute
                Session("Success") = "The GiftCode was edited!"
                Response.redirect("T_GiftCode.asp")
            end if    
        else
            Session("Error") = "You have to input enough info"
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
    <link rel="stylesheet" href="./assets/css/T_GiftCode.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp"-->
    <div class="div_giftcode" style="margin-top: 150px; background-image: url(./assets/images/menu-bg.png);">
        <form action="" method="post">
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
                                    
                                    <td style="min-width: 50px;  padding-top: 15px; text-align: center;">
                                    <span><%=(i+1)%></span>
                                    
                                    <p style="display:none" class="idGiftCode"><%=result("idGiftCode")%></p>
                                    </td>
                                    <td style="min-width: 60px; padding-top: 15px;">
                                        <span>
                                            <%=result("nameGiftCode")%></td>
                                        </span>
                                    <td style="min-width: 80px;  padding-top: 15px; padding-left:15px"><%=result("discountGiftCode")%>%</td>
                                    <td style="min-width: 60px;   padding-top: 15px; text-align:center">
                                        <p style="display:none" class="isActive"><%=result("isActive")%></p>
                                        <%
                                            if (result("isActive") = true) then
                                        %>
                                        <i class="fa-solid fa-circle-check fa-lg icon-active" style="padding: 15px 15px; color: #09c820; font-size: 25px;"></i>
                                        <span class="active-title">Active</span>
                                        <%
                                            else 
                                        %>
                                        <i class="fa-solid fa-circle-xmark fa-lg icon-active" style="padding: 15px 15px; color: red; font-size: 25px;"></i>
                                        <span class="active-title">Not Active</span>
                                        <%
                                            end if
                                        %>
                                    </td>
                                    <td style="min-width: 60px; width: 10%; text-align: center; " class="group-edit-delete">
                                        
                                        <button type="button" class="btn btn-success edit-button" style="width: 85px;"><i class="fa-solid fa-pen" style="font-size: 15px;"></i> Edit</button>
                                        <button data-href="L_deleteGiftCode.asp?idGiftCode=<%=result("idGiftCode")%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" type="button" class="btn btn-danger" style="padding: 7.5px 5px;  margin-left: 50px;"><i class="fa-solid fa-trash"></i> Delete</button>
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
                                    <td style="min-width: 50px; text-align: center;"><%=i+1%></td>
                                    <td style="min-width: 70px;"></td>
                                    <td style="min-width: 80px; "></td>
                                    <td style="min-width: 60px; text-align: center;"></td>
                                    <td style="min-width: 60px;  text-align: center;">
                                        <button type="button" class="btn btn-success add-button" style="width: 85px;"><i class="fa-solid fa-plus" style="font-size: 15px;"></i> Add</button>
                                        <button type="submit" class="btn btn-success save-button" style="width: 85px; display: none;"><i class="fa-solid fa-check" style="font-size: 15px;"></i> Save</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </form>
    </div>   
    <!-- MODAL delete-->
        <div class="modal" tabindex="-1" id="confirm-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Delete Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete giftcode?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="L_menu.asp" type="button" class="btn btn-secondary">Close</a>
                            <a class="btn btn-danger btn-delete">Delete</a>
                        </div>
                    </div>
                </div>
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