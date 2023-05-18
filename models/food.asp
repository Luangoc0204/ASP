<%
    Class Food
        'Private, class member variable
        Private p_idFood
        Private p_nameFood
        Private p_priceFood
        Private p_typeFood
        Private p_forPerson
        Private p_amountFood
        Private p_imgFood
        Private p_isActive
        ' getter and setter

        'idFood
        Public Property Get idFood()
            idFood = p_idFood
        End Property
        Public Property Let idFood(value)
            p_idFood = value
        End Property
        'nameFood
        Public Property Get nameFood()
            nameFood = p_nameFood
        End Property
        Public Property Let nameFood(value)
            p_nameFood = value
        End Property
        'priceFood
        Public Property Get priceFood()
            priceFood = p_priceFood
        End Property
        Public Property Let priceFood(value)
            p_priceFood = value
        End Property
        'typeFood
        Public Property Get typeFood()
            typeFood = p_typeFood
        End Property
        Public Property Let typeFood(value)
            p_typeFood = value
        End Property
        'forPerson
        Public Property Get forPerson()
            forPerson = p_forPerson
        End Property
        Public Property Let forPerson(value)
            p_forPerson = value
        End Property
        'amountFood
        Public Property Get amountFood()
            amountFood = p_amountFood
        End Property
        Public Property Let amountFood(value)
            p_amountFood = value
        End Property
        'imgFood
        Public Property Get imgFood()
            imgFood = p_imgFood
        End Property
        Public Property Let imgFood(value)
            p_imgFood = value
        End Property
        'imgFood
        Public Property Get isActive()
            isActive = p_isActive
        End Property
        Public Property Let isActive(value)
            p_isActive = value
        End Property
    End Class
%>