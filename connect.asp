<%
    'code here
    Dim connDB
    ' gõ obj + enter là ra cái bên dưới
    set connDB = Server.CreateObject("ADODB.Connection")
    Dim strConnection
    strConnection = "Provider=SQLOLEDB.1;Data Source=MSI\SQLEXPRESS;Database=QLNH;User ID=thanhnguyen;Password=nthanh12"
    connDB.ConnectionString = strConnection
    'connDB.Open
%>
