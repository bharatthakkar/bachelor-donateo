<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>jQuery Validation Plugin Password Extension demo</title>

<link rel="stylesheet" type="text/css" media="screen" href="milk.css" />
<link rel="stylesheet" type="text/css" media="screen" href="jquery.validate.password.css" />

<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="jquery.validate.js"></script>
<script type="text/javascript" src="jquery.validate.password.js"></script>

<script id="demo" type="text/javascript">
$(document).ready(function() {
	// validate signup form on keyup and submit
	var validator = $("#signupform").validate({
		rules: {
			username: {
				required: true,
				minlength: 2
			},
			password: {
				password: "#username"
			},
			password_confirm: {
				required: true,
				equalTo: "#password"
			}
		},
		messages: {
			username: {
				required: "Enter a username",
				minlength: jQuery.format("Enter at least {0} characters")
			},
			password_confirm: {
				required: "Repeat your password",
				minlength: jQuery.format("Enter at least {0} characters"),
				equalTo: "Enter the same password as above"
			}
		},
		// the errorPlacement has to take the table layout into account
		errorPlacement: function(error, element) {
			error.prependTo( element.parent().next() );
		},
		// specifying a submitHandler prevents the default submit, good for the demo
		submitHandler: function() {
			alert("submitted!");
		},
		// set this class to error-labels to indicate valid fields
		success: function(label) {
			// set &nbsp; as text for IE
			label.html("&nbsp;").addClass("checked");
		}
	});
	
	// propose username by combining first- and lastname
	$("#username").focus(function() {
		var firstname = $("#firstname").val();
		var lastname = $("#lastname").val();
		if(firstname && lastname && !this.value) {
			this.value = firstname + "." + lastname;
		}
	});
	
});
</script>

</head>
<body>

<div id="main">

<div id="content">

<div id="header">
  <div id="headerlogo"><img src="images/milk.png" alt="Remember The Milk" /></div>
</div>
<div style="clear: both;"><div></div></div>


<div class="content">
    <div id="signupbox">
       <div id="signuptab">
        <ul>
          <li id="signupcurrent"><a href=" ">Signup</a></li>
        </ul>
      </div>
      <div id="signupwrap">
      		<form id="signupform" autocomplete="off" method="get" action="">
	  		  <table>
	  		  <tr>
	  			<td class="label"><label id="lusername" for="username">Username</label></td>
	  			<td class="field"><input id="username" name="username" type="text" value="" maxlength="50" /></td>
	  			<td class="status"></td>
	  		  </tr>
	  		  <tr>
	  			<td class="label"><label id="lpassword" for="password">Password</label></td>
	  			<td class="field"><input id="password" name="password" type="password" maxlength="50" value="" /></td>
	  			<td class="status">
	  				<div class="password-meter">
		<div class="password-meter-message">&nbsp;</div>
		<div class="password-meter-bg">
			<div class="password-meter-bar"></div>
		</div>
	</div>
				</td>
	  		  </tr>
	  		  <tr>
	  			<td class="label"><label id="lpassword_confirm" for="password_confirm">Confirm Password</label></td>
	  			<td class="field"><input id="password_confirm" name="password_confirm" type="password" maxlength="50" value="" /></td>
	  			<td class="status"></td>
	  		  </tr>
	  		  <tr>
	  			<td class="label"><label id="lsignupsubmit" for="signupsubmit">Signup</label></td>
	  			<td class="field" colspan="2">
	            <input id="signupsubmit" name="signup" type="submit" value="Signup" />
	  			</td>
	  		  </tr>

	  		  </table>
          </form>
      </div>
    </div>
</div>

</div>

</div>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-2623402-1";
urchinTracker();
</script>

</body>
</html>