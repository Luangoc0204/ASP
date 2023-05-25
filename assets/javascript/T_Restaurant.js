//
const time_group = document.getElementById('time');
const timeOpen = document.getElementById('timeOpen');
const timeClose = document.getElementById('timeClose');
const gach_ngang = document.querySelector('.gach_ngang');
const editIcon = document.getElementById('edit-icon');
const saveTime = document.querySelector('.btn-saveTime');

let html_input =
    '<input type="time" id="input_timeOpen" style="" value="" name="timeOpen">';
html_input += '<span style="margin: 0 5px;">-</span>';
html_input +=
    '<input type="time" id="input_timeClose" style="" value="" name="timeClose">';

// Tạo sự kiện click cho icon edit
editIcon.addEventListener('click', function () {
    // Tạo input để chỉnh sửa thời gian và ẩn time
    timeOpen.style.display = 'none';
    timeClose.style.display = 'none';
    gach_ngang.style.display = 'none';
    editIcon.style.display = 'none';
    saveTime.style.display = 'block';
    time_group.innerHTML += html_input;
    const input_timeOpen = document.getElementById('input_timeOpen');
    const input_timeClose = document.getElementById('input_timeClose');
    input_timeOpen.value = timeOpen.innerText;
    input_timeClose.value = timeClose.textContent;
});
///lấy dữ liệu doanh thu 5 tháng gần nhất
function getRevenueMonth() {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log(xmlhttp.responseText);
            var response = JSON.parse(this.responseText);
            console.log('Response: ' + response);
            var months = response.map(function (item) {
                return item.Month;
            });

            // Mảng chứa các giá trị của thuộc tính "TotalSumPrice"
            var totalSumPrices = response.map(function (item) {
                return item.TotalSumPrice;
            });
            months = months.reverse();
            totalSumPrices = totalSumPrices.reverse();
            // In các giá trị trong mảng "months"
            console.log('Month: ' + months);

            // In các giá trị trong mảng "totalSumPrices"
            console.log('Revenue Month: ' + totalSumPrices);
            let lengthMonth = months.length;
            console.log('length: ' + lengthMonth);
            document.querySelector('.revenue-this-month').innerText =
                totalSumPrices[lengthMonth - 1];
            let percent = 0;
            if (totalSumPrices[lengthMonth - 2] != 0) {
                percent = parseFloat(
                    (totalSumPrices[lengthMonth - 1] /
                        totalSumPrices[lengthMonth - 2]) *
                        100 -
                        100
                ).toFixed(2);
            } else percent = 100;
            let text_revenue_month = document.querySelector(
                '.text-revenue-month'
            );
            let html = ' ';
            if (percent < 0) {
                html += `
                <i class="fa-solid fa-arrow-down"></i>
                <span class="percent-this-month"></span>
                <span>%</span>
              `;
                text_revenue_month.classList.add('text-danger');
            } else {
                html += `
              <i class="fas fa-arrow-up"></i>
              <span class="percent-this-month"></span>
              <span>%</span>
              `;
                //text_revenue_month.classList.remove('text-danger');
            }
            text_revenue_month.innerHTML = html;
            document.querySelector('.percent-this-month').innerText = percent;
            let canvas = document.getElementById('visitors-chart');
            // Tạo một đối tượng Chart mới với loại là Line
            let chart = new Chart(canvas, {
                type: 'line',
                data: {
                    labels: months,
                    datasets: [
                        {
                            label: 'Revenue Month',
                            data: totalSumPrices,
                            backgroundColor: 'rgba(0, 123, 255, 0.2)', // Màu nền cho biểu đồ
                            borderColor: 'rgba(0, 123, 255, 1)', // Màu viền cho biểu đồ
                            borderWidth: 1, // Độ dày viền cho biểu đồ
                        },
                    ],
                },
                options: {
                    // Cấu hình tùy chọn cho biểu đồ
                    responsive: true,
                    maintainAspectRatio: false,
                },
            });
        }
    };
    xmlhttp.open('GET', 'L_getRevenueMonth.asp', true);
    xmlhttp.send();
}
getRevenueMonth();
//lấy dữ liệu 7 ngày gần nhất
function getRevenueWeek() {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log(xmlhttp.responseText);
            var response = JSON.parse(this.responseText);
            console.log('Response: ' + response);
            var weeks = response.map(function (item) {
                return item.date;
            });

            // Mảng chứa các giá trị của thuộc tính "TotalSumPrice"
            var totalSumPrices = response.map(function (item) {
                return item.TotalSumPrice;
            });
            weeks = weeks.reverse();
            totalSumPrices = totalSumPrices.reverse();
            // In các giá trị trong mảng "months"
            console.log('Days: ' + weeks);

            // In các giá trị trong mảng "totalSumPrices"
            console.log('Revenue Month: ' + totalSumPrices);
            let lengthWeek = 7;
            //console.log('length: ' + lengthMonth);
            document.querySelector('.revenue-this-day').innerText =
                totalSumPrices[lengthWeek - 1];
            let percent = 0;
            if (totalSumPrices[lengthWeek - 2] != 0) {
                percent = parseFloat(
                    (totalSumPrices[lengthWeek - 1] /
                        totalSumPrices[lengthWeek - 2]) *
                        100 -
                        100
                ).toFixed(2);
            } else percent = 100;
            let text_revenue_month =
                document.querySelector('.text-revenue-day');
            let html = ' ';
            if (percent < 0) {
                html += `
                <i class="fa-solid fa-arrow-down"></i>
                <span class="percent-this-day"></span>
                <span>%</span>
              `;
                text_revenue_month.classList.add('text-danger');
            } else {
                html += `
              <i class="fas fa-arrow-up"></i>
              <span class="percent-this-day"></span>
              <span>%</span>
              `;
                //text_revenue_month.classList.remove('text-danger');
            }
            text_revenue_month.innerHTML = html;
            document.querySelector('.percent-this-day').innerText = percent;
            let canvas = document.getElementById('sales-chart');
            // Tạo một đối tượng Chart mới với loại là Bar
            let chart = new Chart(canvas, {
                type: 'bar',
                data: {
                    labels: weeks,
                    datasets: [
                        {
                            label: 'Revenue Day',
                            data: totalSumPrices,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.2)',
                                'rgba(255, 159, 64, 0.2)',
                                'rgba(255, 205, 86, 0.2)',
                                'rgba(75, 192, 192, 0.2)',
                                'rgba(54, 162, 235, 0.2)',
                                'rgba(153, 102, 255, 0.2)',
                                'rgba(255,130,67, 0.2)',
                            ],
                            borderColor: [
                                'rgb(255, 99, 132)',
                                'rgb(255, 159, 64)',
                                'rgb(255, 205, 86)',
                                'rgb(75, 192, 192)',
                                'rgb(54, 162, 235)',
                                'rgb(153, 102, 255)',
                                'rgb(255,130,67)',
                            ],
                            borderWidth: 1,
                        },
                    ],
                },
                options: {
                    // Cấu hình tùy chọn cho biểu đồ
                    responsive: true,
                    maintainAspectRatio: false,
                },
            });
        }
    };
    xmlhttp.open('GET', 'L_getRevenueWeek.asp', true);
    xmlhttp.send();
}
getRevenueWeek();
