<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/user.asp" -->
<!--#include file="./models/employee.asp" -->
<!--#include file="./models/customer.asp" -->
<!--#include file="./models/bookingTable.asp" -->
<!--#include file="./models/table.asp" -->
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
    <title>ListCustomer</title>
    <link rel="stylesheet" href="./assets/css/TH_listCustomer.css">
</head>

<body>
    <!-- start of header  -->
    <!-- #include file="header.asp" -->
    <!-- header ends  -->
    <!-- Menu begin -->
    <section style="background-image: url(assets/images/menu-bg.png);" class="our-menu section bg-light repeat-img"
        id="menu">
        <div class="sec-wp">
            <div class="container">

                <div class="menu-tab-wp">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Main-->
                                <ul class="filters" style="position: absolute; left: 50%; transform: translateX(-50%);">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all, .employee, .chef">
                                        <img style="width: 60px; height: 40px;" src="assets/images/listCus.png"
                                                alt="">
                                                <a href="TH_listCustomer.asp" style="text-decoration: none; color: #fff;">List Customers</a>
                                    </li>
                                </ul>
                                <%
                                    nameSearch = Request.form("nameSearch")
                                    'Session("nameSearch") = nameSearch
                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True
                                    if (isnull(nameSearch) OR trim(nameSearch) = "") then
                                        'tìm tất cả KH
                                        cmdPrep.CommandText = "SELECT * FROM [User] INNER JOIN [Customer] ON [User].idUser = [Customer].idUser"
                                    else
                                        'tìm KH theo tên
                                        cmdPrep.CommandText = "SELECT * FROM [User] INNER JOIN [Customer] ON [User].idUser = [Customer].idUser WHERE [User].nameUser = ?"
                                        cmdPrep.parameters.Append cmdPrep.createParameter("nameSearch",202,1,255,nameSearch)
                                    end if
                                    set result = cmdPrep.execute
                                    if not result.EOF Then
                                        Set listUser = Server.CreateObject("Scripting.Dictionary")
                                        Set listCustomer = Server.CreateObject("Scripting.Dictionary")
                                        count = 0
                                        do while not result.EOF
                                            set userTemp = new User
                                            userTemp.idUser = result("idUser")
                                            userTemp.nameUser = result("nameUser")
                                            userTemp.email = result("email")
                                            userTemp.birthday = result("birthday")
                                            userTemp.phone = result("phone")
                                            userTemp.address = result("address")

                                            listUser.add count, userTemp

                                            set customerTemp = new Customer
                                            customerTemp.idCustomer = result("idCustomer")
                                            customerTemp.idUser = result("idUser")
                                            customerTemp.amountBooking = result("amountBooking")
                                            customerTemp.discount = result("discount")

                                            listCustomer.add count, customerTemp
                                            count = count + 1
                                        result.MoveNext
                                        LOOP 
                                %>
                                <!-- Search Human -->
                                <ul class="filters search-button">
                                    <form method="post" action="" style="display:flex">
                                        <input type="text" class="search-input" name="nameSearch" value="<%=nameSearch%>" placeholder="Search here ...">
                                        <button type="submit" class="search-icon">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </form>
                                </ul>
                                
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
                                        <th scope="col" style="min-width: 50px;width: 4%;">No</th>
                                        <th scope="col" style="min-width: 200px;width: 18%;">Name</th>
                                        <th scope="col" style="min-width: 150px; width: 13%;">Birthday</th>
                                        <th scope="col" style="min-width: 150px; width: 13%;">Phone</th>
                                        <th scope="col" style="min-width: 250px; width: 22%;">Email</th>
                                        <th scope="col" style="min-width: 250px; width: 22%;">Address</th>
                                        <th scope="col" style="min-width: 150px; width: 13%;">Detail</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        For i = 0 To (count-1)
                                    %>
                                    <tr>
                                        <td style="min-width: 50px;width: 4%;"><%=(i+1)%></td>
                                        <td style="min-width: 200px;width: 18%;"><%=listUser(i).nameUser%></td>
                                        <td style="min-width: 150px; width: 13%;"><%=listUser(i).birthday%></td>
                                        <td style="min-width: 150px; width: 13%;"><%=listUser(i).phone%></td>
                                        <td style="min-width: 250px; width: 22%;;" class="note-order"><%=listUser(i).email%></td>
                                        <td style="min-width: 250px; width: 22%;" class="name-order"><%=listUser(i).address%></td>
                                        <td style="min-width: 150px; width: 13%;">
                                            <a href="TH_detailCustomer.asp?idCustomer=<%=listCustomer(i).idCustomer%>" class="btn btn-outline-success" style="padding: 5px 10px;">
                                                <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                View
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                        next
                                    else
                                    %>
                                            <p>No customer!</p>
                                    <%
                                    end if
                                    %>
                                    
                                </tbody>
                            </table>   
                    <div style="width: 100%; display: flex; justify-content: center; margin-top: 20px;">
                        <nav aria-label="Page Navigation">
                        <ul class="pagination pagination-sm justify-content-center my-5">
                            <% if (pages>1) then
                            'kiem tra trang hien tai co >=2
                                if(Clng(page)>=2) then
                            %>
                                <li class="page-item"><a class="page-link" href="TH_listCustomer.asp?page=<%=Clng(page)-1%>">Previous</a></li>
                            <%    
                                end if 
                                for i= 1 to range
                            %>
                                    <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="TH_listCustomer.asp?page=<%=i%>"><%=i%></a></li>
                            <%
                                next
                                if (Clng(page)<pages) then

                            %>
                                <li class="page-item"><a class="page-link" href="TH_listCustomer.asp?page=<%=Clng(page)+1%>">Next</a></li>
                            <%
                                end if    
                            end if
                            %>
                        </ul>
                        </nav>
                    </div>
                    <!--  -->
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
    <script src="./assets/javascript/TH_QL_quanlyNV.js"></script>
    <script src="./assets/javascript/L_header.js"></script>
</body>

</html>