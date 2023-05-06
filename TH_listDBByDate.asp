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
    <title>ListDBByDate</title>
    <link rel="stylesheet" href="./assets/css/TH_listDBByDate.css">
    
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
                                        <a href="./TH_listDBByDate.asp" style="text-decoration: none; color: #fff">List Booking</a>

                                    </li>
                                </ul>
                                <!-- Search Date -->
                                <div style="position: absolute !important;right: 0;">
                                    <form method="post" style="display:flex; align-items:center">
                                        <div class="filters search-button">
                                            <!-- Hiển thị kết quả tìm kiếm -->
                                            <form method="post" action="TH_listDBByDate.asp">
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
                                    <th scope="col" style="min-width: 70px;width: 6.5%;">Time</th>
                                    <th scope="col" style="min-width: 80px; width: 7.5%;">Type</th>
                                    <th scope="col" style="min-width: 80px; width: 7.5%; text-align: center;">Amount</th>
                                    <th scope="col" style="min-width: 250px; width: 24%;">Note</th>
                                    <th scope="col" style="min-width: 150px; width: 14.5%;">Customers</th>
                                    <th scope="col" style="min-width: 120px; width: 11%;">Phone</th>
                                    <th scope="col" style="min-width: 110px; width: 7%; text-align: center;">Check-in</th>
                                    <th scope="col" style="min-width: 80px; width: 7%; text-align: center;">Action</th>
                                    <th scope="col" style="min-width: 100px; width: 9%; border-bottom: none;  text-align: center;">Food</th>

                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True
                                    cmdPrep.CommandText = "SELECT * FROM [BookingTable] INNER JOIN [User] ON [BookingTable].idUser =  [User].idUser inner join [Table] on [Table].idTable = BookingTable.idTable"&_
                                    " where dateBT = CONVERT(date, ?, 103)"&_
                                    " ORDER BY timeBT asc OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
                                    
                                    if (isnull(dateSearch) OR trim(dateSearch) = "") then
                                        cmdPrep.parameters.Append cmdPrep.createParameter("dateBT",133,1, ,dateToday) 
                                    else 
                                        cmdPrep.parameters.Append cmdPrep.createParameter("dateBT",133,1, ,dateSearch)    
                                    end if      

                                    cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
                                    cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)
                                    set result = cmdPrep.execute
                                    Dim i
                                    i = 1
                                    if not result.EOF then
                                        do while not result.EOF
                                            ' Kiểm tra giá trị của isCheckin và hiển thị nút confirm hoặc icon "success"
                                            idBookingTable = result("idBookingTable")
                                            
                                            Set cmdCheck = Server.CreateObject("ADODB.Command")
                                            cmdCheck.ActiveConnection = connDB
                                            cmdCheck.CommandType = 1
                                            cmdCheck.Prepared = True
                                            cmdCheck.CommandText = "SELECT isCheckin FROM BookingTable WHERE idBookingTable = ?"
                                            cmdCheck.parameters.Append cmdCheck.createParameter("nameFood",3,1, ,CInt(idBookingTable))
                                            Set checkResult = cmdCheck.execute
                                            isCheckin = checkResult("isCheckin")
                                            
                                            ' Hiển thị thông tin đặt bàn và kiểm tra giá trị của isCheckin để hiển thị nút confirm hoặc icon "success"
                                            %>
                                            <tr>
                                                <td style="min-width: 50px;width: 4.5%; text-align: center;"><%=i%></td>
                                                <td style="min-width: 70px;width: 6.5%;" class="timeBT"><%=result("timeBT")%></td>
                                                <td style="min-width: 80px; width: 7.5%;"><%=result("typeTable")%> People</td>
                                                <td style="min-width: 80px; width: 7.5%; text-align: center;"><%=result("amountBT")%></td>
                                                <td style="min-width: 250px; width: 24%;" class="note-order"><%=result("noteBT")%></td>
                                                <td style="min-width: 150px; width: 14.5%;" class="name-order"><%=result("nameUser")%></td>
                                                <td style="min-width: 120px; width: 11%;"><%=result("phone")%></td>
                                                <% 
                                                If isCheckin Then
                                                    %>
                                                    <td style="min-width: 60px; width: 5%; text-align: center;">
                                                        <i class="fa-solid fa-circle-check fa-lg" style="color: #09c820;"></i>
                                                    </td>
                                                    <td style="min-width: 60px; width: 5%; text-align: center;">
                                                        <a href="#" class="btn btn-outline-success" style="padding: 5px 15px;">Edit</a>
                                                    </td>
                                                <% Else %>
                                                    <td style="min-width: 60px;width: 5%; text-align: center;">
                                                        <a href="TH_confirmBookingTable.asp?idBookingTable=<%=idBookingTable%>" class="btn btn-outline-success" style="padding: 5px 5px;">
                                                            Confirm
                                                        </a>
                                                    </td>
                                                    <td style="min-width: 60px; width: 5%; text-align: center;">
                                                        <a href="#" class="btn btn-outline-success" style="padding: 5px 15px;">Edit</a>
                                                    </td>
                                                <% End If %>
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
                                        Response.write("No booking table today")
                                    end if    
                                %>       
                            </tbody>
                        </table>
                    </div>


                     <div style="width: 100%; display: flex; justify-content: center;">
                        <nav aria-label="Page Navigation">
                        <ul class="pagination pagination-sm justify-content-center my-5">
                            <% if (pages>1) then
                            'kiem tra trang hien tai co >=2
                                if(Clng(page)>=2) then
                            %>
                                <li class="page-item"><a class="page-link" href="TH_listDBByDate.asp?page=<%=Clng(page)-1%>">Previous</a></li>
                            <%    
                                end if 
                                for i= 1 to range
                            %>
                                    <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="TH_listDBByDate.asp?page=<%=i%>"><%=i%></a></li>
                            <%
                                next
                                if (Clng(page)<pages) then

                            %>
                                <li class="page-item"><a class="page-link" href="TH_listDBByDate.asp?page=<%=Clng(page)+1%>">Next</a></li>
                            <%
                                end if    
                            end if
                            %>
                        </ul>
                    </nav>
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
    <script src="./assets/javascript/TH_listDBByDate.js"></script>
</body>

</html>