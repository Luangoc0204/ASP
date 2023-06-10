<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    'connDB Close
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="") Then
        Response.redirect("logout.asp")
    End If
    function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number Then
            Ceil = Ceil + 1
        end if
    end function

    function checkPage(cond, ret) 
        if cond=true then
            Response.write ret
        else
            Response.write ""
        end if
    end function
' trang hien tai
    page = Request.QueryString("page")
    limit = 5

    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

    offset = (Clng(page) * Clng(limit)) - Clng(limit)

    connDB.Open()
    set cmdPrep = Server.CreateObject("ADODB.Command")
    cmdPrep.ActiveConnection = connDB
    cmdPrep.CommandType = 1
    cmdPrep.Prepared =  true
    cmdPrep.CommandText = "SELECT COUNT(idBookingTable) AS count FROM [BookingTable] where dateBT = CONVERT(date, ?, 103) "
    dateToday = FormatDateTime(Date(), 2)
    dateToday = Replace(dateToday, "/", "-")
    cmdPrep.parameters.Append cmdPrep.createParameter("dateBT",133,1,255 ,dateToday)
    'Response.write("date: " + dateToday)
    Set CountResult = cmdPrep.execute()
    'Response.write("count: " + CStr(CountResult("count")))
    totalRows = CLng(CountResult("count"))
    connDB.Close()
    Set CountResult = Nothing
' lay ve tong so trang
    pages = Ceil(totalRows/limit)
    'Response.write("page: " + Cstr(pages))
    'gioi han tong so trang la 5
    Dim range
    If (pages<=5) Then
        range = pages
    Else
        range = 5
    End if
    'Response.write("Range: " + Cstr(range))
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <title>DetailCustomer</title>
    <link rel="stylesheet" href="./assets/css/TH_detailCustomer.css">
</head>

