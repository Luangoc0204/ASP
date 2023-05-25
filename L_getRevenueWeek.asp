<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "" or Session("role") <> "ADMIN") then
        Response.redirect("logout.asp")
    end if
    connDB.Open
    idFood = Request.QueryString("idFood")
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared = True
    cmdPrep.CommandText = "DECLARE @CurrentDate DATE = GETDATE(); "&_
                            "WITH Numbers AS ( "&_
                                "SELECT number "&_
                                "FROM ( "&_
                                    "VALUES (0), (1), (2), (3), (4), (5), (6) "&_
                                ") AS Numbers(number) "&_
                            ") "&_
                            "SELECT TOP 7 "&_
                                "LEFT(DATENAME(WEEKDAY, DATEADD(DAY, -Numbers.number, @CurrentDate)), 3) + ' ' + "&_
                                "CONVERT(VARCHAR(2), DATEPART(DAY, DATEADD(DAY, -Numbers.number, @CurrentDate))) + "&_
                                "CASE "&_
                                    "WHEN DATEPART(DAY, DATEADD(DAY, -Numbers.number, @CurrentDate)) IN (1, 21, 31) THEN 'st' "&_
                                    "WHEN DATEPART(DAY, DATEADD(DAY, -Numbers.number, @CurrentDate)) IN (2, 22) THEN 'nd' "&_
                                    "WHEN DATEPART(DAY, DATEADD(DAY, -Numbers.number, @CurrentDate)) IN (3, 23) THEN 'rd' "&_
                                    "ELSE 'th' "&_
                                "END AS date, "&_
                                "ISNULL(SUM(sumPrice), 0) AS TotalSumPrice "&_
                            "FROM "&_
                                "Numbers "&_
                            "LEFT JOIN "&_
                                "Bill ON DATEADD(DAY, DATEDIFF(DAY, 0, Bill.dateBill), 0) = DATEADD(DAY, -Numbers.number, @CurrentDate) "&_
                            "GROUP BY "&_
                                "DATEADD(DAY, -Numbers.number, @CurrentDate) "&_
                            "ORDER BY "&_
                                "DATEADD(DAY, -Numbers.number, @CurrentDate) DESC "&_
                            "FOR JSON PATH;"   
    set result = cmdPrep.execute
    Response.write(CStr(result(0).Value))
    
    connDB.Close
%>