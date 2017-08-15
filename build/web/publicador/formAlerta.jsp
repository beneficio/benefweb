<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Alerta"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    } 

    int codAlerta = Integer.parseInt (request.getParameter ("codAlerta"));

Connection dbCon = null;
Alerta alerta = new Alerta();
try {
    if (codAlerta != 0) {
        dbCon = db.getConnection();
        alerta.setcodAlerta(codAlerta);
        alerta.getDB(dbCon);
        if (alerta.getiNumError() != 0) { 
            throw new SurException (alerta.getsMensError());
        }
    }
} catch (Exception e) {
    throw new SurException (e.getMessage());
} finally {
    db.cerrar(dbCon);
}
%> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>script/yui/build/fonts/fonts-min.css" />
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>script/yui/build/editor/assets/skins/sam/simpleeditor.css" />
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>script/yui/build/container/assets/skins/sam/container.css" />
    <script type="text/javascript" src="<%=Param.getAplicacion()%>script/formatos.js"></script>
 <script language="javascript">
    var myEditor;

	function publicar(){
            if (document.getElementById('titulo').value == "" ) {
                alert ("Debe ingresar el titulo");
                document.getElementById('titulo').focus();
                return false;
            }

            if (document.getElementById('fecha').value == "" ) {
                alert ("Debe ingresar la fecha de publicación");
                document.getElementById('fecha').focus();
                return false; 
            }

            if (document.getElementById('vencimiento').value == "" ) {
                alert ("Debe ingresar la fecha de vencimiento");
                document.getElementById('vencimiento').focus();
                return false; 
            }

            if (document.getElementById('alto').value == "" ) {
                alert ("Debe ingresar el alto de la pop up ");
                document.getElementById('alto').focus();
                return false;
            }

            if (document.getElementById('ancho').value == "" ) {
                alert ("Debe ingresar el ancho de la pop up ");
                document.getElementById('ancho').focus();
                return false;
            }

        document.getElementById('Alertas').submit();
	}

    function visualizar(){
        var oForm= document.getElementById("Alertas");
        oForm.action="viewAlerta.jsp";
        oForm.target="ALERT_PREVIEW";
        oForm.html.value = myEditor.getEditorHTML();
        oForm.tipoUsuarioDesc.value = oForm.tipoUsuario.options[oForm.tipoUsuario.selectedIndex].text;
        oForm.submit();
    }

    function grabar(){
        var oForm= document.getElementById("Alertas");
        oForm.action="publicarAlerta.jsp";
        oForm.html.value = myEditor.getEditorHTML();
        oForm.submit();
    }

