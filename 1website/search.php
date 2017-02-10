<?php 
/**
	This is the search page which will include the quick search bar 
	and access to the 'deep' search.
	By Feras Al-Hamadani
*/

?>
<!DOCTYPE html>
<html>
	<head>
		<title> Search | Modulect </title>
		<?php include 'includes/assets.php'; ?>
	</head>
	<body>
  	<?php include 'includes/partial-header.php'; ?>
  	<!--VERY MESSY NOT GOOD CODING PRACTICE-->
   	<style>
   	.banner {
       height: 270px;
       background-image: url(assets/banner.png), linear-gradient(-150deg, #00C1B6 0%, #136EB5 97%);
       background-size: 380px, contain;
       padding-top: 121px;
       padding-bottom: 35px;
       color:#fff;
  	}
   	</style>
   	<div class="banner">
   		<div class="row">
	   		<div class="container">
	   			<div class="col-md-8">
	   				<h1>Hi Alice. Lets find your perfect module...</h1>
	   			</div>
	   		</div>
	   	</div>
   		<div class="row">
   			<div class="container">
	   			<div id="quick-search">
	   				<div class="col-md-8">
		   				<form>
		   					<div class="form-group">
		   						<input type="text" id="inputSearch" class="form-control" placeholder="Search anything (like modules, careers, interests, etc.)" required autofocus>
		   					</div>
		   				</form>
		   			</div>
		   			<div class="col-md-4">
		   				<div class="form-group">
		   					<style>
			   					.btn {
								    color: #2ab27b;
								    background: #FFFFFF;
								    text-shadow: 0 1px 1px rgba(0, 0, 0, .1);
								    text-transform: uppercase;
								    box-shadow: 0px 3px 0px 0px #DDDDDD;
								    -webkit-transition: all 0.5s;
								    -moz-transition: all 0.5s;
								    -o-transition: all 0.5s;
								    transition: all 0.5s;
									}
									.btn:hover,
									.btn:focus {
								    background: #EEEEEE;
								    color: #2ab27b;
									}
									.btn:active {
								    background: #808080;
								    box-shadow: 0px 3px 0px 0px #a8a8a8;
									}
								</style>
		   					<button class="btn btn-lg btn-block" type="submit">Quick Search&nbsp;&nbsp;<i class="fa fa-search" aria-hidden="true"></i>
		   					</button>
		   				</div>
		   			</div>
		   		</div>
		   	</div>
	   	</div>
	  </div>
	  <?php include 'includes/partial-footer.php'; ?>
	</body>
</html>
