<%
    'code here
    Dim connDB
    ' gõ obj + enter là ra cái bên dưới
    set connDB = Server.CreateObject("ADODB.Connection")
    Dim strConnection
    strConnection = "Provider=SQLOLEDB.1;Data Source=MSI\SQLEXPRESS;Database=QLNH;User ID=demo;Password=12345678"
    connDB.ConnectionString = strConnection
    'connDB.Open
%>
