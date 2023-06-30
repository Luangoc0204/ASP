<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/account.asp" -->
<!--#include file="./models/user.asp" -->
<!--#include file="./models/employee.asp" -->
<!--#include file="./models/customer.asp" -->
<!--#include file="./models/bookingTable.asp" -->
<!--#include file="./models/bookingFood.asp" -->
<!--#include file="./models/table.asp" -->
<!--#include file="./models/food.asp" -->
<%
    'connDB Close
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="" OR (Session("role")<>"ADMIN")) Then
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
    <title>QLNV</title>
    <link rel="stylesheet" href="./assets/css/TH_QL_quanlyNV.css">
</head>

<body>
    <!-- start of header  -->
    <!-- #include file="header.asp" -->
    <!-- header ends -->
    <!-- Menu begin -->
    <section style="background-image: url(assets/images/menu-bg.png);" class="our-menu section bg-light repeat-img"
        id="menu">
        <div class="sec-wp">
            <div class="container">
                <div class="menu-tab-wp" style="position: relative;">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Add Human -->
                                <a href="T_AddEmployee.asp">
                                    <ul class="filters add-human">
                                    <i class="fa-solid fa-circle-plus" style="color: #ff8243; font-weight: 900;font-size: 44px;padding-right: 5px;"></i>
                                    Add employee
                                    </li>
                                </ul>
                                </a>
                                
                                <!---->
                                <ul class="filters" style="position: absolute; left: 50%; transform: translateX(-50%);">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all, .Employee, .Chef">
                                        <img style="width: 60px; height: 40px;" src="assets/images/QL_all.png" alt="">
                                        All
                                    </li>
                                    <li class="filter" data-filter=".Employee">
                                        <img style="width: 60px; height: 40px;" src="assets/images/QL_employee.png" alt="">
                                        Employee
                                    </li>
                                    <li class="filter" data-filter=".Chef">
                                        <img style="width: 60px; height: 40px;" src="assets/images/QL_chef.png" alt="">
                                        Chef
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
                                        'tìm tất cả NV
                                        cmdPrep.CommandText = "SELECT [User].*, idEmployee, salary, position FROM [User] INNER JOIN [Employee] ON [User].idUser = [Employee].idUser"
                                    else
                                        'tìm NV theo tên
                                        cmdPrep.CommandText = "SELECT [User].*, idEmployee, salary, position FROM [User] INNER JOIN [Employee] ON [User].idUser = [Employee].idUser where [User].nameUser = ?"
                                        cmdPrep.parameters.Append cmdPrep.createParameter("nameSearch",202,1,255,nameSearch)
                                    end if
                                    set result = cmdPrep.execute
                                    Set listUser = Server.CreateObject("Scripting.Dictionary")
                                    Set listEmployee = Server.CreateObject("Scripting.Dictionary")
                                    count = 0
                                    do while not result.EOF
                                        set userTemp = new User
                                        userTemp.idUser = result("idUser")
                                        userTemp.nameUser = result("nameUser")
                                        userTemp.email = result("email")
                                        userTemp.birthday = result("birthday")
                                        userTemp.phone = result("phone")
                                        userTemp.address = result("address")
                                        userTemp.avatar = result("avatar")
                                        
                                        listUser.add count, userTemp

                                        set employeeTemp = new Employee
                                        employeeTemp.idEmployee = result("idEmployee")
                                        employeeTemp.salary = result("salary")
                                        employeeTemp.position = result("position") 
                                        
                                        listEmployee.add count, employeeTemp
                                        count = count + 1
                                    result.MoveNext
                                    LOOP  
                                    
                                %>
                                <!-- Search Human -->
                                <ul class="filters search-button">
                                    <!-- Hiển thị kết quả tìm kiếm -->
                                    <form method="post" action="TH_QL_quanlyNV.asp">
                                        <input type="text" class="search-input" name="nameSearch" value="<%=nameSearch%>" placeholder="Search by name ...">
                                        <button type="submit" class="search-icon">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </form>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="menu-list-row">
                    <div class="row g-xxl-5 bydefault_show" id="menu-dish">
                        <%
                            For i = 0 To (count-1)
                        %>
                        <!-- 1 -->
                        <div class="col-lg-4 col-sm-6 dish-box-wp <%=Replace(listEmployee(i).position, " ", "")%>" data-cat="<%=Replace(listEmployee(i).position, " ", "")%>">
                            <div class="dish-box text-center">
                                <div class="dist-img">
                                    <img src="upload\user\<%=listUser(i).avatar%>" alt="">
                                </div>
                                <div class="human-title">
                                    <h3 class="h3-title"><%=listUser(i).nameUser%></h3>
                                </div>
                                
                                <div class="human-list">
                                        <table class="human-info">
                                            <tr>
                                                <th>Birthday:</th>
                                                <td><%=listUser(i).birthday%></td>
                                            </tr>
                                            <tr>                                                      
                                                <th>Phone:</th>
                                                <td><%=listUser(i).phone%></td>
                                            </tr>
                                            <tr>                                                      
                                                <th>Address:</th>
                                                <td><%=listUser(i).address%></td>
                                            </tr>                 
                                            <tr>                                                      
                                                <th>Position:</th>
                                                <td><%=listEmployee(i).position%></td>
                                            </tr>
                                            <tr>                                                      
                                                <th>Salary:</th>
                                                <td><%=listEmployee(i).salary%></td>
                                            </tr>
                                
                                        </table>
                                </div>
                                <div class="dist-bottom-row">
                                    <ul>
                                        <a href="T_AddEmployee.asp?idEmployee=<%=listEmployee(i).idEmployee%>">
                                            <li >
                                            <button class="dish-add-btn btn-buy-now">
                                                <i class="fa-regular fa-pen-to-square fa-lg" style="color: #fff;"></i>
                                                <span>Edit</span>
                                            </button>
                                        </li>
                                        </a>
                                        <li>
                                            <button data-href="L_deleteEmployee.asp?idEmployee=<%=listEmployee(i).idEmployee%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="dish-add-btn btn-add-to-cart">
                                                <i class="fa-solid fa-user-minus fa-lg" style="color: #fff;"></i>
                                                <span style="padding-left: 5px;">Delete</span>
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                        <%
                            next
                        %>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Menu end -->
    <!-- MODAL delete-->
        <div class="modal" tabindex="-1" id="confirm-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Delete Employee Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete employee?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="TH_QL_quanlyNV.asp" type="button" class="btn btn-secondary">Close</a>
                            <a class="btn btn-danger btn-delete">Delete</a>
                        </div>
                    </div>
                </div>
        </div>
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
    <script src="./assets/javascript/TH_QL_quanlyNV.js"></script>
    <script src="./assets/javascript/L_header.js"></script>
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