<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" -->  
<%
    connDB.Open()
    'lấy top 5 sản phẩm 
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "select top 5 *, (select * from Food where idFood = cf.idFood for json path) as food "&_
    "from CartFood cf where idCart = (select idCart from Cart where idUser = ?) and isPay = 0 order by datetimeCF desc for json path"
    cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
    set result = cmdPrep.execute
    if result.EOF then
        Response.Write("Failed to load top 5 CartFood")
    Else
        ' In kết quả JSON
        Response.ContentType = "application/json"
        Response.Write(result.Fields(0).Value)
        connDB.Close()
    end if    
%>