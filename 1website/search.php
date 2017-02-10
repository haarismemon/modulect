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
	   			<h1>Hi Alice. Lets find your perfect module...</h1>
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
