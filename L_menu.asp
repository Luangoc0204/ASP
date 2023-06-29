<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/food.asp" -->
<%
    'connDB.Close
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "" ) then
        connDB.Open
    end if
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/fontawesome.css">
    <title>Document</title>
    <link rel="stylesheet" href="./assets/css/L_menu.css">
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
                <div class="row">
                    <div class="col-lg-12">
                        <div class="sec-title text-center mb-2">
                            <p class="sec-sub-title mb-3">our menu</p>
                            <div class="sec-title-shape mb-4">
                                <img src="assets/images/title-shape.svg" alt="">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="menu-tab-wp" style="position: relative;">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <ul class="filters">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all, .Starter, .MainCourse, .Dessert">
                                        <img style="width: 60px; height: 40px;" src="assets/images/menu-1.png" alt="">
                                        All
                                    </li>
                                    <li class="filter" data-filter=".Starter">
                                        <img style="width: 60px; height: 40px;" src="assets/images/sushi_1.png" alt="">
                                        Starter
                                    </li>
                                    <li class="filter" data-filter=".MainCourse">
                                        <img style="width: 60px; height: 40px;" src="assets/images/sushi_2.png" alt="">
                                        Main course
                                    </li>
                                    <li class="filter" data-filter=".Dessert">
                                        <img style="width: 60px; height: 40px;" src="assets/images/Dessert.png" alt="">
                                        Dessert
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <%
                        If (not isnull(Session("role")) and (Session("role") = "ADMIN")) then
                    %>
                    <a href="T_AddFood.asp" class="div_add_food">
                        <div class="div_color_add_food">
                            <i class="fa-solid fa-plus"></i>
                            <span>Add food</span>
                        </div>
                    </a>
                    <%
                        end if
                    %>
                    <%
                        idBookingTable = Request.QueryString("idBookingTable")
                        If (not isnull(idBookingTable) and trim(idBookingTable) <> "") then
                    %>
                    <span id="idBookingTable" style="display:none"><%=idBookingTable%></span>
                    <a href="L_purchaseCart.asp?idBookingTable=<%=idBookingTable%>" class="div_add_food">
                        <div class="div_color_add_food" style="justify-content: center;">
                            <img src="./assets/images/icon_back_fill.png" alt="">
                            <span style="font-size: 20px;">Return</span>
                        </div>
                    </a>
                    <%
                        end if
                    %>
                </div>
                <div class="menu-list-row">
                    <div class="row g-xxl-5 bydefault_show" id="menu-dish">
                    <%
                        
                        set cmdPrep = Server.CreateObject("ADODB.Command")
                        cmdPrep.ActiveConnection = connDB
                        cmdPrep.CommandType = 1
                        cmdPrep.Prepared = True
                        cmdPrep.CommandText = "SELECT * FROM Food where isActive = 1"
                        set result = cmdPrep.execute
                        Set listFood = Server.CreateObject("Scripting.Dictionary")
                        count  = 0
                        do while not result.EOF
                            set foodTemp = new Food
                            foodTemp.idFood = result("idFood")
                            foodTemp.nameFood = result("nameFood")
                            foodTemp.priceFood = result("priceFood")
                            foodTemp.typeFood = result("typeFood")
                            foodTemp.forPerson = result("forPerson")
                            foodTemp.amountFood = result("amountFood")
                            foodTemp.imgFood = result("imgFood")
                            foodTemp.isActive = result("isActive")

                            listFood.add count, foodTemp
                            'sau khi thêm vào dictionary thì tăng index
                            count = count + 1
                            result.MoveNext
                        LOOP    
                        For i = 0 To (count-1) 
                    %>
                        <div class="col-lg-4 col-sm-6 dish-box-wp <%=Replace((listFood(i).typeFood), " ", "")%>" data-cat="<%=Replace(listFood(i).typeFood, " ", "")%>">
                            <div class="dish-box text-center">
                                <div class="dist-img">
                                    <img src="<%=listFood(i).imgFood%>" alt="">
                                </div>
                                <div class="dish-title">
                                    <h3 class="h3-title"><%=listFood(i).nameFood%></h3>
                                </div>
                                <div>
                                    <p>For
                                        <span><%=listFood(i).typeFood%></span>
                                    </p>
                                </div>
                                <div class="dish-info">
                                    <ul style="padding:0">
                                        <li>
                                            <p>Price</p>
                                            <b class="price"><%=listFood(i).priceFood%>
                                                <span>$<span>
                                            </b>
                                        </li>
                                        <li>
                                            <p>Person</p>
                                            <b><%=listFood(i).forPerson%>
                                                
                                            </b>
                                        </li>
                                    </ul>
                                </div>
                                <div class="dist-bottom-row">
                                    <ul>
                                    <%
                                        If (not isnull(Session("role")) and (Session("role") = "ADMIN") and isnull(idBookingTable) and trim(idBookingTable) = "") then
                                    %>
                                        <li>
                                            <a href="T_AddFood.asp?idFood=<%=listFood(i).idFood%>">
                                                <button class="dish-add-btn btn-buy-now">
                                                    <img src="./assets/images/icon_pencil_line.png"
                                                        class="uil uil-plus">
                                                    <span>Edit</span>
                                                </button>
                                            </a>
                                        </li>
                                        <li>
                                            <button data-href="L_deleteFood.asp?idFood=<%=listFood(i).idFood%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="dish-add-btn delete-btn">
                                                <img src="./assets/images/icon_delete_2_line.png"
                                                    class="uil uil-plus">
                                                <span style="padding-left: 5px;">Delete</span>
                                            </button>
                                        </li>
                                    <%
                                        Elseif (not isnull(idBookingTable) and trim(idBookingTable) <> "") then
                                    %>    
                                        <div style="width: 100%; display: flex; justify-content: center;">
                                            <li>
                                                <button data-food-id="<%=listFood(i).idFood%>" data-food-name="<%=listFood(i).nameFood%>" class="dish-add-btn btn-add-to-cart">
                                                    <img src="./assets/images/icon_cart_add_shopping_icon.png"
                                                        class="uil uil-plus">
                                                    <span style="padding-left: 5px;">Add</span>
                                                </button>
                                            </li>
                                        </div>
                                    <%
                                        Elseif (not isnull(Session("role")) and (Session("role") = "CUSTOMER")) then
                                    %>    
                                        <li>
                                            <a href="L_purchaseCart.asp?idFood=<%=listFood(i).idFood%>">
                                                <button class="dish-add-btn btn-buy-now">
                                                    <img src="./assets/images/icon_cart_ecommerce_fast_moving_icon.png"
                                                        class="uil uil-plus">
                                                    <span>Buy now</span>
                                                </button>
                                            </a>
                                        </li>
                                        <li>
                                            <button data-food-id="<%=listFood(i).idFood%>" data-food-name="<%=listFood(i).nameFood%>" class="dish-add-btn btn-add-to-cart">
                                                <img src="./assets/images/icon_cart_add_shopping_icon.png"
                                                    class="uil uil-plus">
                                                <span style="padding-left: 5px;">Add</span>
                                            </button>
                                        </li>
                                    <%
                                        End if
                                    %>    
                                    </ul>
                                </div>
                            </div>
                        </div>

                    <%
                        next
                        connDB.Close
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
                            <h5 class="modal-title">Purchase Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete sushi?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="L_menu.asp" type="button" class="btn btn-secondary">Close</a>
                            <a class="btn btn-danger btn-delete">Delete</a>
                        </div>
                    </div>
                </div>
        </div>
    <!-- Modal notification begin-->
    <div id="modal_notification">
        <div class="modal_notification">
            <div style="width: 100%; display: flex; justify-content: end;">
                <button class="closeModal">
                    <img src="./assets/images/icon_close_fill.png" alt="">
                </button>
            </div>
            <div style="position: relative; margin-top: 20px;">
                <img src="./assets/images/cart_shopping.png" alt="" />
                <img class="cart_line" src="./assets/images/cart_shopping_line.png" alt="" />
                <img class="shop_bag animate__animated animate__fadeInDown"
                    src="./assets/images/sushi_3.png" alt="" />
            </div>
            <p class="content-notification" style="margin-top: 20px;" >
                The 
                <span class="name-product-notification" style="font-weight: bold">sushi</span> 
                has been 
                <span class="text-add-to">
                added to cart
                </span>
            </p>
        </div>
    </div>
    <!-- Modal end -->
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
    <script src="./assets/javascript/L_menu.js"></script>
</body>

</html>