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


      <div id="page" style="padding-top:30px;">
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

<div class="row" style="margin-bottom:20px;">
   <div class="col-md-6 col-md-offset-1">
<h1>Here's what we found:</h1>
<h5>Showing 6 modules</h5>
</div>

<div class="col-md-4 text-right" style="padding-top:40px;">
<select>
  <option>Sort by:</option>
  <option>Pass rate</option>
</select>
</div>

</div>



            <div class="row">


               <div class="col-md-10 col-md-offset-1">
                  <div class="col-md-12 login-card" style="
    border-left-width: 5px;
    border-radius: .25rem;border-left-color: #2ab27b;">

<div class="col-md-9" style="border-right:1px solid #e8e8e8">

                     <h2>5CCS2INS Internet Systems</h2>
                     <h5>Semester 2, Third Year</h5>
                     <p>The aims of this module are: to provide an overall understanding of the communication model used on the Internet,
to provide an in-depth understanding of the main underlying software components of the Internet to provide an overview of the main languages used on the Internet,
to provide an understanding of security threats to Internet application and main techniques used to tackle them.</p>
<a style="cursor:pointer;" data-toggle="collapse" data-target="#result-1-more">More info <i class="fa fa-angle-down" aria-hidden="true"></i></a>


<div id="result-1-more" class="collapse" style="margin-top:10px;">

  <p>The aims of this module are: to provide an overall understanding of the communication model used on the Internet,
 to provide an in-depth understanding of the main underlying software components of the Internet to provide an overview of the main languages used on the Internet,
 to provide an understanding of security threats to Internet application and main techniques used to tackle them.</p>


</div>


</div>
<div class="col-md-3">
<h5>Tag percentage match</h5>
<p style="color:#2ab27b;font-size:20px;">85%</p>


</div>





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
