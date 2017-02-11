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
	   			<div class="col-md-12">
	   				<?php if($login == "true" && $ftLogin == "false") { ?>
	   					<h1>Hi Alice. Lets find your perfect module...</h1>
	   				<?php }
            else if($login == "false") {
            ?>
            	<h1>Hi Stranger. Lets find your perfect module...</h1>
            <?php
            }
            ?>
	   			</div>
	   		</div>
	   	</div>
   		<div class="row">
   			<div class="container">
	   			<div id="quick-search">
	   				<div class="col-md-8">
		   				<form>
		   					<div class="form-group">
		   						<input type="text" data-role="tagsinput" placeholder='Search anything (like modules, careers, interests, etc.)' required autofocus/>
		   						<script>
										var modules = new Bloodhound({
										  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
										  queryTokenizer: Bloodhound.tokenizers.whitespace,
										  prefetch: {
										    url: 'assets/module-list.json',
										    filter: function(list) {
										      return $.map(list, function(modules) {
										        return { name: modules }; });
										    }
										  }
										});
										modules.initialize();

										$('input').tagsinput({
										  typeaheadjs: {
										    name: 'modules',
										    displayKey: 'name',
										    valueKey: 'name',
										    source: modules.ttAdapter()
										  },
										  freeInput: false
										});
									</script>
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

	  <div id="page">
	  	<div class="container login-card">
		  		<div class="col-md-12">
		  			<div class="row">
			  			<h1>Start a Pathway Search</h1>
			  			<h3 style="margin-top: 20px">Let us assist you in finding the right modules which suit your interests and career aspirations.</h3>
			  		</div>
			  	</div>
			  	<?php if($login == "true" && $ftLogin == "false") { ?>
		  		<div class="row" style="margin-top: 20px">
		  			<div class="col-md-4">
			 				<div class="form-group">
		   					<button id='pathwayButton' class="btn btn-lg btn-block" type="submit">Pathway Search&nbsp;&nbsp;<i class="fa fa-search" aria-hidden="true"></i>
		   					</button>
		   				</div>
		   			</div>
		   		</div>
		   		<?php }
            else if($login == "false") {
            ?>
            <div class="row" style="margin-top: 20px">
			  			<div class="col-md-12">
			  				<h4>In order to fully make use of the Modulect system please Register or Login</h4>
			  			</div>
			  		</div>
			  		<div class="row" style="margin-top: 20px">
			  			<div class="col-md-4">
				 				<div class="form-group">
					 				<form action="/">
				   					<button id='loginRegButton' class="btn btn-lg btn-block" type="submit">Login or Register
				   					</button>
				   				</form>
			   				</div>
			   			</div>
		   			</div>
		   			<?php
            }
            ?>
		   		</div>
		   	</div>
		   </div>
	  </div>
	  <?php include 'includes/partial-footer.php'; ?>
	</body>
</html>