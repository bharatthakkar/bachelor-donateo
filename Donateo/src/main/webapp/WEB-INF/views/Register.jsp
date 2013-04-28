<!DOCTYPE html> 
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Registration form </title>
   
   

<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>

   
    <link href="css\bootstrap.css" rel="stylesheet">
    <link href="css\bootstrap-responsive.css" rel="stylesheet">

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
      <script src="http://code.jquery.com/jquery.js"></script>
    <script src="js/bootstrap.min.js"></script>

  
    <!-- Javascript placed at the end of the file to make the  page load faster -->
    <script src="http://twitter.github.com/bootstrap/assets/js/jquery.js"></script>
    
   <!--   <script src="js\bootstrap-button.js"></script>-->
<script type="text/javascript" src="jquery.validate.js"></script>
	  
	
	  <script type="text/javascript">
	  
	  
	  
	  $(document).ready(function(){
			
			$("#signup").validate({
				rules:{
					name:"required",
					
					email:{
							required:true,
							email: true,
						//source.errormessage = "custom message here";
							//errorMessage="Please select an option",
						},
					password:{
						required:true,
						minlength: 8
					},
					conpasswd:{
						required:true,
						equalTo: "#password",
				
					},
					
					phone:"required",
					
					address:"required"
					
				},
				
				/* messages: {
				       name: "Enter your User Name",
				       address: "Enter your Address",
				       password : "Enter Your Password",
				       conpasswd : "Please Confirm Password",
				       phone : "Enter Your Phone phone",
				       email : "Enter Your Email Address",
				        username: {
				            required: "Enter a username",
				            minlength: jQuery.format("Enter at least {0} characters"),
				            remote: jQuery.format("{0} is already in use")
				    } 
				},*/
				
				error: "help-inline"
				
			});
		});
	  </script>
	
	  
	  <style type="text/css">
	  .well
	  {
	  margin-top: 100px;
	  
	  }
	  
	  .error {
   color: red;
   font-size: 12px;
}
	  </style>
	  
	  
	  
</head>
  <body>	 
  
  
  <div class="row-fluid">
  <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
  <!--  <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>    -->
          <a class="brand" href="# donateo"> Donateo </a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li class="active"><a href="# ok">Home</a></li>
              <li class="dropdown">
              
                <a href="#mai" class="dropdown-toggle && text-right" data-toggle="dropdown">Mai Zuhair Elkomy <b class="caret"></b></a>
                <ul class="dropdown-menu">
                  <li><a href="#">My Profile</a></li>
                  <li><a href="#"> Account settings</a></li>
                
                  <li class="divider"></li>
                  <li><a href="#">Logout</a></li>
                  
                </ul>
              </li>
            </ul>
        <form class="navbar-search pull-right">
  <input type="text" class="search-query" placeholder="Search">
</form>
           
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
      </div>  
	
 	    <div class="container">

<div class="well">    
      <form id="signup" class="form-horizontal" method="post" action="">
		<legend>Sign Up</legend>		
		<div class="control-group">
	        <label class="control-label">User Name</label>
			<div class="controls">
			    <div class="input-prepend">
				<span class="add-on"><i class="icon-user"></i></span>
					<input type="text" class="required && field text ln && error" id="name" name="name" placeholder="User Name">
				</div>
			</div>
		</div>
		<div class="control-group">
	        <label class="control-label">Email</label>
			<div class="controls">
			    <div class="input-prepend">
				<span class="add-on"><i class="icon-envelope"></i></span>
					<input type="text" class="required && field text ln && error"  id="email" name="email" placeholder="Email">
				</div>
			</div>	
		</div>
	<div class="control-group">
	        <label class="control-label">Address </label>
			<div class="controls">
			    <div class="input-prepend">
			    <link rel="shortcut icon" href="favicon.ico">
				<span class="add-on"><i class="icon-home"></i></span>
					<input type="text" class="required && field text ln && error" id="address" name="address" placeholder="address">
				</div>
			</div>
		</div>
		
		
			<div class="control-group">
	        <label class="control-label">Phone Number </label>
			<div class="controls">
			    <div class="input-prepend">
			    <link rel="shortcut icon" href="favicon.ico">
				<span class="add-on"><i class="icon-pencil"></i></span>
					<input type = "number"class="required && field text ln && error" id="phone" name="phone" placeholder="phone">
				</div>
			</div>
		</div>
		<div class="control-group">
	        <label class="control-label">Password</label>
			<div class="controls">
			    <div class="input-prepend">
				<span class="add-on"><i class="icon-lock"></i></span>
					<input type="Password" id="password" class="required && field text ln && error"  name="password" placeholder="Password">
				</div>
			</div>
		</div>
		<div class="control-group">
	        <label class="control-label">Confirm Password</label>
			<div class="controls">
			    <div class="input-prepend">
				<span class="add-on"><i class="icon-lock"></i></span>
					<input type="Password" id="conpasswd " class="required && field text ln && error" name="conpasswd" placeholder="Re-enter Password">
				</div>
			</div>
		</div>
		
		<div class="control-group">
		<label class="control-label" for="input01"></label>
	      <div class="controls">
	       <button type="submit" class="btn btn-success" rel="tooltip" title="first tooltip">Create My Account</button>
	       
	      </div>
	
	</div>
	
	  </form>

   </div>
</div>
   

<footer>
  <div  style= "margin-top:150px" class="row-fluid">
  <div class="navbar navbar-inverse span12">
    <div class="navbar-inner " >
      <ul class="nav span12" style="font-size:19px; margin-top:20px">
        <li style="margin-right:70px"> <a href="#" >FAQ</a> </li>
        <li style="margin-right:70px"> <a href="#" >About us</a> </li>
        <li style="margin-right:70px"> <a href="#" >Contact us</a> </li>
        <li > <span class="st_twitter_large" displayText="Tweet"></span> <span class="st_facebook_large" displayText="Facebook"></span> <span class="st_sharethis_large" displayText="ShareThis"></span></li>
      </ul>
    </div>
  </div>
  </div>
  
</footer>
  

  

  </body>
</html>

