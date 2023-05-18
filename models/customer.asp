<%
    Class Customer
        'Private, class member variable
        Private p_idCustomer
        Private p_idUser
        Private p_amountBooking
        Private p_discount
        ' getter and setter

        'idEmployee
        Public Property Get idCustomer()
            idCustomer = p_idCustomer
        End Property
        Public Property Let idCustomer(value)
            p_idCustomer = value
        End Property
        'idUser
        Public Property Get idUser()
            idUser = p_idUser
        End Property
        Public Property Let idUser(value)
            p_idUser = value
        End Property
        'salary
        Public Property Get amountBooking()
            amountBooking = p_amountBooking
        End Property
        Public Property Let amountBooking(value)
            p_amountBooking = value
        End Property
        'position
        Public Property Get discount()
            discount = p_discount
        End Property
        Public Property Let discount(value)
            p_discount = value
        End Property
    
    End Class
%>