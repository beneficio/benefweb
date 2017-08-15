//Detect Browser
var IE4 = (document.all && !document.getElementById) ? true : false;
var NS4 = (document.layers) ? true : false;
var IE5 = (document.all && document.getElementById) ? true : false;
var N6 = (document.getElementById && !document.all) ? true : false;
var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
var is_safari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1;
var is_explorer = navigator.userAgent.toLowerCase().indexOf('Explorer/') > -1;

document.write ('<div id="barra" style="position: absolute; top: 50px; width: 98% ; BACKGROUND-COLOR: #6699cc;"></div>');
document.write ('<div id="espere" align="center" style="position: absolute; top: 50%; WIDTH: 100%; ">Espere por favor, mientras se carga la pagina...</div>');
var globheight;
var globwidth;
var globlevel;
var globdelay;
var globtype;
var menucount=0;
var N6count=0;
var populatemenuitems="false";

//menu_tpl.js from original starts here*****************************************************
var MENU_POS = new Array();
        MENU_POS['height'] = [];
        MENU_POS['width'] = [];
        MENU_POS['block_top'] = [0, 0,];
        MENU_POS['hide_delay'] = [];

var MENU_STYLES = new Array();
        MENU_STYLES['onmouseout'] = [
                'color', [],
                'background', []
        ];
        MENU_STYLES['onmouseover'] = [
                'color', [],
                'background', []
        ];
        
        MENU_STYLES['onmousedown'] = [
                'color', [],
                'background', []
        ];
        
//menu_tpl.js from original ends here*******************************************************

function CloseEspere(){
         document.getElementById('espere').style.display = 'none';
         document.getElementById('espere').style.visibility = 'hidden';
         document.getElementById('barra').style.display = 'none';
         document.getElementById('barra').style.visibility = 'hidden';

}


function initmenu(levels,height,width,delay,type)
{  levels = 6;  // PINO - Item del menu Horizontal

if (populatemenuitems=="true")
{
for (i=0;i<= levels -1;i++)
{
MENU_ITEMS[i] = ITEMS[i+1];
}
}

//setting the height
height=36;
globheight=height;
globlevel=levels;
globwidth=width + 30; // aca antes habia 20 pino
globdelay=delay;

if (populatemenuitems=="false")
{
        if (type=="horizontal")
        {
                //Defaults for horizontal
                MENU_POS['block_left'] = [0, 0];
                MENU_POS['top'] = [0];
                MENU_POS['left'] = [globwidth];
                globtype="horizontal";
        }
        else
        {
                //Defaults for vertical
                MENU_POS['block_left'] = [0, globwidth];
                MENU_POS['top']        = [0, 0];
                MENU_POS['left']       = [0, 0];
                globtype="vertical";
        }
}
}




//menu.js from original starts here********************************************************
var menus = [];

