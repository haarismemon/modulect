<?php /** * Will form the login page / home page * @author Aqib Rashid */ ?>
<!doctype html>
<html>

<head>
    <title>modulect | welcome</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <style>
        header {
            position: fixed;
            height: 60px;
            border-bottom: 1px solid #dfe2e1;
            box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.2);
            transition: top 0.3s ease-in-out;
            height: 66px;
            width: 100%;
            background: white;
        }
        footer {
            height: 60px;
            border-top: 1px solid #dfe2e1;
        }
        #page {
            min-height: 1000px;
            background: #f9f9f9
        }
        @media (max-width: 800px) {
            header {
                position: absolute;
            }
        }
    </style>
</head>

<body>
    <header id="modulect-header">
        Feras, shouldn't be fixed on a mobile device
    </header>
    <div id="page">





    </div>
    <footer id="modulect-footer">
        Khalil
    </footer>
</body>

</html>
