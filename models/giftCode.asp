<%
    Class GiftCode
        'Private, class member variable
        Private p_idGiftCode
        Private p_nameGiftCode
        Private p_discountGiftCode
        Private p_isActive
        ' getter and setter

        'idGiftCode
        Public Property Get idGiftCode()
            idGiftCode = p_idGiftCode
        End Property
        Public Property Let idGiftCode(value)
            p_idGiftCode = value
        End Property
        'nameGiftCode
        Public Property Get nameGiftCode()
            nameGiftCode = p_nameGiftCode
        End Property
        Public Property Let nameGiftCode(value)
            p_nameGiftCode = value
        End Property
        'discountGiftCode
        Public Property Get discountGiftCode()
            discountGiftCode = p_discountGiftCode
        End Property
        Public Property Let discountGiftCode(value)
            p_discountGiftCode = value
        End Property
        'isActive
        Public Property Get isActive()
            isActive = p_isActive
        End Property
        Public Property Let isActive(value)
            p_isActive = value
        End Property
    
    End Class
%>