// --- menu class ---
function menu (item_struct, pos, styles) {
        // browser check
        this.item_struct = item_struct;
        this.pos = pos;
        this.styles = styles;
        this.id = menus.length;
        this.items = [];
        this.children = [];
        this.add_item = menu_add_item;
        this.hide = menu_hide;
        this.onclick = menu_onclick;
        this.onmouseout = menu_onmouseout;
        this.onmouseover = menu_onmouseover;
        this.onmousedown = menu_onmousedown;
        var i;

        for (i = 0; i < this.item_struct.length; i++)
                new menu_item(i, this, this);
        for (i = 0; i < this.children.length; i++)
                this.children[i].visibility(true);
        menus[this.id] = this;
}
function menu_add_item (item) {
        var id = this.items.length;
        this.items[id] = item;
        return (id);
}
function menu_hide () {
        for (var i = 0; i < this.items.length; i++) {
                this.items[i].visibility(false);
                this.items[i].switch_style('onmouseout');

				document.getElementById('iframe_mi_0_'+ this.items[i].id ).style.visibility = 'hidden';
        }
}
function menu_onclick (id) {
        var item = this.items[id];
        return (item.fields[1] ? true : false);
}
function menu_onmouseout (id) {

        this.hide_timer = setTimeout('menus['+ this.id +'].hide();',
                this.pos['hide_delay'][this.active_item.depth]);
        if (this.active_item.id == id)
                this.active_item = null;
}
function menu_onmouseover (id) {

        this.active_item = this.items[id];
        clearTimeout(this.hide_timer);
        var curr_item, visib;

        for (var i = 0; i < this.items.length; i++) {
                curr_item = this.items[i];
                visib = (curr_item.arrpath.slice(0, curr_item.depth).join('_') ==
                        this.active_item.arrpath.slice(0, curr_item.depth).join('_'));
                if (visib) {
                        curr_item.switch_style (
                                curr_item == this.active_item ? 'onmouseover' : 'onmouseout');
						document.getElementById('iframe_mi_0_'+ curr_item.id ).style.visibility = 'visible';
				}
                curr_item.visibility(visib);
        }
}
function menu_onmousedown (id) {
        this.items[id].switch_style('onmousedown');
}
// --- menu item Class ---
function menu_item (path, parent, container) {
        this.path = new String (path);
        this.parent = parent;
        this.container = container;
        this.arrpath = this.path.split('_');
        this.depth = this.arrpath.length - 1;
        // get pointer to item's data in the structure
        var struct_path = '', i;
        for (i = 0; i <= this.depth; i++)
                struct_path += '[' + (Number(this.arrpath[i]) + (i ? 2 : 0)) + ']';
        eval('this.fields = this.container.item_struct' + struct_path);
        if (!this.fields) return;
        
        // assign methods       
        this.get_x = mitem_get_x;
        this.get_y = mitem_get_y;
        // these methods may be different for different browsers (i.e. non DOM compatible)
        this.init = mitem_init;
        this.visibility = mitem_visibility;
        this.switch_style = mitem_switch_style;
        
        // register in the collections
        this.id = this.container.add_item(this);
        parent.children[parent.children.length] = this;
        
        // init recursively
        this.init();
        this.children = [];
        var child_count = this.fields.length - 2;
        for (i = 0; i < child_count; i++)
                new menu_item (this.path + '_' + i, this, this.container);
        this.switch_style('onmouseout');
}
function mitem_init() {
		xtop  = this.get_y();
		if (xtop==1){
		        xtop=2;
                        xwidth =  '100%' ;
                }else{
                     	xtop=xtop+ 14;
                }

        xtop= xtop; // pino alto del menu en la pagina
//        if (is_chrome || is_safari ) {
//            xtop= xtop +120;
//        } else {
//            if ( IE4 || IE5 || is_explorer ) {
//               xtop= xtop +120;
//            } else {
//                xtop= xtop +120;
//           }
//        }

		var child_count = this.fields.length - 2;

		if(child_count > 0 && this.depth != 0){
			flechita = " &#187";
		}else{
			flechita = "";
		}

		document.write (
			'<iframe src="/benef/script/vacio.htm" id="iframe_mi_' + this.container.id + '_'
			+ this.id +'" frameborder="0" border="0" style="visibility: hidden; position: absolute; top: '
			+ xtop + 'px; left: '   + (this.get_x() - 1) + 'px; width: '
			+ this.container.pos['width'][this.depth] + 'px ; height: '
			+ this.container.pos['height'][this.depth] + 'px; z-index:0"></iframe> <a id="mi_' + this.container.id + '_'
			+ this.id +'" class="m' + this.container.id + 'l' + this.depth
			+'o" href="' + this.fields[1] + '" style="position: absolute; top: '
			+ xtop + 'px; left: '   + (this.get_x()-1) + 'px; width: '
			+ this.container.pos['width'][this.depth] + 'px ; height: '
			+ this.container.pos['height'][this.depth] + 'px; visibility: hidden;'
			+' background: black; color: white; z-index: ' + this.depth + ';" '
			+ 'onclick="return menus[' + this.container.id + '].onclick('
			+ this.id + ');" onmouseout="menus[' + this.container.id + '].onmouseout('
			+ this.id + ');" onmouseover="menus[' + this.container.id + '].onmouseover('
			+ this.id + ');" onmousedown="menus[' + this.container.id + '].onmousedown('
			+ this.id + ');"><div id="menudivs" z-index:1; class="m'  + this.container.id + 'l' + this.depth + 'i">'
			+ this.fields[0] + flechita + "</div></a>\n"
		);

                if (globtype=="horizontal")
                {
                        MENU_POS['block_top'][1]=document.getElementById('menudivs').offsetHeight;
                   for (d=1;d<=MENU_POS['top'].length-1;d++)
                    {
                    MENU_POS['top'][d]= document.getElementById('menudivs').offsetHeight;
                        }
                }
                if (globtype=="vertical")
                {
                   for (h=0;h<=MENU_POS['top'].length-1;h++)
                   {
                    MENU_POS['top'][h]= document.getElementById('menudivs').offsetHeight;
                        }
                }
        this.element = document.getElementById('mi_' + this.container.id + '_' + this.id);
        //document.getElementById('holdmenu').innerHTML+=this.element.outerHTML;
}
function mitem_visibility(make_visible) {
        if (make_visible != null) {
                if (this.visible == make_visible) return;
                this.visible = make_visible;
                if (make_visible){
                        this.element.style.display = 'block';
                        this.element.style.visibility = 'visible';
				}
                else if (this.depth){
                        this.element.style.display = 'none';
                        this.element.style.visibility = 'hidden';
						document.getElementById('iframe_mi_0_'+ this.id ).style.visibility = 'hidden';
						
				}
        }
        return (this.visible);
}
function mitem_get_x() {
        var value = 0;
        // valor de inicio del ancho del menu - pino
        for (var i = 0; i <= this.depth; i++)
                value += this.container.pos['block_left'][i]
                + this.arrpath[i] * this.container.pos['left'][i];
		if(i>0){value+=1;}
        return (value);
}
function mitem_get_y() {
        var value = 0;
        for (var i = 0; i <= this.depth; i++)
                value += this.container.pos['block_top'][i]
                + this.arrpath[i] * this.container.pos['top'][i];
		if(i>0){value+=1;}		
        return (value);
}
function mitem_switch_style(state) {
        if (this.state == state) return;
        this.state = state;
        var style = this.container.styles[state];
        for (var i = 0; i < style.length; i += 2)
                if (style[i] && style[i+1])
                        eval('this.element.style.' + style[i] + "='" 
                        + style[i+1][this.depth] + "';");
}
// menu.js from original ends here************************************************



