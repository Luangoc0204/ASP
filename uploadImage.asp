<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="upload.lib.asp"-->
<%
    url = "\"&Replace(Request.QueryString("url"), "%5C", "\")
    'Response.Write "url:"&url
    idUser = Request.QueryString("idUser")
    'hàm upload ảnh
    'Response.Write "avbc"
        Dim Form : Set Form = New ASPForm
        Server.ScriptTimeout = 1440 ' Limite de 24 minutos de execu��o de c�digo, o upload deve acontecer dentro deste tempo ou ent�o ocorre erro de limite de tempo.
        Const MaxFileSize = 5242880 ' Bytes. Aqui est� configurado o limite de 100 MB por upload (inclui todos os tamanhos de arquivos e conte�dos dos formul�rios).
        Form.SizeLimit = MaxFileSize
        Form.CharSet = Response.Charset
        ' Khai báo đối tượng FileSystemObject
        Dim FSO
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        allowedFormats = Array("jpg", "jpeg", "png")
                    
        Dim fileExtension
        If Form.State = 0 Then

            For each Key in Form.Texts.Keys
                'Response.Write "Elemento: " & Key & " = " & Form.Texts.Item(Key) & "<br />"
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
                    newFileName = idUser &"_"& currentDate & "_" & currentTime & "_" & Replace(oldFileName, " ", "_")  ' Tạo tên tệp tin mới

                    filePath = Server.MapPath(".") & url & newFileName ' Đường dẫn tệp tin ban đầu
                    If FSO.FileExists(filePath) Then
                        Dim uniqueNumber : uniqueNumber = 1
                        Do While FSO.FileExists(Server.MapPath(".") & url & baseFileName & "(" & uniqueNumber & ")." & fileExtension)
                            uniqueNumber = uniqueNumber + 1
                        Loop
                        oldFileName = baseFileName & "(" & uniqueNumber & ")." & fileExtension ' Tạo tên tệp tin mới với số duy nhất
                    End If
                    ' Kiểm tra xem tệp tin cần xóa có tồn tại hay không
                    If FSO.FileExists(Server.MapPath(".") & url & newFileName) Then
                        ' Nếu tệp tin tồn tại, thực hiện xóa
                        FSO.DeleteFile(Server.MapPath(".") & url & newFileName)
                        ' Response.Write "File " & oldFileName & " deleted. <br />"
                    End If
                    newFileName = idUser &"_"& currentDate & "_" & currentTime & "_" & Replace(oldFileName, " ", "_")  ' Tạo tên tệp tin mới
                    
                    Field.SaveAs Server.MapPath(".") & url & newFileName
                    'Response.Write "File name: " & newFileName & " uploaded. <br />"
                    Response.Write newFileName
                Else
                    ' Nếu tệp tin không có định dạng ảnh được cho phép
                    Session("ErrorTitle") = "File name: "& Field.FileName & " is not an allowed image format (.jpg, .jpeg, .png)"
                    success = False
                End If
                ' # Field.Filename : Nome do Arquivo que chegou.
                ' # Field.ByteArray : Dados bin�rios do arquivo, �til para subir em blobstore (MySQL).
                
            Next
        End If

        ' Hàm kiểm tra phần tử có tồn tại trong mảng hay không

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