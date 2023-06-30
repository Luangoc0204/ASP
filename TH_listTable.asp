<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!--#include file="./models/user.asp" -->
<!--#include file="./models/customer.asp" -->
<!--#include file="./models/bookingTable.asp" -->
<!--#include file="./models/bookingFood.asp" -->
<!--#include file="./models/table.asp" -->
<!--#include file="./models/food.asp" -->
<!--#include file="./models/bill.asp" -->
<%
    'connDB Close
    If (isnull(Session("idUser")) OR TRIM(Session("idUser")) ="" OR (Session("role")="CUSTOMER")) Then
        Response.redirect("logout.asp")
    End If
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
    <link rel="stylesheet" href="./assets/css/TH_listTable.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome/css/all.css">
    <title>ListTable</title>
</head>

<body>
    <!-- start of header  -->
    <!-- #include file="header.asp" -->
    <!-- header ends  -->
    <!-- Menu begin -->
    <section style="background-image: url(assets/images/menu-bg.png); overflow-x: hidden;" class="our-menu section bg-light repeat-img"
        id="menu">
        <div class="sec-wp">
            <div class="container" style="max-width: 100vw !important;">
                <div class="menu-tab-wp">
                    <div class="row">
                        <div class="col-lg-12 m-auto">
                            <div class="menu-tab text-center">
                                <!-- Main  -->
                                <ul class="filters" style="position: absolute; left: 50%; transform: translateX(-50%);">
                                    <div class="filter-active"></div>
                                    <li class="filter" data-filter=".all, .employee, .chef">
                                        <img style="width: 60px; height: 40px;" src="assets/images/dinnerTable.png" alt="">
                                        List Table
                                    </li>
                                </ul>
                                <!-- Add Human -->
                                <%
                                    if (Session("role") = "ADMIN") then
                                %>
                                <a href="TH_AddTable.asp">
                                    <ul class="filters add-human" style="padding: 10px 20px;">
                                        <i class="fa-solid fa-circle-plus" style="color: #ff8243; font-weight: 900;font-size: 44px;padding-right: 5px;"></i>
                                        Add table
                                        </li>
                                    </ul>
                                </a>
                                <%
                                    end if
                                %>
                                <!--  -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="menu-list-row">
                    <div class="row g-xxl-5 bydefault_show width4" id="menu-dish">
                        <!-- 1 -->
                        <%
                            set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT [Table].* FROM [Table] where isActive = 1"
                            set result = cmdPrep.execute
                            Set listTable = Server.CreateObject("Scripting.Dictionary")
                            count = 0
                            do while not result.EOF
                                set tableTemp = new Table
                                tableTemp.idTable = result("idTable")
                                tableTemp.typeTable = result("typeTable")
                                tableTemp.amountTable = result("amountTable")
                                tableTemp.isActive = result("isActive")
                                tableTemp.imgTable = result("imgTable")
                                
                                listTable.add count, tableTemp
                            count = count + 1
                            result.MoveNext
                            LOOP
                            For i = 0 To (count-1)      

                        %>
                        <div class="col-lg-4 col-sm-6 dish-box-wp chef width25">
                            <div class="dish-box text-center">
                                <div class="dist-img">
                                    <img src="upload\table\<%=listTable(i).imgTable%>" alt="">
                                </div>
                                <div class="human-list">
                                        <table class="human-info">
                                            <tr>
                                                <th>Type:</th>
                                                <td><%=listTable(i).typeTable%> People</td>
                                            </tr>
                                            <tr>                                                      
                                                <th>Amount:</th>
                                                <td><%=listTable(i).amountTable%></td>
                                            </tr>
                                        </table>
                                </div>
                                <%
                                    if (Session("role") = "ADMIN") then
                                %>
                                <div class="dist-bottom-row">
                                    <ul>
                                        <li >
                                            <a href="TH_AddTable.asp?idTable=<%=listTable(i).idTable%>">
                                                <button class="dish-add-btn btn-buy-now">
                                                    <i class="fa-regular fa-pen-to-square fa-lg" style="color: #fff;"></i>
                                                    <span>Edit</span>
                                                </button>
                                            </a>
                                        </li>
                                        <li>
                                            <button data-href="L_deleteTable.asp?idTable=<%=listTable(i).idTable%>" data-bs-toggle="modal" data-bs-target="#confirm-delete" class="dish-add-btn btn-add-to-cart">
                                                <i class="fa-solid fa-user-minus fa-lg" style="color: #fff;"></i>
                                                <span style="padding-left: 5px;">Delete</span>
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                                <%
                                    end if
                                %>
                            </div>
                        </div>
                        <%
                            next
                        %>
                        <!--  -->
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
                            <h5 class="modal-title">Delete Table Confirmation</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete table?</p>
                        </div>
                        <div class="modal-footer">
                            <a href="TH_listTable.asp" type="button" class="btn btn-secondary">Close</a>
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
    <script src="./main.js"></script>
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