//map:findByTitle
function(doc) {
    if (doc.title) {
        var i;
        for (i = 0; i < doc.title.length; i += 1) {
            emit(doc.title.toLowerCase().slice(i), doc);
        }
    }
}

//map:findByAlbum
function(doc) {
    if (doc.album) {
        var i;
        for (i = 0; i < doc.album.length; i += 1) {
            emit(doc.album.toLowerCase().slice(i), doc);
        }
    }
}


//map:findByArtist
function(doc) {
    if (doc.artist) {
        var i;
        for (i = 0; i < doc.artist.length; i += 1) {
            emit(doc.artist.toLowerCase().slice(i), doc);
        }
    }
}


//map:findByFile
function(doc) {
    if (doc.file) {
        var i;
        for (i = 0; i < doc.file.length; i += 1) {
            emit(doc.file.toLowerCase().slice(i), doc);
        }
    }
}

//map:findByGenre_s
function(doc) {
    if (doc.genre_s) {
        var i;
        for (i = 0; i < doc.genre_s.length; i += 1) {
            emit(doc.genre_s.toLowerCase().slice(i), doc);
        }
    }
}

//map:findByAny
function(doc) {
    for (attr in doc) {
        //log("attr = " + attr);
        if (doc[attr].indexOf) {// it's a string
            //log ("\tit's a string!");
            var i;
            var lc = doc[attr].toLowerCase();
            for (i = 0; i < lc.length; i += 1) {
                var slice = lc.slice(i); 
                //log("\t\tslice="+slice);
                emit(slice, doc);
            }
        }
    }
}


//map:findAll
function(doc) {
    emit(doc.id, doc)
}
