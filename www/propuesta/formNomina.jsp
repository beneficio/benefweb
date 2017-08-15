<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  
    Usuario usu = (Usuario) session.getAttribute("user"); 
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");
    int    codProceso   = oProp.getCodProceso();
    String codBoca      = oProp.getBoca();
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;
    int    codRama      = oProp.getCodRama();
   // 
    int cantNominas = 0 ;
   
    if (request.getAttribute("nominas") != null ) {
        LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;        
        cantNominas = lNom.size();       
    }

    int posOrden = 1;
   
    String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script language="javascript">
    if(history.forward(1)){
        history.replace(history.forward(1));
    }

        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }
    </script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language="javascript">
    var rama     = <%= oProp.getCodRama() %>;
    var subRama  = <%= oProp.getCodSubRama()%>;
    var edadMinima = 18;
    var edadMaxima = 69;
    
    if (rama === 10 && subRama === 32 ) {
        edadMaxima = 84;        
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    
    function ValidarDatos() {



        if (document.formNom.prop_nom_orden.value == "" ) {            
          alert ("Ingrese el Orden");
          return false; 
        }

        if ( Trim(document.formNom.prop_nom_ApeNom.value) == "" ) {
          alert ("Ingrese el Apellido y Nombre");
          return false; 
        }
        
        if (Trim(document.formNom.prop_nom_numDoc.value) == "" ) {
          alert ("Ingrese el Documento");
          return false; 
        }

        if  ( !ControlarDNI ( Trim(document.formNom.prop_nom_numDoc.value) ) ) {
            return false;
        }

        if (document.formNom.prop_nom_fechaNac.value == "" ) {            
          alert ("Ingrese Fecha Nacimiento");
          return false; 
        }

        if ( !ValidarDoc() ){
          return false;  
        } 

        return true; 

    } 

    function ValidarDoc(){

        var cantNom  = document.formNom.prop_cantNom.value;                      

        for (i=0;i < cantNom ; i++){
            var tipo = document.getElementById('prop_tipoDoc_'+i).value;
            var doc = Trim(document.getElementById('prop_numDoc_'+i).value);
            
            if ( tipo == document.formNom.prop_nom_tipDoc.value && 
                 doc  == Trim(document.formNom.prop_nom_numDoc.value)
               ) {
                   alert( " El documento ingresado ya existe ..."  );
                   return false; 
               }
        }                

        return true;
    }

    function ControlarDNI ( dni ) {
       
        if ( document.getElementById('prop_nom_tipDoc').value == '80') {
            if ( ! ValidoCuit ( Trim(document.getElementById('prop_nom_numDoc').value))) {
                document.getElementById('prop_nom_numDoc').focus ();
                return false;
            }
        } else {
            if (Trim(document.formNom.prop_nom_numDoc.value).length < 7) {
                alert ("Documento inválido !");
                document.formNom.prop_nom_numDoc.focus ();
                return false;
            } 
        }

        return true;
    }

    function AddNomina () {       

        var cantNom   = parseInt(document.formNom.prop_cantNom.value) + parseInt(1);        
        var cantVidas = document.formNom.prop_cantVidas.value ;

        if ( cantNom > cantVidas ) {            
          alert (" La nómina debe tener " + cantVidas + " personas");
          return false; 
        }         

        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.prop_nom_numDoc.value =
                 Trim(document.formNom.prop_nom_numDoc.value);
            document.formNom.opcion.value="grabarNomina";
            document.formNom.submit();            
        }  
    }

    function Grabar () {
        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.prop_nom_numDoc.value =
                 Trim(document.formNom.prop_nom_numDoc.value);
            document.formNom.opcion.value="grabarNomina";
            document.formNom.submit();            
        }  
    }

    function Enviar () {
        var numTarjeta  = document.getElementById ("num_tarjeta").value;
        var cbu         = document.getElementById ("cbu").value;
        
        if (numTarjeta !== "" && numTarjeta === '1111111111111111'.substr(0, numTarjeta.length)) { 
            alert ("Número de tarjeta inválida: " + numTarjeta)
            return false;
        }
        
            if (cbu !== "" && ( cbu === '1111111111111111111111'.substr(0, cbu.length) || 
                                cbu === '0000000000000000000000'.substr(0, cbu.length))) { 
                alert ("CBU o cuenta inválida: " + cbu + ". Corregir desde el formulario de carga antes de enviar.");
                return false;
            }
        
        var cantNom   = document.formNom.prop_cantNom.value ;
        var cantVidas = document.formNom.prop_cantVidas.value ;
        if( cantNom === cantVidas ) {
            desbloquea();
            document.formNom.opcion.value="enviarPropuesta";
            document.formNom.submit();
            OpenEspere ();
            return true;
        } else {
            alert(" La nómina no puede ser enviada. Debe tener " + cantVidas + " personas " ); 
            return true;
        }
    }  


    function DelNomina (param) {
        if (confirm("Esta usted seguro que desea eliminar la persona de la nómina ?  ")) {
            desbloquea();
            document.formNom.prop_del_orden.value = document.getElementById(param).value;
            document.formNom.opcion.value="borrarNomina"; 
            document.formNom.submit();            
            return true;
        } else {
            return false;
        }
    }

    function desbloquea(){
        document.formNom.prop_numero.disabled = false;      
        document.formNom.prop_nom_orden.disabled = false;      
            
    }

    function ControlarFecha (fecha, desde) {

//        var edad =  calcular_edad (fecha, desde );
        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));
        if ( edad > edadMaxima ) {
            alert ("Fecha de nacimiento incorrecta, debe tener a lo sumo " + edadMaxima + " años \n a la fecha de inicio de vigencia");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else if ( edad <  edadMinima ) {
            alert ("Fecha de nacimiento incorrecta, debe ser mayor de " + edadMinima + " años !!");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
    }

function EnviarNomina () {
    if (document.formPropuesta.FILE1.value === "") {
        alert ("Haga clic en Examinar... para cargar el excel con la nómina ")
        document.formPropuesta.FILE1.focus ();
        return false;
    } else {
        document.formPropuesta.submit();
        return true;
    }
}
</script>
<body  onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);">
    <table id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
    <tr>
        <td align="center" valign="top" width='100%'>
            <table border='0' width='100%'>
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNom' id='formNom'>
                <input type="hidden" name="opcion"         id="opcion"           value='' />
                <input type="hidden" name="siguiente"      id="siguiente"        value='formNomina' />
                <input type="hidden" name="prop_proceso"   id="prop_proceso"     value="<%=codProceso%>"  />
                <input type="hidden" name="prop_codBoca"   id="prop_codBoca"     value="<%=codBoca%>"  />
                <input type="hidden" name="prop_cantVidas" id="prop_cantVidas"   value="<%=cantVidas%>"  />
                <input type="hidden" name="volver"         id="volver"
                       value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" />
                <input type="hidden" name="prop_del_orden" id="prop_del_orden"   value="" />
                <input type="hidden" name="num_tarjeta"    id="num_tarjeta"    value="<%= (oProp.getNumTarjCred() == null ? "" : oProp.getNumTarjCred()) %>"  />                
                <input type="hidden" name="cbu"            id="cbu"    value="<%= (oProp.getCbu() == null ? "" : oProp.getCbu()) %>"  />                                
                <tr>
                    <td>
                        <table border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td align="left" class='titulo'>Propuesta Nº:
                                    <input type="text" name="prop_numero" id="prop_numero"  size="10" maxleng="20" value="<%=numPropuesta%>"  disabled >
                                </td>
                            </tr>
                            <tr>
                                <td  colspan='4' valign="middle" align="left" class='titulo'>Carga de N&oacute;mina de Asegurados</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='titulo'>Ingrese desde aqu&iacute; el asegurado:</td>
                </tr>
                <tr>
                    <td>
                        <table  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="50px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th width="100px">Mano</th>
                                <th  width="60px">&nbsp;</th>
                            </thead>
                            <td> <input id='prop_nom_orden'  name='prop_nom_orden'  type='TEXT' value='<%=posOrden%>' style="WIDTH: 50px;" disabled></td>
                            <td> <input id='prop_nom_ApeNom' name='prop_nom_ApeNom' type='TEXT' value='' style="WIDTH: 200px;"></td>
                            <td>
                                <SELECT id='prop_nom_tipDoc' name='prop_nom_tipDoc' style="WIDTH: 50px"  class="select">
                                    <OPTION value="80"> CUIL </OPTION>
                                    <OPTION value="96"> DNI </OPTION> 
                                </SELECT>	
                            </td>
                            <td> <input type='TEXT' id='prop_nom_numDoc'   name='prop_nom_numDoc' style="WIDTH: 140px;" value=''
                                        size='12' maxlength='12'  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></td>
                            <td> <input type="text" id='prop_nom_fechaNac' name='prop_nom_fechaNac' style="WIDTH: 80px;"
                                        size="8"  maxlength='10' onblur="ControlarFecha (validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);" value=''> </td>
                            <td><SELECT id='prop_nom_mano' name='prop_nom_mano' style="WIDTH:100px" class="select">
                                    <option value="D">Diestro</Option>
                                    <option value="I">Zurdo</option> 
                                </select>
                            </td>
                            <td> <input type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="AddNomina();"  ></td>
                        </table>
                    </td>
                </tr>
