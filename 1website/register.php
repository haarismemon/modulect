<?php
   /**
   * Will form the registration
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
    <?php include 'includes/assets.php'; ?>
   </head>
   <body>
     <?php include 'includes/partial-header.php'; ?>
      <div id="page">
         <div class="container">
            <?php if($mock == "error"){?>
            <div class="row">
               <div class="col-md-6 col-md-offset-3">
                  <div class="flash-alert flash-alert-error">
                     <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> You did something wrong.
                  </div>
               </div>
            </div>
            <?php }
               else if($mock == "success"){?>
            <div class="row">
               <div class="col-md-6 col-md-offset-3">
                  <div class="flash-alert flash-alert-success">
                     <i class="fa fa-check" aria-hidden="true"></i> You successfully did something.
                  </div>
               </div>
            </div>
            <?php } ?>
            <div class="row">
               <div class="col-md-6 col-md-offset-3">
                  <div class="col-md-12  login-card">
                     <h2>Sign up</h2>
                     <div id="login-area">
                        <form>
                           <div class="form-group">
                              <label for="inputName" class="sr-only">Name</label>
                              <input type="text" id="inputName" class="form-control" placeholder="Full name" required autofocus>
                           </div>
                           <div class="form-group">
                              <label for="inputEmail" class="sr-only">Email address</label>
                              <input type="email" id="inputEmail" class="form-control" placeholder="Email: first.last@kcl.ac.uk" required>
                           </div>
                           <div class="form-group">
                              <label for="inputPassword" class="sr-only">Password</label>
                              <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
                           </div>
                           <div class="form-group">
                              <label for="inputCPassword" class="sr-only">Confirm Password</label>
                              <input type="password" id="inputCPassword" class="form-control" placeholder="Confirm password" required>
                           </div>
                           <div class="form-group">
                              <button class="btn btn-lg btn-block" type="submit">Sign up&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i>
                              </button>
                           </div>
                           <div class="form-group">
                              <p style="margin-top:30px;"><a href="/login.php">< Want to login instead?</a>
                              </p>
                           </div>
                        </form>
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
