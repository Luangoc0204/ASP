<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/bookingFood.asp" -->
<!--#include file="./models/cartFood.asp" -->
<!--#include file="./models/Food.asp" -->
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "") then
        Response.redirect("logout.asp")
    end if
    idFood = Request.QueryString("idFood")
    idBookingTable = Request.QueryString("idBookingTable")
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <link rel="stylesheet" href="./assets/css/L_purchaseCart.css">
    <!-- bootstrap  -->
    <title>PurchaseCart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
</head>

<body>
    <!-- start of header  -->
    <!--#include file="header.asp"-->
    <!-- header ends  -->
    <!-- Menu begin -->
    <!-- ------------------------------------------------------------------------- -->
    <%
        If (isnull(idBookingTable) or trim(idBookingTable) = "") then
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT idCart from Cart where idUser = ? "
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
            set result = cmdPrep.execute
    %>
    <p style="display:none" class="idCart"><%=result("idCart")%></p>
    <%
        Elseif (not isnull(idBookingTable) and trim(idBookingTable) <> "") then
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT * from BookingTable where idBookingTable = ? "
            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
            set result = cmdPrep.execute
            isCheckin = result("isCheckin")
            
    %>
    <p style="display:none" class="idBookingTable"><%=idBookingTable%></p>
    <p style="display:none" class="ischeckin"><%=isCheckin%></p>
    <%
        end if
    %>
    <div class="container-body" style="background-image: url(assets/images/menu-bg.png);">
        <div class="cart-wrap">
            <div class="cart-details">
                <div class="title-cart">
                    <div class="title-cart-left">
                        <h1>My Cart</h1>
                    </div>
                    <%
                        If (not isnull(idBookingTable) and trim(idBookingTable) <> "") then
                            if(Session("role") = "CUSTOMER" and isCheckin = "True") then
                    %>
                        <button disabled type="button" class="btn btn-success add-button" style="padding: 5px 15px; font-size:20px; font-weight: 600"><i class="fa-solid fa-plus" style="font-size: 15px;"></i> Add Food</button>
                    <%
                            else
                    %>
                    <a href="L_menu.asp?idBookingTable=<%=idBookingTable%>">
                        <button type="button" class="btn btn-success add-button" style="padding: 5px 15px; font-size:20px; font-weight: 600"><i class="fa-solid fa-plus" style="font-size: 15px;"></i> Add Food</button>
                    </a>
                    <%
                            end if
                        End if
                    %>
                    <div class="title-cart-right">
                    <%
                        If (isnull(idFood) or trim(idFood) = "") then
                    %>
                        <h3 ><span class="num-item"></span> items</h3>
                    <%
                        end if
                    %>    
                    </div>
                </div>
                <!-- ----------------------------------- -->
                <!-- Ten sp -->
                <div class="list-product">
                    <!--  -->
                    <%
                        'connDB.Open()    
                        set cmdPrep = Server.CreateObject("ADODB.Command")
                        cmdPrep.ActiveConnection = connDB
                        cmdPrep.CommandType = 1
                        cmdPrep.Prepared = True
                        If ( (isnull(idFood) or trim(idFood) = "") and (isnull(idBookingTable) or trim(idBookingTable)="") ) then
                            cmdPrep.CommandText = "SELECT cf.idCartFood, cf.amountCF, cf.datetimeCF, cf.priceCF, Food.* "&_
                            "FROM CartFood cf inner join Food on cf.idFood = Food.idFood "&_
                            "where cf.isPay = 0 and cf.idCart = (select idCart from Cart where idUser = ?) order by cf.datetimeCF desc"
                            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
                        elseif (not isnull(idFood)  and trim(idFood) <>"") then
                            cmdPrep.CommandText = "select * from Food where idFood = ?"
                            cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,CInt(idFood)) 
                        elseif (not isnull(idBookingTable)  and trim(idBookingTable) <>"") then 
                            cmdPrep.CommandText = "select bf.idBookingFood, bf.amountBF, bf.priceBF, Food.*  "&_
                                                    "from BookingFood bf inner join Food on bf.idFood = Food.idFood "&_
                                                    "where bf.idBookingTable = ?"
                            cmdPrep.parameters.Append cmdPrep.createParameter("idFood",3,1, ,CInt(idBookingTable)) 
                        end if       
                        set result = cmdPrep.execute
                        if result.EOF then
                    %>
                    <p style="margin-top: 20px;">Your cart is empty!</p>
                    <%
                        else
                            'đặt Object
                            Set listCartFood = Server.CreateObject("Scripting.Dictionary")
                            Set listBookingFood = Server.CreateObject("Scripting.Dictionary")
                            Set listFood = Server.CreateObject("Scripting.Dictionary")
                            count = 0
                            'nếu là cartFood
                            If ( (isnull(idFood) or trim(idFood) = "") and (isnull(idBookingTable) or trim(idBookingTable) = "") )  then
                                do while not result.EOF
                                    set cartFoodTemp = new CartFood
                                    cartFoodTemp.idCartFood = result("idCartFood")
                                    cartFoodTemp.idFood = result("idFood")
                                    cartFoodTemp.amountCF = result("amountCF")
                                    cartFoodTemp.datetimeCF = result("datetimeCF")
                                    cartFoodTemp.priceCF = result("priceCF")

                                    listCartFood.add count, cartFoodTemp

                                    set foodTemp = new Food
                                    foodTemp.idFood = result("idFood")
                                    foodTemp.nameFood = result("nameFood")
                                    foodTemp.priceFood = result("priceFood")
                                    foodTemp.typeFood = result("typeFood")
                                    foodTemp.forPerson = result("forPerson")
                                    foodTemp.amountFood = result("amountFood")
                                    foodTemp.imgFood = result("imgFood")

                                    listFood.add count, foodTemp
                                    'sau khi thêm vào dictionary thì tăng index
                                    count = count + 1
                                result.MoveNext
                                LOOP    
                                For i = 0 To (count-1)    
                    %>
                    <div class="content-cart" >
                        <p style="display:none" class="idCartFood"><%=listCartFood(i).idCartFood%></p>
                        <p style="display:none" class="idFood"><%=listCartFood(i).idFood%></p>
                        <div class="content-cart-left">
                            <div class="cart-img-name">
                                <img class="img-product"
                                    src="upload\menu\<%=listFood(i).imgFood%>"
                                    alt="Image Food">
                                <span class="name-food"><%=listFood(i).nameFood%></span>
                            </div>
                            <div class="content-cart-center-1">
                                <div class="add-sub-amount">
                                    <button class="sub-amount">
                                        <img src="./assets/images/icon_minimize_fill.png" alt="">
                                    </button>

                                    <input class="amount-product-cart" type="number" value="<%=listCartFood(i).amountCF%>" min="1" oninput="validity.valid||(value='');" required onblur="if(this.value==''){this.value=1;}" title="Amount >= 1">

                                    <button class="plus-amount">
                                        <img src="./assets/images/icon_add_fill_mainColor.png" alt="">
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Tang giam so luong -->


                        <div class="content-cart-right">
                            <!-- Gia tien -->
                            <div class="content-cart-center-2">
                                <span class="price-index-product" style="display: none;"><%=listCartFood(i).priceCF%></span>
                                <h3>
                                    <span class="sumPrice-index-product"></span>
                                    <span>$</span>
                                </h3>
                            </div>
                            <!-- Xoa san pham -->
                            <button data-href="L_removeFoodFromCart.asp?idCartFood=<%=listCartFood(i).idCartFood%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="remove">
                                <img src="./assets/images/icon_delete_2_line_color.png" alt="">
                            </button>
                        </div>
                        <%
                            Dim formattedDate
                            formattedDate = FormatDateTime(CDate(listCartFood(i).datetimeCF), vbShortDate) & " " & FormatDateTime(CDate(listCartFood(i).datetimeCF), vbShortTime)
                        %>
                        <p class="time-added">
                            <span>
                                Added in <span><%=formattedDate%></span>
                            </span>
                            <span style="margin-left: 15px; color:red; font-size:14px" class="sold-out-text"></span>
                            <span style="margin-left: 15px; font-size:14px" class="remaining-text"></span>
                        </p>
                    </div>
                    <%
                                Next
                    %>
                    <!-- ----------------------------------- -->
                    <%
                            'nếu có idFood (Buy Now)
                            elseif (not isnull(idFood)  and trim(idFood) <>"") then
                                do while not result.EOF
                                    set foodTemp = new Food
                                    foodTemp.idFood = result("idFood")
                                    foodTemp.nameFood = result("nameFood")
                                    foodTemp.priceFood = result("priceFood")
                                    foodTemp.typeFood = result("typeFood")
                                    foodTemp.forPerson = result("forPerson")
                                    foodTemp.amountFood = result("amountFood")
                                    foodTemp.imgFood = result("imgFood")

                                    listFood.add count, foodTemp
                                    count = count + 1
                                    result.MoveNext
                                LOOP    
                                For i = 0 To (count-1)  
                    %>
                    <div class="content-cart" >
                        <p style="display:none" class="idCartFood">0</p>
                        <p style="display:none" class="idFood"><%=listFood(i).idFood%></p>
                        <div class="content-cart-left">
                            <div class="cart-img-name">
                                <img class="img-product"
                                    src="upload\menu\<%=listFood(i).imgFood%>"
                                    alt="Image Food">
                                <span class="name-food"><%=listFood(i).nameFood%></span>
                            </div>
                            <div class="content-cart-center-1">
                                <div class="add-sub-amount">
                                    <button class="sub-amount">
                                        <img src="./assets/images/icon_minimize_fill.png" alt="">
                                    </button>

                                    <input class="amount-product-cart" type="number" value="1" min="1" oninput="validity.valid||(value='');" required onblur="if(this.value==''){this.value=1;}" title="Amount >= 1">

                                    <button class="plus-amount">
                                        <img src="./assets/images/icon_add_fill_mainColor.png" alt="">
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Tang giam so luong -->


                        <div class="content-cart-right">
                            <!-- Gia tien -->
                            <div class="content-cart-center-2">
                                <span class="price-index-product" style="display: none;"><%=listFood(i).priceFood%></span>
                                <h3>
                                    <span class="sumPrice-index-product"><%=listFood(i).priceFood%></span>
                                    <span>$</span>
                                </h3>
                            </div>
                        </div>
                        <p class="time-added">
                            <span style="margin-left: 15px; color:red; font-size:14px" class="sold-out-text"></span>
                            <span style="margin-left: 15px; font-size:14px" class="remaining-text"></span>
                        </p>
                    </div>
                    <%
                                Next
                    %>
                    <%  
                            'nếu là xem danh sách BookingFood
                            elseif (not isnull(idBookingTable)  and trim(idBookingTable) <>"") then
                                do while not result.EOF
                                    set bookingFoodTemp = new BookingFood
                                    bookingFoodTemp.idBookingFood = result("idBookingFood")
                                    bookingFoodTemp.idFood = result("idFood")
                                    bookingFoodTemp.amountBF = result("amountBF")
                                    bookingFoodTemp.priceBF = result("priceBF")

                                    listBookingFood.add count, bookingFoodTemp

                                    set foodTemp = new Food
                                    foodTemp.idFood = result("idFood")
                                    foodTemp.nameFood = result("nameFood")
                                    foodTemp.priceFood = result("priceFood")
                                    foodTemp.typeFood = result("typeFood")
                                    foodTemp.forPerson = result("forPerson")
                                    foodTemp.amountFood = result("amountFood")
                                    foodTemp.imgFood = result("imgFood")

                                    listFood.add count, foodTemp
                                    'sau khi thêm vào dictionary thì tăng index
                                    count = count + 1
                                    result.MoveNext
                                LOOP    
                                For i = 0 To (count-1)  
                    %>
                    <div class="content-cart" >
                        <p style="display:none" class="idBookingFood"><%=listBookingFood(i).idBookingFood%></p>
                        <p style="display:none" class="idFood"><%=listBookingFood(i).idFood%></p>
                        <div class="content-cart-left">
                            <div class="cart-img-name">
                                <img class="img-product"
                                    src="upload\menu\<%=listFood(i).imgFood%>"
                                    alt="Image Food">
                                <span class="name-food"><%=listFood(i).nameFood%></span>
                            </div>
                            <div class="content-cart-center-1">
                                <div class="add-sub-amount">
                                <%
                                    if(Session("role") = "CUSTOMER" and isCheckin = "True") then
                                %>
                                    <button disabled class="sub-amount disable-btn-input">
                                        <img src="./assets/images/icon_minimize_fill.png" alt="" >
                                    </button>

                                    <input readonly class="amount-product-cart disable-btn-input" type="number" value="<%=listBookingFood(i).amountBF%>" min="1" oninput="validity.valid||(value='');" required onblur="if(this.value==''){this.value=1;}" title="Amount >= 1">

                                    <button disabled class="plus-amount disable-btn-input">
                                        <img src="./assets/images/icon_add_fill_mainColor.png" alt="">
                                    </button>
                                <%
                                    else
                                %>
                                    <button class="sub-amount">
                                        <img src="./assets/images/icon_minimize_fill.png" alt="">
                                    </button>

                                    <input class="amount-product-cart" type="number" value="<%=listBookingFood(i).amountBF%>" min="1" oninput="validity.valid||(value='');" required onblur="if(this.value==''){this.value=1;}" title="Amount >= 1">

                                    <button class="plus-amount">
                                        <img src="./assets/images/icon_add_fill_mainColor.png" alt="">
                                    </button>
                                <%
                                    end if
                                %>    
                                </div>
                            </div>
                        </div>
                        <!-- Tang giam so luong -->


                        <div class="content-cart-right">
                            <!-- Gia tien -->
                            <div class="content-cart-center-2">
                                <span class="price-index-product" style="display: none;"><%=listBookingFood(i).priceBF%></span>
                                <h3>
                                    <span class="sumPrice-index-product"></span>
                                    <span>$</span>
                                </h3>
                            </div>
                            <!-- Xoa san pham -->
                            <%
                                if(Session("role") = "CUSTOMER" and isCheckin = "True") then
                            %>

                            <%
                                else
                            %>
                            <button data-href="L_removeFoodFromBookingFood.asp?idBookingFood=<%=listBookingFood(i).idBookingFood%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="remove">
                                <img src="./assets/images/icon_delete_2_line_color.png" alt="">
                            </button>
                            <%
                                end if
                            %>
                        </div>
                        
                        <p class="time-added">
                            
                            <span style="margin-left: 15px; color:red; font-size:14px" class="sold-out-text"></span>
                            <span style="margin-left: 15px; font-size:14px" class="remaining-text"></span>
                        </p>
                    </div>
                    <%
                                Next
                    %>
                    <%
                            end if
                            
                        end if    
                    %> 
                </div>

            </div>
            <div class="pay-fees">
                <div class="title-pay">
                    <h1>Summary</h1>
                </div>
                <div class="details-pay">
                    <div class="amount-product">
                        <h4>
                            <span class="sumAmount"></span>
                            items
                        </h4>

                    </div>
                    <div class="price-product">
                        <h4 ><span class="sumMoney"></span> $</h4>

                    </div>
                </div>
                <div class="details-discount">
                    <div class="details-discount-header">
                        <h4 style="width: 130px; text-align: left;">Discount:</h4>
                    </div>
                    <div class="details-discount-body">
                        <div class="percent-discount">
                            <h4>
                                <%
                                    if (isnull(idBookingTable)  or trim(idBookingTable) ="") then
                                        set cmdPrep = Server.CreateObject("ADODB.Command")
                                        cmdPrep.ActiveConnection = connDB
                                        cmdPrep.CommandType = 1
                                        cmdPrep.Prepared = True
                                        cmdPrep.CommandText = "SELECT * FROM Customer where idUser = ?" 
                                        cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Session("idUser")))
                                        set result = cmdPrep.execute
                                    else 
                                        set cmdPrep = Server.CreateObject("ADODB.Command")
                                        cmdPrep.ActiveConnection = connDB
                                        cmdPrep.CommandType = 1
                                        cmdPrep.Prepared = True
                                        cmdPrep.CommandText = "SELECT discount FROM Customer where idUser = (select idUser from BookingTable where idBookingTable = ?) "
                                        cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(idBookingTable))
                                        set result = cmdPrep.execute
                                    end if    
                                %>
                                <span data-discount="<%=result("discount")%>" class="discount-user" style="margin-left: 30px;"><%=result("discount")%></span>
                                <span>%</span>
                            </h4>
                        </div>
                        <div class="price-discount">
                            <h4 style="margin-right: 20px;">
                                <span>-</span>
                                <span class="discount-user-money"></span>
                                <span>$</span>
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="details-giftcode">
                    <div class="details-giftcode-header">
                        <h4 style="width: 130px; text-align: left;">Gift code:</h4>
                        <div class="details-discount-body">
                            
                            <div class="percent-discount">
                                <h4>
                                    <span data-discountGiftCode="0" class="discount-giftCode" style="margin-left: 35px;">0</span>
                                    <span>%</span>
                                </h4>
                            </div>
                            <div class="price-discount">
                                <h4 style="margin-right: 20px;">
                                    <span>-</span>
                                    <span class="discount-giftCode-money"></span>
                                    <span>$</span>
                                </h4>
                            </div>
                            
                        </div>
                    </div>
                    <div class="details-giftcode-body">
                    <%
                        if(Session("role") = "CUSTOMER" and isCheckin = "True") then
                    %>
                        <input readonly class="input-giftcode" type="text">
                    <%
                        else
                    %>    
                        <input class="input-giftcode" type="text">
                    <%
                        end if
                    %>    
                    </div>
                    <div class="details-giftcode-footer">
                        <h6 class="giftcode-text-notification">Enter your code</h6>
                    </div>
                </div>
                <div class="purchase-product">
                    <div class="price-closing">
                        <div class="price-closing-left">
                            <h3>TOTAL PRICE</h3>
                        </div>
                        <div class="price-closing-right">
                            <h3 style="color: red;font-size: 40px;">
                                <span class="total-price" >0</span>
                                <span>$</span>
                            </h3>
                        </div>
                    </div>
                    <div class="btn-purchase">
                    <%
                        if (not isnull(idBookingTable)  and trim(idBookingTable) <>"") then
                            set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT * FROM Bill where idBookingTable = ? "
                            cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
                            set result = cmdPrep.execute
                            if not result.EOF then
                            'nếu tồn tại Bill
                                if(Session("role") = "CUSTOMER") then
                    %>
                        <button disabled class="disable-btn-input">
                            <h2>Purchase</h2>
                        </button>
                    <%
                                else
                    %>
                        <button id="button-purchase" data-id-bill =<%=result("idBill")%>>
                            <h2>Update</h2>
                        </button>
                    <%
                                end if
                            else
                            'nếu ko tồn tại Bill
                                if(Session("role") = "CUSTOMER" and isCheckin = "True") then
                                'nếu BookingTable đã checkin thì customer không thể tự purchase
                    %>    
                        <button disabled id="button-purchase" class="disable-btn-input">
                            <h2>Purchase</h2>
                        </button>
                    <%
                                else
                    %>    
                        <button id="button-purchase">
                            <h2>Purchase</h2>
                        </button>
                    <%
                                end if
                            end if
                        else    
                        'nếu không có idBookingTable -> purchase cart
                    %>
                        <button id="button-purchase">
                            <h2>Purchase</h2>
                        </button>
                    <%
                        end if
                    %>    
                    </div>
                </div>

            </div>
        </div>
        <!-- MODAL delete-->
        <div class="modal" tabindex="-1" id="confirm-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Purchase Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to remove sushi from the cart?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="L_purchaseCart.asp" type="button" class="btn btn-secondary">Close</a>
                            <a class="btn btn-danger btn-delete">Remove</a>
                        </div>
                    </div>
                </div>
        </div>
        <!-- MODAL purchase-->
        <div class="modal" tabindex="-1" id="confirm-purchase">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Purchase Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body purchase-modal-body">
                            <p>The <span><b class="nameFood-soldOut-last">sushi</b></span> is <span style="color:red">sold out</span> now.</p>
                            <span class="notice-delete-text" style="display: none">If you continue to purchase, the food is out of stock will be deleted!</span>
                            <p>Do you want to continue purchase?</p>
                        </div>
                        <p style="margin-left:16px">This dialog will be close in <span class="countdown" style="color:red">3</span>s</p>
                        <div class="modal-footer">
                            <a href="L_purchaseCart.asp" type="button" class="btn btn-secondary btn-close-purchase">Close</a>
                            <a class="btn btn-danger btn-delete btn-continue-purchase">Continue</a>
                        </div>
                    </div>
                </div>
        </div>
        <script>
                $(function()
                {
                    $('#confirm-delete').on('show.bs.modal', function(e){
                        $(this).find('.btn-delete').attr('href', $(e.relatedTarget).data('href'));
                    });
                });
        </script>
        <!-- Loading -->
        <div id="loading">
            <div class="ic-Spin-cycle--classic">
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0" y="0" viewBox="156 -189 512 512" enable-background="new 156 -189 512 512" xml:space="preserve">
                    <path d="M636 99h-64c-17.7 0-32-14.3-32-32s14.3-32 32-32h64c17.7 0 32 14.3 32 32S653.7 99 636 99z"/>
                    <path d="M547.8-23.5C535.2-11 515-11 502.5-23.5s-12.5-32.8 0-45.2l45.2-45.2c12.5-12.5 32.8-12.5 45.2 0s12.5 32.8 0 45.2L547.8-23.5z"/>
                    <path d="M412-61c-17.7 0-32-14.3-32-32v-64c0-17.7 14.3-32 32-32s32 14.3 32 32v64C444-75.3 429.7-61 412-61z"/>
                    <path d="M276.2-23.5L231-68.8c-12.5-12.5-12.5-32.8 0-45.2s32.8-12.5 45.2 0l45.2 45.2c12.5 12.5 12.5 32.8 0 45.2S288.8-11 276.2-23.5z"/>
                    <path d="M284 67c0 17.7-14.3 32-32 32h-64c-17.7 0-32-14.3-32-32s14.3-32 32-32h64C269.7 35 284 49.3 284 67z"/>
                    <path d="M276.2 248c-12.5 12.5-32.8 12.5-45.2 0 -12.5-12.5-12.5-32.8 0-45.2l45.2-45.2c12.5-12.5 32.8-12.5 45.2 0s12.5 32.8 0 45.2L276.2 248z"/>
                    <path d="M412 323c-17.7 0-32-14.3-32-32v-64c0-17.7 14.3-32 32-32s32 14.3 32 32v64C444 308.7 429.7 323 412 323z"/>
                    <path d="M547.8 157.5l45.2 45.2c12.5 12.5 12.5 32.8 0 45.2 -12.5 12.5-32.8 12.5-45.2 0l-45.2-45.2c-12.5-12.5-12.5-32.8 0-45.2S535.2 145 547.8 157.5z"/>
                </svg>
            </div>
        </div>
        
        
    </div>
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
    <script src="./assets/javascript/L_purchaseCart.js"></script>
</body>

</html>