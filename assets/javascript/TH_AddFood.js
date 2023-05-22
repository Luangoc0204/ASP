const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');
// kiểm tra tên
function checkName() {
    let input_name = document.getElementById('name').value
    const regex = /^[\p{L}\s']{2,50}$/u;
    if (regex.test(input_name)){
        title_error.innerText = '';
        btn_submit.disabled = false
    } else{
        title_error.innerText =
        'You must enter a valid name food!';
        btn_submit.disabled = true;
    }
}
// kiểm tra person
function checkForPerson(){
    let input_forPerson = document.getElementById('forPerson').value
    const regex = /^[1-9]\d*$|^0$/;
    if (regex.test(input_forPerson) && input_forPerson > 0){
        title_error.innerText = '';
        btn_submit.disabled = false
    } else{
        title_error.innerText =
        'You must enter a valid number for the people!';
        btn_submit.disabled = true;
    }
}
// kiểm tra price
function checkPrice() {
    let input_pricefood = document.getElementById('priceFood').value
    const regex = /^\d+(\.\d{1,2})?$/;
    if (input_pricefood > 0 && regex.test(input_pricefood)){
        title_error.innerText = ''
        btn_submit.disabled = false
    } else{
        title_error.innerText =
            'You must enter the correct format greater than 0! (eg 50.50)';
        btn_submit.disabled = true;
    }
}
// kiểm tra person
function checkAmount(){
    let input_amountfood = document.getElementById('amountFood').value
    const regex = /^[1-9]\d*$|^0$/;
    if (regex.test(input_amountfood) && input_amountfood > 0){
        title_error.innerText = '';
        btn_submit.disabled = false
    } else{
        title_error.innerText =
        'You must enter a valid number for the food!';
        btn_submit.disabled = true;
    }
}
document.getElementById('name').addEventListener('change', checkName);
document.getElementById('forPerson').addEventListener('change', checkForPerson);
document.getElementById('priceFood').addEventListener('change', checkPrice);
document.getElementById('amountFood').addEventListener('change', checkAmount);
