//lấy numCart & numBookingFood
let idBookingTable = '';
if (document.querySelector('.idBookingTable') != null) {
    idBookingTable = document.querySelector('.idBookingTable').innerText;
}
console.log('idBookingTable: ' + idBookingTable);
function getNumItem() {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log('NumCart: ' + xmlhttp.responseText);
            numCart = xmlhttp.responseText;
            const cartNumber = document.querySelector('.num-item');
            cartNumber.innerText = numCart;
        }
    };
    if (idBookingTable.trim() == '') {
        xmlhttp.open('GET', 'L_getNumCart.asp', true);
        // console.log("nhảy vào numCart rồi")
    } else {
        xmlhttp.open(
            'GET',
            'L_getNumBookingFood.asp?idBookingTable=' + idBookingTable,
            true
        );
        // console.log("nhảy vào idBookingTable")
    }
    xmlhttp.send();
}
getNumItem();
// Lấy danh sách các sản phẩm
const products = document.querySelectorAll('.content-cart');

// Duyệt qua từng sản phẩm
function allProductInsertBill() {
    products.forEach((product) => {
        // Lấy các phần tử HTML cần thiết của sản phẩm
        const amountInput = product.querySelector('.amount-product-cart');
        const subButton = product.querySelector('.sub-amount');
        const plusButton = product.querySelector('.plus-amount');
        const priceElement = product.querySelector('.price-index-product');
        const sumPriceElement = product.querySelector(
            '.sumPrice-index-product'
        );
        let idCartFood, idBookingFood;
        if (idBookingTable.trim() == '') {
            idCartFood = product.querySelector('.idCartFood').innerText;
        } else {
            idBookingFood = product.querySelector('.idBookingFood').innerText;
        }
        const idFood = product.querySelector('.idFood').innerText;
        const soldOutText = product.querySelector('.sold-out-text');
        const remainingText = product.querySelector('.remaining-text');
        //gán sumPrice
        sumPriceElement.innerText = parseFloat(
            parseFloat(priceElement.innerText) * amountInput.value
        ).toFixed(2);
        //kiểm tra sold out
        let remainingAmount;
        //hàm show số sản phẩm còn lại
        function checkRemaining() {
            checkSoldOut(idFood, function (sumAmount) {
                console.log('sumAmount idFood ' + idFood + ' :' + sumAmount);
                // thực hiện các hành động tiếp theo với giá trị sumAmount
                remainingAmount = sumAmount;
                amountInput.setAttribute('max', parseInt(remainingAmount));
                if (sumAmount <= 0) {
                    product.classList.add('sold-out-today');
                    soldOutText.innerText = 'Sold Out Today';
                } else if (
                    (remainingAmount - parseInt(amountInput.value) <= 10) &
                    (remainingAmount - parseInt(amountInput.value) >= 0)
                ) {
                    product.classList.remove('sold-out-today');
                    soldOutText.innerText = '';
                    remainingText.innerHTML =
                        'Remaining Food: <span style="color:red">' +
                        remainingAmount +
                        '</span>';
                } else if (remainingAmount - parseInt(amountInput.value) < 0) {
                    remainingText.innerHTML =
                        'Remaining Food: <span style="color:red">' +
                        remainingAmount +
                        '</span>';
                    product.classList.add('sold-out-today');
                    soldOutText.innerText = '';
                } else {
                    remainingText.innerHTML = '';
                    soldOutText.innerText = '';
                }
                //cập nhật sumMoney
                updateSumMoney();
                if (idBookingTable.trim() == '') {
                    updateAmount(idCartFood, amountInput.value);
                } else {
                    updateAmount(idBookingFood, amountInput.value);
                }
            });
        }
        checkRemaining();
        // Lấy giá của sản phẩm và chuyển về kiểu số thực
        const price = parseFloat(priceElement.innerText).toFixed(2);

        // Xử lý sự kiện khi ấn nút trừ số lượng
        subButton.addEventListener('click', () => {
            let amount = parseInt(amountInput.value);
            amount = amount > 1 ? amount - 1 : 1;
            amountInput.value = amount;
            sumPriceElement.innerText = (price * amount).toFixed(2);
            checkRemaining();
        });

        // Xử lý sự kiện khi ấn nút thêm số lượng
        plusButton.addEventListener('click', () => {
            let amount = parseInt(amountInput.value);
            amount = amount + 1;
            if (amount > parseInt(remainingAmount)) {
                //not doing anything
            } else {
                amountInput.value = amount;
                sumPriceElement.innerText = (price * amount).toFixed(2);
            }
            checkRemaining();
        });

        // Xử lý sự kiện khi người dùng thay đổi số lượng
        amountInput.addEventListener('change', () => {
            let amount = parseInt(amountInput.value);
            amount = amount < 1 ? 1 : amount;
            amountInput.value = amount;
            sumPriceElement.innerText = (price * amount).toFixed(2);
            checkRemaining();
        });
    });
}
function allProductUpdateBill() {
    products.forEach((product) => {
        const amountInput = product.querySelector('.amount-product-cart');
        const subButton = product.querySelector('.sub-amount');
        const plusButton = product.querySelector('.plus-amount');
        const priceElement = product.querySelector('.price-index-product');
        const sumPriceElement = product.querySelector(
            '.sumPrice-index-product'
        );
        const idBookingFood = product.querySelector('.idBookingFood').innerText;
        const idFood = product.querySelector('.idFood').innerText;
        const soldOutText = product.querySelector('.sold-out-text');
        const remainingText = product.querySelector('.remaining-text');
        soldOutText.innerText = '';
        remainingText.innerText = '';
        //gán sumPrice
        sumPriceElement.innerText = parseFloat(
            parseFloat(priceElement.innerText) * amountInput.value
        ).toFixed(2);
        amountInput.removeAttribute('max');
        // Lấy giá của sản phẩm và chuyển về kiểu số thực
        const price = parseFloat(priceElement.innerText).toFixed(2);

        // Xử lý sự kiện khi ấn nút trừ số lượng
        subButton.addEventListener('click', () => {
            let amount = parseInt(amountInput.value);
            amount = amount > 1 ? amount - 1 : 1;
            amountInput.value = amount;
            sumPriceElement.innerText = (price * amount).toFixed(2);
            updateAmount(idBookingFood, amountInput.value);
            updateSumMoney()
        });

        // Xử lý sự kiện khi ấn nút thêm số lượng
        plusButton.addEventListener('click', () => {
            let amount = parseInt(amountInput.value);
            amount = amount + 1;
            amountInput.value = amount;
            sumPriceElement.innerText = (price * amount).toFixed(2);
            updateAmount(idBookingFood, amountInput.value);
            updateSumMoney()
        });

        // Xử lý sự kiện khi người dùng thay đổi số lượng
        amountInput.addEventListener('change', () => {
            let amount = parseInt(amountInput.value);
            amount = amount < 1 ? 1 : amount;
            amountInput.value = amount;
            sumPriceElement.innerText = (price * amount).toFixed(2);
            updateAmount(idBookingFood, amountInput.value);
            updateSumMoney()
        });
    });
}
//update lại Purchase
let btnPurchase_idBill;
if (document.querySelector('button[data-idBill]') != null){
    btnPurchase_idBill = document.querySelector('button[data-idBill]');
    allProductUpdateBill()
} else{
    allProductInsertBill()
}
///thay đổi sumMoney
// Tìm tất cả sản phẩm không bị sold-out-today
function updateSumMoney() {
    let products_notSoldOut = document.querySelectorAll(
        '.content-cart:not(.sold-out-today)'
    );
    // gán sumAmount
    document.querySelector('.sumAmount').innerText = products_notSoldOut.length;
    //tính tổng
    let tempTotalPrice = 0;
    for (let i = 0; i < products_notSoldOut.length; i++) {
        const product_index = products_notSoldOut[i];
        // Tính tổng giá tiền cho sản phẩm hiện tại
        const sumPrice = product_index.querySelector(
            '.sumPrice-index-product'
        ).textContent;
        tempTotalPrice += parseFloat(sumPrice);
        console.log('Temp total price: ' + tempTotalPrice);
    }
    document.querySelector('.sumMoney').innerText = tempTotalPrice.toFixed(2);
    //update discount user
    let discount_user = parseFloat(
        document.querySelector('.discount-user').getAttribute('data-discount')
    ).toFixed(2);
    //console.log('Discount user: ' + discount_user);
    let discount_user_money = parseFloat(
        (discount_user / 100) * tempTotalPrice
    ).toFixed(2);
    document.querySelector('.discount-user-money').innerText =
        discount_user_money;
    //update discount gift code
    let discount_giftCode = parseFloat(
        document
            .querySelector('.discount-giftCode')
            .getAttribute('data-discountGiftCode')
    ).toFixed(2);
    let discount_giftCode_money = parseFloat(
        (discount_giftCode / 100) * tempTotalPrice
    ).toFixed(2);
    document.querySelector('.discount-giftCode-money').innerText =
        discount_giftCode_money;
    //update totalPrice
    let totalPrice = (
        tempTotalPrice -
        discount_user_money -
        discount_giftCode_money
    ).toFixed(2);
    document.querySelector('.total-price').innerText = totalPrice;
}
updateSumMoney();
//hàm update amount
function updateAmount(idCF_BF, amount) {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log('Update AmountCF: ' + xmlhttp.responseText);
        }
    };
    xmlhttp.open('POST', 'L_plus_sub_amountFood.asp', true);
    xmlhttp.setRequestHeader(
        'Content-type',
        'application/x-www-form-urlencoded'
    );
    let data =
        'id=' +
        encodeURIComponent(idCF_BF) +
        '&amount=' +
        encodeURIComponent(amount);
    if (idBookingTable.trim() == '') {
        data += '&file=CF';
    } else {
        data += '&file=BF';
    }

    xmlhttp.send(data);
}
//hàm kiểm tra Sold out
function checkSoldOut(idFood, callback) {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            let sumAmount = this.responseText;
            callback(sumAmount);
        }
    };
    xmlhttp.open('GET', 'L_checkSoldOut.asp?idFood=' + idFood, true);
    xmlhttp.send();
}
// lấy giftcode
function getGiftCode() {
    const giftcodeInput = document.querySelector('.input-giftcode');
    const discountOutput = document.querySelector('.discount-giftCode');
    const giftcodeNotification = document.querySelector(
        '.giftcode-text-notification'
    );
    const giftcode = giftcodeInput.value.trim();
    if (giftcode == '') {
        giftcodeNotification.innerHTML = 'Enter your code';
    }

    if (giftcode) {
        const xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const discount = parseFloat(this.responseText);
                if (!isNaN(discount)) {
                    discountOutput.innerText = discount.toFixed(2);
                    discountOutput.setAttribute(
                        'data-discountGiftCode',
                        discount
                    );
                    console.log('giftCode: ' + discountOutput);
                    giftcodeNotification.innerHTML = 'Enter your code';
                } else {
                    discountOutput.innerText = 0;
                    discountOutput.setAttribute('data-discountGiftCode', 0);
                    giftcodeNotification.innerHTML =
                        '<span style="color:red">Giftcode does not exist!!!</span>';
                }
                updateSumMoney();
            }
        };
        xmlhttp.open(
            'GET',
            'L_getGiftcode.asp?giftcode=' + encodeURIComponent(giftcode),
            true
        );
        xmlhttp.send();
    }
}

