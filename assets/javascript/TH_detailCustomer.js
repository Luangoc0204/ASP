        
//format time
const timeElements = document.querySelectorAll('.timeBT');

// Lặp qua các phần tử được chọn và format lại giá trị
timeElements.forEach(function (element) {
    const time = element.innerText
    const formattedTime = time.substr(0, 5); // Lấy 5 ký tự đầu tiên là giờ và phút
    // console.log(formattedTime);
    element.textContent = formattedTime;
});