<?php
   /**
   * Will form the results page
   * author Aqib Rashid
   */
      $mock = "";
      if(isset($_GET['mock'])) {
        $mock = $_GET['mock'];
      }
      $results = "";
      if(isset($_GET['results'])) {
        $results = $_GET['results'];
      }
      ?>
<!doctype html>
<html>
   <head>
      <title>Search results | Modulect</title>
      <?php include 'includes/assets.php'; ?>
      <style>
         @media print {
         .navbar,.banner, footer, .sort-area, .save-button, .more-info-link, .here-what{display:none;}
         .collapse{display:block;}
         }
      </style>
   </head>
   <body>
      <?php include 'includes/partial-header.php'; ?>
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
            <?php if($results == "false") { ?>
            <div class="row" style="margin-bottom:20px;">
               <div class="col-md-10 col-md-offset-1 text-center">
                  <h1>No modules found :(</h1>
               </div>
            </div>
            <?php } else { ?>
            <div class="row here-what" style="margin-bottom:20px;">
               <div class="col-md-6 col-md-offset-1">
                  <h1>Here's what we found:</h1>
                  <h5>Showing 2 modules</h5>
               </div>
               <div class="col-md-4 text-right" style="padding-top:30px;">
                  <div class="sort-area">
                     Sort by: &nbsp;&nbsp;
                     <select class="selectpicker">
                        <option value="tags" selected>Tag match %</option>
                        <option value="coursework">Coursework weighting</option>
                        <option value="exam">Exam weighting</option>
                        <option value="pass">Pass rate</option>
                     </select>
                  </div>
               </div>
            </div>
            <div class="row nomobile" style="margin-top:-20px;margin-bottom:10px;">
               <div class="col-md-10 col-md-offset-1 text-right">
                  <ul class="results-page-options">
                     <li><a href="javascript:void()" onClick="window.print()"><i class="fa fa-print" aria-hidden="true"></i>&nbsp;&nbsp;Print page</a></li>
                     <?php if($login == "true") { ?>
                     <li><a href="#"><i class="fa fa-envelope" aria-hidden="true"></i>&nbsp;&nbsp;Email advisor</a> </li>
                     <?php } ?>
                  </ul>
               </div>
            </div>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <!--BEGIN CARD -->
                  <div class="col-md-12 login-card res-card result-card-green" >
                     <div class="row">
                        <div class="col-md-9 result-card-main">
                           <h2>5CCS2INS Internet Systems</h2>
                           <h4>Second Year, Semester 1 - 15 Credits</h4>
                           <div style="margin-top:30px">
                              <?php if($login == "true") { ?>
                              <a href="#" class="btn btn-lg btn-small save-button"><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
                              <?php } else { ?>
                              <a class="btn btn-lg btn-small btn-disabled save-button" data-toggle="tooltip"  data-placement="right" title="To save modules, you must be logged in."><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
                              <?php } ?>
                              <a style="cursor:pointer;float:right;margin-right:10px;margin-top:5px;" data-toggle="collapse" data-target="#result-1-more" class="more-info-link">More info <i class="fa fa-angle-down" aria-hidden="true"></i></a>
                           </div>
                        </div>
                        <div class="col-md-3 result-side-column result-card-side">
                           <div class="row">
                              <h5><i class="fa fa-tag" aria-hidden="true"></i>&nbsp;&nbsp;Tag match </h5>
                              <div class="tag-match-figure" style="font-size:18px;">80%</div>
                              <p>4 out of 5</p>
                           </div>
                           <div class="row" style="margin-top:10px">
                              <style>
                              </style>
                              <h5><i class="fa fa-tags" aria-hidden="true"></i>&nbsp;&nbsp;Matched tags</h5>
                              <div class="tags-area">
                                 <span title="" href="" class="color5">Internet</span>
                                 <span title="" href="" class="color5">Web servers</span>
                                 <span title="" href="" class="color5">Engineer</span>
                                 <span title="" href="" class="color5">Networks</span>
                              </div>
                           </div>
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
                  <!--END CARD -->
                  <!--BEGIN CARD -->
                  <div class="col-md-12 login-card res-card result-card-orange" >
                     <div class="row">
                        <div class="col-md-9 result-card-main">
                           <h2>5CCS2SEG Sofware Engineering Group Project</h2>
                           <h4>Second Year, Semester 1 & 2 - 30 Credits</h4>
                           <div style="margin-top:30px">
                              <?php if($login == "true") { ?>
                              <a href="#" class="btn btn-lg btn-small save-button"><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
                              <?php } else { ?>
                              <a class="btn btn-lg btn-small btn-disabled save-button" data-toggle="tooltip"  data-placement="right" title="To save modules, you must be logged in."><i class="fa fa-star" aria-hidden="true"></i>&nbsp;&nbsp;Save Module</a>
                              <?php } ?>
                              <a style="cursor:pointer;float:right;margin-right:10px;margin-top:5px;" class="more-info-link" data-toggle="collapse" data-target="#result-2-more">More info <i class="fa fa-angle-down" aria-hidden="true"></i></a>
                           </div>
                        </div>
                        <div class="col-md-3 result-side-column result-card-side">
                           <div class="row">
                              <h5><i class="fa fa-tag" aria-hidden="true"></i>&nbsp;&nbsp;Tag match </h5>
                              <div class="tag-match-figure" style="font-size:18px;">40%</div>
                              <p>2 out of 5</p>
                           </div>
                           <div class="row" style="margin-top:10px">
                              <style>
                              </style>
                              <h5><i class="fa fa-tags" aria-hidden="true"></i>&nbsp;&nbsp;Matched tags</h5>
                              <div class="tags-area">
                                 <span title="" href="" class="color5">Internet</span>
                                 <span title="" href="" class="color5">Engineer</span>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div id="result-2-more" class="collapse" style="margin-left:-15px;margin-top:20px;">
                        <div class="col-md-12" style="margin-bottom:15px;">
                           <h5>Description</h5>
                           <p>SEG The aims of this module are: to provide an overall understanding of the communication model used on the Internet,
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
                           <p>Dr Jeroen Keppens</p>
                        </div>
                        <div class="col-md-4" style="margin-bottom:15px;">
                           <h5><i class="fa fa-book" aria-hidden="true"></i>&nbsp;&nbsp;Assessment methods</h5>
                           <p>15% exam, 85% coursework (assessed over 3 projects)</p>
                        </div>
                        <div class="col-md-4" style="margin-bottom:15px;">
                           <h5><i class="fa fa-pencil-square-o" aria-hidden="true"></i>&nbsp;&nbsp;Exam:Coursework ratio</h5>
                           <p>15:85</p>
                        </div>
                        <div class="col-md-4" style="margin-bottom:15px;">
                           <h5><i class="fa fa-graduation-cap" aria-hidden="true"></i>&nbsp;&nbsp;Pass rate</h5>
                           <p>85%</p>
                        </div>
                     </div>
                  </div>
                  <!--END CARD -->
               </div>
            </div>
            <?php } ?>
            <?php include 'includes/aftercontent.php' ?>
         </div>
      </div>
      <?php include 'includes/partial-footer.php'; ?>
   </body>
</html>