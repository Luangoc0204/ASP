//lấy id-> insert product to cart -> show modal notification
let modalN = document.querySelector("#modal_notification");
let modalM = document.querySelector(".modal_notification");
let closeMD = document.querySelector(".closeModal");
document.querySelectorAll('.btn-add-to-cart').forEach(button => {
    // Thêm sự kiện click cho mỗi button
    button.addEventListener('click', () => {
        // Lấy idProduct từ thuộc tính data-product-id của button
        const idFood = button.dataset.foodId;
        // Gửi idProduct đi sang file ASP khác
        const xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let responseText = xmlhttp.responseText;
                console.log('Response: ' + responseText);
                if (
                    responseText == 'Food is not exists!!!' ||
                    responseText == 'Create cart faild!!!'
                ) {
                    let html =
                        '<p style="margin-top: 20px;" >' +
                        responseText +
                        '</p>';
                    modalM.innerHTML = html;
                } else {
                    document.querySelector(
                        '.name-product-notification'
                    ).innerText = button.dataset.foodName;
                    modalN.setAttribute('style', 'display:flex');
                    modalN.classList.add('show_modal_notification');
                    getTop5Cart();
                }
            }
        };
        xmlhttp.open("POST", "L_addFoodToCart.asp", true);
        xmlhttp.setRequestHeader(
            'Content-type',
            'application/x-www-form-urlencoded'
        );
        let data = "idFood=" + encodeURIComponent(idFood);
        xmlhttp.send(data);
        console.log(idFood);
    });
});
closeMD.addEventListener("click", function () {
    modalN.setAttribute("style", "display:none");
    modalN.classList.remove("show_modal_notification");
});
modalN.addEventListener("click", function () {
    modalN.setAttribute("style", "display:none");
    modalN.classList.remove("show_modal_notification");
});
///xóa food
$(function () {
    $('#confirm-delete').on('show.bs.modal', function (e) {
        $(this)
            .find('.btn-delete')
            .attr('href', $(e.relatedTarget).data('href'));
    });
});