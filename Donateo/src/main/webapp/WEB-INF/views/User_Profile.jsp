<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map" %>
<%@page import ="net.codejava.springmodels.Projects" %>
<html xmlns="http://www.w3.org/1999/xhtml">


<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/bootstrap-responsive.css" rel="stylesheet"
		type="text/css">
		<link href="css/bootstrap.css" rel="stylesheet" type="text/css">
			<script type="text/javascript"
				src="http://w.sharethis.com/button/buttons.js"></script>

			<script src="http://code.jquery.com/jquery-latest.js"></script>
			<script src="css/bootstrap.js"></script>


			<!-- Bootstrap -->
			<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
				<script src="http://code.jquery.com/jquery.js"></script>
				<script src="js/bootstrap.min.js"></script>
				<head>
<title>My Profile</title>



<style>
.footer {
	position: relative;
	margin-top: 10px; /* negative value of footer height */
	height: 60px;
	clear: both;
	padding-top: 20px;
	color: #0000;
	margin-left: 20px;
}

.container-fluid {
	margin-top: 70px;
}

.navbar navbar-inverse navbar-fixed-top {
	background-colour: #f55f66;
}
</style>

<script>
	$(function() {
		$('#myTab a:last').tab('show');
	});

	$(function() {
		$('.myCarousel').carousel();
	});
