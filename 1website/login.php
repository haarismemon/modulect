<?php /** * Will form the login page / home page * @author Aqib Rashid */ ?>
<!doctype html>
<html>

<head>
    <title>modulect | welcome</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="https://use.fontawesome.com/bbc851b668.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css?family=Raleway|Open+Sans|Varela+Round');
        ::selection {
            background: rgba(61, 201, 179, 0.6);
            /* WebKit/Blink Browsers */
        }
        ::-moz-selection {
            background: rgba(61, 201, 179, 0.6);
            /* Gecko Browsers */
        }
        body {
            font-family: "Varela Round";
            color: #555459
        }
        p {
            font-family: "Open Sans"
        }
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
            padding-top: 90px;
        }
        .login-card {
            background-color: #fff;
            border-radius: 2px;
            box-shadow: 0 1px 0 rgba(0, 0, 0, .25);
            padding: 10px 30px 30px 30px;
            border: 1px solid #e8e8e8;
        }
        #login-area {
            margin-top: 20px;
        }

#login-area .form-control{

font-size:18px;

    padding: 25px 15px;
}

textarea:focus, input:focus, .uneditable-input:focus {
    border-color: rgba(42, 178, 123, 0.8) !important;
    box-shadow: 0 0.4px 0.4px rgba(42, 178, 123, 0.075) inset, 0 0 6px rgba(42, 178, 123, 0.6) !important;
    outline: 0 none !important;
}

.btn {


  background: #2ab27b;
    text-shadow: 0 1px 1px rgba(0,0,0,.1);
    text-transform: uppercase;
    box-shadow: 0px 3px 0px 0px #228e62;

    color: #fff;
    -webkit-transition: all 0.5s;
    -moz-transition: all 0.5s;
    -o-transition: all 0.5s;
    transition: all 0.5s;

  }
    .btn:hover, .btn:focus {
        background: rgba(42, 178, 123, 0.7);
        color: #fff;
    }
    .btn:active{background:#14563b;
    box-shadow: 0px 3px 0px 0px #228e62;}

        @media (max-width: 800px) {
            header {
                position: absolute;
            }
            [class*="col-"] {
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
                        <h2>Log in to modulect</h2>

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
                                        <label>
                                            <input type="checkbox" value="remember-me"> Remember me
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <button class="btn btn-lg btn-block" type="submit">Sign in&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i></button>
                                </div>
                                <div class="form-group">
                                  <p style="margin-top:30px;"><a href="#">Forgot your password?</a></p>
                                </div>
                            </form>
                        </div>


                    </div>
                </div>

                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <p>test</p>
            </div>

        </div>



    </div>
    <footer id="modulect-footer">
        Khalil
    </footer>
</body>

</html>
