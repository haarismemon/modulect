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
  <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/css/bootstrap-select.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/js/bootstrap-select.min.js"></script>

<!-- (Optional) Latest compiled and minified JavaScript translation files -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/js/i18n/defaults-*.min.js"></script>

<Style>
.dropdown-toggle,.dropdown-toggle:hover,.dropdown-toggle:focus,.dropdown-toggle:active{background: #dfe2e1;
    color: #333;
    box-shadow: 0px 3px 0px 0px #999;
    outline: none;}
</Style>



               <div class="col-md-4 text-right" style="padding-top:40px;">
                  <div class="sort-area">
                     Sort by: &nbsp;&nbsp;
                     <select class="selectpicker">
                        <option value="tags" selected>Tag matches</option>
                        <option value="coursework">Coursework %</option>
                        <option value="exam">Exam %</option>
                        <option value="pass">Pass rate</option>
                     </select>
                  </div>
               </div>
            </div>
            <div class="row">
               <style>
                  .result-card-side{border-left:1px dotted #dfe2e1;}
                  .btn-small{    width: 150px;
                  font-size: 13px;}
                  @media (max-width: 768px) {
                  .result-card-side{border-left:0px;border-top:1px dotted #dfe2e1;border-bottom:1px dotted #dfe2e1;padding-top:20px;padding-bottom:20px;margin-top:20px;}
                  }
               </style>



               <div class="col-md-10 col-md-offset-1">
                  <div class="col-md-12 login-card result-card" style="
                     border-left-width: 5px;
                     border-radius: .25rem;border-left-color: #2ab27b;">

<div class="row">
                     <div class="col-md-9 result-card-main">
                        <h2>5CCS2INS Internet Systems</h2>
                        <h4>Second Year, Semester 1 - 15 Credits</h4>
                        <div style="margin-top:30px">

<style>
.btn-disabled{opacity: 0.5;cursor: default}
.tooltip {text-align: left;font-family: "Open Sans";}
.tooltip-inner {padding:8px 12px;text-align: left;}
</style>

<?php if($login == "true") { ?>

                            <a href="#" class="btn btn-lg btn-small"><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
<?php } else { ?>

                           <a class="btn btn-lg btn-small btn-disabled" data-toggle="tooltip"  data-placement="right" title="To save modules, you must be logged in."><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
<?php } ?>


                           <a style="cursor:pointer;float:right;margin-right:10px;margin-top:5px;" data-toggle="collapse" data-target="#result-1-more">More info <i class="fa fa-angle-down" aria-hidden="true"></i></a>
                        </div>
                     </div>
                     <style>
                        .result-side-column .row{margin-left:0px;margin-right:0px;}
                     </style>
                     <div class="col-md-3 result-side-column result-card-side">
                        <div class="row">
                           <h5><i class="fa fa-tag" aria-hidden="true"></i>&nbsp;&nbsp;Tag match </h5>
                           <div style="color:#2ab27b;font-size:18px;">80%</div>
                           <p>4 out of 5</p>
                        </div>
                        <div class="row" style="margin-top:10px">

<style>
.tags-area{padding-left:10px;margin-top:10px;}
.tags-area span { 
  display: inline-block;
  height: 24px;
  line-height: 24px;
  position: relative;
  margin: 0 16px 8px 0;
  padding: 0 10px 0 12px;
  background: #2986BE; 
  -webkit-border-bottom-right-radius: 3px;  
  border-bottom-right-radius: 3px;
  -webkit-border-top-right-radius: 3px; 
  border-top-right-radius: 3px;
  -webkit-box-shadow: 0 1px 2px rgba(0,0,0,0.2);
  box-shadow: 0 1px 2px rgba(0,0,0,0.2);
  color: #fff;
  font-size: 11px;
  text-decoration: none;
  text-shadow: 0 1px 2px rgba(0,0,0,0.2);
  font-weight: bold;
  } 

.tags-area span:before {
  content: "";
  position: absolute;
  top:0;
  left: -12px;
  width: 0;
  height: 0;
  border-color: transparent #2986BE transparent transparent;
  border-style: solid;
  border-width: 12px 12px 12px 0;   
  }

.tags-area span:after {
  content: "";
  position: absolute;
  top: 10px;
  left: 1px;
  float: left;
  width: 5px;
  height: 5px;
  -webkit-border-radius: 50%;
  border-radius: 50%;
  background: #fff;
  -moz-box-shadow: -1px -1px 2px rgba(0,0,0,0.4);
  -webkit-box-shadow: -1px -1px 2px rgba(0,0,0,0.4);
  box-shadow: -1px -1px 2px rgba(0,0,0,0.4);
  }


</style>





                           <h5><i class="fa fa-tags" aria-hidden="true"></i>&nbsp;&nbsp;Matched tags</h5>
                        <div class="tags-area">
    
      <span title="" href="" class="color5">Internet</span>
      <span title="" href="" class="color5">Web servers</span>
      <span title="" href="" class="color5">Engineer</span>
      <span title="" href="" class="color5">Networks</span>
    
  </div></div>
                       
                     </div>
                     
                     </div>

<div id="result-1-more" class="collapse" style="margin-left:-15px;margin-top:20px;">



                       

<div class="col-md-12" style="margin-bottom:15px;">
 <h5>Description</h5>
                        <p>The aims of this module are: to provide an overall understanding of the communication model used on the Internet,
                           to provide an in-depth understanding of the main underlying software components of the Internet to provide an overview of the main languages used on the Internet,
                           to provide an understanding of security threats to Internet application and main techniques used to tackle them.
                        </p>
</div>


<div class="col-md-4" style="margin-bottom:15px;">
<h5><i class="fa fa-briefcase" aria-hidden="true"></i>&nbsp;&nbsp;Careers for this module</h5>
                        <p>Read, from, model, okay</p>
</div>

<div class="col-md-4" style="margin-bottom:15px;">
 <h5><i class="fa fa-check-circle-o" aria-hidden="true"></i>&nbsp;&nbsp;Requirements/Pre-requisites</h5>
                        <p>(none)</p>
                      
</div>

<div class="col-md-4" style="margin-bottom:15px;">
  <h5><i class="fa fa-users" aria-hidden="true"></i>&nbsp;&nbsp;Lecturer(s)</h5>
                        <p>Dr Steve Phelps and Dr Samhar Mahmood</p>
</div>

<div class="col-md-4" style="margin-bottom:15px;">

                        <h5><i class="fa fa-book" aria-hidden="true"></i>&nbsp;&nbsp;Assessment methods</h5>
                        <p>80% exam, 20% coursework</p>
</div>

<div class="col-md-4" style="margin-bottom:15px;">
 <h5><i class="fa fa-pencil-square-o" aria-hidden="true"></i>&nbsp;&nbsp;Exam:Coursework ratio</h5>
                        <p>80:20</p>
</div>


<div class="col-md-4" style="margin-bottom:15px;">
 <h5><i class="fa fa-graduation-cap" aria-hidden="true"></i>&nbsp;&nbsp;Pass rate</h5>
                        <p>65%</p>
</div>


            










                     </div>



                  </div>
               </div>














            </div>
            <?php include 'includes/aftercontent.php' ?>
         </div>
      </div>
      <?php include 'includes/partial-footer.php'; ?>
   </body>
</html>