</script>

				</head>

				<body>
					<div class="row-fluid">
						<div class="navbar navbar-inverse navbar-fixed-top">
							<div class="navbar-inner">
								<div class="container">
									<a class="brand" href="# donateo"> Donateo </a>
									<div class="nav-collapse collapse">
										<ul class="nav">
											<li class="active"><a href="# ok">Home</a></li>
											<li class="dropdown"><a href="#mai"
												class="dropdown-toggle && text-right" data-toggle="dropdown">Mai
													Zuhair Elkomy <b class="caret"></b>
											</a>
												<ul class="dropdown-menu">
													<li><a href="#">My Profile</a></li>
													<li><a href="#"> Account settings</a></li>
													<li class="divider"></li>
													<li><a href="#">Logout</a></li>

												</ul></li>
										</ul>
										<form class="navbar-search pull-right">
											<input type="text" class="search-query" placeholder="Search">
										</form>

									</div>
									<!--/.nav-collapse -->
								</div>
							</div>
						</div>
					</div>
					<div class="container-fluid">

						<!-- PROFILE PICTURwE-->
						<header class="jumbotron subhead" id="overview">
						<div class="container">
							<div id="pp">
							<%
							java.util.Hashtable<String, Object> x = (java.util.Hashtable<String, Object>) session
											.getAttribute("controller_table");
							java.util.ArrayList<Projects> array = new ArrayList<Projects>();
									java.util.Set entrySet = x.entrySet();
									java.util.Iterator itr = entrySet.iterator();
									Map.Entry<String, Object> entry = (Map.Entry<String, Object>) itr.next();
									while (itr.hasNext())
										System.out.println(itr.next());
									array = (ArrayList) entry.getValue();
									String name = array.get(0).getProject_name();
								%>

								<img class="photo" src="images/unknown2.png"
									style="width: 200px; height: 200px" id="profile-photo"> <TEXT
										font="italic"> hena <%=name%>
									+++  </TEXT>
							</div>
						</div>
						</header>

						<br />
						<hr style="margin-left: 20px; margin-right: 20px;" />
						<br />
						<!--  TABSSSSS -->
						<ul id="myTab" class="nav nav-tabs">
							<li class="active"><a href="#Cproject" data-toggle="tab">Current
									Projects</a></li>
							<li class=""><a href="#following" data-toggle="tab">Following</a></li>
							<li class=""><a href="#fproject" data-toggle="tab">Finished
									Project</a></li>

						</ul>
						<div id="myTabContent" class="tab-content">

							<!-----------------------  Current Projectssss--------------------------------------------- -->
							<div class="tab-pane active" id="Cproject">

								<h2>Cases !!</h2>
								<br> </br>

								<div class="carousel slide" id="trial">
									<div class="carousel-inner">


										<div class="item active">
											<div class="row-fluid  offset2 span8">
												<!--  Spannn 555555  -->
												<!--  <div class="span2" id = "casses"> -->

												<%
													for (int y = 0; y < 4; y++) {
												%>

												<div class="span2"
													style="background-color: #D0D0D0 cursor:pointer; width: 220px">
													<img class="img-circle" data-src="holder.js/140x140"
														alt="140x140" style="width: 140px; height: 140px;"
														src="images/unknown2.png" style="height:135px">
														<div style="margin-left: 10px">

															<h5 style="color: CDFFFF">Maple Bakery</h5>
															<p>${ok}</p>
															<div class="progress progress-success">
																<div class="bar" style="width: 60%;"></div>
															</div>
															<p style="color: Green">60% raised</p>
														</div>
												</div>


												<%
													}
												%>
												<!-- /.span9 -->

												<!--  </div> /.span5 -->

												<br /> <br />
											</div>
										</div>
										<div class="item">
											<div class="row-fluid  offset2 span8">

												<%
													for (int y = 0; y < 4; y++) {
												%>

												<div class="span3"
													style="background-color: #D0D0D0 cursor:pointer; width: 220px">
													<img class="img-circle" data-src="holder.js/140x140"
														alt="140x140" style="width: 140px; height: 140px;"
														src="images/unknown2.png" style="height:135px">
														<div style="margin-left: 10px">

															<h5 style="color: CDFFFF">Project 2</h5>
															<p>ok mai</p>
															<div class="progress progress-success">
																<div class="bar" style="width: 80%;"></div>
															</div>
															<p style="color: Green">80% raised</p>
														</div>
												</div>


												<%
													}
												%>

											</div>
										</div>
									</div>


									<a href="#trial" class="left carousel-control"
										data-slide="prev">&lsaquo;</a> <a href="#trial"
										class="right carousel-control" data-slide="next">&rsaquo;</a>
								</div>


							</div>
							<!------------------------------- END  Current Projectssss -->

							<!------------------------- Following   Projectssss -->
							<div class="tab-pane" id="following">

								<form id="following" class="form-horizontal" method="get"
									action="listFollowingProjects">

									<div class="row">



										<div class="span5" id="casses">
											<h3 align="left" style="color: #4FD5D6">Cases</h3>
											<%
												//for (int y  = 0 ; y <1; y ++) 
												//    {
											%>
											<a href="Register">
												<div class="span9"
													style="background-color: #D0D0D0 cursor:pointer; width: 220px">
													<img class="img-circle" data-src="holder.js/140x140"
														alt="140x140" style="width: 140px; height: 140px;"
														src="images/unknown2.png" style="height:135px">
														<div style="margin-left: 10px">

															<h5 style="color: CDFFFF">${ok}</h5>
															<p>
																hena al session ,
																<%=session.getAttribute("ok")%>
															</p>
															<div class="progress progress-success">
																<div class="bar" style="width: 60%;"></div>
															</div>
															<p style="color: Green">60% raised</p>
														</div>
												</div>
											</a>

											<%
												// }
											%>
											<!-- /.span9 -->
										</div>


										<!-- /.span5 -->


										<div class="span5" id="CF">
											<h3 align="left" style="color: #4FD5D6">Crowd Funding</h3>
											<%
												for (int y = 0; y < 2; y++) {
											%>
											<a href="Register">
												<div class="span9"
													style="background-color: #D0D0D0 cursor:pointer; width: 220px">
													<img class="img-circle" data-src="holder.js/140x140"
														alt="140x140" style="width: 140px; height: 140px;"
														src="images/unknown2.png" style="height:135px">
														<div style="margin-left: 10px">

															<h5 style="color: CDFFFF">Maple Bakery</h5>
															<p>ok mai</p>
															<div class="progress progress-success">
																<div class="bar" style="width: 60%;"></div>
															</div>
															<p style="color: Green">60% raised 30 backers</p>
														</div>
												</div> <%
 	}
 %> <!-- /.span9 -->
										</div>
										</a>
										<!-- /.span5 -->

										<div class="span5" id="camp">
											<h3 align="left" style="color: #4FD5D6">Campaigns</h3>
											<%
												for (int y = 0; y < 2; y++) {
											%>


											<a href="Register">
												<div class="span9"
													style="background-color: #D0D0D0 cursor:pointer; width: 220px">
													<img class="img-circle" data-src="holder.js/140x140"
														alt="140x140" style="width: 140px; height: 140px;"
														src="images/unknown2.png" style="height:135px">
														<div style="margin-left: 10px">

															<h5 style="color: CDFFFF">Maple Bakery</h5>
															<p>${ok}</p>
															<div class="progress progress-success">
																<div class="bar" style="width: 60%;"></div>
															</div>
															<p style="color: Green">60% raised 30 backers</p>
														</div>
												</div> <%
 	}
 %> <!-- /.span9 -->
										</div>
										</a>
										<!-- /.span5 -->


									</div>

								</form>

							</div>
							<!------------------------------ - END of Follo WING Projecctttststssssssssssssss -->
							<div class="tab-pane" id="fproject">

								<div class="media" style="margin-left: 20px;">
									<a class="pull-left" href="#"> <img src=""
										style="height: 150px; width: 150px;" class="media-object"></a>
									<div class="media-body">
										<h4 class="media-heading"></h4>

										<a href=""> View Project </a>
									</div>
								</div>

							</div>
							<!--END OF FInished    Projectssss -->


						</div>


					</div>
					<footer>
					<div style="margin-top: 150px" class="row-fluid">
						<div class="navbar navbar-inverse span12">
							<div class="navbar-inner ">
								<ul class="nav span12" style="font-size: 19px; margin-top: 20px">
									<li style="margin-right: 70px"><a href="#">FAQ</a></li>
									<li style="margin-right: 70px"><a href="#">About us</a></li>
									<li style="margin-right: 70px"><a href="#">Contact us</a>
									</li>
									<li><span class="st_twitter_large" displayText="Tweet"></span>
										<span class="st_facebook_large" displayText="Facebook"></span>
										<span class="st_sharethis_large" displayText="ShareThis"></span></li>
								</ul>
							</div>
						</div>
					</div>

					</footer>


				</body>
</html>
