<!DOCTYPE html>
<html>
<head>

<title>
Volunteer
</title>


<meta charset="utf-8" />
<title>Volunteer</title>


<!-- JS -->
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>

<!-- Combo-handled YUI JS files: --> 
<script type="text/javascript" src="http://yui.yahooapis.com/combo?2.9.0/build/yahoo-dom-event/yahoo-dom-event.js&2.9.0/build/animation/animation-min.js&2.9.0/build/dragdrop/dragdrop-min.js&2.9.0/build/element/element-min.js&2.9.0/build/resize/resize-min.js&2.9.0/build/layout/layout-min.js"></script> 
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
<!-- Combo-handled YUI CSS files: --> 
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.9.0/build/reset-fonts-grids/reset-fonts-grids.css&2.9.0/build/resize/assets/skins/sam/resize.css&2.9.0/build/layout/assets/skins/sam/layout.css"> 
<link rel="stylesheet" type="text/css"href="http://yui.yahooapis.com/2.9.0/build/reset-fonts-grids/reset-fonts-grids.css">



<!-- CSS -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
<link href="Register.css" rel="stylesheet">
<link href="form.css" rel="stylesheet">
<link rel="stylesheet" href="/resources/demos/style.css" />

<!-- JSS tany  -->
<script src="jquery.js"></script>
<script src="layout.js"></script>
<script type="text/javascript" src="jquery.validate.js"></script>




<style>

#login{

width:600px;
}

</style>

 
  <script> 
  $(document).ready(function(){
  $("#volunteer").validate();
 
 });

	 
  $(function() {
	    $( "#datepicker" ).datepicker();
	  });

	
		 
	function viewDiv()
	{
	   if( typeof viewDiv.counter == 'undefined' ) { 
	     viewDiv.counter = 2;
	 }
	else {
	if (viewDiv.counter== 11)
	{
		viewDiv.counter=2;
		} 
	  }
	document.getElementById("div"+viewDiv.counter.toString()).className="viewDiv";

	$( "#datepicker"+viewDiv.counter.toString()).datepicker();
	  viewDiv.counter++;
	}
  
  </script>





</head>

<body id="public">
<div id="center">
<div id="container" class="ltr">

<h1 id="logo">
<a ></a>
</h1>



<header id="header" class="info">
<h2>Volunteer</h2>
<div></div>
</header>
<form id="volunteer" name="volunteer"   autocomplete="off" enctype="multipart/form-data" method="Post" action="Register" >

<h1>Which days can you volunteer?  </h1>

<li>
<div id="div" class="viewDiv">
<p>Date: </p>

<input type="text" class="required number && field text ln"  id="datepicker"/>

</div>

</li>
<li>
<div id="div2" class="hideDiv" >
<p>Date:  </p>
<input type="text" id="datepicker2"/>
</div>
</li>


<li>
<div id="div3" class="hideDiv">
<p>Date: </p>
 <input type="text" id="datepicker3"/>
</div>
</li>

<li>
<div id="div4" class="hideDiv">
<p>Date: </p> <input type="text" id="datepicker4"/>
</div>
</li>

<li>
<div id="div5" class="hideDiv">
<p>Date:</p>
 <input type="text" id="datepicker5"/>
</div>
</li>

<li>
<div id="div6" class="hideDiv">

<p>Date:</p>
 <input type="text" id="datepicker6"/>
</div>
</li>

<li>
<div id="div7" class="hideDiv">
<p>Date: <input type="text" id="datepicker7"/>
</div>
</li>
 <li>
<div id="div8" class="hideDiv">
<h6>Sorry u can only volunteer for 7 days =)</h6>
</div>
</li>



<input type="submit" value="submit" />

</form>
<button onclick="viewDiv()">One more Day</button>

<!--  <a href="">Remove</a>-->
</div> 
</div>
</body>

</html>