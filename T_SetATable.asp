<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp" -->
<%
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "") Then
        Response.redirect("logout.asp")
    End If
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        idBookingTable = Request.QueryString("idBookingTable")
        If (isnull(idBookingTable) OR trim(idBookingTable) = "") then 
            idBookingTable = 0
        End if
        If (Len(idBookingTable)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM BookingTable inner join [Table] on BookingTable.idTable = [Table].idTable WHERE idBookingTable=?"
            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1,,CInt(idBookingTable))   
            Set result = cmdPrep.execute

            If not result.EOF then
                'Response.write(idBookingTable + "<br>")
                typeTable = result("typeTable")
                amountBT = result("amountBT")
                dateBT = result("dateBT")
                timeBT = result("timeBT")
                noteBT = result("noteBT")
                'Response.write(timeBT + "<br>")
            End If
            result.Close()
        End if
    Else
        idBookingTable = Request.QueryString("idBookingTable")
        If (isnull(idBookingTable) OR trim(idBookingTable) = "") then 
            idBookingTable = 0
        End if
        typeTable = Request.form("typeTable")
        amountBT = Request.form("amountBT")  
        dateBT = Request.form("dateBT")
        timeBT = Request.form("timeBT")
        noteBT = Request.form("noteBT")
        if (cint(idBookingTable) = 0) then
            if (NOT isnull(amountBT) and amountBT<>"" and NOT isnull(dateBT) and dateBT<>"" and NOT isnull(timeBT) and timeBT<>"" and NOT isnull(noteBT) and noteBT<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "INSERT INTO BookingTable(idUser,idTable,amountBT, dateBT, timeBT, noteBT) VALUES (?, (select idTable from [Table] where [Table].typeTable = ?) ,?,?,?,?); SELECT SCOPE_IDENTITY() AS idUser"
                cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1,,CInt(Session("idUser")))
                cmdPrep.parameters.Append cmdPrep.createParameter("typeTable",3,1,,CInt(typeTable))
                cmdPrep.parameters.Append cmdPrep.createParameter("amountBT",202,1,255,amountBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("dateBT",202,1,255,dateBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("timeBT",202,1,255,timeBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("noteBT",202,1,255,noteBT)

                cmdPrep.execute
                Session("Success") = "New booking table was added!"
                Response.redirect("L_home.asp")
            else
                Session("Error") = "You have to input enough info!!!"
            end if
        else          
            if (NOT isnull(amountBT) and amountBT<>"" and NOT isnull(dateBT) and dateBT<>"" and NOT isnull(timeBT) and timeBT<>"" and NOT isnull(noteBT) and noteBT<>"") then

                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE BookingTable SET amountBT=?, dateBT=?, timeBT=?, noteBT=? WHERE idBookingTable=?"
                cmdPrep.parameters.Append cmdPrep.createParameter("amountBT",202,1,255,amountBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("dateBT",202,1,255,dateBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("timeBT",202,1,255,timeBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("noteBT",202,1,255,noteBT)
                cmdPrep.parameters.Append cmdPrep.createParameter("idTable",202,1,255,idBookingTable)
                cmdPrep.execute
                Session("Success") = "The booking table was edited!"
                Response.redirect(Session("ReturnBack"))
            else
                Session("Error") = "You have to input enough info!!!"
            end if   
        end if
    End if         
    connDB.Close
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/T_SetATable.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <title>Document</title>
</head>
<body>
    <!-- #include file="header.asp" -->
    <div class="div_container">
        <form action="" method="post">
            <div class="container_0">
                <h1 class="header_0">Set a table</h1>
                <div class="header__one">
                    <div class="header_1">
                        <p class="header_title">Type:</p>
                        <select class="ais-SortBy-select" id="typeTable" name="typeTable" value="<%=typeTable%>">
                            <option class="ais-SortBy-option" value="2">2 people</option>
                            <option class="ais-SortBy-option" value="4">4 people</option>
                            <option class="ais-SortBy-option" value="6">6 people</option>
                            <option class="ais-SortBy-option" value="10">10 people</option>
                        </select>
                    </div>
                    <div class="header_1">
                        <p class="header_title">Amount:</p>
                        <input type="number" min="1" class="header_2" id="amountBT" name="amountBT" value="<%=amountBT%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Date:</p>
                        <input type="date" class="header_2" id="dateBT" name="dateBT" value="<%=dateBT%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Time:</p>
                        <p style="display:none" id="timeBT"><%=timeBT%></p>
                        <input id = "timeBT2" type="time" class="header_2" class="input_timeBT" name="timeBT" value="<%=Left(timeBT,5)%>">
                    </div>
                    <div class="header_1">
                        <p class="header_title">Note:</p>
                        <input type="text" class="header_3" id="noteBT" name="noteBT" value="<%=noteBT%>">
                    </div>
                </div>
                <%
                <p class="p_error" style="padding: 5px 10px; height: 18px;"></p>	                    If (NOT isnull(Session("ErrorTitle"))) AND (TRIM(Session("ErrorTitle"))<>"") Then
                %>
                <p class="p_error" style="padding: 5px 10px; height: 24px; text-align: center; color: red; width: 100%; white-space: break-spaces;"><%=Session("ErrorTitle")%></p>                
                <%
                    Session.Contents.Remove("ErrorTitle")
                    else
                %>
                <p class="p_error" style="padding: 5px 10px; height: 24px; text-align: center; color: red;width: 100%; white-space: break-spaces;"></p>                <%
                    end if
                %>
                <div class="controls">
                    <div class="controls_1">
                        <button type="submit" class="btn btn-primary key">Set</button>
                        <%
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "select * from Bill where idBookingTable = ?"
                            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",202,1,255,idBookingTable)
                            set result = cmdPrep.execute
                            if result.EOF then
                                If (isnull(Session("idUser")) OR TRIM(Session("idUser")) = "" OR Session("role") <> "CUSTOMER") Then
                        %>
                        <button type="button" data-href="L_deleteBookingTable.asp?idBookingTable=<%=idBookingTable%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="btn btn-primary delete-btn">Delete</button>
                        <%
                                end if
                            end if    
                        %>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <!-- MODAL delete-->
        <div class="modal" tabindex="-1" id="confirm-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Delete Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete this booking table?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="" type="button" class="btn btn-secondary">Close</a>
                            <a class="btn btn-danger btn-delete">Delete</a>
                        </div>
                    </div>
                </div>
        </div>
        <%
            connDB.close()
        %>
    <!-- header ends  -->
    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    
    <!-- header js -->
    <script src="./assets/javascript/L_header.js"></script>
    <script src="./assets/javascript/TH_SetATable.js"></script>
    <!-- Modal js  -->
    <script>
        $(function () {
            $('#confirm-delete').on('show.bs.modal', function (e) {
                $(this)
                    .find('.btn-delete')
                    .attr('href', $(e.relatedTarget).data('href'));
            });
        });
    </script>
</body>
</html>