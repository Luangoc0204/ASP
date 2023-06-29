
<link rel="stylesheet" href="./assets/css/animate.css">
<link rel="stylesheet" href="assets/css/L_header.css">
<script src="./assets/javascript/jquery-3.5.1.min.js"></script>
<style>
  .toast:not{
    display:block;
  }

</style>
    <!-- start of header  -->
<body>
    <header class="site-header header-white">
        <div class="container header-height">
            <div class="row">
                <div class="col-lg-2">
                    <div class="header-logo">
                        <a data-href="index.html">
                            <img src="./assets/images/logo.png" width="160" height="45" alt="Logo">
                        </a>
                    </div>
                </div>
                <div class="col-lg-10">
                    <div class="main-navigation">
                        <button class="menu-toggle"><span></span><span></span></button>
                        <nav class="header-menu">
                            <ul class="menu food-nav-menu">
                                <li><a href="L_home.asp">Home</a></li>
                                <%
                                    If (not isnull(Session("idUser")) and TRIM(Session("idUser")) <> "" and Session("role") = "CUSTOMER") Then
                                %>
                                <li><a href="T_SetATable.asp">Booking</a></li>
                                <%
                                    else
                                %>
                                <li><a href="TH_listDBByDate.asp">Booking</a></li>
                                <%
                                    end if
                                %>
                                <li><a href="L_menu.asp">Menu</a></li>
                                <%
                                    If (not isnull(Session("role")) and (Session("role") = "ADMIN" OR Session("role") = "EMPLOYEE")) then
                                %>
                                <li>
                                    <div class="btn-group btn_manager">
                                        <button type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown"
                                            aria-expanded="false" style="background-image: none;">
                                            Manager
                                        </button>
                                        <ul class="dropdown-menu">
                                            <%
                                                If (not isnull(Session("role")) and Session("role") = "ADMIN") then
                                            %>
                                            <li style="width: 100%; margin: 0;"><a class="dropdown-item" href="TH_QL_quanlyNV.asp"
                                                    style="width: 100%; border-radius: 0;">Employees</a></li>
                                            <li style="width: 100%; margin: 0;"><a class="dropdown-item" href="TH_listCustomer.asp"
                                                    style="width: 100%; border-radius: 0;">Customers</a></li>
                                            <li style="width: 100%; margin: 0;"><a class="dropdown-item" href="T_Restaurant.asp"
                                                    style="width: 100%; border-radius: 0;">Restaurant</a></li>
                                            <%
                                                end if
                                            %>
                                            <li style="width: 100%; margin: 0;"><a class="dropdown-item" href="TH_listTable.asp"
                                                    style="width: 100%; border-radius: 0;">Table</a></li>
                                        </ul>
                                    </div>
                                </li>
                                <%
                                    end if
                                %>
                            </ul>
                        </nav>
                        <div class="header-right">
                                    <%
                                        If (not isnull(Session("idUser")) and trim(Session("idUser")) <> "" and Session("role") = "CUSTOMER") Then
                                    %>
                            <div class="header-cart">
                                <a href="L_purchaseCart.asp" class="header-btn icon-white" style="margin: 0;">
                                    <img src="./assets/images/icon_shopping_cart_2_line.png">
                                    <span class="cart-number"></span>
                                </a>
                                <div id="modal-cart">
                                    <div class="triangle"></div>
                                    <!-- <div class="empty_cart">
                                        <img src="./assets/images/cart_shopping.png" alt="">
                                        <p>You have no items in your shopping cart</p>
                                    </div> -->
                                    <div class="list-food-cart">
                                        <p>Recently Added Products</p>
                                        <div class="index_product">
                                            <img class="cart_img" src="./assets/images/dish/1.png" alt="">
                                            <div class="group_name_price">
                                                <span class="cart_name">Nishin with Mayonnase Gunkan</span>
                                                <span class="cart_price">4.49$</span>
                                            </div>
                                        </div>
                                        
                                    </div>
                                    <div class="btn_show_cart">
                                        <a href="L_purchaseCart.asp">View My Shopping Cart</a>
                                    </div>
                                </div>
                            </div>
                                    <%
                                        End if
                                    %>
                            <div class="header-info">
                                <a data-href="" class="header-btn header-info icon-white" style="margin: 0;">
                                    <img src="./assets/images/icon_user_3_line.png">
                                </a>
                                <div id="modal-info">
                                    <div class="triangle"></div>
                                    <%
                                        If (not isnull(Session("idUser")) and trim(Session("idUser")) <> "") Then
                                            connDB.Open
                                            dim cmdPrep
                                            set cmdPrep = Server.CreateObject("ADODB.Command")
                                            cmdPrep.ActiveConnection = connDB
                                            cmdPrep.CommandType = 1
                                            cmdPrep.Prepared =  true
                                            cmdPrep.CommandText = "SELECT * FROM [USER] WHERE idUser = ?"
                                            cmdPrep.Parameters.Append cmdPrep.CreateParameter("idUser", 3, 1, 255 , CInt(Session("idUser")))
                                            dim result
                                            set result = cmdPrep.execute     
                                            if not result.EOF then              
                                    %>
                                    <div class="info">
                                        <%
                                            if (trim(result("avatar"))="") then
                                        %>
                                        <img src="upload\user\user.png" alt="">
                                        <%
                                            else
                                        %>
                                        <img src="upload\user\<%=result("avatar")%>" alt="">
                                        <%
                                            end if
                                        %>
                                        <div class="group_name_email">

                                            <p class="name_User"><%=result("nameUser")%></p>
                                            <span class="email_User"><%=result("email")%></span>
                                        </div>
                                    </div>
                                    <a href="TH_detailCustomer.asp?idUser=<%=result("idUser")%>">
                                        <img src="./assets/images/icon_information_line.png" alt="">
                                        My Information</a>
                                    <a href="logout.asp">
                                        <img src="./assets/images/icon_logout.png" alt="">
                                        Logout</a>
                                    
                                    <%
                                            end if
                                        
                                        Else
                                        
                                    %>
                                    <div class="btn_show_cart">
                                        <a href="loginPage.asp">Please login</a>
                                    </div>
                                    <%
                                        end if
                                        'connDB.Close
                                    %>    
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <!-- header ends  -->
    <!-- Toast success -->
    <%
    
        If (NOT isnull(Session("Success"))) AND (TRIM(Session("Success"))<>"") Then
    %>

    <div style="margin-top:100px; --bs-bg-opacity: .9; position:fixed ; z-index:99 " class=" toast align-items-center bg-success text-white start-50 animate__animated animate__fadeInDown " role="status" aria-live="polite" aria-atomic="true" data-bs-animation="false" data-bs-autohide="true" data-bs-delay="5000">
        
        <div class="d-flex  ">
            <div class="toast-body ">
                <%=Session("Success")%>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>

        
        <script>
            $(document).ready(function() {
            $('.toast').toast('show');

            $('.toast').on('hidden.bs.toast', function () {
            $(this).removeClass('hide').addClass('show');
            // Thêm lớp animate__animated animate__fadeOutUp vào Toast trước khi ẩn nó
            $(this).addClass('animate__animated animate__fadeOutUp');
            
            // Đợi cho animation hoàn thành trước khi ẩn Toast
            setTimeout(function() {
                $(this).hide();
            }.bind(this), 1500); // thời gian animation, tương ứng với duration của animate__fadeOutUp
            });
            });
        </script>
    <%
        Session.Contents.Remove("Success")
        End If
    %>
    <!-- Toast error -->
    <%
    
        If (NOT isnull(Session("Error"))) AND (TRIM(Session("Error"))<>"") Then
    %>

    <div style="margin-top:100px; --bs-bg-opacity: .9; position:fixed ; z-index:99 " class=" toast align-items-center bg-danger text-white start-50 animate__animated animate__fadeInDown " role="status" aria-live="polite" aria-atomic="true" data-bs-animation="false" data-bs-autohide="true" data-bs-delay="5000">
        
        <div class="d-flex  ">
            <div class="toast-body ">
                <%=Session("Error")%>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>

        
        <script>
            $(document).ready(function() {
            $('.toast').toast('show');

            $('.toast').on('hidden.bs.toast', function () {
            $(this).removeClass('hide').addClass('show');
            // Thêm lớp animate__animated animate__fadeOutUp vào Toast trước khi ẩn nó
            $(this).addClass('animate__animated animate__fadeOutUp');
            
            // Đợi cho animation hoàn thành trước khi ẩn Toast
            setTimeout(function() {
                $(this).hide();
            }.bind(this), 1500); // thời gian animation, tương ứng với duration của animate__fadeOutUp
            });
            });
        </script>
    <%
        Session.Contents.Remove("Error")
        End If
    %>
    <script src="./assets/javascript/bootstrap.min.js"></script>
    <!-- header js -->

    <script src="./assets/javascript/L_header.js"></script>
</body>