<%
        if (cantNominas > 0) { 
%>                
                <tr>
                    <td class='titulo'>N&oacute;mina de asegurados</td>
                <tr>
                <tr>
                    <td>
                       <table  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="150px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th width="50px">Mano</th>
                                <th width="60px">&nbsp;</th>                                                         
                            </thead>
<%

            LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;

            for( int i=0; i < cantNominas; ++i) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNom.get(i);
                int    orden       = oAseg.getOrden();
                if (orden > posOrden) { posOrden = orden; }
                String fechaNac    = (oAseg.getFechaNac() == null ? "No informada" : Fecha.showFechaForm(oAseg.getFechaNac()));
%>
                            <tr>
                                <td    style="WIDTH: 50px;"  align='right'><%=orden%>&nbsp;</td>

                                <input type="hidden" id='prop_nom_orden_<%=i%>' name='prop_nom_orden_<%=i%>' value='<%=oAseg.getOrden () %>' />
                                <input type="hidden" id='prop_tipoDoc_<%=i%>'   name='prop_tipoDoc_<%=i%>' value='<%=oAseg.getTipoDoc () %>' />
                                <input type="hidden" id='prop_numDoc_<%=i%>'    name='prop_numDoc_<%=i%>' value='<%=oAseg.getNumDoc () %>'/>
                                <td    style="WIDTH: 200px;" align='left'>&nbsp;<%=oAseg.getNombre ()%></td>
                                <td    style="WIDTH: 150px;" align='left'>&nbsp;<%=oAseg.getDescTipoDoc () %></td>
                                <td    style="WIDTH: 140px;" align='right'><%=oAseg.getNumDoc()%>&nbsp;</td>
                                <td    style="WIDTH: 80px;"  align='right'><%=fechaNac%>&nbsp;</td>
<%                              if (oAseg.getmano() == null || oAseg.getmano ().equals ("")) {
%>
                                <td align='center'>no info</td>
<%                              } else {
%>
                                <td align='center'><%= (oAseg.getmano().equals ("D") ? "Diestro" : "Zurdo") %>&nbsp;</td>
<%                              }
%>

                                <td> <input type='BUTTON' value='Borrar' style="WIDTH: 60px;" class="boton" onClick="DelNomina('prop_nom_orden_<%=i%>');"  /></td>


                            </tr>
<%
            }
            posOrden += 1;

