<?php /** * Will form the login page / home page * @author Aqib Rashid */ ?>
<!doctype html>
<html>

<head>
    <title>modulect | welcome</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <style>
    @import url('https://fonts.googleapis.com/css?family=Raleway|Open+Sans');

    body { font-family:"Raleway";color:#555459}
    p{font-family:"Open Sans"}


        header {
            position: fixed;
            height: 60px;
            border-bottom: 1px solid #dfe2e1;
            box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.2);
            transition: top 0.3s ease-in-out;
            height: 66px;
            width: 100%;
            background: white;
            z-index: 1000000000;
        }
        footer {
            height: 60px;
            border-top: 1px solid #dfe2e1;
        }
        #page {
            min-height: 1000px;
            background: #f9f9f9;
            padding-top: 80px;
        }

.login-card {     background-color: #fff;
    border-radius: 2px;
    box-shadow: 0 1px 0 rgba(0,0,0,.25);
    padding: 5px 25px 15px 25px;
    border: 1px solid #e8e8e8;}


        @media (max-width: 800px) {
            header {
                position: absolute;
            }
  [class*="col-"]{
      margin-bottom: 15px;
  }

        }
    </style>
</head>

<body>
    <header id="modulect-header">
        Feras
    </header>
    <div id="page">

<div class="container">

<div class="row">

  <div class="col-md-5 col-md-offset-1">
       <div class="col-md-12 login-card">
          <h2>Sign up</h2>
       </div>
    </div>
    <div class="col-md-5">
       <div class="col-md-12 login-card">
         <h2>Log in</h2>
       </div>
    </div>

<br /><br /><br /><br /><br /><br /><br /><br /><br />
<p>test</p>
</div>

</div>



    </div>
    <footer id="modulect-footer">
        Khalil
    </footer>
</body>

</html>
