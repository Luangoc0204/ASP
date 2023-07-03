const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');
var isUpdate
if (document.querySelector('#isUpdate') != null) {
    isUpdate = document.getElementById('isUpdate').innerText
}
const role = document.getElementById('role').innerText;
const btnSetTable = document.querySelector('.btn-setTable')
// kiểm tra amount
function checkAmount() {
    let input_amountbt = document.getElementById('amountBT').value;
    const regex = /^[1-9]\d*$|^0$/;
    if (regex.test(input_amountbt) && input_amountbt > 0) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerText = 'You must enter a valid amount!';
        btn_submit.disabled = true;
    }
}
// kiểm tra date phải chưa đến
function checkDate() {
    let input_datebt = document.getElementById('dateBT').value;
    const inputDate = new Date(input_datebt);
    const today = new Date();
    if (inputDate.setHours(0, 0, 0, 0) >= today.setHours(0, 0, 0, 0)) {
        title_error.innerText = '';
        btn_submit.disabled = false;
    } else {
        title_error.innerHTML =
            'You cannot choose the date before the present date!';
        btn_submit.disabled = true;
    }
}
// kiểm tra giờ
var timeOpen, timeClose
$(function () {
    $.ajax({
        type: 'GET',
        url: 'L_getTimeOpenClose.asp',
        cache: false,
        contentType: false,
        processData: false,
        success: function (response) {
            // Xử lý kết quả trả về từ file uploadImage.asp
            //console.log("thành công")
            console.log(response);
            var responseObject = JSON.parse(response);
            // ...
                // Lấy giá trị timeOpen và timeClose từ phần tử đầu tiên của mảng
                timeOpen = responseObject.map((item) => item.timeOpen)[0];
                timeClose = responseObject.map((item) => item.timeClose)[0];
                console.log('timeOpen: ' + timeOpen);
                console.log('timeClose: ' + timeClose);
                
                
        },
    });
});
function checkTime() {
    const input_timebt = document.getElementById('timeBT2').value;
    console.log('time chọn: ' + input_timebt);
    const currentTime = new Date();
    //đặt ngày giờ hiện tại
    const [inputHour, inputMinute] = input_timebt.split(':');
    const inputDateTime = new Date();
    inputDateTime.setHours(inputHour);
    inputDateTime.setMinutes(inputMinute);
    //đặt ngày giờ mở cửa
    const [openHour, openMinute, openSecond] = timeOpen.split(':');
    const openDate = new Date();
    openDate.setHours(openHour);
    openDate.setMinutes(openMinute);
    console.log('openDate:' + openDate)
    //đặt ngày giờ đóng cửa
    const [closeHour, closeMinute, closeSecond] = timeClose.split(':');
    const closeDate = new Date();
    closeDate.setHours(closeHour);
    closeDate.setMinutes(closeMinute);
    console.log('closeDate:' + closeDate)
    if (inputDateTime < openDate || inputDateTime > closeDate) {
        console.log('time vượt quá thời gian mở cửa');
        title_error.innerHTML =
            'The time you entered is not within business hours!';
        btn_submit.disabled = true;
    } else if (inputDateTime < currentTime) {
        console.log('time < time hiện tại');
        title_error.innerHTML =
            'You cannot choose the time before the present time!';
        btn_submit.disabled = true;
    } else if (inputDateTime > currentTime) {
        console.log('time > time hiện tại');
        title_error.innerText = '';
        btn_submit.disabled = false;
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
        title_error.innerText = 'Maximum number of characters is 300!';
        btn_submit.disabled = true;
    }
}
document.getElementById('amountBT').addEventListener('change', checkAmount);
if (isUpdate !== 1 || (isUpdate == 1 && role === 'CUSTOMER')){
    document.getElementById('dateBT').addEventListener('change', checkDate);
    document.getElementById('timeBT2').addEventListener('change', checkTime);
}
document.getElementById('noteBT').addEventListener('change', checkNote);
