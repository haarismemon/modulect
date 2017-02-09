<?php
/**
* Will form the login page / home page
* author Aqib Rashid
*/
   $mock = "";
   if(isset($_GET['mock'])) {
     $mock = $_GET['mock'];
   }
   ?>
<!doctype html>
<html>
   <head>
      <title>Search results | Modulect</title>
      <?php include 'includes/assets.php'; ?>
   </head>
   <body>
   <?php include 'includes/partial-header.php'; ?>

   <!--VERY MESSY NOT GOOD CODING PRACTICE-->
   <style>
   .banner {
       height: 270px;
       background: #2986BE;
       background-image: url(//p6.zdassets.com/hc/theme_assets/138842/200037786//pattern_transparent.png);
       background-size: 380px, contain;
       padding-top: 121px;
       padding-bottom: 35px;
       color:#fff;
   }
   </style>
   <div class="banner">
     <div class="container">
       <h1>Results</h1>
     </div>
   </div>


      <div id="page" style="padding-top:40px;">
         <div class="container">
            <?php if($mock == "error"){?>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="flash-alert flash-alert-error">
                     <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> You did something wrong.
                  </div>
               </div>
            </div>
            <?php }
               else if($mock == "success"){?>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="flash-alert flash-alert-success">
                     <i class="fa fa-check" aria-hidden="true"></i> You successfully did something.
                  </div>
               </div>
            </div>
            <?php } ?>




            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="col-md-12 login-card">
                     <h2>Module name</h2>
                     <p>It's quick and simple to register. Once signed up, you can use Modulect as you want.</p>

                  </div>
               </div>
            </div>









            <div class="row" style="margin-top:40px;">
               <div class="col-md-12 text-center">
                  <p>Need help? <a href="#">Contact KCL Modulect support</a>
                  </p>
               </div>
            </div>
         </div>
      </div>
      <?php include 'includes/partial-footer.php'; ?>
   </body>
</html>