<body>
    <!-- start of header  -->
    <!--#include file="header.asp"-->
    <!-- header ends  -->
    <!-- Menu begin -->
    <%
        dateSearch = Request.form("dateSearch")
        if (isnull(dateSearch) OR trim(dateSearch) = "") then
    %>
    <p style="display:none" id="dateToday"><%=dateToday%></p>
    <%
        else
    %>
    <p style="display:none" id="dateToday"><%=dateSearch%></p>
    <%
        end if
    %>
    <p style="display:none" id="dateReverse"></p>
    <section style="background-image: url(assets/images/menu-bg.png);" class="our-menu section bg-light repeat-img"
        id="menu">
        <div class="sec-wp">
            <div class="container">

                <div class="menu-tab-wp">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Main  -->
                                <ul class="filters" style="position: absolute; left: 50%; transform: translateX(-50%);">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all, .employee, .chef">
                                        <img style="width: 60px; height: 40px;" src="assets/images/listBooking.png"
                                            alt="">
                                        List Booking
                                    </li>
                                </ul>
                                <!-- Search Date -->
                                  
                                <!--  -->
                            </div>
                        </div>
                    </div>
                </div>
                <!-- -->
                <div class="body-detail" style="display: flex;justify-content: space-around;">
                    <div class="detail-list" style="margin-top: -10%;">
                                <%
                                    idCustomer = Request.QueryString("idCustomer")
                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True
                                    cmdPrep.CommandText = "SELECT * FROM [User] INNER JOIN [Customer] ON [User].idUser = [Customer].idUser WHERE idCustomer = ?"
                                    cmdPrep.parameters.Append cmdPrep.createParameter("idCustomer",3,1, ,CInt(idCustomer))
                                    set result = cmdPrep.execute
                                %>
                        <div class="dish-box text-center">
                            <div class="dist-img">
                                <img src="<%=result("avatar")%>" alt="">
                            </div>
                            <div class="human-title">
                                <h3 class="h3-title"><%=result("nameUser")%></h3>
                                <tr>
                                    <th><%=result("email")%></th>
                                </tr>
                            </div>
                            
                            <div class="human-list">
                                    <table class="human-info">
                                        <tr>
                                            <th>Birthday:</th>
                                            <td><%=result("birthday")%></td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Phone:</th>
                                            <td><%=result("phone")%></td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Address:</th>
                                            <td><%=result("address")%></td>
                                        </tr>                 
                                        <tr>                                                      
                                            <th>Discount:</th>
                                            <td><%=result("discount")%>%</td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Amount Booking:</th>
                                            <td><%=result("amountBooking")%></td>
                                        </tr>
                            
                                    </table>  
                            </div>
                            <div class="dist-bottom-row" style="margin-top: 40px;">
                                <ul>
                                    <li>
                                        <button class="dish-add-btn btn-buy-now">
                                            <i class="fa-regular fa-pen-to-square fa-lg" style="color: #fff;"></i>
                                            <span>Edit</span>
                                        </button>
                                    </li>
                                    <li>
                                        <button class="dish-add-btn btn-add-to-cart">
                                            <i class="fa-solid fa-user-minus fa-lg" style="color: #fff;"></i>
                                            <span style="padding-left: 5px;">Delete</span>
                                        </button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--  -->
                    <div class="info-list">
                        
                        <!--  -->
                        <div class="info-list-wrap">
                            <table class="table table-hover table-scroll">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 4%;min-width: 40px;;">No</th>
                                        <th scope="col" style="width: 14%;min-width: 115px;">Time</th>
                                        <th scope="col" style="width: 8%;min-width: 80px;">Type</th>
                                        <th scope="col" style="min-width: 74px;width: 9%;">Amount</th>
                                        <th scope="col" style="width: 21%;min-width: 173px;">Note</th>
                                        <th scope="col" style="width: 15%;min-width: 134px;">Customers</th>
                                        <th scope="col" style="width: 12%;min-width: 100px;">Phone</th>
                                        <th scope="col" style="width: 10%;min-width: 88px;text-align: center;">Food</th>
                                    </tr>
                                </thead>
                                <tbody class="tbody_list">
                                    <%
                                        set cmdPrep = Server.CreateObject("ADODB.Command")
                                        cmdPrep.ActiveConnection = connDB
                                        cmdPrep.CommandType = 1
                                        cmdPrep.Prepared = True
                                        cmdPrep.CommandText = "SELECT * FROM [BookingTable] INNER JOIN [User] ON [BookingTable].idUser =  [User].idUser inner join [Table] on [Table].idTable = BookingTable.idTable WHERE [User].idUser = (SELECT idUser FROM Customer WHERE idCustomer = ?)"
                                        cmdPrep.parameters.Append cmdPrep.createParameter("idCustomer",3,1, ,CInt(idCustomer))        
                                        set result = cmdPrep.execute
                                        Dim i
                                        i = 1
                                        if not result.EOF then
                                        do while not result.EOF
                                    %>
                                    <tr>
                                        <td style="width: 5%; min-width: 40px;"><%=i%></td>
                                        <td style="width: 14%;min-width: 115px;">
                                            <span><%=result("dateBT")%></span>
                                            <span class="timeBT"><%=result("timeBT")%></span>
                                        </td>
                                        <td style="min-width: 80px;width: 8%;"><%=result("typeTable")%> People</td>
                                        <td style="width: 9%;min-width: 74px;"><%=result("amountBT")%></td>
                                        <td style="width: 22%;min-width: 173px;;" class="note-order"><%=result("noteBT")%></td>
                                        <td style="min-width: 134px;width: 16%;" class="name-order"><%=result("nameUser")%></td>
                                        <td style="width: 12%;min-width: 100px;"><%=result("phone")%></td>
                                        <td style="width: 11%;min-width: 88px;">
                                            <a href="#" class="btn btn-outline-success" style="padding: 5px 5px;">
                                                <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                View
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                    i = i + 1
                                    result.MoveNext
                                    LOOP
                                    else
                                        Response.write("No booking table")
                                    end if    
                                %>    
                                </tbody>
                            </table>
                            
                        </div>
                        <!--  -->
                    </div>
                </div>
            </div>
        </div>
        </div>
    </section>
    <!-- Menu end -->

    <!-- jquery  -->
    <script src="./assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="./assets/javascript/popper.min.js"></script>
    <script src="./assets/javascript/bootstrap.min.js"></script>
    <!-- swiper slider  -->
    <script src="./assets/javascript/swiper-bundle.min.js"></script>

    <!-- mixitup -- filter  -->
    <script src="./assets/javascript/jquery.mixitup.min.js"></script>
    <!-- fancy box  -->
    <script src="./assets/javascript/jquery.fancybox.min.js"></script>

    <!-- parallax  -->
    <script src="./assets/javascript/parallax.min.js"></script>

    <!-- gsap  -->
    <script src="./assets/javascript/gsap.min.js"></script>
    <!-- main js -->
    <script src="./main.js"></script>
    <script src="./assets/javascript/L_header.js"></script>
    <script src="./assets/javascript/TH_detailCustomer.js"></script>

</body>

</html>