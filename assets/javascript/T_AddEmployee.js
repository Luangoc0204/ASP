const btn_submit = document.getElementById('btn-submit');
let title_error = document.querySelector('.p_error');
//kiểm tra salary
function checkSalary() {
    let input_salary = document.getElementById('salary').value
    const regex = /^\d+(\.\d{1,2})?$/;
    if (input_salary > 0 && regex.test(input_salary)){
        title_error.innerText = ''
        btn_submit.disabled = false
    } else{
        title_error.innerText =
            'You must enter the correct format greater than 0 (eg 500.50)';
        btn_submit.disabled = true
    }
}
document.getElementById('salary').addEventListener('change', checkSalary)