<!--#include file="connect.asp"-->
<!--#include file="upload.lib.asp"-->
<%
    'Response.Charset = "utf-8"
    Dim Form : Set Form = New ASPForm
    Server.ScriptTimeout = 1440 ' Limite de 24 minutos de execu��o de c�digo, o upload deve acontecer dentro deste tempo ou ent�o ocorre erro de limite de tempo.
    Const MaxFileSize = 10240000 ' Bytes. Aqui est� configurado o limite de 100 MB por upload (inclui todos os tamanhos de arquivos e conte�dos dos formul�rios).
    Form.SizeLimit = MaxFileSize
    Form.CharSet = Response.Charset
    Function EncodeStringToUTF8(s)
        Dim stream: Set stream = Server.CreateObject("ADODB.Stream")
        stream.Charset = "utf-8"
        stream.Open
        stream.WriteText s
        stream.Position = 0
        stream.Type = 2 ' adTypeText
        stream.Charset = "utf-8"
        EncodeStringToUTF8 = stream.ReadText
        stream.Close
        Set stream = Nothing
    End Function
    idUser = Request.QueryString("idUser")
        nameUser = EncodeStringToUTF8(Form.Texts.Item("nameUser"))
        birthday = Form.Texts.Item("birthday")  
        phone = Form.Texts.Item("phone")   
        address = Form.Texts.Item("address")
        email = Form.Texts.Item("email")
        password = Form.Texts.Item("password")
        Response.Write "nameUser: " &nameUser&"<br>"
        Response.Write "nameUser: " &birthday&"<br>"
        Response.Write "nameUser: " &phone&"<br>"
        Response.Write "nameUser: " &address&"<br>"
        Response.Write "nameUser: " &email&"<br>"
        Response.Write "nameUser: " &password&"<br>"
    connDB.Open
    
    Set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE [User] SET nameUser=N'"&nameUser&"', birthday=?, phone=?, address=?, email=?, avatar = ? WHERE idUser=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("birthday",202,1,255,birthday)
            cmdPrep.parameters.Append cmdPrep.createParameter("phone",202,1,255,phone)
            cmdPrep.parameters.Append cmdPrep.createParameter("address",202,1,255,address)
            cmdPrep.parameters.Append cmdPrep.createParameter("email",202,1,255,email)
            cmdPrep.parameters.Append cmdPrep.createParameter("avatar",202,1,255,CStr(newFileName))
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
                        
            set result = cmdPrep.execute
    Function uploadImg(oldFileName,newFileName, url)
        'tạo biến để kiểm tra việc upload thành công hay không
        Dim success 
        ' thực hiện up ảnh và lấy newFileName
        

        ' Khai báo đối tượng FileSystemObject
        Dim FSO
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        allowedFormats = Array("jpg", "jpeg", "png")
                    
        Dim fileExtension
        If Form.State = 0 Then

            For each Key in Form.Texts.Keys
                Response.Write "Elemento: " & Key & " = " & Form.Texts.Item(Key) & "<br />"
            Next

            For each Field in Form.Files.Items
                fileExtension = LCase(FSO.GetExtensionName(Field.FileName))
                If IsInArray(fileExtension, allowedFormats) Then
                    ' Nếu tệp tin có định dạng ảnh được cho phép
                    Dim currentDate, currentTime
                    currentDate = FormatDateTime(Date, vbShortDate) ' Lấy ngày hiện tại
                    currentDate = Replace(currentDate, "/", "") ' Xóa dấu gạch chéo ngược
                    currentTime = FormatDateTime(Now, vbShortTime) ' Lấy giờ hiện tại
                    currentTime = Replace(currentTime, ":", "") ' Xóa dấu hai chấm
                    baseFileName = Left(Field.FileName, InStrRev(Field.FileName, ".") - 1) ' Lấy phần tên tệp tin gốc (không bao gồm phần mở rộng)
                    fileExtension = Mid(Field.FileName, InStrRev(Field.FileName, ".") + 1) ' Lấy phần mở rộng tệp tin
                    oldFileName = baseFileName & "." & fileExtension ' Tên tệp tin ban đầu

                    filePath = Server.MapPath(".") & url & newFileName ' Đường dẫn tệp tin ban đầu
                    If FSO.FileExists(filePath) Then
                        Dim uniqueNumber : uniqueNumber = 1
                        Do While FSO.FileExists(Server.MapPath(".") & url & baseFileName & "(" & uniqueNumber & ")." & fileExtension)
                            uniqueNumber = uniqueNumber + 1
                        Loop
                        oldFileName = baseFileName & "(" & uniqueNumber & ")." & fileExtension ' Tạo tên tệp tin mới với số duy nhất
                    End If
                    
                    newFileName = currentDate & "_" & currentTime & "_" & Replace(oldFileName, " ", "_")  ' Tạo tên tệp tin mới
                    Field.SaveAs Server.MapPath(".") & url & newFileName
                    ' Kiểm tra xem tệp tin cần xóa có tồn tại hay không
                    If FSO.FileExists(Server.MapPath(".") & url & oldFileName) Then
                        ' Nếu tệp tin tồn tại, thực hiện xóa
                        FSO.DeleteFile(Server.MapPath(".") & url & oldFileName)
                        Response.Write "File " & oldFileName & " deleted. <br />"
                    End If
                    Response.Write "File name: " & newFileName & " uploaded. <br />"
                    success = True
                Else
                    ' Nếu tệp tin không có định dạng ảnh được cho phép
                    Session("ErrorTitle") = "File name: "& Field.FileName & " is not an allowed image format (.jpg, .jpeg, .png)"
                    success = False
                End If
                ' # Field.Filename : Nome do Arquivo que chegou.
                ' # Field.ByteArray : Dados bin�rios do arquivo, �til para subir em blobstore (MySQL).
                
            Next
        End If
        ' Kiểm tra kết quả upload và trả về giá trị tương ứng
        If success Then
            ' Thực hiện các việc tiếp theo sau khi upload thành công
            uploadImg = True ' Trả về giá trị True để chỉ ra thành công
        Else
            ' Xử lý khi có lỗi xảy ra trong quá trình upload
            uploadImg = False ' Trả về giá trị False để chỉ ra có lỗi
        End If
        ' Hàm kiểm tra phần tử có tồn tại trong mảng hay không
    End Function
    Function IsInArray(item, arr)
        Dim i
        For i = LBound(arr) To UBound(arr)
            If arr(i) = item Then
                IsInArray = True
                Exit Function
            End If
        Next
        IsInArray = False
    End Function
%>