//menu_items.js from original starts here******************************************
var arraywith10values = new Array();
var arraywith10valuescount = 0;
var splitvalarray;
var doflag;
var newarraystr = new Array();
var mainarray = new Array();
var mainarraywithcommas = new Array();
var fullmainarray = new Array();
var MENU_ITEMS = new Array();
var ITEMS = new Array();
var splitarray = new Array();
var count=0;

//This is the new function added. This function replaces all the occurances of a particular character/substring in a string with the given character/string***********************
function replace(string,text,by)
{
    var strLength = string.length, txtLength = text.length;
    if ((strLength == 0) || (txtLength == 0)) return string;

    var i = string.indexOf(text);
    if ((!i) && (text != string.substring(0,txtLength))) return string;
    if (i == -1) return string;

    var newstr = string.substring(0,i) + by;

    if (i+txtLength < strLength)
        newstr += replace(string.substring(i+txtLength,strLength),text,by);

    return newstr;
}
//******************************************************************************************

function addmenuitem(val,desc,url,onmouseovrtxtcol,onmouseovrbgndcol,onmouseouttxtcol,onmouseoutbgndcol,onmousedowntxtcol,onmousedownbgndcol,fontstyles)
{
/*
val=Node level
desc=description which shows up
url=url linked to description
onmouseovertxtcol=Onmouseover Text color
*/
doflag="yes";
fontstyles="font-family:  Arial, Helvetica, sans-serif; font-size:12px;font-weight:bold;text-decoration:none;padding: 5px";
splitvalarray=val.split(",");
        for (b=0;b<=splitvalarray.length-1;b++)
        {
                if ((splitvalarray[b]=="10") || (splitvalarray[b]=="20"))
                {
                doflag="no";
                }
        }
        
        //populate array values for only those inputs which have a level of 10,20etc only after first level,ex:1,10,1;1,1,10,1etc************************************************************
        if ((doflag=="no") && (splitvalarray[0].length!=2))
        {
                        arraywith10values[arraywith10valuescount]=new Array(val,desc,url);
                        arraywith10valuescount=arraywith10valuescount+1;
        }
        //********************************************************************************
        
        //populate array values for only those inputs which have a level of 10,20etc only after first level,ex:10,1,1;10,1,10,1etc***********************************************************
        if ((doflag=="no") && (splitvalarray[0].length==2) && (splitvalarray.length>1))
        {
                        arraywith10values[arraywith10valuescount]=new Array(val,desc,url);
                        arraywith10valuescount=arraywith10valuescount+1;
        }
        //********************************************************************************

        
        
        //for first level
        if ((doflag=="no") && (val.length==2))
        {
                ITEMS[splitvalarray[0]]=new Array(desc,url);
        }       
        

        if (doflag=="yes")
        {
var val1=replace(val,",","0");
var val2=replace(val,",","");
//calculate no of commas in val,this will give us the level************
                 var noofcommascount=0;
                 for (h=0;h<=val.length-1;h++)
                 {
                 if (val.charAt(h)==",")
                 {
                 noofcommascount=noofcommascount+1;
                 }
                 }
                        //*********************************************************
MENU_STYLES['onmouseover'][1][noofcommascount] = onmouseovrtxtcol;
MENU_STYLES['onmouseover'][3][noofcommascount] = "#CED2DB";//onmouseovrbgndcol; PINO

MENU_STYLES['onmouseout'][1][noofcommascount] = onmouseouttxtcol;                                                 
MENU_STYLES['onmouseout'][3][noofcommascount] = "#6699CC" ; //onmouseoutbgndcol;

MENU_STYLES['onmousedown'][1][noofcommascount] = onmousedowntxtcol;                                               
MENU_STYLES['onmousedown'][3][noofcommascount] = "#CED2DB"; //onmousedownbgndcol;

MENU_POS['hide_delay'][noofcommascount] = globdelay;
MENU_POS['height'][noofcommascount]=globheight;

if (val.length > 3){
    MENU_POS['width'][noofcommascount]=globwidth - 50; // este es el ancho de las celdas
    // del nivel 3.
}else{
    MENU_POS['width'][noofcommascount]=globwidth;
}
//defining classes for setting font-family,size etc*******
if (IE5)
{

    document.styleSheets[0].addRule(".m0l"+noofcommascount+"o", "text-decoration : none; border : 0px solid black;");
    document.styleSheets[0].addRule(".m0l"+noofcommascount+"i", fontstyles);
	
}
else
{
    var x = document.styleSheets[0];
    x.insertRule('PRE {font: 14px verdana}',x.cssRules.length);
    x.insertRule(".m0l"+noofcommascount+"o {text-decoration : none; border : 0px solid black;}",x.cssRules.length);
    x.insertRule(".m0l"+noofcommascount+"i {"+fontstyles+"}",x.cssRules.length);

}
//**********************************************************



if (noofcommascount>1)
{
        MENU_POS['block_left'][noofcommascount] = globwidth+1;
        MENU_POS['block_top'][noofcommascount] = 0;
}
if (noofcommascount>0)
{
MENU_POS['left'][noofcommascount] = 0;
MENU_POS['top'][noofcommascount] = 0;//need not be 23,you can assign any number.
}

                                  
if (val.lastIndexOf(",")=="-1")
{
var substrextract=val;
}
else
{
var substrextract=val.substring(0,val.lastIndexOf(","));
}
var replacedstr=replace(substrextract,",","0");
var val1=replace(val,",","0");
ITEMS[val1]=new Array(desc,url);
mainarray[count]=replacedstr; 
fullmainarray[count]=val1;
mainarraywithcommas[fullmainarray[count]]=val;
count=count+1;
        }
}

