<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<%
    If (isnull(Session("idUser")) or trim(Session("idUser")) = "") then
        Response.redirect("logout.asp")
    end if
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/T_BillUser.css">
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <title>Document</title>
</head>
<body>
    <!-- start of header  -->
    <!--#include file="header.asp"-->
    <!-- header ends  -->
    
    <!-- Phan Bill -->
    <div class="div_bill">
        <div id="hoa_don">
            <div class="chi_tiet_hoa_don">
            <div class="nha_hang">
                <img src="./assets/images/logo.png" alt="Logo" style="width: 210px;">
            </div>
            <h6 class="dia_chi" >55 Giải Phóng , Hai Bà Trưng , Hà Nội</h6>
            <div></div>
        </div>
        <h5 class="hoa_don_tt">Bill</h5>
        <%
            set cmdPrep = Server.CreateObject("ADODB.Command")
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.Prepared = True
            cmdPrep.CommandText = "SELECT * from Bill where idBill = ? "
            cmdPrep.parameters.Append cmdPrep.createParameter("idUser",3,1, ,CInt(Request.QueryString("idBill")))
            set result = cmdPrep.execute
            %>
        <div class="hoa_don_thanh_toan">
            <div style="display: inline-flex">
                <span>Code:</span> <span style="margin-left: 5px"><%=result("idBill")%></span>
            </div>
            <div></div>
            <div></div>
            <div class="ngay_in" style="display: inline-flex">
                <span>Date: </span>  <span style="margin-left: 5px"><%=result("dateBill")%></span>
                <span class="gio_in"> Time:</span> <span class="timeBill" style="margin-left: 5px"><%=result("timeBill")%></span>
            </div>
            <div></div>
            <%
                Dim idBookingTable, idCart
                idBookingTable = 0
                idCart = 0
                if (isnull(result("idCart")) or trim(result("idCart"))= "") then
                    idBookingTable = result("idBookingTable")
                else  
                    idCart = result("idCart")
                end if
                dateBill = result("dateBill")
                timeBill = result("timeBill")
                discount_user = result("discount")
                discount_giftcode = result("discountGiftCode")    
                totalPrice = result("sumPrice")
                set cmdPrep = Server.CreateObject("ADODB.Command")
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                if (idCart = 0) then
                    cmdPrep.CommandText = "SELECT * from [User] where idUser = (select idUser from BookingTable where idBookingTable = ?) "
                    cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
                else 
                    cmdPrep.CommandText = "SELECT * from [User] where idUser = (select idUser from Cart where idCart = ?) "
                    cmdPrep.parameters.Append cmdPrep.createParameter("idCart",3,1, ,CInt(idCart))
                end if
                set result = cmdPrep.execute
            %>
            <p style="display:none" class="idCart"><%=dateBill + TypeName(dateBill)%></p>
            <p style="display:none" class="idCart"><%=timeBill + TypeName(timeBill)%></p>

            <div class="tt_khach_hang" style="display: inline-flex">
                <span> Customer: </span> <span style="margin-left: 5px"><%=result("nameUser")%></span>
                <span class="sdt_khach_hang">Phone:</span> <span style="margin-left: 5px"><%=result("phone")%></span>
            </div>
        </div>
        <div class="table_list">
            <table class="table list_banAn border-dark">
                <thead>
                <tr>
                    <th scope="col" style="width:50px">No</th>
                    <th scope="col" style="width:100px">Type</th>
                    <th scope="col" class="col_monan">Food</th>
                    <th scope="col" style="width:100px">Price</th>
                    <th scope="col" style="width:100px">Amount</th>
                    <th scope="col" style="width:100px">Total</th>
                </tr>
                </thead>
                <tbody>
                <%
                    set cmdPrep = Server.CreateObject("ADODB.Command")
                    cmdPrep.ActiveConnection = connDB
                    cmdPrep.CommandType = 1
                    cmdPrep.Prepared = True
                    if (idCart = 0) then
                    cmdPrep.CommandText = "SELECT BookingFood.*, Food.nameFood,  Food.typeFood FROM BookingFood inner join Food on BookingFood.idFood = Food.idFood where idBookingTable = ?"
                    cmdPrep.parameters.Append cmdPrep.createParameter("idBookingTable",3,1, ,CInt(idBookingTable))
                    else 
                    cmdPrep.CommandText = "SELECT CartFood.*, Food.nameFood,  Food.typeFood FROM CartFood inner join Food on CartFood.idFood = Food.idFood where CONVERT(varchar(8), datetimeCF, 108) = CONVERT(varchar(8), ?, 108) and cast(datetimeCF as date) = ? and idCart = ?"
                    cmdPrep.parameters.Append cmdPrep.createParameter("time",202,1,255 ,timeBill)
                    cmdPrep.parameters.Append cmdPrep.createParameter("date",202,1,255,dateBill)
                    cmdPrep.parameters.Append cmdPrep.createParameter("idCart",3,1, ,CInt(idCart))
                    end if
                    set result = cmdPrep.execute
                    i = 1
                    do while not result.EOF
                %>
                <tr>
                    <td style="width:50px"><%=i%></td>
                    <td width:100px><%=result("typeFood")%></td>
                    <td><%=result("nameFood")%></td>
                    <%
                        if (idBookingTable = 0) then
                    %>
                    <td style="width:100px"><%=result("priceCF")%><span>$</span></td>
                    <td style="width:100px"><%=result("amountCF")%></td>
                    <td style="width:100px">
                        <span class="index-sumPrice"><%=CDbl(result("priceCF") * result("amountCF"))%></span>
                        <span>$</span>
                    </td>
                    <%
                        else
                    %>
                    <td style="width:100px"><%=result("priceBF")%><span>$</span></td>
                    <td style="width:100px"><%=result("amountBF")%></td>
                    <td style="width:100px">
                        <span class="index-sumPrice"><%=CDbl(result("priceBF") * result("amountBF"))%></span>
                        <span>$</span>
                    </td>
                    <%
                        end if
                    %>
                </tr>
                <%
                    i = i +1
                    result.MoveNext
                    loop
                    connDB.Close
                %> 
                <!-- Phần tổng tiền -->
                <tr>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0">Total:</td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0"> </td>
                    <td class="border-bottom-0">
                        <span class="totalPrice"></span>
                        <span>$</span>
                    </td>
                </tr>
                <tr>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0" colspan="2">Discount user:</td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0">
                        <span class="discountUser"><%=discount_user%></span>
                        <span>%</span>
                    </td>
                    <td class="border-bottom-0"> 
                        <span class="money-discountUser"></span>
                        <span>$</span>
                    </td>
                </tr>
                <tr>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0" colspan="2">Discount giftcode:</td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0">
                        <span class="discountGiftcode"><%=discount_giftcode%> </span>
                        <span>%</span>
                    </td>
                    <td class="border-bottom-0">
                        <span class="money-discountGiftcode"></span>
                        <span>$</span>
                    </td>
                </tr>
                <tr>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0">Payment:</td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0"></td>
                    <td class="border-bottom-0" style="color: red"> 
                        <span><%=totalPrice%></span> 
                        <span>$</span> 
                    </td>
                </tr>
            </tbody>
            </table>
            <div class="gach_duoi" style="top: 10px;"></div>
            <div class="phan_cuoi">
                <div></div>
                <h6>Please evaluate 10 points if you feel satisfied!</h6>
            </div>
        </div>
    </div>
    
    <!-- header ends  -->
    <!-- jquery  -->
    <script src="assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="assets/javascript/popper.min.js"></script>
    <script src="assets/javascript/bootstrap.min.js"></script>
    
    <!-- header js -->
    <script src="./assets/javascript/L_header.js"></script>
    <script src="./assets/javascript/L_BillUser.js"></script>

</body>
</html>