const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');
// kiểm tra type
function checkType() {
    let input_type = document.getElementById('typeTable').value;
    const regex = /^[1-9]\d*$/;
    if (regex.test(input_type) && input_type > 0) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid type table!';
        btn_submit.disabled = true;
    }
}
// kiểm tra amount
function checkAmount() {
    let input_amount = document.getElementById('amountTable').value;
    const regex = /^[1-9]\d*$/;
    if (regex.test(input_amount) && input_amount > 0) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid amount table!';
        btn_submit.disabled = true;
    }
}
document.getElementById('typeTable').addEventListener('change', checkType);
document.getElementById('amountTable').addEventListener('change', checkAmount);
