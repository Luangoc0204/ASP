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
    cmdPrep.CommandText = "SELECT m.month_year as Month, ISNULL(SUM(b.sumPrice), 0) AS TotalSumPrice "&_
                            "FROM ( "&_
                                "SELECT TOP 5 FORMAT(DATEFROMPARTS(YEAR(dateBill), MONTH(dateBill), 1), 'MMM yyyy') AS month_year "&_
                                "FROM ( "&_
                                    "SELECT DATEADD(MONTH, -(number - 1), GETDATE()) AS dateBill "&_
                                    "FROM master..spt_values "&_
                                    "WHERE type = 'P' AND number BETWEEN 1 AND 5 "&_
                                ") AS dates "&_
                                "ORDER BY dateBill DESC "&_
                            ") AS m "&_
                            "LEFT JOIN Bill b ON FORMAT(DATEFROMPARTS(YEAR(b.dateBill), MONTH(b.dateBill), 1), 'MMM yyyy') = m.month_year "&_
                            "GROUP BY m.month_year "&_
                            "ORDER BY CONVERT(DATE, '01 ' + m.month_year) DESC "&_
                            "for json path"   
    set result = cmdPrep.execute
    Response.write(CStr(result(0).Value))
    
    connDB.Close
%>