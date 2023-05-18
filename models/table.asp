<%
    Class Table
        'Private, class member variable
        Private p_idTable
        Private p_typeTable
        Private p_amountTable
        Private p_imgTable
        Private p_isActive
        ' getter and setter

        'idTable
        Public Property Get idTable()
            idTable = p_idTable
        End Property
        Public Property Let idTable(value)
            p_idTable = value
        End Property
        'typeTable
        Public Property Get typeTable()
            typeTable = p_typeTable
        End Property
        Public Property Let typeTable(value)
            p_typeTable = value
        End Property
        'amountTable
        Public Property Get amountTable()
            amountTable = p_amountTable
        End Property
        Public Property Let amountTable(value)
            p_amountTable = value
        End Property
        'imgTable
        Public Property Get imgTable()
            imgTable = p_imgTable
        End Property
        Public Property Let imgTable(value)
            p_imgTable = value
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