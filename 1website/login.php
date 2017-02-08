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
      <title>modulect | login</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
      <script src="https://use.fontawesome.com/bbc851b668.js"></script>
      <link rel="stylesheet" href="style.css">
   </head>
   <body>
      <header id="modulect-header">
         Feras
      </header>
      <div id="page">
         <div class="container">
            <?php if($mock == "error"){?>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="flash-alert flash-alert-error">
                     <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Sorry, you entered an incorrect email address or password.
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
               <div class="col-md-5 col-md-offset-1">
                  <div class="col-md-12 login-card">
                     <h2>modulect log in</h2>
                     <div id="login-area">
                        <form class="form-signin">
                           <div class="form-group">
                              <label for="inputEmail" class="sr-only">Email address</label>
                              <input type="email" id="inputEmail" class="form-control" placeholder="Email: first.last@kcl.ac.uk" required autofocus>
                           </div>
                           <div class="form-group">
                              <label for="inputPassword" class="sr-only">Password</label>
                              <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
                           </div>
                           <div class="form-group">
                              <div class="checkbox">
                                 <input type="checkbox" id="remember-me" value="remember-me">
                                 <label for="remember-me">Remember me
                                 </label>
                              </div>
                           </div>
                           <div class="form-group">
                              <button class="btn btn-lg btn-block" type="submit">Log in&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i>
                              </button>
                           </div>
                           <div class="form-group">
                              <p style="margin-top:30px;"><a href="#">Forgot your password?</a>
                              </p>
                           </div>
                        </form>
                     </div>
                  </div>
               </div>
               <div class="col-md-5">
                  <div class="col-md-12 login-card">
                     <h2>register</h2>
                     <p>It's quick and easy to sign-up. Just fill in a few details and you're done!</p>
                     <div style="margin-top:20px;"><a class="btn btn-lg btn-block" type="submit">register&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i></a>
                     </div>
                  </div>
               </div>
            </div>
            <div class="row" style="margin-top:40px;">
               <div class="col-md-12 text-center">
                  <p>Need help? <a href="#">Contact KCL modulect support</a>
                  </p>
               </div>
            </div>
         </div>
      </div>
      <footer id="modulect-footer">
         Khalil
      </footer>
   </body>
</html>
