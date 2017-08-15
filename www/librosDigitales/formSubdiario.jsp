<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.util.*"%> 
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
     Usuario usu = (Usuario) session.getAttribute("user"); 
    String sEstado  = (String) request.getAttribute ("estado");
    String sLink    = (String) request.getAttribute ("link");
    String sLinkLog = (String) request.getAttribute ("linkLog");
     
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language="javascript">
        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }
    
     function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

     function Enviar () {

        if ( document.getElementById('fecha_desde').value == "" ) {
            alert (" La fecha desde es inv&aacute;lida !! ");
            return document.getElementById('fecha_desde').focus();
        }
        if ( document.getElementById('fecha_hasta').value == "" ) {
            alert (" La fecha hasta es inv&aacute;lida !! ");
            return document.getElementById('fecha_hasta').focus();
        }
        var marcado = -1;

        for(i=0; i < document.form1.criterio.length; i++){
            if(document.form1.criterio[i].checked) {
            marcado=i;
            break;
            }
        }

        if ( marcado == -1 ) {
            alert (" Por favor marque el libro a generar (Emisi&oacute;n o Cobranza) ");
            return document.form1.criterio[marcado].focus();
        }

        document.getElementById('opcion').value =  document.form1.criterio[marcado].value;
        document.form1.submit ();
        OpenEspere ();
        return true;
     }

     function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('cod_prod').value != "0") {
                document.getElementById ('cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('cod_prod').length; i++) {
                if (document.getElementById ('cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" C&oacute;digo inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }
</script>
<body>
    <table id="tabla_general" id="Principal" name="Principal"  cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
        <TD align="center" valign="top" width='100%' height='450' >
            <TABLE width='100%' cellpadding='3' cellspacing='4' border='0' align="center" style='margin-top:5;margin-bottom:5;' class="fondoForm" >
                <form action='<%= Param.getAplicacion()%>servlet/LibrosDigitalesServlet' id="form1" name="form1"  method="POST">
                <input type="hidden" name='opcion' id='opcion' value="get_emision"/>
                <input type="hidden" name="num_orden" id="num_orden" value="1"/>

                <tr>
                    <td class="titulo" height="30px" align="center" valign="middle" >LIBROS RUBRICADOS DIGITALES</td>
                </tr>
                <tr>
                    <td class="subtitulo" height="30px" align="left" valign="middle" >
El sistema de R&uacute;brica Digital es una herramienta desarrollada por la Superintendencia de Seguros de la Naci&oacute;n para reemplazar la r&uacute;brica de los libros en papel realizada por los productores en el Ente Ley 22.400.
                    </td>
                <tr>
                    <td class="subtitulo" height="30px" align="left" valign="middle" >
                        Para m&aacute;s informaci&oacute;n se puede bajar el manual de la SSN haciendo clic en el siguiente link                     
                        <a href="http://manuales.ssn.gob.ar/Externos/ManualRubricasProd.pdf" target="_blank" >
                         manuales.ssn.gob.ar/Externos/ManualRubricasProd.pdf
                        </a>
                    </td>
                </tr>
                <tr>
                    <td class="subtitulo" height="30px" align="left" valign="middle" >
                        Si necesita asistencia para subir nuestros archivos puede comunicarse 
                        v&iacute;a mail a webmaster@beneficio.com.ar o telef&oacute;nicamente al 11-50329503
                    </td>
                </tr>
                    
<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
%>
                <tr>
                    <td align="left" class="subtitulo" >Productor:&nbsp;
                        <select class='select' name="cod_prod" id="cod_prod" style="width: 400px;">
<%
                    LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                    for (int i= 0; i < lProd.size (); i++) {
                        Usuario oProd = (Usuario) lProd.get(i);
                        if (oProd.getiCodProd() < 80000 ) {
                         out.print("<option value='" + oProd.getiCodProd() + "'>" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                        }
                    }
%>    
                        </select>
                    &nbsp;
                    <LABEL>Cod : </LABEL>
                    &nbsp;
                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                    </td>
                </tr>
<%    } else {
%>
                <input type="hidden" name="cod_prod" id="cod_prod" value="<%= usu.getiCodProd()%>" >
<%
}
%>

                    <tr>    
                        <td align="left" nowrap  class="subtitulo">Ingrese periodo a procesar:</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">  DESDE&nbsp;<input type="text" name="fecha_desde" id="fecha_desde" value="" onblur="validaFecha(this);"
                                                             onkeypress="return Mascara('F',event);" size='15' maxlength='10'>&nbsp;formato dd/mm/yyyy&nbsp;
                        - HASTA&nbsp;<input type="text" name="fecha_hasta" id="fecha_hasta" value="" onblur="validaFecha(this);"
                                           onkeypress="return Mascara('F',event);" size='15' maxlength='10'>&nbsp;formato dd/mm/yyyy</td>
                    </tr>
                    <tr>
                        <td align="left" nowrap   class="text"><strong<span style="color:red;">Importante:&nbsp;</span>
                                la fecha desde no puede ser menor al 01 de Marzo de 2013</strong>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" nowrap valign="top"  class="subtitulo">Opci&oacute;n:</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;
                            <INPUT TYPE="radio" NAME="criterio" id="criterio" VALUE="get_emision"  checked>&nbsp;Libro rubricado digital de emisi&oacute;n<br>
                                    &nbsp;&nbsp;
                            <INPUT TYPE="radio" NAME="criterio" id="criterio" VALUE="get_cobranza" >&nbsp;Libro rubricado digital de cobranza
                        </td>
                    </tr>
                    <tr>
                        <td align="center" >
                            <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir();">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdEnviar" value="Enviar" width="100px" height="20px" class="boton" onClick="Enviar();">
                        </td>
                   </tr>
                    <tr>
                        <td valign="middle"  height="40px"  class="text"><hr/></td>
                    </tr>

<%          if (sEstado != null) {
                if  (sEstado.equals ("OK")) {
    %>
                    <tr>
                        <td align="left" nowrap valign="middle"  height="45"  class="text"><h2><strong>El proceso ha finalizado con exito !! </strong></h2></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap valign="middle" height="30"  class="text"><a href="<%= Param.getAplicacion() + sLink %>" target="_blank" ><img src="/benef/images/icono_zip.png" border="0" width="50" height="50" />Haga clic aqui para obtener el archivo que deber&aacute; presentar en la SSN</a>.<br/></td> 
                    </tr>
                    <tr>
                        <td align="left" nowrap valign="middle" height="30"  class="text"><a href="<%= Param.getAplicacion() + sLinkLog %>" target="_blank" ><img src="/benef/images/icono_csv.jpg" border="0" width="50" height="50" />Haga clic aqui para obtener un archivo de control en formato .csv para ser visualizado con Excel</a>.<br/></td> 
                    </tr>
                    <tr>
                        <td align="left" class="subtitulo"><span style="color:red;">Importante:</span><br/>
La presente información, a los fines de cumplir con los requisitos exigidos por la SSN para los registros de los productores-asesores de seguros surge, salvo error u omisión, de los datos con que cuenta nuestra Compañía. Por favor, revisarla atentamente por si deben realizar alguna modificación, antes de enviarla a la SSN y, en su caso, informarnos de cualquier diferencia que pudieran detectar.
<br/>Recuerde que la preparación y el envío de dicha información a la SSN es su responsabilidad y que éste es solo un medio para facilitarle la carga de los datos, a los fines de su remisión al organismo de contralor.
                        </td>
                    </tr>

<%
                } else {
    %>
                    <tr>
                        <td align="left" nowrap valign="top"   class="text"><span style="color:red"><%= sEstado %></span></td>
                    </tr>
<%              }
            }
%>      
            </form>    
            </TABLE>

        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</TABLE>
<script language="javascript">
var divHeight;
var obj = document.getElementById('tabla_general');

if(obj.offsetHeight)          {divHeight=obj.offsetHeight;}
else if(obj.style.pixelHeight){divHeight=obj.style.pixelHeight;}
document.write('<div id="mascara" style="width:100%;height:' + divHeight + 'px;position:absolute;top:0;left:0;' +
               'background-color:#F5F7F7;z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>' );
</script>
<!--<div id="mascara" style="position:fixed;top:0;left:0; width:100%;height:100%; background-color:#F5F7F7; z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>
-->
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:650px;height:100%;margin-top: -30px;margin-left: -250px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                    Este proceso puede tardar unos minutos. Por favor, espere...</span>&nbsp;
                    <img src="/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
//document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
//                                                  oFrameTit.document.getElementById ('cod_cob').value).value;
CloseEspere();
</script>
</body>
</html>        

