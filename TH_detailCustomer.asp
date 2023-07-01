<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/user.asp" -->
<!--#include file="./models/employee.asp" -->
<!--#include file="./models/customer.asp" -->
<!--#include file="./models/bookingTable.asp" -->
<!--#include file="./models/table.asp" -->
<%
    'connDB Close
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="") Then
        Response.redirect("logout.asp")
    End If
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
    <section style="background-image: url(assets/images/menu-bg.png);" class="our-menu section bg-light repeat-img"
        id="menu">
        <div class="sec-wp">
            <div class="container">
                <div class="menu-tab-wp">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Main  -->
                <%
                    idCustomer = Request.QueryString("idCustomer")
                    idUser = Request.QueryString("idUser")
                    if (trim(idCustomer) = "") then
                        Session("ReturnBack") = "TH_detailCustomer.asp?idUser="&idUser
                    else 
                        Session("ReturnBack") = "TH_detailCustomer.asp?idCustomer="&idCustomer
                    end if    
                    if ( (not isnull(idCustomer) and trim(idCustomer) <> "") or (not isnull(idUser) and trim(idUser) <> "" and Session("role") = "CUSTOMER") ) then
                %>
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
                <%
                    end if
                %>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- -->
                <div class="body-detail" style="display: flex;justify-content: space-around;">
                    <div class="detail-list" style="margin-top: -10%;">
                                <%
                                    
                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                    cmdPrep.ActiveConnection = connDB
                                    cmdPrep.CommandType = 1
                                    cmdPrep.Prepared = True
                                    if (not isnull(idCustomer) and trim(idCustomer) <> "") then
                                    'nếu idCustomer khác null và không rỗng
                                        cmdPrep.CommandText = "SELECT [User].*, idCustomer, amountBooking, discount FROM [User] INNER JOIN [Customer] ON [User].idUser = [Customer].idUser WHERE idCustomer = ?"
                                        cmdPrep.parameters.Append cmdPrep.createParameter("idCustomer",3,1, ,CInt(idCustomer))
                                    elseif (not isnull(idUser) and trim(idUser) <> "") then
                                        if (not isnull(Session("role")) AND TRIM(Session("role")) <>"" AND Session("role") = "ADMIN") then
                                            cmdPrep.CommandText = "SELECT * FROM [User] WHERE idUser = ?"
                                            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
                                        elseif (not isnull(Session("role")) AND TRIM(Session("role")) <>"" AND Session("role") = "EMPLOYEE") then
                                            cmdPrep.CommandText = "SELECT [User].*, idEmployee, salary, position FROM [User] inner join Employee on [User].idUser = Employee.idUser WHERE [User].idUser = ?"
                                            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
                                        elseif (not isnull(Session("role")) AND TRIM(Session("role")) <>"" AND Session("role") = "CUSTOMER") then
                                            cmdPrep.CommandText = "SELECT [User].*, idCustomer, amountBooking, discount FROM [User] inner join Customer on [User].idUser = Customer.idUser WHERE [User].idUser = ?"
                                            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))
                                        end if    
                                    end if
                                    
                                    set result = cmdPrep.execute
                                        set userTemp = new User
                                        userTemp.idUser = result("idUser")
                                        userTemp.nameUser = result("nameUser")
                                        userTemp.email = result("email")
                                        userTemp.birthday = result("birthday")
                                        userTemp.phone = result("phone")
                                        userTemp.address = result("address")
                                        userTemp.avatar = result("avatar")
                                        'nếu là Customer
                                        if ( (not isnull(idCustomer) and trim(idCustomer) <> "") or (not isnull(idUser) and trim(idUser)<>"" and Session("role")="CUSTOMER") ) then
                                            set customerTemp = new Customer
                                            customerTemp.idCustomer = result("idCustomer")
                                            customerTemp.idUser = result("idUser")
                                            customerTemp.amountBooking = result("amountBooking")
                                            customerTemp.discount = result("discount")
                                        elseif (not isnull(idUser) and trim(idUser)<>"" and Session("role")="EMPLOYEE") then
                                            set employeeTemp = new Employee
                                            employeeTemp.idEmployee = result("idEmployee")
                                            employeeTemp.idUser = result("idUser")
                                            employeeTemp.salary = result("salary")
                                            employeeTemp.position = result("position")
                                        end if     

                                %>
                        <div class="dish-box text-center">
                            <div class="dist-img">
                                <%
                                    If (isnull(userTemp.avatar) or trim(userTemp.avatar)="") Then
                                    ' true
                                %>
                                <img src="upload\user\user.png" alt="">
                                <%
                                    else
                                %>
                                <img src="upload\user\<%=userTemp.avatar%>" alt="">
                                <%
                                    end if
                                %>
                            </div>
                            <div class="human-title">
                                <h3 class="h3-title"><%=userTemp.nameUser%></h3>
                                <tr>
                                    <th><%=userTemp.email%></th>
                                </tr>
                            </div>
                            
                            <div class="human-list">
                                    <table class="human-info">
                                        <tr>
                                            <th>Birthday:</th>
                                            <td><%=userTemp.birthday%></td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Phone:</th>
                                            <td><%=userTemp.phone%></td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Address:</th>
                                            <td><%=userTemp.address%></td>
                                        </tr>    
                                        <%
                                            if ((not isnull(idCustomer) and trim(idCustomer) <> "") or (not isnull(idUser) and trim(idUser)<>"" and Session("role")="CUSTOMER") ) then
                                            'nếu có idCustomer -> admin đang xem thông tin customer
                                        %>
                                        <tr>                                                      
                                            <th>Amount Booking:</th>
                                            <td><%=customerTemp.amountBooking%></td>
                                        </tr>
                                        <tr>                                                      
                                            <th>Discount:</th>
                                            <td><%=customerTemp.discount%>%</td>
                                        </tr>
                                        <%
                                            elseif (not isnull(idUser) and trim(idUser) <> "" and not isnull(Session("role")) AND TRIM(Session("role")) <>"" AND Session("role") = "EMPLOYEE") then
                                            'nếu có idUser -> người dùng đang tự xem thông tin của mình
                                            'nếu là Employee thì hiện position và salary
                                        %>
                                        <tr>                                                      
                                            <th>Salary:</th>
                                            <td><%=employeeTemp.salary%>$</td>  
                                        </tr>
                                        <tr>                                                      
                                            <th>Position:</th>
                                            <td><%=employeeTemp.position%></td>
                                        </tr>
                                        <%        
                                            end if
                                        %>
                                    </table>  
                            </div>
                            <div class="dist-bottom-row" style="margin-top: 40px;">
                                <ul>
                                    <li >
                                        <button class="dish-add-btn btn-buy-now">
                                            <a href="T_EditUser.asp?idUser=<%=userTemp.idUser%>" style="text-decoration: none;color: white;">
                                                <i class="fa-regular fa-pen-to-square fa-lg" style="color: #fff;"></i>
                                                <span>Edit</span>
                                            </a>
                                        </button>
                                    </li>
                                    <%
                                        if (not isnull(idCustomer) and trim(idCustomer) <>"" and  not isnull(Session("role")) AND TRIM(Session("role")) <>"" AND Session("role") = "ADMIN") then
                                    %>
                                    <li>
                                        <button class="dish-add-btn btn-add-to-cart">
                                            <i class="fa-solid fa-user-minus fa-lg" style="color: #fff;"></i>
                                            <span style="padding-left: 5px;">Delete</span>
                                        </button>
                                    </li>
                                    <%
                                        end if
                                    %>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--  -->
                    <%
                        if ( (not isnull(idCustomer) and trim(idCustomer) <> "") or (not isnull(idUser) and trim(idUser) <> "" and Session("role") = "CUSTOMER") ) then
                    %>
                    <div class="info-list">
                        
                        <!--  -->
                        <div class="info-list-wrap">
                            <table class="table table-hover table-scroll">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 4%;min-width: 40px;;">No</th>
                                        <th scope="col" style="width: 20%;min-width: 115px;">Time</th>
                                        <th scope="col" style="width: 8%;min-width: 80px;">Type</th>
                                        <th scope="col" style="min-width: 74px;width: 9%;">Amount</th>
                                        <th scope="col" style="width: 31%;min-width: 173px;">Note</th>
                                        <th scope="col" style="width: 14%;min-width: 88px;text-align: center;">Action</th>
                                        <th scope="col" style="width: 14%;min-width: 88px;text-align: center;">Food</th>
                                    </tr>
                                </thead>
                                <tbody class="tbody_list">
                                    <%
                                        set cmdPrep = Server.CreateObject("ADODB.Command")
                                        cmdPrep.ActiveConnection = connDB
                                        cmdPrep.CommandType = 1
                                        cmdPrep.Prepared = True
                                        if (not isnull(idCustomer) and trim(idCustomer) <> "") then
                                            cmdPrep.CommandText = "SELECT BookingTable.*,  typeTable FROM [BookingTable] inner join [Table] on [Table].idTable = BookingTable.idTable WHERE [BookingTable].idUser = (SELECT idUser FROM Customer WHERE idCustomer = ?) order by dateBT desc"
                                            cmdPrep.parameters.Append cmdPrep.createParameter("idCustomer",3,1, ,CInt(idCustomer))   
                                        elseif (not isnull(idUser) and trim(idUser) <> "") then
                                            cmdPrep.CommandText = "SELECT BookingTable.*,  typeTable FROM [BookingTable] inner join [Table] on [Table].idTable = BookingTable.idTable WHERE [BookingTable].idUser = ? order by dateBT desc"
                                            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idUser))   
                                        end if         
                                        set result = cmdPrep.execute
                                        'đặt Object
                                        Set listBookingTable = Server.CreateObject("Scripting.Dictionary")
                                        Set listTable = Server.CreateObject("Scripting.Dictionary")
                            
                                        count = 0
                                        if not result.EOF then
                                            do while not result.EOF
                                                set bookingTableTemp = new BookingTable
                                                bookingTableTemp.idBookingTable = result("idBookingTable")
                                                bookingTableTemp.idUser = result("idUser")
                                                bookingTableTemp.idTable = result("idTable")
                                                bookingTableTemp.amountBT = result("amountBT")
                                                bookingTableTemp.dateBT = result("dateBT")
                                                bookingTableTemp.timeBT = result("timeBT")
                                                bookingTableTemp.noteBT = result("noteBT")
                                                bookingTableTemp.isCheckin = result("isCheckin")

                                                listBookingTable.add count, bookingTableTemp

                                                set tableTemp = new Table
                                                tableTemp.idTable = result("idTable")
                                                tableTemp.typeTable = result("typeTable")

                                                listTable.add count, tableTemp
                                                'sau khi thêm vào dictionary thì tăng index
                                                count = count + 1
                                            result.MoveNext
                                            LOOP    
                                            For i = 0 To (count-1) 
                                    %>
                                    <tr>
                                        <td style="width: 4%; min-width: 40px;"><%=(i+1)%></td>
                                        <td style="width: 20%;min-width: 115px;">
                                            <span><%=listBookingTable(i).dateBT%></span>
                                            <span class="timeBT"><%=listBookingTable(i).timeBT%></span>
                                        </td>
                                        <td style="min-width: 80px;width: 8%;"><%=listTable(i).typeTable%> People</td>
                                        <td style="width: 9%;min-width: 74px; text-align:center"><%=listBookingTable(i).amountBT%></td>
                                        <td style="width: 31%;min-width: 173px;;" class="note-order"><%=listBookingTable(i).noteBT%></td>
                                        <td style="width: 14%;min-width: 88px; text-align:center">
                                            <a href="T_SetATable.asp?idBookingTable=<%=listBookingTable(i).idBookingTable%>" class="btn btn-success" style="padding: 5px 10px;">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                                Edit
                                            </a>
                                        </td>
                                        <td style="width: 14%;min-width: 88px; text-align:center">
                                            <%
                                                if (not isnull(Session("role")) and Session("role") = "ADMIN") then
                                                
                                            %>
                                            <a href="L_purchaseCart.asp?idBookingTable=<%=listBookingTable(i).idBookingTable%>" class="btn btn-outline-success" style="padding: 5px 5px;">
                                                <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                View
                                            </a>
                                            <%
                                                else
                                                    set cmdPrep = Server.CreateObject("ADODB.Command")
                                                    cmdPrep.ActiveConnection = connDB
                                                    cmdPrep.CommandType = 1
                                                    cmdPrep.Prepared = True
                                                    cmdPrep.CommandText = "SELECT * FROM Bill where idBookingTable = ? "
                                                    cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
                                                    set result = cmdPrep.execute
                                                    if not result.EOF then
                                            %>
                                            <a href="L_BillUser.asp?idBill=<%=result("idBill")%>" class="btn btn-outline-success" style="padding: 5px 5px;">
                                                <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                View
                                            </a>
                                            <%
                                                    else
                                            %>
                                            <a href="L_purchaseCart.asp?idBookingTable=<%=listBookingTable(i).idBookingTable%>" class="btn btn-outline-success" style="padding: 5px 5px;">
                                                <i class="fa-sharp fa-regular fa-eye fa-xs"></i>
                                                View
                                            </a>
                                            <%
                                                    end if
                                                end if                                                
                                            %>
                                        </td>
                                    </tr>
                                    <%
                                            Next
                                        else
                                            Response.write("No booking table")
                                        end if    
                                %>    
                                </tbody>
                            </table>
                            
                        </div>
                        <!--  -->
                    </div>
                    <%
                        end if
                        connDB.Close
                    %>
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