const giftcodeInput = document.querySelector('.input-giftcode');
giftcodeInput.addEventListener('change', getGiftCode);
//hàm đếm ngược số của Modal Purchase
function countdown() {
    const btnContinuePurchase = document.querySelector(
        '.btn-continue-purchase'
    );
    const countdownText = document.querySelector('.countdown');
    let numCountdown = 5;
    function updateCountdown() {
        countdownText.innerText = numCountdown;
        numCountdown--;
    }
    let countdownInterval = setInterval(() => {
        if (numCountdown >= 0) {
            updateCountdown();
        } else {
            clearInterval(countdownInterval);
            location.reload();
        }
    }, 1000);
    btnContinuePurchase.addEventListener('click', () => {
        clearInterval(countdownInterval);
    });
}
/// thực hiện Purchase
//1) kiểm tra lại xem đã hết hàng chưa -> hiện toast
let listIdCartFood = [];
const btnPurchase = document.getElementById('button-purchase');
const modalPurchase = document.getElementById('confirm-purchase');
const loading = document.getElementById('loading');
let listProductSoldOutId = [];
let products_SoldOut = document.querySelectorAll('.content-cart .sold-out-today')

// lấy id của các BookingFood SoldOut để xóa đi
products_SoldOut.forEach((product) => {
    let idBookingFood;
    if (idBookingTable.trim() == '') {
        idCartFood = product.querySelector('.idCartFood').innerText;
    }
    listProductSoldOutId.push(idBookingFood);
});
function checkRemainingAgain() {
    loading.style.display = 'flex';
    let products_notSoldOut = document.querySelectorAll(
        '.content-cart:not(.sold-out-today)'
    );
    let nameFoodSoldOut = document.querySelector('.nameFood-soldOut-last');
    let listProductSoldOut = [];
    let idFoodBuyNow = 0;
    let amountFoodBuyNow = 1;
    products_notSoldOut.forEach((product) => {
        let idCartFood, idBookingFood;
        if (idBookingTable.trim() == '') {
            idCartFood = product.querySelector('.idCartFood').innerText;
        } else {
            idBookingFood = product.querySelector('.idBookingFood').innerText;
        }
        const idFood = product.querySelector('.idFood').innerText;
        const nameFood = product.querySelector('.name-food').innerText;
        const amountInput = product.querySelector('.amount-product-cart');
        checkSoldOut(idFood, function (sumAmount) {
            console.log('sumAmount idFood ' + idFood + ' :' + sumAmount);
            // thực hiện các hành động tiếp theo với giá trị sumAmount
            if (sumAmount <= 0 || sumAmount - parseInt(amountInput.value) < 0) {
                listProductSoldOut.push(nameFood);
                if (idBookingTable.trim() != '') {
                    listProductSoldOutId.push(idBookingFood);
                }
                product.classList.add('sold-out-today');
                updateSumMoney();
                if (idBookingTable.trim() == '') {
                    updateAmount(idCartFood, amountInput.value);
                } else {
                    updateAmount(idBookingFood, amountInput.value);
                }
            } else {
                if (idCartFood == 0 && idBookingTable.trim() == '') {
                    console.log('idFood: ' + idFood);
                    console.log('amountInput: ' + amountInput.value);
                    idFoodBuyNow = idFood;
                    console.log('idFoodBuyNow: ' + idFoodBuyNow);
                    amountFoodBuyNow = amountInput.value;
                    console.log('amountFoodBuyNow: ' + amountFoodBuyNow);
                } else if (idCartFood != 0) {
                    listIdCartFood.push(idCartFood);
                }
            }
        });
    });
    setTimeout(() => {
        console.log('listIdCartFood: ' + listIdCartFood.join(','));
        if (listProductSoldOut.length === 0) {
            ///lưu thông tin -> hiện loadding -> chuyển sang bill
            console.log('listProductSoldOut: ' + listProductSoldOut);
            if (idBookingTable.trim() == '') {
                purchaseCart(listIdCartFood, idFoodBuyNow, amountFoodBuyNow);
            } else {
                purchaseBookingTable(listProductSoldOutId);
            }
        } else {
            loading.style.display = 'none';
            nameFoodSoldOut.innerText = listProductSoldOut.join(', ');
            if (idBookingTable.trim() != '') {
                document.querySelector('.notice-delete-text').style.display =
                    'block';
            }
            // toastPurchase.classList.add('show.bs.modal');
            const myModal = new bootstrap.Modal(modalPurchase, {
                keyboard: false,
                backdrop: 'static',
            });
            myModal.show();
            countdown();
            if (listIdCartFood.length === 0){
                document.querySelector('.btn-continue-purchase').style.display = 'none'
            } else{
                document
                    .querySelector('.btn-continue-purchase')
                    .addEventListener('click', () => {
                        myModal.hide();
                        loading.style.display = 'flex';
                        if (idBookingTable.trim() == '') {
                            purchaseCart(
                                listIdCartFood,
                                idFoodBuyNow,
                                amountFoodBuyNow
                            );
                        } else {
                            purchaseBookingTable(listProductSoldOutId);
                        }
                    });
            }
        }
    }, 2000);
}

