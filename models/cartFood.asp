<%
    Class CartFood
        'Private, class member variable
        Private p_idCartFood
        Private p_idCart
        Private p_idFood
        Private p_amountCF
        Private p_datetimeCF
        Private p_priceCF
        Private p_isPay
        ' getter and setter

        'idCartFood
        Public Property Get idCartFood()
            idCartFood = p_idCartFood
        End Property
        Public Property Let idCartFood(value)
            p_idCartFood = value
        End Property
        'idCart
        Public Property Get idCart()
            idCart = p_idCart
        End Property
        Public Property Let idCart(value)
            p_idCart = value
        End Property
        'idFood
        Public Property Get idFood()
            idFood = p_idFood
        End Property
        Public Property Let idFood(value)
            p_idFood = value
        End Property
        'amountCF
        Public Property Get amountCF()
            amountCF = p_amountCF
        End Property
        Public Property Let amountCF(value)
            p_amountCF = value
        End Property
        'datetimeCF
        Public Property Get datetimeCF()
            datetimeCF = p_datetimeCF
        End Property
        Public Property Let datetimeCF(value)
            p_datetimeCF = value
        End Property
        'priceCF
        Public Property Get priceCF()
            priceCF = p_priceCF
        End Property
        Public Property Let priceCF(value)
            p_priceCF = value
        End Property
        'isPay
        Public Property Get isPay()
            isPay = p_isPay
        End Property
        Public Property Let isPay(value)
            p_isPay = value
        End Property
    End Class
%>