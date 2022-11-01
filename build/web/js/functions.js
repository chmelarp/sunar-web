/*
*	Tomáš Krejčíř(xkrejc31), JavaScript file
*/

//-----------------------------------------------------------
//  Nastavení CSS souboru
//-----------------------------------------------------------
function cssfile() {
    document.write('<link rel="stylesheet" type="text/css" id="css" ');

    var cookies = document.cookie;
    var cname='STYLE';
    var stylename='user.css';
    var pos1 = cookies.indexOf(escape(cname) + '=');

    if (pos1 != -1) {
        pos1 = pos1 + (escape(cname) + '=').length;
        pos2 = cookies.indexOf(';', pos1);
        if (pos2 == -1) pos2 = cookies.length;

        stylename = cookies.substring(pos1, pos2);
    }

    document.write('href="css/'+unescape(stylename)+'" />');
}

//cas = new Date();
//cas.setTime(cas_s.getTime() + 3600*24*7*30);

