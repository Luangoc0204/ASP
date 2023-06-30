let dateToday = document.getElementById('dateToday').innerText;
console.log(dateToday);
function formatDate(dateStr) {
    var regex = /^\d{2}\-\d{2}\-\d{4}$/;
    if (regex.test(dateStr)) {
        const dateArr = dateStr.split('-').reverse();
        console.log('dateArr: ' + dateArr);
        return dateArr.join('-');
    } else {
        return dateStr;
    }
}
dateSearch = formatDate(dateToday);
console.log('dateSearch: ' + dateSearch);
document.querySelector('.search-input').value = dateSearch;
document.getElementById('dateReverse').innerText = dateSearch;
//format time
const timeElements = document.querySelectorAll('.timeBill');

// Lặp qua các phần tử được chọn và format lại giá trị
timeElements.forEach(function (element) {
    const time = element.innerText;
    const formattedTime = time.substr(0, 5); // Lấy 5 ký tự đầu tiên là giờ và phút
    // console.log(formattedTime);
    element.textContent = formattedTime;
});