</script>
</head>
<body class=" yui-skin-sam">
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
                </div>
            </td>
        </tr>
     <TR>
        <TD height="100%" valign="top" width='100%'> 
            <FORM id='Alertas' METHOD="POST" ACTION="/benef/publicador/publicarAlerta.jsp">
            <input type="hidden" name="tipoUsuarioDesc" value="">
            <input type="hidden" name="html" value="">
            <input name="codAlerta" id="codAlerta" type="Hidden" value="<%= alerta.getcodAlerta()%>">
            <TABLE class="fondoForm" align="center" width='95%' cellpadding='2' cellspacing='2' border='0'>
                <TR>
                    <TD valign="top" align="center" class='subtitulo' colspan='4' height='30'>ALERTAS</TD>
                </TR>
                <TR>
                    <TD class="text">T&iacute;tulo:</TD>
                    <TD class="text" colspan='3'>
                        <INPUT type="text" name="titulo" id="titulo" value="<%= (alerta.gettitulo() == null ? "" : alerta.gettitulo())%>" size="53" maxlengh="50" >
                    </TD>				
                </TR>
                <TR>
                    <TD class="text">Tipo de usuario:</TD>
                    <TD class="text" class='select'>
                        <select name="tipoUsuario" id="tipoUsuario">
                                <option value="99999999" <%= (alerta.gettipoUsuario() == 99999999 ? "selected" : " " )%>>Todos los usuarios</option>
                                <option value="0" <%= (alerta.gettipoUsuario() == 0 ? "selected" : " " )%>>Internos</option>
                                <option value="1" <%= (alerta.gettipoUsuario() == 1 ? "selected" : " " )%>>Productores</option>
                                <option value="2" <%= (alerta.gettipoUsuario() == 2 ? "selected" : " " )%>>Clientes</option>
                        </select>
                    </TD>				
                    <TD width='200' class="text" align="left">Alto:&nbsp;
                        <input name="alto" id="alto" value="<%= alerta.getalto () %>"  size="5" maxlength="3" onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                    </TD>
                    <TD width='200' class="text" align="left">Ancho:&nbsp;
                        <input name="ancho" id="ancho" value="<%= alerta.getancho () %>"  size="5" maxlength="3" onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                    </TD>
                </TR>
                <TR>
                    <TD nowrap  width='120' class="text" align="left">Fecha de Publicación:</TD>
                    <TD width='200' class="text" align="left">
                        <input name="fecha" id="fecha" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" maxlength="10" size="10" value="<%= (alerta.getfechaDesde () == null ? "" : Fecha.showFechaForm(alerta.getfechaDesde ()))%>">
                    </TD>				
                    <TD nowrap width='120' class="text" align="left">Vencimiento:</TD>
                    <TD class="text"  align="left" width='25%'>
                        <input name="vencimiento" id="vencimiento" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" maxlength="10" size="10" value="<%= (alerta.getfechaHasta () == null ? "" : Fecha.showFechaForm(alerta.getfechaHasta ()))%>">
                    </TD>				
                </TR>
                <tr>
                    <td colspan="4" valign="middle" height='200'>
                       <textarea id="editor" name="editor" rows="20" cols="75" style="width:100%;height:100%" ><%= (alerta.getsBody () == null ? "" : alerta.getsBody()) %></textarea>
                    </td>
               </tr>
            </TABLE>               
            </FORM>
        </TD>
    </TR>
    <TR>
        <TD align="center" VALIGN="top">
            <input class="Boton" type="button" name="cmdSalir" value="Cancelar" onClick="javascript:history.back();">
            &nbsp;&nbsp;&nbsp;&nbsp;    
            <input class="Boton"  type="button" name="cmdVis" value="Visualizar" onClick="visualizar();">
            &nbsp;&nbsp;&nbsp;&nbsp;    
            <input class="Boton"  type="button" name="cmdAceptar" value="Grabar" onClick="grabar();">
        </TD>
    </TR>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/element/element-beta-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/container/container_core-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/editor/editor-beta-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/utilities/utilities.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/container/container-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/menu/menu-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/button/button-beta-min.js"></script>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/yui/build/container/container-min.js"></script>

<script language="javascript">
    var Dom = YAHOO.util.Dom,
        Event = YAHOO.util.Event,
        win = null;

     myEditor = new YAHOO.widget.Editor('editor', {
        height: '200px',
        width: '100%',
        dompath: true,
        animate: true
    });
    myEditor.on('toolbarLoaded', function() {
        //Agrego el evento del imageClick
        this.toolbar.on('insertimageClick', function() {
            var _sel = this._getSelectedElement();
            //Si el elemento seleccionado es una imagen no hago nada y dejo todo como esta
            if (_sel && _sel.tagName && (_sel.tagName.toLowerCase() == 'img')) {
                //aca se podria customizar esto si queremos
            } else {
                //Abro mi super imagebrowser ;)
                win = window.open('imageBrowser.jsp', 'IMAGE_BROWSER', 'left=20,top=20,width=600,height=400,toolbar=0,resizable=0,status=0,location=0,menubar=0');
                if (!win) {
                    //Me fijo si tiene bloqueador de popups
                    alert('Por favor deshabilite el bloqueador de popups!!');
                }
                //Mando false de respuesta para que no se abra el imagepicker original
                return false;
            }
        }, this, true);
    }, myEditor, true);
    myEditor.on('afterOpenWindow', function() {
        //Cuando se abre la ventana deshabilito la url de la imagen asi no me la cambian
        Dom.get('insertimage_url').disabled = true;
    }, myEditor, true);

	//CloseEspere();
    myEditor.render();
</script>
</body>
</html>