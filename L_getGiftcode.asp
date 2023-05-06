<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="connect.asp" --> 
<%
    giftCode = Request.QueryString("giftcode")
    connDB.Open
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "SELECT discountGiftCode from GiftCode where nameGiftCode = ? and isActive = 1"
    cmdPrep.parameters.Append cmdPrep.createParameter("giftcode",202,1,Len(giftCode) ,giftCode)
    set result = cmdPrep.execute
    if not result.EOF then 
        Response.write(CStr(result(0).Value))
    else 
        Response.write("Giftcode does not exist!!!")    
    end if    
    connDB.Close    
%>