function doCompare(a,b)
{
return a-b
}
 
function createmenu()
{
mainarray.sort(doCompare);
fullmainarray.sort(doCompare);
var count1=2;
for (i=mainarray.length-1;i>=0;i--)
{
    mainarray[i]=mainarray[i]+"";
     var len=mainarray[i].length;
     for (j=0;j<=fullmainarray.length-1;j++)
     {
     //calculate no of zeros in fullmainarray[j]************
     var noofzeroscount=0;
     for (u=0;u<=fullmainarray[j].length-1;u++)
     {
     if (fullmainarray[j].charAt(u)=="0")
     {
     noofzeroscount=noofzeroscount+1;
     }
     }
     //*********************************************************
     //calculate no of zeros in mainarray[i]************
     var noofzeroscounti=0;
     for (v=0;v<=mainarray[i].length-1;v++)
     {
     if (mainarray[i].charAt(v)=="0")
     {
     noofzeroscounti=noofzeroscounti+1;
     }
     }
     //*********************************************************


     splitarray=mainarraywithcommas[fullmainarray[j]].split(",");
             if (mainarray[i]!=fullmainarray[j])
            {
             fullmainarray[j]=fullmainarray[j]+"";
                       if ((fullmainarray[j].substring(0,len)==mainarray[i]) && (mainarray[i].length==(fullmainarray[j].length-noofzeroscount)-(splitarray[splitarray.length-1].length-noofzeroscounti)))
                       {
                       ITEMS[mainarray[i]][count1]=ITEMS[fullmainarray[j]];
                       count1=count1+1;
                       }
              }
      }
count1=2;
 }
 populatemenuitems="true";
 initmenu(globlevel,globheight,globwidth);
} 

