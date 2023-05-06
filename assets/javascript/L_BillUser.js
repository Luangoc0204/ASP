//format timeBill
const time = document.querySelector('.timeBill').innerText
const formatTime = time.substr(0, 5);
document.querySelector('.timeBill').innerText = formatTime
//
const listSumMoney = document.querySelectorAll('.index-sumPrice')
let totalPrice = 0
listSumMoney.forEach((food) => {
    let sumPrice = food.innerText
    totalPrice += parseFloat(sumPrice)
})
document.querySelector('.totalPrice').innerText = totalPrice.toFixed(2)
const discountUser = document.querySelector('.discountUser').innerText
const discountGiftCode = document.querySelector('.discountGiftcode').innerText;
const moneyDiscountUser = parseFloat(discountUser / 100 * totalPrice).toFixed(2)
const moneyDiscountGiftcode = parseFloat(discountGiftCode /100 * totalPrice).toFixed(2)
document.querySelector('.money-discountUser').innerText = moneyDiscountUser
document.querySelector('.money-discountGiftcode').innerText = moneyDiscountGiftcode
