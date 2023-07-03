<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="connect.asp"-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <!-- for icons  -->
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
    <!-- bootstrap  -->
    <link rel="stylesheet" href="./assets/css/bootstrap.min.css">
    <!-- for swiper slider  -->
    <link rel="stylesheet" href="assets/css/swiper-bundle.min.css">
    <!-- fancy box  -->
    <link rel="stylesheet" href="assets/css/jquery.fancybox.min.css">
    <!--  -->
    <link rel="stylesheet" href="./assets/css/L_header.css">
    <link rel="stylesheet" href="./assets/css/L_home.css">
</head>
<body>
    <!-- start of header  -->
    <!--#include file="header.asp"-->
    <!-- header ends  -->
            <!-- banner begin -->
            <section class="main-banner" id="home">
                <div class="js-parallax-scene">
                    <div class="banner-shape-1 w-100" data-depth="0.30">
                        <img src="assets/images/berry.png" alt="">
                    </div>
                    <div class="banner-shape-2 w-100" data-depth="0.25">
                        <img src="assets/images/sushi_banner.png" alt="">
                    </div>
                </div>
                <div class="sec-wp">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="banner-text">
                                    <h1 class="h1-title">
                                        Welcome to our
                                        <span>Sushi</span>
                                        restaurant.
                                    </h1>
                                    <p>This is Lorem ipsum dolor sit amet, consectetur adipisicing elit. Numquam eius
                                        vel tempore consectetur nesciunt? Nam eius tenetur recusandae optio aperiam.</p>
                                    
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="banner-img-wp">
                                    <div class="banner-img" style="background-image: url(assets/images/main-b.jpg);">
                                    </div>
                                </div>
                                <div class="banner-img-text mt-4 m-auto">
                                    <h5 class="h5-title">Sushi</h5>
                                    <p>this is Lorem ipsum dolor sit amet consectetur adipisicing elit.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- banner end -->
            <section style="padding-top: 0;" class="about-sec section" id="about">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="sec-title text-center mb-5">
                                <p class="sec-sub-title mb-3">About Us</p>
                                <h2 class="h2-title">Discover our <span>restaurant story</span></h2>
                                <div class="sec-title-shape mb-4">
                                    <img src="assets/images/title-shape.svg" alt="">
                                </div>
                                <p>This is Lorem ipsum dolor sit amet consectetur adipisicing elit. Saepe dolore at
                                    aspernatur eveniet temporibus placeat voluptatum quaerat accusamus possimus
                                    cupiditate, quidem impedit sed libero id perspiciatis esse earum repellat quam.
                                    Dolore modi temporibus quae possimus accusantium, cum corrupti sed deserunt iusto at
                                    sapiente nihil sint iste similique soluta dolor! Quod.</p>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 m-auto">
                            <div class="about-video">
                                <div class="about-video-img" style="background-image: url(assets/images/sushi\ 4K.jpg);">
                                </div>
                                <div class="play-btn-wp">
                                    <a href="assets/images/video_Home.mp4" data-fancybox="video" class="play-btn">
                                        <img style="width: 48px;" src="./assets/images/icon_play_line.png" class="uil uil-play"></img>

                                    </a>
                                    <span>Watch The Recipe</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        
            <section class="book-table section bg-light">
                <div class="book-table-shape">
                    <img src="assets/images/table-leaves-shape.png" alt="">
                </div>

                <div class="book-table-shape book-table-shape2">
                    <img src="assets/images/table-leaves-shape.png" alt="">
                </div>

                <div class="sec-wp">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="sec-title text-center mb-5">
                                    <p class="sec-sub-title mb-3">Book Table</p>
                                    <h2 class="h2-title">Opening Table</h2>
                                    <div class="sec-title-shape mb-4">
                                        <img src="assets/images/title-shape.svg" alt="">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="book-table-info">
                            <div class="row align-items-center" style="display: flex; justify-content: space-around;">
                                <div class="col-lg-4">
                                    <div class="call-now text-center">
                                        <img src="./assets/images/icon_phone_line.png" class="uil uil-phone">
                                        <a href="tel:+91-8866998866">+10 - 1010101010</a>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="table-title text-center">
                                        <h3>Monday to Sunday</h3>
                                        <p>
                                            
                                            <span class="timeOpen"></span>
                                            <span style="margin:0 10px"><b>to</b></span>
                                            <span class="timeClose"></span>
                                            
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row" id="gallery">
                            <div class="col-lg-10 m-auto">
                                <div class="book-table-img-slider" id="icon">
                                    <div class="swiper-wrapper">
                                        <a href="assets/images/sushi_4K_1.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_1.jpg)"></a>
                                        <a href="assets/images/sushi_4K_2.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_2.jpg)"></a>
                                        <a href="assets/images/sushi_4K_3.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_3.jpg)"></a>
                                        <a href="assets/images/sushi_4K_4.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_4.jpg)"></a>
                                        <a href="assets/images/sushi_4K_5.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_5.jpg)"></a>
                                        <a href="assets/images/sushi_4K_6.jpg" data-fancybox="table-slider"
                                            class="book-table-img back-img swiper-slide"
                                            style="background-image: url(assets/images/sushi_4K_6.jpg)"></a>
                                    </div>

                                    <div class="swiper-button-wp">
                                        <div class="swiper-button-prev swiper-button">
                                            <img src="./assets/images/icon_left_fill.png" class="uil uil-angle-left">
                                        </div>
                                        <div class="swiper-button-next swiper-button">
                                            <img src="./assets/images/icon_right_fill.png" class="uil uil-angle-right">
                                        </div>
                                    </div>
                                    <div class="swiper-pagination"></div>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>

            </section>
    <!-- footer starts  -->
    <footer class="site-footer" id="contact">
        <div class="top-footer section">
            <div class="sec-wp">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="footer-info">
                                <div class="footer-logo">
                                    <a href="index.html">
                                        <img src="./assets/images/logo.png" alt="">
                                    </a>
                                </div>
                                <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Mollitia, tenetur.
                                </p>
                                <div class="social-icon">
                                    <ul>
                                        <li>
                                            <a href="https://www.facebook.com/thanhdepchaivl" target="_blank">
                                                <i class="uil uil-facebook-f"></i>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://www.instagram.com/n.kimthanh_/" target="_blank">
                                                <i class="uil uil-instagram"></i>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://github.com/Luangoc0204" target="_blank">
                                                <i class="uil uil-github-alt"></i>
                                            </a>
                                        </li>
                                        <li>
                                            <a data-href="#">
                                                <i class="uil uil-youtube"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-8">
                            <div class="footer-flex-box">
                                <div class="footer-table-info">
                                    <h3 class="h3-title">open hours</h3>
                                    <ul>
                                        <li><i class="uil uil-clock"></i> Mon-Sun : 
                                            <span class="timeOpen"></span>
                                            <span style="margin:0 10px"><b>-</b></span>
                                            <span class="timeClose"></span>
                                        </li>
                                    </ul>
                                </div>
                                <div class="footer-menu">
                                    <h3 class="h3-title">Company</h3>
                                    <ul>
                                        <li><a href="#">Terms & Conditions</a></li>
                                        <li><a href="#">Privacy Policy</a></li>
                                        <li><a href="#">Cookie Policy</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="bottom-footer">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <div class="copyright-text">
                            <p>Copyright &copy; 2023 <span class="name">Luangoc.</span>All Rights Reserved.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- jquery  -->
    <script src="./assets/javascript/jquery-3.5.1.min.js"></script>
    <!-- bootstrap -->
    <script src="./assets/javascript/popper.min.js"></script>
    <script src="./assets/javascript/bootstrap.min.js"></script>
    <!-- swiper slider  -->
    <script src="./assets/javascript/swiper-bundle.min.js"></script>

    <!-- mixitup -- filter  -->
    <script src="./assets/javascript/jquery.mixitup.min.js"></script>
    <!-- fancy box  -->
    <script src="./assets/javascript/jquery.fancybox.min.js"></script>

    <!-- parallax  -->
    <script src="./assets/javascript/parallax.min.js"></script>

    <!-- gsap  -->
    <script src="./assets/javascript/gsap.min.js"></script>
    <!-- scroll trigger  -->
    <script src="assets/javascript/ScrollTrigger.min.js"></script>
    <!-- scroll to plugin  -->
    <script src="assets/javascript/ScrollToPlugin.min.js"></script>
    <!-- main js -->
    <script src="./main.js"></script>
    <script src="./assets/javascript/L_header.js"></script>
    <script>
        $(function () {
            $.ajax({
                type: 'GET',
                url: 'L_getTimeOpenClose.asp',
                cache: false,
                contentType: false,
                processData: false,
                success: function (response) {
                     // Xử lý kết quả trả về từ file uploadImage.asp
                    //console.log("thành công")
                    console.log(response);
                    var responseObject = JSON.parse(response);
                    // ...
                        // Lấy giá trị timeOpen và timeClose từ phần tử đầu tiên của mảng
                        var timeOpen = responseObject.map((item) => item.timeOpen)[0];
                        var timeClose = responseObject.map((item) => item.timeClose)[0];
                        console.log('timeOpen: ' + timeOpen);
                        console.log('timeClose: ' + timeClose);
                        const listTimeOpen = document.querySelectorAll('.timeOpen')
                        const listTimeClose = document.querySelectorAll('.timeClose')
                        listTimeOpen.forEach(function(element){
                            element.innerText = timeOpen.substr(0, 5);
                        })
                        listTimeClose.forEach(function(element){
                            element.innerText = timeClose.substr(0, 5);
                        })
                        
                },
            });
        });
    </script>
</body>
</html>