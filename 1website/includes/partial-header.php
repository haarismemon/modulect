<?php
/**
 * Purely for development and testing purposes
 * @author Aqib Rashid
 * @author Feras Al-Hamadani
 */
?>
<!--Header stuff goes here-->
<nav class="navbar navbar-default" id="nav">

      <div class="container">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/"><img style="height:50px;" src="assets/modulect-logo.png"></a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav navbar-right">
            <!-- this would be our current page, but it is static for now -->
            <li><a href="#">About<span class="sr-only">(current)</span></a></li>
            <li><a href="#">Search <i class="fa fa-search" aria-hidden="true"></i></a></li>
            <li><a href="#">Saved <i class="fa fa-star-o" aria-hidden="true"></i></a></li>
            <li class="dropdown">
              <button class="btn btn-drop btn-default navbar-btn dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Welcome Alice <span class="caret"></span></button>
              <ul class="dropdown-menu">
                <li><a href="#">Profile</a></li>
                <li role="separator" class="divider"></li>
                <li><a href="#">Log Out</a></li>
              </ul>
            </li>
          </ul>
        </div><!-- /.navbar-collapse -->
      </div><!-- /.container-fluid -->
    </nav>