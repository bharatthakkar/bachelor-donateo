<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>jQuery Validation Plugin Password Extension demo</title>

<link rel="stylesheet" type="text/css" media="screen" href="jquery.validate.password.css" />

<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="jquery.validate.js"></script>
<script type="text/javascript" src="jquery.validate.password.js"></script>

<script id="demo" type="text/javascript">
$(document).ready(function() {
	$("#register").validate();
	$("#password").valid();
	
});
</script>
<style>
label, input { float: left; }
input { margin-left: 1em; } 
label.error { display: none !important; }
.password-meter {
	float: left;
}
</style>

</head>
<body>

<form id="register">
	<label for="password">Password:</label>
	<input class="password" name="password" id="password" />
	<div class="password-meter">
		<div class="password-meter-message">&nbsp;</div>
		<div class="password-meter-bg">
			<div class="password-meter-bar"></div>
		</div>
	</div>
</form>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-2623402-1";
urchinTracker();
</script>

</body>
</html>