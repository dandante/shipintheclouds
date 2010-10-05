
    var charArray = new Array(
			' ', '!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-',
			'.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';',
			'<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
			'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
			'X', 'Y', 'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e',
			'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
			't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '', '«', '¸',
			'È', '‚', '‰', '‡', 'Â', 'Á', 'Í', 'Î', 'Ë', 'Ô', 'Ó', 'Ï', 'ƒ', '≈',
			'…', 'Ê', '∆', 'Ù', 'ˆ', 'Ú', '˚', '˘', 'ˇ', '÷', '‹', '¯', '£', 'ÿ',
			'◊', 'É', '·', 'Ì', 'Û', '˙', 'Ò', '—', '™', '∫', 'ø', 'Æ', '¨', 'Ω',
			'º', '°', '´', 'ª', '_', '_', '_', '¶', '¶', '¡', '¬', '¿', '©', '¶',
			'¶', '+', '+', '¢', '•', '+', '+', '-', '-', '+', '-', '+', '„', '√',
			'+', '+', '-', '-', '¶', '-', '+', '§', '', '–', ' ', 'À', '»', 'i',
			'Õ', 'Œ', 'œ', '+', '+', '_', '_', '¶', 'Ã', '_', '”', 'ﬂ', '‘', '“',
			'ı', '’', 'µ', '˛', 'ﬁ', '⁄', '€', 'Ÿ', '˝', '›', 'Ø', '¥', '≠', '±',
			'_', 'æ', '∂', 'ß', '˜', '∏', '∞', '®', '∑', 'π', '≥', '≤', '_', ' ');
	//-----------------------------------------------------------------------------
	
	    
		function getSignature(hexString, secretKey){
			//var form = document.forms[0];
			//var hexString = form.hexString.value;
			//var secretKey = form.secretKey.value;
			var canonicalString = chars_from_hex(hexString);
			var str_to_sign = canonicalString.replace(/\\n/g, "\n");
			var signature = encodeURIComponent(b64_hmac_sha1 (secretKey, str_to_sign));
			//document.getElementById("info").innerHTML = display(canonicalString, signature);
			return signature;
		}
	//---------------------------------------------------------------------------	
		function clean_numstr(raw_str, base){
			var ret_str = "";
			var c = "";
			var i;
			for(i=0; i < raw_str.length; i++) {
				c = raw_str.charAt(i);
				if(c == "0" || parseInt(c, base) > 0) {
					ret_str += c;
				}
			}
			return ret_str;
		}
	//---------------------------------------------------------------------------
		function chars_from_hex(hexString){
			var hex_str = clean_numstr(hexString, 16);
			var char_str = "";
			var num_str = "";
			var i;
			for(i=0; i < hex_str.length; i+=2)
				char_str += byteToChar(parseInt(hex_str.substring(i, i+2), 16));
			return(char_str);
		}
	//---------------------------------------------------------------------------
		function byteToChar(n){
			if(n==10) return "\\n";
			else if(n < 32 || n > 255) return " ";
			else return charArray[n-32];
		}
	//---------------------------------------------------------------------------
		function display(canonicalString, signature){
			var message = "String to be signed: <b>" + canonicalString + "</b>"
							+ "<br>Signature (using secret key):  <b>" + signature + "</b>"
			 				+ "<br>URL encoded signature (for query strings): <b>" + encodeURIComponent(signature) + "</b>";
			return message;
		}


/*****************************************************************************
 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
 * in FIPS PUB 180-1
 * Version 2.1a Copyright Paul Johnston 2000 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for details.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var b64pad  = "="; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */

function b64_hmac_sha1(key, data) { return binb2b64(core_hmac_sha1(key, data));}

/*
 * Calculate the SHA-1 of an array of big-endian words, and a bit length
 */
function core_sha1(x, len)
{
  /* append padding */
  x[len >> 5] |= 0x80 << (24 - len % 32);
  x[((len + 64 >> 9) << 4) + 15] = len;

  var w = Array(80);
  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;
  var e = -1009589776;

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;
    var olde = e;

    for(var j = 0; j < 80; j++)
    {
      if(j < 16) w[j] = x[i + j];
      else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
      var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
                       safe_add(safe_add(e, w[j]), sha1_kt(j)));
      e = d;
      d = c;
      c = rol(b, 30);
      b = a;
      a = t;
    }

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
    e = safe_add(e, olde);
  }
  return Array(a, b, c, d, e);

}

/*
 * Perform the appropriate triplet combination function for the current
 * iteration
 */
function sha1_ft(t, b, c, d)
{
  if(t < 20) return (b & c) | ((~b) & d);
  if(t < 40) return b ^ c ^ d;
  if(t < 60) return (b & c) | (b & d) | (c & d);
  return b ^ c ^ d;
}

/*
 * Determine the appropriate additive constant for the current iteration
 */
function sha1_kt(t)
{
  return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
         (t < 60) ? -1894007588 : -899497514;
}

/*
 * Calculate the HMAC-SHA1 of a key and some data
 */
function core_hmac_sha1(key, data)
{
  var bkey = str2binb(key);
  if(bkey.length > 16) bkey = core_sha1(bkey, key.length * chrsz);

  var ipad = Array(16), opad = Array(16);
  for(var i = 0; i < 16; i++)
  {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
  return core_sha1(opad.concat(hash), 512 + 160);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert an 8-bit or 16-bit string to an array of big-endian words
 * In 8-bit function, characters >255 have their hi-byte silently ignored.
 */
function str2binb(str)
{
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (32 - chrsz - i%32);
  return bin;
}

/*
 * Convert an array of big-endian words to a base-64 string
 */
function binb2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * (3 -  i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * (3 - (i+2)%4)) & 0xFF);
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
    }
  }
  return str;
}
//************************************************************************************

function getSecretKey() {
    var fileName = environment["user.home"] + "/.s3conf/s3config.yml";
    var yaml = readFile(fileName)
    yaml.match(/aws_secret_access_key: ([^\n]*)/)
    var secretKey = RegExp.$1;
    //print(secretKey);
    return secretKey;
}

/// main code goes here:
//main();
//getSecretKey();

if (arguments.length == 0) {
    print("quitting");
    quit();
}

var signature = getSignature(arguments[arguments.length -1], getSecretKey());
print(signature);