btnPurchase.addEventListener('click', () => {
    let totalPrice = parseFloat(
        document.querySelector('.total-price').innerText
    ).toFixed(2);
    if (totalPrice == 0) {
        showIsEmptyCart();
    } else {
        if (document.querySelector('button#button-purchase[data-id-bill]') == null){
            checkRemainingAgain();
        } else {
            const idBill = document.querySelector(
                'button#button-purchase[data-id-bill]'
            ).dataset.idBill
            console.log("idBill: " + idBill)
            updatePurchaseBookingTable(idBill)
        }
    }
});


//hàm kiểm tra xem có sản phẩm nào trong giỏ hàng không
function showIsEmptyCart() {
    let nameFoodSoldOut = document.querySelector('.purchase-modal-body');
    loading.style.display = 'none';
    nameFoodSoldOut.innerHTML = 'Your cart is empty!';
    // toastPurchase.classList.add('show.bs.modal');
    const myModal = new bootstrap.Modal(modalPurchase, {
        keyboard: false,
        backdrop: 'static',
    });
    myModal.show();
    countdown();
    document
        .querySelector('.btn-continue-purchase')
        .addEventListener('click', () => {
            myModal.hide();
            loading.style.display = 'flex';
            location.reload();
        });
}
//2)hàm chuyển dữ liệu idCart và sumMoney sang file khác
function purchaseCart(arrIdCartFood, idFoodBuyNow, amountFoodBuyNow) {
    console.log('idFoodBuyNow: ' + idFoodBuyNow);
    console.log('amountFoodBuyNow: ' + amountFoodBuyNow);
    let idCart = document.querySelector('.idCart').innerText;
    let discount_user = parseFloat(
        document.querySelector('.discount-user').innerText
    ).toFixed(2);
    let discount_giftCode = parseFloat(
        document.querySelector('.discount-giftCode').innerText
    ).toFixed(2);
    let totalPrice = parseFloat(
        document.querySelector('.total-price').innerText
    ).toFixed(2);
    let arrMoney = [];
    arrMoney.push(discount_user);
    arrMoney.push(discount_giftCode);
    arrMoney.push(totalPrice);
    console.log('arrMoney: ' + arrMoney);
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log(this.responseText);
            var idBill = this.responseText;
            var url = 'L_BillUser.asp?idBill=' + idBill;
            window.location.replace(url);
        }
    };
    if (idFoodBuyNow == 0) {
        xmlhttp.open(
            'GET',
            'L_addBill.asp?arrIdCartFood=' +
                arrIdCartFood +
                '&discountUser=' +
                discount_user.toString() +
                '&discountGF=' +
                discount_giftCode.toString() +
                '&totalPrice=' +
                totalPrice.toString() +
                '&idCart=' +
                idCart,
            true
        );
    } else {
        xmlhttp.open(
            'GET',
            'L_addBill.asp?idFoodBuyNow=' +
                idFoodBuyNow +
                '&amountFoodBuyNow=' +
                amountFoodBuyNow +
                '&discountUser=' +
                discount_user.toString() +
                '&discountGF=' +
                discount_giftCode.toString() +
                '&totalPrice=' +
                totalPrice.toString() +
                '&idCart=' +
                idCart,
            true
        );
    }
    xmlhttp.send();
}
function purchaseBookingTable(arrIdBookingFood) {
    let xmlhttp = new XMLHttpRequest();
    let discount_user = parseFloat(
        document.querySelector('.discount-user').innerText
    ).toFixed(2);
    let discount_giftCode = parseFloat(
        document.querySelector('.discount-giftCode').innerText
    ).toFixed(2);
    let totalPrice = parseFloat(
        document.querySelector('.total-price').innerText
    ).toFixed(2);
    let arrMoney = [];
    arrMoney.push(discount_user);
    arrMoney.push(discount_giftCode);
    arrMoney.push(totalPrice);
    console.log('arrMoney BookingTable: ' + arrMoney);
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log(this.responseText);
            var idBill = this.responseText;
            var url = 'L_BillUser.asp?idBill=' + idBill;
            window.location.replace(url);
        }
    };
    xmlhttp.open(
        'GET',
        'L_addBill.asp?idBookingTable=' +
            encodeURIComponent(idBookingTable) +
            '&discountUser=' +
            discount_user.toString() +
            '&discountGF=' +
            discount_giftCode.toString() +
            '&totalPrice=' +
            totalPrice.toString() +
            '&arrIdBookingFood=' +
            arrIdBookingFood,
        true
    );
    xmlhttp.send();
}
function updatePurchaseBookingTable(idBill) {
    let xmlhttp = new XMLHttpRequest();
    let discount_user = parseFloat(
        document.querySelector('.discount-user').innerText
    ).toFixed(2);
    let discount_giftCode = parseFloat(
        document.querySelector('.discount-giftCode').innerText
    ).toFixed(2);
    let totalPrice = parseFloat(
        document.querySelector('.total-price').innerText
    ).toFixed(2);
    let arrMoney = [];
    arrMoney.push(discount_user);
    arrMoney.push(discount_giftCode);
    arrMoney.push(totalPrice);
    console.log('arrMoney BookingTable: ' + arrMoney);
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log(this.responseText);
            var url = 'L_BillUser.asp?idBill=' + idBill;
            window.location.replace(url);
        }
    };
    xmlhttp.open(
        'GET',
        'L_updateBill.asp?idBill=' +
            encodeURIComponent(idBill) +
            '&discountUser=' +
            discount_user.toString() +
            '&discountGF=' +
            discount_giftCode.toString() +
            '&totalPrice=' +
            totalPrice.toString(),
        true
    );
    xmlhttp.send();
}
