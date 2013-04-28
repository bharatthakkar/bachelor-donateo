
(function() { 
		    var Dom = YAHOO.util.Dom, 
		        Event = YAHOO.util.Event; 
		 
		    Event.onDOMReady(function() { 
		        var layout = new YAHOO.widget.Layout({ 
		            minWidth: 1000, 
		            minHeight: 500, 
		            units: [ 
	
		                { position: 'top', height: 20, resize: false, body: 'top', gutter: '2px 5px' }, 
		                { position: 'right', width: 70, resize: true, body: 'right', gutter: '2px 5px' }, 
		               // { position: 'bottom',  height: 20, resize: true, body: 'bottom', gutter: '5px', maxHeight: 130 }, 
		                { position: 'left', width:50, resize: true, body: 'left', scroll: false, maxWidth: 300}, 
		                { position: 'center',body: 'center',  height: 300 ,gutter: '2px', scroll: true, minWidth: 400, maxHeight: 700} 
		            ] 
		        }); 
		        
		        
		      //  layout.setOrientation(1);
		        //layout.setBackgroundResource(R.drawable.background);
		   
		        layout.render(); 
		    
		       
		    }); 
	})();

