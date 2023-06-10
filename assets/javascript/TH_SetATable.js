const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');

// kiểm tra amount
function checkAmount(){
    let input_amountbt = document.getElementById('amountBT').value
    const regex = /^[1-9]\d*$|^0$/;
    if (regex.test(input_amountbt) && input_amountbt > 0){
        title_error.innerText = '';
        btn_submit.disabled = false
    } else{
        title_error.innerText =
        'You must enter a valid amount!';
        btn_submit.disabled = true;
    }
}
// kiểm tra date phải chưa đến
function checkDate() {
    let input_datebt = document.getElementById('dateBT').value
    const inputDate = new Date(input_datebt);
    const today = new Date();
    if (inputDate.setHours(0, 0, 0, 0) >= today.setHours(0, 0, 0, 0)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    }
    else {
        title_error.innerHTML = 
        'You must enter a valid day!';
        btn_submit.disabled = true;
    }
}
// kiểm tra giờ
function checkTime() {
    const input_timebt = document.getElementById('timeBT2').value;
    const currentTime = new Date();
    const inputDateTime = new Date();

    const [inputHour, inputMinute] = input_timebt.split(':');
    inputDateTime.setHours(inputHour);
    inputDateTime.setMinutes(inputMinute);

    const startHour = 7; // Giờ bắt đầu (7 giờ sáng)
    const endHour = 23; // Giờ đóng cửa (11 giờ tối)

    if (inputDateTime > currentTime) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    }
    else
        if (inputDateTime.getHours() < startHour && inputDateTime.getHours() > endHour)
            {
                title_error.innerHTML = 'The time you entered is not within business hours!';
                btn_submit.disabled = true;
            }
        else
            {
                title_error.innerHTML = 'You cannot enter elapsed time!';
                btn_submit.disabled = true;
            }
}
// Kiểm tra note
function checkNote() {
    const input_notebt = document.getElementById('noteBT').value;
    const regex = /^.{1,300}$/;
    if (regex.test(input_notebt)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'Maximum number of characters exceeded!';
        btn_submit.disabled = true;
    }
}
document.getElementById('amountBT').addEventListener('change', checkAmount);
document.getElementById('dateBT').addEventListener('change', checkDate);
document.getElementById('timeBT2').addEventListener('change', checkTime);
document.getElementById('noteBT').addEventListener('change', checkNote);
