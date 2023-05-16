//đổi định dạng time sang hh:mm
// const timeOpen = document.getElementById("timeOpen")
// document.getElementById("timeOpen").textContent = timeOpen.innerText.substr(0,5)

// const timeClose = document.getElementById("timeClose")
// document.getElementById("timeClose").textContent = timeClose.innerText.substr(0,5)

// Lấy các phần tử DOM cần sử dụng
const editIcon = document.getElementById('edit-icon');
const input_timeOpen = document.getElementById('input_timeOpen');
const input_timeClose = document.getElementById('input_timeClose');

// Tạo sự kiện click cho icon edit
editIcon.addEventListener('click', function() {
  // Tạo input để chỉnh sửa thời gian và ẩn time
  timeOpen.style.display = 'none'
  timeClose.style.display = 'none'
  input_timeOpen.style.display = 'block'
  input_timeClose.style.display = 'block'
});