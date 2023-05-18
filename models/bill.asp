<%
    Class Bill
        'Private, class member variable
        Private p_idBill
        Private p_idBookingTable
        Private p_idCart
        Private p_dateBill
        Private p_timeBill
        Private p_sumPrice
        Private p_discount
        Private p_discountGiftCode
        ' getter and setter

        'idBill
        Public Property Get idBill()
            idBill = p_idBill
        End Property
        Public Property Let idBill(value)
            p_idBill = value
        End Property
        'idBookingTable
        Public Property Get idBookingTable()
            idBookingTable = p_idBookingTable
        End Property
        Public Property Let idBookingTable(value)
            p_idBookingTable = value
        End Property
        'idCart
        Public Property Get idCart()
            idCart = p_idCart
        End Property
        Public Property Let idCart(value)
            p_idCart = value
        End Property
        'dateBill
        Public Property Get dateBill()
            dateBill = p_dateBill
        End Property
        Public Property Let dateBill(value)
            p_dateBill = value
        End Property
        'timeBill
        Public Property Get timeBill()
            timeBill = p_timeBill
        End Property
        Public Property Let timeBill(value)
            p_timeBill = value
        End Property
        'sumPrice
        Public Property Get sumPrice()
            sumPrice = p_sumPrice
        End Property
        Public Property Let sumPrice(value)
            p_sumPrice = value
        End Property
        'discount
        Public Property Get discount()
            discount = p_discount
        End Property
        Public Property Let discount(value)
            p_discount = value
        End Property
        'discountGiftCode
        Public Property Get discountGiftCode()
            discountGiftCode = p_discountGiftCode
        End Property
        Public Property Let discountGiftCode(value)
            p_discountGiftCode = value
        End Property
    End Class
%>