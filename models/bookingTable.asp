<%
    Class BookingTable
        'Private, class member variable
        Private p_idBookingTable
        Private p_idUser
        Private p_idTable
        Private p_amountBT
        Private p_dateBT
        Private p_timeBT
        Private p_noteBT
        Private p_isCheckin
        ' getter and setter

        'idBookingTable
        Public Property Get idBookingTable()
            idBookingTable = p_idBookingTable
        End Property
        Public Property Let idBookingTable(value)
            p_idBookingTable = value
        End Property
        'idUser
        Public Property Get idUser()
            idUser = p_idUser
        End Property
        Public Property Let idUser(value)
            p_idUser = value
        End Property
        'idTable
        Public Property Get idTable()
            idTable = p_idTable
        End Property
        Public Property Let idTable(value)
            p_idTable = value
        End Property
        'amountBT
        Public Property Get amountBT()
            amountBT = p_amountBT
        End Property
        Public Property Let amountBT(value)
            p_amountBT = value
        End Property
        'dateBT
        Public Property Get dateBT()
            dateBT = p_dateBT
        End Property
        Public Property Let dateBT(value)
            p_dateBT = value
        End Property
        'timeBT
        Public Property Get timeBT()
            timeBT = p_timeBT
        End Property
        Public Property Let timeBT(value)
            p_timeBT = value
        End Property
        'noteBT
        Public Property Get noteBT()
            noteBT = p_noteBT
        End Property
        Public Property Let noteBT(value)
            p_noteBT = value
        End Property
        'isCheckin
        Public Property Get isCheckin()
            isCheckin = p_isCheckin
        End Property
        Public Property Let isCheckin(value)
            p_isCheckin = value
        End Property
    End Class
%>