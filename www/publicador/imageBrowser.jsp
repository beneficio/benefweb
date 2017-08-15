<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/benef/error.jsp"%>
<%@page import="com.business.util.*,java.io.*,java.io.File"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <title>Imagenes</title>
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>script/yui/build/reset-fonts-grids/reset-fonts-grids.css">
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>script/yui/build/assets/skins/sam/skin.css">
<SCRIPT language="javascript">
	function publicar(){
            if (document.getElementById('archivo').value == "" ) {
                alert ("Debe ingresar el archivo a publicar");
                document.getElementById('archivo').focus();
                return false; 
            }

		document.getElementById('alerta').submit();
	}
</script>
</head>
<body class="yui-skin-sam">
<FORM  name='alerta' id='alerta' METHOD="POST" ACTION="/benef/publicador/uploadImage.jsp" ENCTYPE="multipart/form-data">
    <table width="100%" height="500px" class="fondoForm" cellpadding='2' cellspacing='2' border='0'>
    <tr>    
       <td>
        Haga click sobre una imagen para llevarla al editor
       </td>
    </tr>
    <tr>
       <td>
        <div id="images" style="overflow:auto;height:300px;width:580px">
            <table border="0">
                <tr>
 <%
                    String imgLocation = application.getRealPath("/publicador/upload/img") ;
                    File dir = new File( imgLocation );
                    String[] arEDirs = dir.list();
                    if (arEDirs != null){
                        for( int ii=0 ; ii< arEDirs.length ; ii++){
                            File file = new File(imgLocation + "/" +arEDirs[ii]) ;
System.out.println ("imgLocation->" + imgLocation);
System.out.println ("imgLocation->" + arEDirs[ii]);
System.out.println ("name->" + file.getName());

    %>
                        <td>
                           <img src="<%=Param.getAplicacion()%>publicador/upload/img/<%=file.getName()%>" title="Seleccionar">
                        </td>
    <%                  }
                    }
    %>
               </tr>
           </table>
        </div>
       </td>
    </tr>
    </table>
    <table  width="100%" height="500px" class="fondoForm" cellpadding='2' cellspacing='2' border='0'>
    <tr>
       <td>
        Subir una nueva imagen
       </td>
    </tr>
    <tr>
       <td>
        <input type="file" name="archivo" id="archivo" class="Boton">
        &nbsp;&nbsp;&nbsp;
        <input class="Boton"  type="button" name="cmdAceptar" value="Enviar" onClick="publicar();"> 
       </td>
    </tr>
    </table>
<script type="text/javascript" src="http://yui.yahooapis.com/2.3.1/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript">
(function() {
    var Dom = YAHOO.util.Dom,
        Event = YAHOO.util.Event,
        myEditor = window.opener.YAHOO.widget.EditorInfo.getEditorById('editor');
        //Tomo la referencia al editor

    //Agrego el listener al contenedor de las imagenes
    Event.on('images', 'click', function(ev) {
        var tar = Event.getTarget(ev);
        //Me fijo si apreto sobre una imagen
        if (tar && tar.tagName && (tar.tagName.toLowerCase() == 'img')) {
            //hago foco en el editor
            myEditor._focusWindow();
            //Disparo el execCommand para insertar la imagen en el editor
            myEditor.execCommand('insertimage', tar.getAttribute('src', 2));
            //Cierro esta ventanita
            window.close();
        }
    });
})();
</script>
</form>