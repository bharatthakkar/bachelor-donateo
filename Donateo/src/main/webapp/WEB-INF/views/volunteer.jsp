<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>My Profile</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
<link href="css/bootstrap.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
<script type="text/javascript">
    stLight.options({ publisher: '12345' });
</script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="css/bootstrap.js"></script>


    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
      <script src="http://code.jquery.com/jquery.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <style>
    .footer 
{
    position: relative;
    margin-top: 10px; /* negative value of footer height */
    height: 60px;
    clear:both;
    padding-top:20px;
    color:#0000;
    margin-left:20px;
} 
   
    .container-fluid{
    margin-top:70px;
    }
    
    .navbar navbar-inverse navbar-fixed-top
    {
    background-colour:#f55f66;
    
    }
    
    </style>
    
    <script>
 
    $(function () {
      $('#myTab a:last').tab('show');
    })

     $(function () {
    	 $('#element').popover('hide');
    })

    
    
    
   
    
    </script>
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
              
                <a href="#mai" class="dropdown-toggle && text-right" data-toggle="dropdown">Resala  <b class="caret"></b></a>
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
   <div class="container-fluid">
   
   <!-- PROFILE PICTURwE-->
   
   <div id ="pp">
   
   <img class="photo" src="images/unknown2.png" style="width:200px;height:200px" id="profile-photo">
   <TEXT font = "italic">Resala  </TEXT>
 
   </div>
                     <br/>
                     <hr  style="margin-left:20px; margin-right:20px;"/>
                    <br /> 
   <!--  TABSSSSS -->
            <ul id="myTab" class="nav nav-tabs">
              <li class=""><a href="#Cproject" data-toggle="tab">Current Projects</a></li>
              <li class=""><a href="#following" data-toggle="tab">Following</a></li>
               <li class="active"><a href="#fproject" data-toggle="tab">Finished Project</a></li>
              
            </ul>
            <div id="myTabContent" class="tab-content">
            
            <!--  Current Projectssss -->
                <div class="tab-pane" id="Cproject">
                   <%int [] m = new int [3];
                              m[0]=1;
                              m[1]=2;
                              m[2]=3; %>
                              
                              <% for (int i =0;i<m.length;i++)
                            	  {
                            	  %>
                            	     <div class="media" style="margin-left:20px;"> <a class="pull-left" href="#"> <img src="images/milk.png" style="height:150px; width:150px;" class="media-object"> </a>
                         <div class="media-body">
                              <h4 class="media-heading">Project<%=m[i] %></h4>
                           
                                <p>       here the descrition of Project  <%=m[i] %>    </p> 
                                
                                   
                         </div>
                      </div> 
                      
               
                     <hr  style="margin-left:20px; margin-right:20px;"/>
                    

 
                            	 <% }
                            	  %>

                  
                    
                     <div class="pagination"  style="text-align: center">
                        <ul>
                        <li><a href="#">Prev</a></li>
                            <li><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                             <li><a href="#">4</a></li>
                               <li><a href="#">5</a></li>
                            <li><a href="#">Next</a></li>
                         </ul>
               </div> 
                 </div>
                 <!-- END  Current Projectssss -->
                 
                   <!-- Following   Projectssss -->
                 <div class="tab-pane" id="following">
                <% String check = ""; 
                
                if (check == "" )
                
                {
                %>
             <!--      <div class="media" style="margin-left:20px;"> <a class="pull-left" href="#"> <img src="" style="height:150px; width:150px;" class="media-object"> </a>
                         <div class="media-body">
                              <h4 class="media-heading"></h4>
 
                              <a href="">NO FOLLOWED PROJECT </a>       
                         </div>
                      </div> -->
                      
        <li>
         <a href="#" class="btn" id = "element" data-toggle="popover" data-placement="bottom" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus." title="" data-original-title="Popover on bottom">Popover on bottom</a> 
      <div  style="visibility: hidden"  class="popover fade bottom in" style="top: 69px; left: 371.5px; display: block;">
        <div class="arrow"></div>
         <h3 class="popover-title">Popover on bottom</h3>
        <div class="popover-content">Vivamus sagittis lacus vel augue laoreet rutrum faucibus.</div>
        </div>
        </li>
                
                <%
                
                }
                
                else {
                	
               
                %>
                     <div class="media" style="margin-left:20px;"> <a class="pull-left" href="#"> <img src="" style="height:150px; width:150px;" class="media-object"> </a>
                         <div class="media-body">
                              <h4 class="media-heading"></h4>
 
                              <a href=""> View Project  </a>       
                         </div>
                      </div> 
          <%} %>
                </div>              
             <!--   ENDDDDD   Following   Projectssss -->
              <div class="tab-pane active" id="fproject">
            
             
            
             <div>
             <li class="span4">
             
              <% 
             for (int i=0;i<3 ; i ++) 
             
             {
             
             %>
                <div class="thumbnail">
                  <img  alt="300x200" style="width: 200px; height: 100px;" src = 'images/milk.png'>
                  <div class="caption">
                    <h3> Project <%= i %> ! </h3>
                       <p>  okokokokok </p>
                    <p><a href="#" class="btn btn-primary">View Project</a>
                  </div>
                </div>
                 <br>
                     <hr  style="margin-left:20px; margin-right:30px;"/>
                     </br>
             <%
             }
 
      %>     
              </li> 
              </div>
             
  
                </div>  
                <!--END OF FInished    Projectssss -->            
             
             
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
