// logging functions:
var fb_lite = false;
try {
	if (firebug) {
		fb_lite = true;  
		firebug.d.console.cmd.log("initializing firebug logging");
	}
} catch(e) {
	// do nothing
}



function log(message) {
	if (fb_lite) {  
		console.log(message);
	} else {
		if (window.console) {
			console.log(message);
		} 
	}
	if (window.dump) {
	    dump(message + "\n");
	}
}

// convenience functions
String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.ltrim = function() {
	return this.replace(/^\s+/,"");
}
String.prototype.rtrim = function() {
	return this.replace(/\s+$/,"");
}

//utility functions
var getParameterByName = function ( name ) {
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return decodeURIComponent(results[1].replace(/\+/g, " "));
}

//global variables
//var database = "music"; // "music" or "toy"
var database = "toy";

var emit = function(arg1, arg2) {
    log("emit:arg1 = " + arg1 + ", arg2 = " +arg2);
}

var uniquify = function(rows) {
    var hsh = {}
    var output = [];
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (!hsh[row["id"]]) {
            output.push(row);
        }
        hsh[row["id"]] = 1;
    }
    return output;
}

var onSearchSuccess = function(data) {
    log("success");
    jQuery("#results").html("success");
    log("data length = " +  data["rows"].length);
    if (data["rows"].length == 0) {
        jQuery("#results").html("nothing matched your search");
    } else {
       var rows = data["rows"];
       //rows = uniquify(rows);
       str = "<table><tr><th>title</th><th>artist</th><th>album</th></tr>";
       for (var i = 0; i < rows.length; i++) {
           var id = rows[i]["id"];
           var row = rows[i]["value"];
           var file = row.file;
           var segs = file.split(".");
           var fileType = segs[segs.length -1];
           str += "<tr>"
           str += '<td><a class="playsong" id ="' + id + '.' + fileType +'" href="#">' + row.title + '</a></td>'
           str += "<td>" + row.artist + "</td>"
           str += "<td>" + row.album + "</td>"
           str += "<td>" + file + "</td>"
           str += "</tr>";
       } 
       str += "</table>";
       jQuery("#results").html(str);
    }
}

var onSearchError = function(xmlHttpRequest, textStatus, errorThrown) {
    log("failure");
    jQuery("#results").html("oops, there was an error");
}

var checkForEnter = function(event) {
    if(event.keyCode == 13) {
        doSearch();
    }
}


var handleSelection = function(id) {
    log("in handleSelection, id is "  + id);
}

var doSearch = function() {
    var search = jQuery("#search_key").val().toLowerCase();
    var field = jQuery("#field").val();

    //jQuery("#grid").empty();
    //jQuery("#pager").empty();
    
    jQuery("#grid").jqGrid({
	   	url:'/main/search?query=' + search + "&searchcol=" + field,
	   	width: 500,
	   	onSelectRow: function(id) {
	   	    log("you selected a row with id: " + id);
	   	},
	   	beforeRequest: function() {
	   	  log("in beforeRequest event handler");
	   	},
	   	gridComplete: function() {
	   	  log("in gridComplete event handler");
	   	},
	   	loadComplete: function(data) {
	   	  log("in loadComplete event handler");
	   	  log("data is: " + data);
	   	  log("more: " + data['rows'][0]['song']['artist']);
	   	},
	   	loadError: function(xhr, status, error) {
	   	  log("in loadError handler, xhr = " + xhr + ", status = " + status + ", error = " + error);
	   	},
		datatype: "json",
		colNames:['Title', 'Artist', 'Album', 'File', 'Length', 'id', 'uuid'],
	   	colModel:[
   		    {name:'title',index:'title', width:55},
	   		{name:'artist',index:'arist', width:55},
	   		{name:'album',index:'album', width:55},
	   		{name:'file',index:'file', width:55},
	   		{name:'length',index:'length', width:55},
	   		{name:'id',index:'id', width:55},
	   		{name:'uuid',index:'uuid', width:55}
	   	],
	   	rowNum:20,
	   	rowList:[10,20,30],
	   	pager: '#pager',
	   	sortname: 'id',
	   	jsonReader: {
	   	  root: "rows",
	   	  page: "page",
	   	  total: "totalpages",
	   	  records: "totalrecords",
	   	  cell: "song",
	   	  //id: "id",
	   	  repeatitems: false
	   	},
	    viewrecords: true,
	    sortorder: "asc",
	    hidegrid: false,
	    caption:"Results"
	});
	jQuery("#grid").jqGrid('navGrid','#pager',{edit:false,add:false,del:false});
}

var onPlaySuccess = function(data) {
    jQuery("#loading").empty();
    log("in onPlaySuccess, data is " + data);
    var str = "<a target='_blank' href=\"" + data + "\">Play Song</a>";
    jQuery("#play").html(str);
}

var onPlayError = function(xmlHttpRequest, textStatus, errorThrown) {
    jQuery("#loading").empty();
    log("in onPlayError");
}

var playSong = function(song) {
    jQuery.ajax({
        url: "/main/get_url",
        data: {"song": song},
        success: onPlaySuccess,
        error: onPlayError
    });
}

// set up audio player
/*
AudioPlayer.setup("/javascripts/player.swf", {  
                width: 290,
                checkpolicy: "yes"  
            });

*/

// document ready function
jQuery(function() {
    jQuery("#search_key").focus();
    
    jQuery("#search_key").keydown(checkForEnter);
    
    jQuery(".playsong").live("click", function(event){
        event.preventDefault();
        var song = jQuery(this).attr("id");
        log("playing song " + song);
        jQuery("#loading").html("Loading...");
        playSong(song);
    });

    jQuery("#search_button").live("click", function(event){
        doSearch()
    });
    
    jQuery("#play").live("click", function(event) {
        //jQuery("#play").empty();
    });

    
});


