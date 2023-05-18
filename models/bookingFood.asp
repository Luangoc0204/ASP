<%
    Class BookingFood
        'Private, class member variable
        Private p_idBookingFood
        Private p_idBookingTable
        Private p_idFood
        Private p_amountBF
        Private p_priceBF
        ' getter and setter

        'idBookingFood
        Public Property Get idBookingFood()
            idBookingFood = p_idBookingFood
        End Property
        Public Property Let idBookingFood(value)
            p_idBookingFood = value
        End Property
        'idBookingTable
        Public Property Get idBookingTable()
            idBookingTable = p_idBookingTable
        End Property
        Public Property Let idBookingTable(value)
            p_idBookingTable = value
        End Property
        'idFood
        Public Property Get idFood()
            idFood = p_idFood
        End Property
        Public Property Let idFood(value)
            p_idFood = value
        End Property
        'amountBF
        Public Property Get amountBF()
            amountBF = p_amountBF
        End Property
        Public Property Let amountBF(value)
            p_amountBF = value
        End Property
        'priceBF
        Public Property Get priceBF()
            priceBF = p_priceBF
        End Property
        Public Property Let priceBF(value)
            p_priceBF = value
        End Property
    
    End Class
%>