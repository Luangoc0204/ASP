$(function () {
    $('#confirm-delete').on('show.bs.modal', function (e) {
        $(this)
            .find('.btn-delete')
            .attr('href', $(e.relatedTarget).data('href'));
    });
});
// Lấy tất cả các nút "Edit" và "Add" bằng cách sử dụng phương thức getElementsByClassName
var editButtons = document.getElementsByClassName('group-edit-delete');
var addButton = document.querySelector('.add-button');
var saveButton = document.querySelector('.save-button');
var isActiveCheckboxes = document.getElementsByClassName('input-checkbox');

// Xử lý sự kiện khi click vào nút "Edit"
for (var i = 0; i < editButtons.length; i++) {
    let editButtonItem = editButtons[i];
    editButtons[i]
        .querySelector('.edit-button')
        .addEventListener('click', function () {
            var parentRow = this.parentNode.parentNode;
            //get id
            let idGiftCode = parentRow.querySelector('.idGiftCode').innerText;
            var idInput = parentRow.cells[0];
            idInput.innerHTML +=
                '<input type="hidden" name="idGiftCode" value="' +
                idGiftCode +
                '"></input>';

            // Thay thế cột "Giftcode" bằng một ô input
            var giftcodeCell = parentRow.cells[1];
            giftcodeCell.innerHTML =
                '<input type="text" name="nameGiftCode" value="' +
                giftcodeCell.innerText +
                '">';

            // Thay thế cột "Percentage" bằng một ô input
            var percentageCell = parentRow.cells[2];
            percentageCell.innerHTML =
                '<input type="text" name="discountGiftCode" value="' +
                percentageCell.innerText.replace('%', '') +
                '">';

            // Thay thế cột "Is Active" bằng một checkbox
            var checkboxCell = parentRow.cells[3];
            var inputCheckbox = document.createElement('input');
            inputCheckbox.type = 'checkbox';
            inputCheckbox.name = 'isActive';
            inputCheckbox.style.margin = '0 10px';
            inputCheckbox.style.transform = 'scale(1.9)';
            inputCheckbox.className = 'input-checkbox';

            checkboxCell.insertBefore(
                inputCheckbox,
                checkboxCell.querySelector('.isActive')
            );
            let input_checkbox = checkboxCell.querySelector('.input-checkbox');
            let isActive = checkboxCell.querySelector('.isActive').innerText;
            console.log('isActive: ' + isActive);
            let active_title = checkboxCell.querySelector('.active-title');
            if (isActive == 'True') {
                input_checkbox.checked = true;
                console.log('checked: 1');
            } else {
                input_checkbox.checked = false;
                console.log('checked: 0');
            }
            checkboxCell.querySelector('.icon-active').style.display = 'none';
            input_checkbox.addEventListener('change', function () {
                var isActiveText = this.nextElementSibling;

                // Cập nhật văn bản tùy thuộc vào trạng thái checked
                active_title.textContent = this.checked
                    ? 'Active'
                    : 'Not Active';
            });
            // Thay thế nút "Edit" bằng nút "Save"
            let html1 = `<button type="submit" class="btn btn-success save-button" style="width: 85px;"><i class="fa-solid fa-check" style="font-size: 15px;"></i> Save</button>`;
            let html2 = `<button type="button" class="btn btn-danger" style="padding: 7.5px 5px;  margin-left: 50px;"><i class="fa-solid fa-trash"></i> Delete</button>`;
            editButtonItem.innerHTML = html1 + html2;
            disableEditButton();
        });
}
function disableEditButton() {
    var editButtons = document.querySelectorAll('.edit-button');
    for (var i = 0; i < editButtons.length; i++) {
        if (editButtons[i] !== this) {
            editButtons[i].disabled = true;
        }
    }
    document.querySelector('.add-button').disabled = true;
}
// Xử lý sự kiện khi click vào nút "Add"
addButton.addEventListener('click', function () {
    var parentRow = this.parentNode.parentNode;

    // Thêm các ô input và checkbox vào hàng cuối cùng
    var giftcodeCell = parentRow.cells[1];
    giftcodeCell.innerHTML = '<input type="text" name="nameGiftCode">';

    var percentageCell = parentRow.cells[2];
    percentageCell.innerHTML = '<input type="text" name="discountGiftCode">';

    var isActiveCell = parentRow.cells[3];
    isActiveCell.innerHTML = '';

    // Thay thế nút "Add" bằng nút "Save"
    addButton.style.display = 'none'; // Ẩn nút Add
    saveButton.style.display = 'inline-block'; // Hiển thị nút Save
    disableEditButton();
});