%>
                        </table>
                    </td>
                </tr>
<%
        } 
%>
                <input type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNominas%>"  />
                <tr valign="bottom" >
                    <td width="100%" align="center" height="40px" valign="middle">
                        <table border='0' align='left' class="" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdSalir"  value="Salir"  class="boton" onClick="Salir ();"/>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdEnviar"  value="Enviar Propuesta" class="boton" onClick="Enviar();"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                </form>
            </table>
        </td>
    </tr>
<% if (cantVidas >= 5 ) { %>

                <tr>
                    <td>
                        <table border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr bgcolor="#E8F2F6">
                                <td valign="top" bgcolor="#C8E0EA" class="txt2">
                                    <I>
                                    <P>&nbsp;Estimado, como la cantidad de asegurados de la propuesta supera los 10,como alternativa usted podrá ingresar los
                                    <BR>&nbsp;mismos desde una planilla Excel que nosotros le facilitaremos.
                                    <BR>
                                    <BR>
                                    <P>&nbsp;Si asi lo desea, por favor siga las siguientes instrucciones:
                                    <BR>
                                    <BR>
                                    &nbsp;1 - Si a&uacute;n no se ha bajado la planilla Excel, por favor hagalo
                                        <A class="link" target='_blank' href='<%= Param.getAplicacion()%>files\manuales\nominaBenef.xls'>
                                            <B> desde aqu&iacute;. </B>
                                        </A>  Recuerde que usted <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;puede reusar la misma planilla utilizada en la carga de otra propuesta.<BR>

                                    &nbsp;2 - Lea con mucha atenci&oacute;n las instrucciones de la primera hoja. La n&oacute;mina la deber&aacute; <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;completar en la segunda hoja.<BR>
                                    &nbsp;3 - Luego de completar la carga de la n&oacute;mina, grabe el archivo en su disco(desde Archivos -> Guardar como...)<BR>
                                    &nbsp;4 - Haga click en Examinar para buscar el archivo en su disco, y luego <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;haga click en Cargar Nomina.<BR>
                                    </I>
                                        <form id='formPropuesta' name='formPropuesta'  METHOD="POST" ACTION="/benef/propuesta/upload.jsp?num_propuesta=<%=numPropuesta%>&prop_cantVidas=<%=cantVidas%>&prop_rama=<%=codRama%>"
                                              ENCTYPE="multipart/form-data">
                                            <table border="0" cellpadding="0" cellspacing="4" width="100%" >
                                                <tr>
                                                    <td>
                                                        <input type="FILE"   name= "FILE1"   id="FILE1" SIZE="50"/>
                                                        <input type="button" name="EnviarArchivo" id="EnviarArchivo" value="Cargar Nomina" onclick="EnviarNomina ();" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </form>
                                    &nbsp;<LABEL style='color:red;'><I><U>IMPORTANTE:</U></I></LABEL> &nbsp;&nbsp;la carga desde esta via pisa la nomina ya ingresada manualmente<BR>
                                    &nbsp;o desde otro archivo Excel.<BR>
                        </table>
                    </td>
                </tr>
<%  }  %>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>

</table>
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
<div id="ventanita" style="display:none;position:absolute;top:80%;left :50%;width:600px;height:100%;margin-top: -30px;margin-left: -300px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                    Espere por favor que se esta emitiendo la p&oacute;liza...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
document.getElementById ('prop_nom_orden').value = <%= posOrden %>;
CloseEspere();
</script>
</body>
</html>
