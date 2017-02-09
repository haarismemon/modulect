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
<h5>Showing 2 modules</h5>
</div>

<div class="col-md-4 text-right" style="padding-top:40px;">
<select>
  <option>Sort by:</option>
  <option>Pass rate</option>
</select>
</div>

</div>



            <div class="row">

<style>
  .result-card-main{border-right:1px dotted #dfe2e1;}
.btn-small{    width: 150px;
    font-size: 13px;}
@media (max-width: 768px) {

  .result-card-main{border-right:0px;border-bottom:1px dotted #dfe2e1;margin-bottom:20px;padding-bottom:20px;}

}


</style>
               <div class="col-md-10 col-md-offset-1">
                  <div class="col-md-12 login-card result-card" style="
                  border-left-width: 5px;
                  border-radius: .25rem;border-left-color: #2ab27b;">

<div class="col-md-9 result-card-main">
                     <h2>5CCS2INS Internet Systems</h2>
                     <h4>Second Year, Semester 1 - 15 Credits</h4>

                     <h5 style="margin-top:20px;">Description</h5>
                     <p>The aims of this module are: to provide an overall understanding of the communication model used on the Internet,
to provide an in-depth understanding of the main underlying software components of the Internet to provide an overview of the main languages used on the Internet,
to provide an understanding of security threats to Internet application and main techniques used to tackle them.</p>

<div style="margin-top:20px">
  <a href="#" class="btn btn-lg btn-small"><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
<a style="cursor:pointer;float:right;margin-right:10px;margin-top:5px;" data-toggle="collapse" data-target="#result-1-more">More info <i class="fa fa-angle-down" aria-hidden="true"></i></a></div>


<div id="result-1-more" class="collapse" style="padding-top:25px;">
  <h5 style="margin-top:20px;">Potential careers aspects for this module</h5>
  <p>Read, from, model, okay</p>

                       <h5 style="margin-top:20px;">Requirements/Pre-requisites</h5>
    <p>(none)</p>
                       <h5 style="margin-top:20px;">Lecturers</h5>
<p>Dr Steve Phelps and Dr Samhar Mahmood</p>
                       <h5 style="margin-top:20px;">Assessment methods</h5>
    <p>80% exam, 20% coursework</p>


</div>


</div>
<div class="col-md-3">
<h5>Tag match </h5>
<div style="color:#2ab27b;font-size:18px;">80%</div>
<p>4 out of 5</p>


<h5 style="margin-top:20px">Matched tags</h5>
<div style="font-size:18px;">HERE</div>



<h5 style="margin-top:20px">Module pass rate</h5>
<div style="font-size:18px;">74%</div>


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
