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
var database = "music"; // "music" or "toy"


var emit = function(arg1, arg2) {
    log("emit:arg1 = " + arg1 + ", arg2 = " +arg2);
}

var onSearchSuccess = function(data) {
    log("success");
    jQuery("#results").html("success");
    log("data length = " +  data["rows"].length);
    if (data["rows"].length == 0) {
        jQuery("#results").html("nothing matched your search");
    } else {
       str = "<table><tr><th>title</th><th>artist</th><th>album</th></tr>";
       for (var i = 0; i < data["rows"].length; i++) {
           var row = data["rows"][i]["value"];
           str += "<tr>"
           str += '<td><a class="playsong" id ="' + row['file'] + '" href="#">' + row.title + '</a></td>'
           str += "<td>" + row.artist + "</td>"
           str += "<td>" + row.album + "</td>"
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

var doSearch = function() {
    var search = jQuery("#search_key").val().toLowerCase();
    var url = "/" + database + "/_design/example/_view/findBy" + jQuery("#field").val();
    
    data = {"startkey": '"' + search + '"', "endkey": '"' + search + '\u9999"'}
    
    log("url = \n" + url);
    
    jQuery.ajax({url: url,
        dataType: 'json',
        data: data,
        success: onSearchSuccess,
        error: onSearchError});
}

var onPlaySuccess = function(data) {
    jQuery("#loading").empty();
    log("in onPlaySuccess, data is " + data);
    var str = "<h1><a target='_blank' href=\"" + data + "\">Play Song</a></h1>";
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

    jQuery("#play").live("click", function(event) {
        //jQuery("#play").empty();
    });

    
});


