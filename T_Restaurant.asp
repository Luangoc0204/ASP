<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
 <%
    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN
        Set cmdPrep = Server.CreateObject("ADODB.Command")
        connDB.Open()
        cmdPrep.ActiveConnection = connDB
        cmdPrep.CommandType = 1
        cmdPrep.Prepared = True
        cmdPrep.CommandText = "SELECT Substring(Convert(nvarchar(20),timeOpen),1,5) as timeOpen, Substring(Convert(nvarchar(20),timeClose),1,5) as timeClose  FROM Restaurant where idRestaurant = 1"
        Set result = cmdPrep.execute

        If not result.EOF then
            timeOpen = result("timeOpen")
            timeClose = result("timeClose")
        End If
        result.Close()
    Else
        timeOpen = Request.form("timeOpen")
        timeClose = Request.form("timeClose")
        if (NOT isnull(timeOpen) and timeOpen <> "" and NOT isnull(timeClose) and timeClose<> "") Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "UPDATE Restaurant SET timeOpen = ?, timeClose = ? "
            cmdPrep.parameters.Append cmdPrep.createParameter("timeOpen",202,1,255,timeOpen)
            cmdPrep.parameters.Append cmdPrep.createParameter("timeClose",202,1,255,timeClose)

            cmdPrep.execute
            Session("Success") = "Update time successfully!"
            ' Response.redirect("L_home.asp")
        else
            Session("Error") = "You have to input enough info"
        end if
    End if
    connDB.Close

' %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <!-- IonIcons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/T_Restaurant.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <title>Document</title>
</head>

<body>
    <!-- #include file="header.asp" -->
    <section style="background-image: url(assets/images/menu-bg.png);" class="our-menu section bg-light repeat-img"id="menu">
        <div class="div_restaurant">
            <form action="" method="post">
                <div id="header_restaurant">
                    <div class="thong_tin_restaurant">
                        <div class="logo_restaurant">
                            <img src="./assets/images/logo.png" alt="Logo" style="width: 210px;">
                            <div></div>
                        </div>
                    </div>
                    <div class="chi_tiet_restaurant">
                        <div style="display: inline-flex">
                            <div></div>
                            <h6>Time:</h6>
                            <span id="time" style="margin-left: 10px; display: flex;">
                                <span id="timeOpen"><%=timeOpen%></span>
                                <input type="time" id="input_timeOpen" style="display: none;" value="<%=timeOpen%>">
                                <span style="margin: 0 5px;">-</span>
                                <span id="timeClose"><%=timeClose%></span>
                                <input type="time" id="input_timeClose" style="display: none;" value="<%=timeClose%>">
                            </span>
                            <i id="edit-icon" style="color: #ff8243; font-size: 17px; margin-left: 15px; margin-top: 2px;" class="fa fa-edit" onclick="editTime()"></i> 
                            <button type="submit" class="btn btn-success btn-saveTime" style="">Save</button>
                        </div>
                    </div>
                    <div class="content" style="display: flex; margin-top: 20px;">
                        <div class="card" style="width: 50%; margin-right: 12px; margin-left: 5px; ">
                            <div class="card-header border-0">
                                <div class="d-flex justify-content-between">
                                    <h3 class="card-title">Online Store Visitors</h3>
                                    <a href="javascript:void(0);">View Report</a>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="d-flex">
                                    <p class="d-flex flex-column">
                                    <span class="text-bold text-lg">820</span>
                                    <span>Visitors Over Time</span>
                                    </p>
                                    <p class="ml-auto d-flex flex-column text-right">
                                    <span class="text-success">
                                        <i class="fas fa-arrow-up"></i> 12.5%
                                    </span>
                                    <span class="text-muted">Since last week</span>
                                    </p>
                                </div>
            
                                <div class="position-relative mb-4">
                                    <canvas id="visitors-chart" height="200"></canvas>
                                </div>
            
                                <div class="d-flex flex-row justify-content-end">
                                    <span class="mr-2">
                                    <i class="fas fa-square text-primary"></i> This Week
                                    </span>
                
                                    <span>
                                    <i class="fas fa-square text-gray"></i> Last Week
                                    </span>
                                </div>
                            </div>
                        </div>
            
                        <div class="card" style="width: 50%; margin-right: 5px;">
                            <div class="card-header border-0">
                                <div class="d-flex justify-content-between">
                                    <h3 class="card-title">Sales</h3>
                                    <a href="javascript:void(0);">View Report</a>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="d-flex">
                                    <p class="d-flex flex-column">
                                    <span class="text-bold text-lg">$18,230.00</span>
                                    <span>Sales Over Time</span>
                                    </p>
                                    <p class="ml-auto d-flex flex-column text-right">
                                    <span class="text-success">
                                        <i class="fas fa-arrow-up"></i> 33.1%
                                    </span>
                                    <span class="text-muted">Since last month</span>
                                    </p>
                                </div>
            
                                <div class="position-relative mb-4">
                                    <canvas id="sales-chart" height="200"></canvas>
                                </div>
            
                                <div class="d-flex flex-row justify-content-end">
                                    <span class="mr-2">
                                    <i class="fas fa-square text-primary"></i> This year
                                    </span>
                                    <span>
                                    <i class="fas fa-square text-gray"></i> Last year
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </section>

    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    
    <!-- header js -->
    <script src="./assets/javascript/L_header.js"></script>

    <!-- AdminLTE -->
    <script src="dist/js/adminlte.js"></script>

    <!-- OPTIONAL SCRIPTS -->
    <script src="plugins/chart.js/Chart.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <!-- <script src="dist/js/demo.js"></script> -->
    <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
    <script src="dist/js/pages/dashboard3.js"></script>

    <script src="./assets/javascript/T_Restaurant.js"></script>
</body>

</html>