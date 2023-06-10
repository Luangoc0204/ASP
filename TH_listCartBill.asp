<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    'connDB Close
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="" OR (Session("role")="CUSTOMER")) Then
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
    cmdPrep.CommandText = "SELECT COUNT(idCart) AS count FROM [Bill] where dateBill = CONVERT(date, ?, 103) "
    dateToday = FormatDateTime(Date(), 2)
    dateToday = Replace(dateToday, "/", "-")
    cmdPrep.parameters.Append cmdPrep.createParameter("dateBill",133,1,255 ,dateToday)
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
    <title>CartBill</title>
    <link rel="stylesheet" href="./assets/css/TH_listCartBill.css">
    
</head>

<body>
    <!-- start of header  -->
    <!-- #include file="header.asp"-->
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
        <div class="sec-wp" style="height: 100%;">
            <div class="container" style="height: 100%;">

                <div class="menu-tab-wp">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Main  -->
                                <ul class="filters" style="position: absolute; left: 50%; transform: translateX(-50%);">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all">
                                        <img style="width: 60px; height: 40px;" src="assets/images/listBooking.png"
                                            alt="">
                                        <a href="./TH_listCartBill.asp" style="text-decoration: none; color: #fff">List Bill</a>

                                    </li>
                                </ul>
                                <!-- Search Date -->
                                <div style="position: absolute !important;right: 0;">
                                    <form method="post" style="display:flex; align-items:center">
                                        <div class="filters search-button">
                                            <!-- Hiển thị kết quả tìm kiếm -->
                                            <form method="post" action="TH_listCartBill.asp">
                                                <%
                                                    if (isnull(dateSearch) OR trim(dateSearch) = "") then
                                                %>
                                                <input type="date" class="search-input" name="dateSearch" value="<%=dateToday%>" placeholder="Search here ...">
                                                <%
                                                    else
                                                %>
                                                <input type="date" class="search-input" name="dateSearch" value="<%=dateSearch%>" placeholder="Search here ...">
                                                <%
                                                    end if
                                                %>
                                                <button type="submit" class="search-icon" style="padding: 10px;">
                                                    <i class="fa fa-search"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </form>                                
                                </div>  
                                <!--  -->
                            </div>
                        </div>
                    </div>
                </div>
                <!--  -->
                <div class="info-list">
                    <div class="info-list-wrap">
                        <table class="table table-hover table-scroll">
                            <thead>
                                <tr>
                                    <th scope="col" style="min-width: 50px;width: 4.5%; text-align: center;">No</th>
                                    <th scope="col" style="min-width: 80px;width: 7.5%;">TotalPrice</th>
                                    <th scope="col" style="min-width: 80px; width: 7.5%;">Date</th>
                                    <th scope="col" style="min-width: 70px; width: 6.5%; text-align: center;">Time</th>
                                    <th scope="col" style="min-width: 100px; width: 9%; border-bottom: none;  text-align: center;">Detail</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True  
                                    cmdPrep.CommandText = "SELECT * FROM [Bill] where dateBill = CONVERT(date, ?, 103)"              
                                    if (isnull(dateSearch) OR trim(dateSearch) = "") then
                                        cmdPrep.parameters.Append cmdPrep.createParameter("dateBill",133,1, ,dateToday) 
                                    else 
                                        cmdPrep.parameters.Append cmdPrep.createParameter("dateBill",133,1, ,dateSearch)    
                                    end if  
                                    set result = cmdPrep.execute
                                    Dim i
                                    i = 1
                                    if not result.EOF then
                                        do while not result.EOF              
                                            ' Hiển thị thông tin hóa đơn theo ngày
                                            %>
                                            <tr>
                                                <td style="min-width: 50px;width: 4.5%; text-align: center;"><%=i%></td>
                                                <td style="min-width: 80px; width: 7.5%;"><%=result("sumPrice")%>$</td>
                                                <td style="min-width: 80px; width: 7.5%;"><%=result("dateBill")%></td>
                                                <td style="min-width: 70px;width: 6.5%;; text-align: center;" class="timeBill"><%=result("timeBill")%></td>
                                                <td style="min-width: 120px; width: 11%;  text-align: center;">
                                                    <a href="#" class="btn btn-outline-success" style="padding: 5px 10px;">
                                                        <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                        View
                                                    </a>
                                                </td>
                                            </tr>
                                            <%
                                            
                                            i = i + 1
                                            result.MoveNext
                                        loop
                                    else
                                        Response.write("No bill today")
                                    end if    
                                %>       
                            </tbody>
                        </table>
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
    <script src="./assets/javascript/TH_listCartBill.js"></script>
</body>

</html>