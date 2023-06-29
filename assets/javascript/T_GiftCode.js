
// Lấy tất cả các nút "Edit" và "Add" bằng cách sử dụng phương thức getElementsByClassName
var editButtons = document.getElementsByClassName("group-edit-delete");
var addButton = document.getElementsByClassName("add-button")[0];
var isActiveCheckboxes = document.getElementsByClassName("input-checkbox");

// Xử lý sự kiện khi click vào nút "Edit"
for (var i = 0; i < editButtons.length; i++) {
  let editButtonItem = editButtons[i];
  editButtons[i].querySelector('.edit-button').addEventListener("click", function() {
    var parentRow = this.parentNode.parentNode;
    
    // Thay thế cột "Giftcode" bằng một ô input
    var giftcodeCell = parentRow.cells[1];
    giftcodeCell.innerHTML = '<input type="text" name="nameGiftCode" value="' + giftcodeCell.innerText + '">';
    
    // Thay thế cột "Percentage" bằng một ô input
    var percentageCell = parentRow.cells[2];
    percentageCell.innerHTML = '<input type="text" name="discountGiftCode" value="' + percentageCell.innerText.replace('%', '') + '">';
    
    // Thay thế cột "Is Active" bằng một checkbox
    var checkboxCell = parentRow.cells[3];
    let input_checkbox = checkboxCell.querySelector('.input-checkbox')
    input_checkbox.style.display = 'block'
    checkboxCell.querySelector('.icon-active').style.display  = 'none'
    input_checkbox.addEventListener('change', function(){
      var isActiveText = this.nextElementSibling;

    // Cập nhật văn bản tùy thuộc vào trạng thái checked
      isActiveText.textContent = this.checked ? "Active" : "Not Active";
    })
    // Thay thế nút "Edit" bằng nút "Save"
    let html1 = `<button type="submit" class="btn btn-success edit-button" style="width: 85px;"><i class="fa-solid fa-check" style="font-size: 15px;"></i> Save</button>`
    let html2 = `<button type="button" class="btn btn-danger" style="padding: 7.5px 5px;  margin-left: 50px;"><i class="fa-solid fa-trash"></i> Delete</button>`
    editButtonItem.innerHTML = html1 + html2

  });
}

// Xử lý sự kiện khi click vào nút "Add"
addButton.addEventListener("click", function() {
  var parentRow = this.parentNode.parentNode;

  // Thêm các ô input và checkbox vào hàng cuối cùng
  var giftcodeCell = parentRow.cells[1];
  giftcodeCell.innerHTML = '<input type="text">';

  var percentageCell = parentRow.cells[2];
  percentageCell.innerHTML = '<input type="text">';

  var isActiveCell = parentRow.cells[3];
  isActiveCell.innerHTML = '<input type="checkbox">';

  // Thay thế nút "Add" bằng nút "Save"
  var addButton = parentRow.cells[4].querySelector(".add-button");
  addButton.innerHTML = '<i class="fa-solid fa-check" style="font-size: 15px; width: 23%;"></i> Save';
});