function add10xitems()
{
for (p=0;p<=arraywith10values.length-1;p++)
{
var position=arraywith10values[p][0].substring(arraywith10values[p][0].lastIndexOf(",")+1,arraywith10values[p][0].length);
var substrextract=arraywith10values[p][0].substring(0,arraywith10values[p][0].lastIndexOf(","));
var replacedstr=replace(substrextract,",","0");
var replacedwholestr=replace(arraywith10values[p][0],",","0");
//change indexes
                for (r=ITEMS[replacedstr].length;r>=parseInt(position);r--)
                {
                        ITEMS[replacedstr][r+1]=ITEMS[replacedstr][r];
                }
ITEMS[replacedwholestr]=new Array(arraywith10values[p][1],arraywith10values[p][2]);
ITEMS[replacedstr][parseInt(position)+1]=ITEMS[replacedwholestr];
}
}

//menu_items.js from original ends here*****************************************************
function Redirect(sUrl) {
	var lRespuesta
	var bPregunto
	var sHref

	sHref = top.frames['central'].location;
//	sHref = window.parent.frames("central").location.href;

	switch (sUrl) {
       		case "/logout.jsp" :
               		window.parent.navigate(sUrl);
			break;
		default :
                        top.frames['central'].location=sUrl;
//			window.parent.frames("central").navigate(sUrl);
		}
}   
function get_fecha(){
    dias=new Array("Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado")
    meses=new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre");
    nmeses=new Array("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
    ndia=new Array("00","01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23", "24", "25", "26", "27", "28", "29", "30", "31");
    fecha=new Date();
    if (IE5) {
        var sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +fecha.getYear();
    }else{
	var sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +(fecha.getYear()+1900);
    }
  return sfecha;
}

function AbrirPopup(Url,Nombre,sFeatures,Ancho,Alto){
    var ScreenAncho=window.screen.availWidth;
    var ScreenAlto =window.screen.availHeight;
    var WinAncho   = Ancho;
    var WinAlto    = Alto;
    var left       = (ScreenAncho-WinAncho)/2;
    var top        = (ScreenAlto-WinAlto)/2;
        sFeatures  += "top="+top;
        sFeatures  += ",left="+left;
        sFeatures  += ",width="+WinAncho;
        sFeatures  += ",height="+WinAlto;

    window.open(Url,Nombre,sFeatures);
}