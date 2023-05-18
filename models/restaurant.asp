<%
    Class Restaurant
        'Private, class member variable
        Private p_idRestaurant
        Private p_nameRestaurant
        Private p_timeOpen
        Private p_timeClose
        Private p_revenue
        ' getter and setter

        'idRestaurant
        Public Property Get idRestaurant()
            idRestaurant = p_idRestaurant
        End Property
        Public Property Let idRestaurant(value)
            p_idRestaurant = value
        End Property
        'nameRestaurant
        Public Property Get nameRestaurant()
            nameRestaurant = p_nameRestaurant
        End Property
        Public Property Let nameRestaurant(value)
            p_nameRestaurant = value
        End Property
        'timeOpen
        Public Property Get timeOpen()
            timeOpen = p_timeOpen
        End Property
        Public Property Let timeOpen(value)
            p_timeOpen = value
        End Property
        'timeClose
        Public Property Get timeClose()
            timeClose = p_timeClose
        End Property
        Public Property Let timeClose(value)
            p_timeClose = value
        End Property
        'timeClose
        Public Property Get revenue()
            revenue = p_revenue
        End Property
        Public Property Let revenue(value)
            p_revenue = value
        End Property
    End Class
%>