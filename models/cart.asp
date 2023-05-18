<%
    Class Cart
        'Private, class member variable
        Private p_idCart
        Private p_idUser
        Private p_sumPrice
        ' getter and setter

        'idCart
        Public Property Get idCart()
            idCart = p_idCart
        End Property
        Public Property Let idCart(value)
            p_idCart = value
        End Property
        'idUser
        Public Property Get idUser()
            idUser = p_idUser
        End Property
        Public Property Let idUser(value)
            p_idUser = value
        End Property
        'sumPrice
        Public Property Get sumPrice()
            sumPrice = p_sumPrice
        End Property
        Public Property Let sumPrice(value)
            p_sumPrice = value
        End Property
    
    End Class
%>