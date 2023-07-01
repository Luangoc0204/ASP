<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<!--#include file="upload.lib.asp"-->

<%
    Response.Charset = "utf-8"
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "") Then
        Response.redirect("logout.asp")
    End If
    'tạo các biến để kiểm tra và lấy tên file
    Dim newFileName, oldFileName, url
    oldFileName = ""
    url = "upload\user\" 'đường dẫn lưu file
    
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
                oldFileName = result("avatar")
                password = result("password")
            End If
            connDB.Close
        ' End if
    Else
        ' thực hiện up ảnh và lấy newFileName
        
        idUser = Request.QueryString("idUser")
        nameUser = Request.Form("nameUser")
        birthday = Request.Form("birthday")  
        phone = Request.Form("phone")   
        address = Request.Form("address")
        email = Request.Form("email")
        password = Request.Form("password")
        newFileName = Request.Form("url")
        Dim FSO
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
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
            cmdPrep.parameters.Append cmdPrep.createParameter("avatar",202,1,255,CStr(newFileName))
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
            'Response.redirect(Session("ReturnBack"))
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
                    oldFileName = result("avatar")
                    If (result("phone") = phoneTemp) Then
                        ' true -> nếu phone của Employee = phone gửi theo form -> chính là Employee đó đang dùng phone -> update
                            ' Thực hiện chức năng khi upload thành công
                            ' ...
                            if (trim(newFileName) <> "") then
                                If FSO.FileExists(Server.MapPath(".")&"\" & url & oldFileName) Then
                                    ' Nếu tệp tin tồn tại, thực hiện xóa
                                    FSO.DeleteFile(Server.MapPath(".")&"\"  & url & oldFileName)
                                    ' Response.Write "File " & oldFileName & " deleted. <br />"
                                End If
                            else 
                                newFileName = oldFileName    
                            end if    
                            updateUser()
                            connDB.Close
                            Response.redirect(Session("ReturnBack"))
                    Else
                        ' false -> ngược lại thì không phải phone của Employee
                        
                        If FSO.FileExists(Server.MapPath(".")&"\"  & url & newFileName) Then
                            ' Nếu tệp tin tồn tại, thực hiện xóa
                            FSO.DeleteFile(Server.MapPath(".")&"\"  & url & newFileName)
                            ' Response.Write "File " & oldFileName & " deleted. <br />"
                        End If
                        Session("ErrorTitle") = "Phone is existed!"
                        connDB.Close
                    End if
                End if     
            End if  
        else
            If FSO.FileExists(Server.MapPath(".")&"\"  & url & newFileName) Then
                ' Nếu tệp tin tồn tại, thực hiện xóa
                FSO.DeleteFile(Server.MapPath(".")&"\"  & url & newFileName)
                ' Response.Write "File " & oldFileName & " deleted. <br />"
            End If
            Session("ErrorTitle") = "You have to input enough info"
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
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <p id="url" style="display:none"><%=url%></p>
    <p id="idUser" style="display:none"><%=idUser%></p>
        <div class="div_container">
            <div class="human-list dish-box">
                <form id="uploadImg-form" action="" accept-charset="utf-8" method="post" enctype="multipart/form-data">
                    <div class="text-center box gr-img">
                            <div class="dist-img">
                                <div style="position:relative">
                                <%
                                    If (isnull(oldFileName) or trim(oldFileName)="") Then
                                        ' true
                                %>
                                    <img src="<%=url%>\user.png" alt="avatar" id="img-preview">
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
                <form id="text-form" action="" method="post">
                    <input id="img-input" type="text" name="url" style="display: none;">
                    <div class="container_0">
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
                                <button id="btn-submit" type="button" class="btn btn-primary key">Set</button>
                                <a href="<%=Session("ReturnBack")%>" type="button" class="btn btn-primary key">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
        </div>
    <%
        connDB.close
    %>
    <!-- header ends  -->
    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    <script src="./assets/javascript/TH_EditUser.js"></script>
    
    <!-- header js -->
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