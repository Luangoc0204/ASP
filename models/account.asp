<%
    Class Account
        'Private, class member variable
        Private p_idAccount
        Private p_idUser
        Private p_username
        Private p_password
        Private p_role
        ' getter and setter

        'idAccount
        Public Property Get idAccount()
            idAccount = p_idAccount
        End Property
        Public Property Let idAccount(value)
            p_idAccount = value
        End Property
        'idUser
        Public Property Get idUser()
            idUser = p_idUser
        End Property
        Public Property Let idUser(value)
            p_idUser = value
        End Property
        'username
        Public Property Get username()
            username = p_username
        End Property
        Public Property Let username(value)
            p_username = value
        End Property
        'password
        Public Property Get password()
            password = p_password
        End Property
        Public Property Let password(value)
            p_password = value
        End Property
        'role
        Public Property Get role()
            role = p_role
        End Property
        Public Property Let role(value)
            p_role = value
        End Property
    End Class
%>