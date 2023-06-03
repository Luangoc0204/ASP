<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
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
                                        cmdPrep.CommandText = "SELECT * FROM [User] INNER JOIN [Employee] ON [User].idUser = [Employee].idUser"
                                    else
                                        'tìm NV theo tên
                                        cmdPrep.CommandText = "SELECT * FROM [User] INNER JOIN [Employee] ON [User].idUser = [Employee].idUser where [User].nameUser = ?"
                                        cmdPrep.parameters.Append cmdPrep.createParameter("nameSearch",202,1,255,nameSearch)
                                    end if
                                    set result = cmdPrep.execute
                                %>
                                <!-- Search Human -->
                                <ul class="filters search-button">
                                    <!-- Hiển thị kết quả tìm kiếm -->
                                    <form method="post" action="TH_QL_quanlyNV.asp">
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
                <div class="menu-list-row">
                    <div class="row g-xxl-5 bydefault_show" id="menu-dish">
                        <!-- 1 -->
                        <%    
                            
                            do while not result.EOF
                        %>
                        <div class="col-lg-4 col-sm-6 dish-box-wp <%=Replace(result("position"), " ", "")%>" data-cat="<%=Replace(result("position"), " ", "")%>">
                            <div class="dish-box text-center">
                                <div class="dist-img">
                                    <img src="<%=result("avatar")%>" alt="">
                                </div>
                                <div class="human-title">
                                    <h3 class="h3-title"><%=result("nameUser")%></h3>
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
                                                <th>Position:</th>
                                                <td><%=result("position")%></td>
                                            </tr>
                                            <tr>                                                      
                                                <th>Salary:</th>
                                                <td><%=result("salary")%></td>
                                            </tr>
                                
                                        </table>
                                </div>
                                <div class="dist-bottom-row">
                                    <ul>
                                        <a href="T_AddEmployee.asp?idEmployee=<%=result("idEmployee")%>">
                                            <li >
                                            <button class="dish-add-btn btn-buy-now">
                                                <i class="fa-regular fa-pen-to-square fa-lg" style="color: #fff;"></i>
                                                <span>Edit</span>
                                            </button>
                                        </li>
                                        </a>
                                        <a href="L_deleteEmployee.asp?idEmployee=<%=result("idEmployee")%>">
                                        <li>
                                            <button class="dish-add-btn btn-add-to-cart">
                                                <i class="fa-solid fa-user-minus fa-lg" style="color: #fff;"></i>
                                                <span style="padding-left: 5px;">Delete</span>
                                            </button>
                                        </li>
                                        </a>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                        <%
                            result.MoveNext
                            LOOP
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
    <script src="./assets/javascript/TH_QL_quanlyNV.js"></script>
    <script src="./assets/javascript/L_header.js"></script>
</body>

</html>