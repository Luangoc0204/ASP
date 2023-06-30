const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');
// kiểm tra tên
function checkName() {
    let input_name = document.getElementById('nameUser').value;
    const regex = /^[\p{L}\s']{2,50}$/u;
    if (regex.test(input_name)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid name!';
        btn_submit.disabled = true;
    }
}
// kiểm tra số điện thoại
function checkPhone() {
    let input_phone = document.getElementById('phone').value;
    const regex = /^(?:\+84|0)(?:\d){9,10}$/;
    if (regex.test(input_phone) && input_phone > 0) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid phone!';
        btn_submit.disabled = true;
    }
}
// kiểm tra địa chỉ
function checkAddress() {
    let input_address = document.getElementById('address').value;
    const regex = /^[\p{L}\s'\d]{2,50}$/u;
    if (regex.test(input_address)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid address!';
        btn_submit.disabled = true;
    }
}
// kiểm tra email
function checkEmail() {
    let input_email = document.getElementById('email').value;
    const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,50}$/;
    if (regex.test(input_email)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter the correct email format!';
        btn_submit.disabled = true;
    }
}
// kiểm tra password
function checkPassword() {
    let input_password = document.getElementById('password').value;
    const regex = /^[^\s]+$/;
    if (regex.test(input_password)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'Password must not contain spaces';
        btn_submit.disabled = true;
    }
}

// thực thi function
document.getElementById('nameUser').addEventListener('change', checkName);
document.getElementById('phone').addEventListener('change', checkPhone);
document.getElementById('email').addEventListener('change', checkEmail);
document.getElementById('password').addEventListener('change', checkPassword);
