<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "select timeOpen, timeClose from Restaurant where idRestaurant = 1 for json path"
        set result = cmdPrep.execute
        Response.write(CStr(result(0).Value))
    connDB.Close    
%>
