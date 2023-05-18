<%
    Class Employee
        'Private, class member variable
        Private p_idEmployee
        Private p_idUser
        Private p_salary
        Private p_position
        ' getter and setter

        'idEmployee
        Public Property Get idEmployee()
            idEmployee = p_idEmployee
        End Property
        Public Property Let idEmployee(value)
            p_idEmployee = value
        End Property
        'idUser
        Public Property Get idUser()
            idUser = p_idUser
        End Property
        Public Property Let idUser(value)
            p_idUser = value
        End Property
        'salary
        Public Property Get salary()
            salary = p_salary
        End Property
        Public Property Let salary(value)
            p_salary = value
        End Property
        'position
        Public Property Get position()
            position = p_position
        End Property
        Public Property Let position(value)
            p_position = value
        End Property
    
    End Class
%>