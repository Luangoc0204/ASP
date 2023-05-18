<%
    Class User
        'Private, class member variable
        Private p_IdUser
        Private p_NameUser
        Private p_Birthday
        Private p_Phone
        Private p_Address
        Private p_Email
        Private p_Avatar

        ' getter and setter

        'idUser
        Public Property Get idUser()
            idUser = p_IdUser
        End Property
        Public Property Let idUser(value)
            p_IdUser = value
        End Property
        'nameUser
        Public Property Get nameUser()
            nameUser = p_NameUser
        End Property
        Public Property Let nameUser(value)
            p_NameUser = value
        End Property
        'birthday
        Public Property Get birthday()
            birthday = p_Birthday
        End Property
        Public Property Let birthday(value)
            p_Birthday = value
        End Property
        'phone
        Public Property Get phone()
            phone = p_Phone
        End Property
        Public Property Let phone(value)
            p_Phone = value
        End Property
        'address
        Public Property Get address()
            address = p_Address
        End Property
        Public Property Let address(value)
            p_Address = value
        End Property
        'email
        Public Property Get email()
            email = p_Email
        End Property
        Public Property Let email(value)
            p_Email = value
        End Property
        'avatar
        Public Property Get avatar()
            avatar = p_Avatar
        End Property
        Public Property Let avatar(value)
            p_Avatar = value
        End Property
    End Class
%>