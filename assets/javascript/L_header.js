// hiển thị modal cart
var shopCart = document.querySelector('.header-cart');
if (shopCart != null){
    var modal = document.getElementById('modal-cart');
    modal.classList.add('stardust-popover__popover--hide');
    
    shopCart.addEventListener('mouseenter', () => {
        modal.style.visibility = 'visible';
        modal.classList.add('stardust-popover__popover--show');
        modal.classList.remove('stardust-popover__popover--hide');
    });
    shopCart.addEventListener('mouseleave', () => {
        if (!shopCart.contains(event.relatedTarget)) {
            modal.classList.remove('stardust-popover__popover--show');
            modal.classList.add('stardust-popover__popover--hide');
            setTimeout(() => {
                modal.style.visibility = 'hidden';
            }, 200);
        }
    });
}
// hiển thị modal infor
var user_info = document.querySelector('.header-info');
var modal_user = document.getElementById('modal-info');
modal_user.classList.add('stardust-popover__popover--hide');

user_info.addEventListener('mouseenter', () => {
    modal_user.style.visibility = 'visible';
    modal_user.classList.add('stardust-popover__popover--show');
    modal_user.classList.remove('stardust-popover__popover--hide');
});
user_info.addEventListener('mouseleave', () => {
    if (!user_info.contains(event.relatedTarget)) {
        modal_user.classList.remove('stardust-popover__popover--show');
        modal_user.classList.add('stardust-popover__popover--hide');
        setTimeout(() => {
            modal_user.style.visibility = 'hidden';
        }, 200);
    }
});
//set num cart
var numCart;
function getNumCart() {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            console.log('NumCart: ' + xmlhttp.responseText);
            numCart = xmlhttp.responseText;
            const cartNumber = document.querySelector('.cart-number');
            if (numCart > 0) {
                cartNumber.innerText = numCart;
                cartNumber.style.display = 'flex'; //hiển thị phần tử
            } else {
                cartNumber.style.display = 'none'; //ẩn phần tử
            }
        }
    };
    xmlhttp.open('GET', 'L_getNumCart.asp', true);
    xmlhttp.send();
}
getNumCart();
function getTop5Cart() {
    let xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        let modalCart = document.querySelector('.list-food-cart');
        let html = '';
        if (this.readyState == 4 && this.status == 200) {
            console.log(xmlhttp.responseText);
            var response = JSON.parse(this.responseText);
            console.log('Response: ' + response);
            html = '<p>Recently Added Products</p>';
            for (let i = 0; i < response.length; i++) {
                let CartFood = response[i];
                console.log('CardFood:' + CartFood);
                html += `
                    <div class="index_product">
                        <img class="cart_img" src="upload\\menu\\${CartFood.food[0].imgFood}" alt="">
                        <div class="group_name_price">
                            <span class="cart_name">${CartFood.food[0].nameFood}</span>
                            <span class="cart_price">${CartFood.food[0].priceFood} $</span>
                        </div>
                    </div>
                `;
            }
            getNumCart();
        } else {
            html = `
                <div class="empty_cart">
                    <img src="./assets/images/cart_shopping.png" alt="">
                    <p>You have no items in your shopping cart</p>
                </div>
            `;
        }
        modalCart.innerHTML = html;
    };
    xmlhttp.open('GET', 'L_getTop5Cart.asp', true);
    xmlhttp.send();
}
getTop5Cart();
