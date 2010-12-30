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



var checkForEnter = function(event) {
    if(event.keyCode == 13) {
        doSearch();
    }
}


var handleSelection = function(id) {

	var ids;
	ids = jQuery("#songs").getGridParam('selarrrow');
    
    jQuery.get("/main/songs_detail", {ids: ids.join(",")}, function(data, textStatus, XMLHttpRequest){
        //var song = data['song'];
        playSong(data);
    }, "json");
}

var doSearch = function() {
    jQuery("#outer").empty();
    jQuery("#outer").html('<table id="songs" class="scroll" cellpadding="0" cellspacing="0"></table>\n<div id="songs_pager" class="scroll" style="text-align:center;">');
    gridInit();
}




var playSong = function(rawSongs) {
    jQuery("#loading").empty();
    var songs = [];
    var titles = [];
    var artists = [];
    var urls = [];
    
    for (var i = 0; i < rawSongs.length; i++) {
        var song = rawSongs[i]['song'];
        songs.push(song);
        titles.push(song.title_c);
        artists.push(song.artist_c);
        urls.push(song.url);
    }
    
    log("titles = " + titles.join(","));
    
    var str = "<a title='Play in browser or download' target='_blank' href=\"" + songs[0].url + "\">Play " + songs[0].title_c + "</a>";
    jQuery("#play").html(str);
    
    
    AudioPlayer.embed("flashplay", 
    {soundFile: urls.join(","), titles: titles.join(","), artists: artists.join(","), checkpolicy: "yes",
    remaining: "yes"}); 
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

    jQuery("#search_button").live("click", function(event){
        doSearch();
    });
    
    jQuery("#play").live("click", function(event) {
        //jQuery("#play").empty();
    });

    jQuery("#search_key").focus();
    
});

var lastsel;
var gridInit = function() {
          AudioPlayer.setup("/javascripts/player.swf", {  
                     width: 290  
           });
        
    
          var url = "/main/main?q=1";
          var search = jQuery("#search_key").val().toLowerCase();
          var field = jQuery("#field").val();
          log("search =" + search);
          
          if (search != "") {
              url += "&query=" + search + "&searchcol=" + field;
          }
    
          log("url = " + url);
            
            var mygrid = jQuery("#songs").jqGrid({
                url:url,
                editurl:'',
                datatype: "json",
                colNames:['ID','Title','Artist','Album','File'],
                colModel:[{name:'id', index:'id',resizable:false,width:35},{name:'title_c', index:'title_c'},{name:'artist_c', index:'artist_c'},{name:'album_c', index:'album_c'},{name:'file_c', index:'file_c'}],
                pager: '#songs_pager',
                rowNum:14,
                rowList:[10,14,25,50,100],
                imgpath: '/images/jqgrid',
                sortname: '',
                viewrecords: true,
                hidegrid: false,
                height: 320,
                sortorder: '',
                gridview: false,
                scrollrows: true,
                autowidth: false,
                rownumbers: false,
                multiselect: true,



          onSelectRow: function(id){ 
            if(id){ 
              handleSelection(id); 
            } 
          },

                subGrid:false,

                caption: "Songs"
              })
              .navGrid('#songs_pager',
                {edit:false,add:false,del:false,search:false,refresh:true},
                {afterSubmit:function(r,data){return true;(r,data,'edit');}},
                {afterSubmit:function(r,data){return true;(r,data,'add');}},
                {afterSubmit:function(r,data){return true;(r,data,'delete');}}
              )
              .navButtonAdd("#songs_pager",{caption:"",title:"Toggle Search Toolbar", buttonicon :'ui-icon-search', onClickButton:function(){ mygrid[0].toggleToolbar() } })


              mygrid.filterToolbar();mygrid[0].toggleToolbar()
            jQuery("#search_key").focus();
            
}

