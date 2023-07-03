<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "ADMIN") Then
        Response.redirect("logout.asp")
    End If
        'tạo các biến để kiểm tra và lấy tên file
        Dim newFileName, oldFileName, url
        oldFileName = ""
        url = "upload\table\" 'đường dẫn lưu file
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
                oldFileName = result("imgTable")
            End If
            result.Close()
            connDB.Close
        End if
    Else

        idTable = Request.QueryString("idTable")
        if (isnull (idTable) OR trim(idTable) = "") then idTable=0 end if
        typeTable = Request.form("typeTable")
        amountTable = Request.form("amountTable")
        imgTable = Request.form("imgTable")

        newFileName = Request.Form("url")
        oldFileName = Request.Form("oldFileName")
        Dim FSO
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")

        if (cint(idTable) = 0) then
            if (NOT isnull(typeTable) and TRIM(typeTable) <> "" and NOT isnull(amountTable) and TRIM(amountTable)<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO [Table](typeTable, amountTable, imgTable) VALUES ('"&typeTable&"','"&amountTable&"','"&newFileName&"')"
                cmdPrep.execute
                Session("Success") = "New Table added!"
                Response.redirect("./TH_listTable.asp")
            else
                If FSO.FileExists(Server.MapPath(".")&"\"  & url & newFileName) Then
                ' Nếu tệp tin tồn tại, thực hiện xóa
                FSO.DeleteFile(Server.MapPath(".")&"\"  & url & newFileName)
                ' Response.Write "File " & oldFileName & " deleted. <br />"
                End If
                Session("ErrorTitle") = "You have to input enough info"
            end if
        else          
            if (NOT isnull(typeTable) and TRIM(typeTable)<> "" and NOT isnull(amountTable) and TRIM(amountTable)<>"") then     
                If (trim(newFileName) <> "") then
                    If FSO.FileExists(Server.MapPath(".")&"\" & url & oldFileName) Then
                        ' Nếu tệp tin tồn tại, thực hiện xóa
                        FSO.DeleteFile(Server.MapPath(".")&"\"  & url & oldFileName)
                        ' Response.Write "File " & oldFileName & " deleted. <br />"
                    End If
                else 
                    newFileName = oldFileName      
                end if
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE [Table] SET typeTable= '"&typeTable&"', amountTable= '"&amountTable&"', imgTable= '"&CStr(newFileName)&"' WHERE idTable = '"&idTable&"'"
                cmdPrep.execute
                Session("Success") = "The Table was edited!"
                    
                connDB.Close
                Response.redirect("TH_listTable.asp")
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
    'connDB.Close         
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
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <title>Document</title>
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
            <form id="text-form" method="post">
                <input id="img-input" type="text" name="url" style="display: none;">
                <input id="img-input" type="text" value="<%=oldFileName%>" name="oldFileName" style="display: none;">
                <div>
                    <%
                        ' true
                        if (cint(idTable) = 0) then
                    %>
                        <h1 class="header_0"> Add Table</h1> 
                    <%    
                        ' false
                        Else
                    %>
                        <h1 class="header_0"> Edit Table</h1> 
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
                    </div>
                    <%
                        If (NOT isnull(Session("ErrorTitle"))) AND (TRIM(Session("ErrorTitle"))<>"") Then
                    %>
                    <p class="p_error" style="padding: 5px 10px; height: 24px; text-align: center; color: red;width: 100%; white-space: break-spaces;"><%=Session("ErrorTitle")%></p>
                    <%
                        Session.Contents.Remove("ErrorTitle")
                        else
                    %>
                    <p class="p_error" style="padding: 5px 10px; height: 24px;"></p>
                    <%
                        end if
                    %>
                    <div class="controls">
                        <div class="controls_1">
                    <%
                        ' true
                        if (cint(idTable) = 0) then
                    %>
                        <button id="btn-submit" type="button" class="btn btn-primary key" style="padding: 0px 46px;">Add</button>
                    <%    
                        ' false
                        Else
                    %>
                        <button id="btn-submit" type="button" class="btn btn-primary key" style="padding: 0px 46px;">Set</button>
                    <%
                        End if
                    %>
                            <a href="TH_listTable.asp" type="button" class="btn btn-primary key">Cancel</a>
                        </div>
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
    <script src="./assets/javascript/TH_AddTable.js"></script>
    
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