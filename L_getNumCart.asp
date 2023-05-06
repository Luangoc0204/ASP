<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT Count(idCartFood) from CartFood where idCart = (select idCart from Cart where idUser = ?) and isPay = 0"
        cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
        set result = cmdPrep.execute
        Response.write(CStr(result(0).Value))
    connDB.Close    
%>