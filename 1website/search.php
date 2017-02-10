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
		<link rel="stylesheet" type="text/css" href="assets/bootstrap-tagsinput.css">
		<link rel="stylesheet" type="text/css" href="assets/searchStyle.css">
		<script type="text/javascript" src="../includes/bootstrap-tagsinput.js"></script>
		<script type="text/javascript" src="../includes/typeahead.bundle.js"></script>
		<script type="text/javascript" src="../includes/bloodhound.js"></script>
	</head>
	<body>
  	<?php include 'includes/partial-header.php'; ?>
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
		   						<input type="text" name="searchBar" data-role="tagsinput" placeholder='Search anything (like modules, careers, interests, etc.)' required autofocus/>
		   					</div>
		   				</form>
		   			</div>
		   			<div class="col-md-4">
		   				<div class="form-group">
		   					<button id='quickButton' class="btnQuick btn btn-lg btn-block" type="submit">Quick Search&nbsp;&nbsp;<i class="fa fa-search" aria-hidden="true"></i>
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