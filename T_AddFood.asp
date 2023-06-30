<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "ADMIN") Then
        Response.redirect("logout.asp")
    End If
    'tạo các biến để kiểm tra và lấy tên file
    Dim newFileName, oldFileName, url
    oldFileName = ""
    url = "upload\menu\" 'đường dẫn lưu file
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
                oldFileName = result("imgFood")
                typeFood = result("typeFood")
                forPerson = result("forPerson")
                priceFood = result("priceFood")
                amountFood = result("amountFood")
            End If
            result.Close()
            connDB.Close
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
        newFileName = Request.Form("url")
        Dim FSO
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        if (cint(idFood) = 0) then
            if (NOT isnull(nameFood) and TRIM(nameFood) <> "" and NOT isnull(newFileName) and TRIM(newFileName)<>"" and NOT isnull(typeFood) and TRIM(typeFood)<>"" and NOT isnull(forPerson) and TRIM(forPerson)<>"" and NOT isnull(priceFood) and TRIM(priceFood)<>"" and NOT isnull(amountFood) and TRIM(amountFood)<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO Food(nameFood, imgFood, typeFood, forPerson, priceFood, amountFood) VALUES ('"&nameFood&"','"&newFileName&"','"&typeFood&"','"&forPerson&"','"&priceFood&"','"&amountFood&"')"

                cmdPrep.execute
                Session("Success") = "New food added!"
                Response.redirect("L_menu.asp")
            else
                If FSO.FileExists(Server.MapPath(".")&"\"  & url & newFileName) Then
                    ' Nếu tệp tin tồn tại, thực hiện xóa
                    FSO.DeleteFile(Server.MapPath(".")&"\"  & url & newFileName)
                    ' Response.Write "File " & oldFileName & " deleted. <br />"
                End If
                Session("ErrorTitle") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(nameFood) and TRIM(nameFood) <> "" and NOT isnull(newFileName) and TRIM(newFileName)<>"" and NOT isnull(typeFood) and TRIM(typeFood)<>"" and NOT isnull(forPerson) and TRIM(forPerson)<>"" and NOT isnull(priceFood) and TRIM(priceFood)<>"" and NOT isnull(amountFood) and TRIM(amountFood)<>"") then
                
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE Food SET nameFood='"&nameFood&"', imgFood='"&newFileName&"', typeFood='"&typeFood&"', forPerson='"&forPerson&"', priceFood='"&priceFood&"', amountFood='"&amountFood&"' WHERE idFood='"&idFood&"'"

                cmdPrep.execute
                Session("Success") = "The food was edited!"
                If FSO.FileExists(Server.MapPath(".")&"\" & url & oldFileName) Then
                    ' Nếu tệp tin tồn tại, thực hiện xóa
                    FSO.DeleteFile(Server.MapPath(".")&"\"  & url & oldFileName)
                    ' Response.Write "File " & oldFileName & " deleted. <br />"
                End If
                connDB.Close
                Response.redirect("L_menu.asp")
            else
                If FSO.FileExists(Server.MapPath(".")&"\"  & url & newFileName) Then
                    ' Nếu tệp tin tồn tại, thực hiện xóa
                    FSO.DeleteFile(Server.MapPath(".")&"\"  & url & newFileName)
                    ' Response.Write "File " & oldFileName & " deleted. <br />"
                End If
                Session("ErrorTitle") = "You have to input enough info"
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
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <link rel="stylesheet" href="./assets/css/T_AddFood.css">
    <title>Add Food</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <p id="url" style="display:none"><%=url%></p>
    <p id="idUser" style="display:none"><%=Session("idUser")%></p>
    <div class="div_container">
    
            <div class="human-list dish-box">
                <form id="uploadImg-form" action="" accept-charset="utf-8" method="post" enctype="multipart/form-data">
                    <div class="text-center box gr-img">
                            <div class="dist-img">
                                <div style="position:relative">
                                <%
                                    If (trim(oldFileName)="") Then
                                        ' true
                                %>
                                    <img src="<%=url%>\demo.jpg" alt="avatar" id="img-preview">
                                <%        
                                    Else
                                %>
                                    <img src="<%=url&oldFileName%>" alt="avatar" id="img-preview">
        
                                <%    
                                        ' false
                                    End if
                                %>
                                    <input type="file" accept=".jpg, .jpeg, .png" name="img" id="img-upload" style="display:none">
                                    <div class="camera-above">
                                        <i class="fa-solid fa-camera"></i>
                                    </div>
                                </div>
                            </div> 
                        <script>
                            
                        </script>   
                    </div>
                </form>
                <form id="text-form" method="post">
                <input id="img-input" type="text" name="url" style="display: none;">
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title">Name:</p>
                        <input type="text" class="header_2" id="name" name="nameFood" value="<%=nameFood%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Type:</p>
                        <select class="ais-SortBy-select header_2" id="typer" name="typeFood" value="<%=typeFood%>">
                            <option class="ais-SortBy-option" value="Starter">Starter</option>
                            <option class="ais-SortBy-option" value="MainCourse">Main Course</option>
                            <option class="ais-SortBy-option" value="Dessert">Dessert</option>
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
                        <input type="number"  min="1" class="header_2" id="amount" name="amountFood" value="<%=amountFood%>"> 
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
                        if(cint(idFood) = 0) then
                    %>
                        <button id="btn-submit" type="button" class="btn btn-primary key" style="padding: 0px 46px;">Add</button>
                    <%
                        else
                    %>    
                        <button id="btn-submit" type="button" class="btn btn-primary key" style="padding: 0px 46px;">Set</button>
                    <%
                        end if
                    %>
                        <a href="L_menu.asp" type="button" class="btn btn-primary">Cancel</a>
                    </div>
                </div>
                </form>
            </div>
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
    <script>
        const imgUpload = document.getElementById('img-upload');
        const imgPreview = document.getElementById('img-preview');
        const btnCamera = document.querySelector('.camera-above');
        btnCamera.addEventListener('click', function() {
            imgUpload.click();
        });

        imgUpload.addEventListener('change', function() {
            const file = imgUpload.files[0];
            const reader = new FileReader();
            var maxSize = 5 * 1024 * 1024; // Giới hạn dung lượng tối đa là 5MB
            if (file.size > maxSize) {
                alert('Dung lượng file vượt quá giới hạn cho phép.');
                imgUpload.value = ''; // Xóa giá trị file đã chọn
            } else{
                reader.onload = function(e) {
                    imgPreview.src = e.target.result;
                };
    
                reader.readAsDataURL(file);
            }    
        });

        function uploadImg(url, idUser) {
            //console.log("chạy vào hàm r")
            let form = $('#uploadImg-form')[0];
            let formData = new FormData(form);
            formData.forEach(function(value, key) {
                console.log(key + ': ' + value);
            });
            $.ajax({
                type: 'POST',
                url: "uploadImage.asp?url=" + encodeURIComponent(url) + "&idUser=" + idUser,
                data: formData ? formData : form.serialize(),
                cache: false,
                contentType: false,
                processData: false,
                success: function(response) {
                    // Xử lý kết quả trả về từ file uploadImage.asp
                    //console.log("thành công")
                    console.log(response);
                    // ...
                    submitForm(response)
                }
            });
        };
        function submitForm(response) {
            let form = $('#text-form')[0];
            let formData = new FormData(form);
            document.getElementById('img-input').value = response;
            form.submit();
        }
        document.getElementById('btn-submit').addEventListener('click', function() {
            let url = document.querySelector('#url').innerText
            let idUser = document.querySelector('#idUser').innerText
            //console.log("click btn rồi")
            // Gọi hàm bạn muốn thực thi ở đây
            uploadImg(url,idUser);
        });
    </script>
</body>
</html>