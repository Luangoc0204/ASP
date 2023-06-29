<%
    'code here
    Dim connDB
    ' gõ obj + enter là ra cái bên dưới
    set connDB = Server.CreateObject("ADODB.Connection")
    Dim strConnection
    strConnection = "Provider=SQLOLEDB.1;Data Source=MSI;Charset=UTF8;Database=QLNH;User ID=sa;Password=123456"
    connDB.ConnectionString = strConnection
    'connDB.Open
%>
