<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp" %>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.Date"%>
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
    int cantNominas = 0 ;
   
    if (request.getAttribute("nominas") != null ) {
        LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;        
        cantNominas = lNom.size();
    }
    int posOrden = 1;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title></head>
<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    String.prototype.trim =  function() {
                    return (this.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
                }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    
    function ValidarDatos() {


        if (document.formNom.prop_nom_orden.value == "" ) {            
          alert ("Ingrese el Orden");
          return false; 
        }

        if (document.formNom.prop_nom_ApeNom.value == "" ) {            
          alert ("Ingrese el Nombre y Apellido");
          return false; 
        }
        
        if (document.formNom.prop_nom_numDoc.value == "") {            
          alert ("Ingrese el Documento o documento inválido !");
          return false; 
        }

        if  ( !ControlarDNI ( document.formNom.prop_nom_numDoc.value ) ) {
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
            var doc = document.getElementById('prop_numDoc_'+i).value;
            
            if ( tipo == document.formNom.prop_nom_tipDoc.value && 
                 doc  == document.formNom.prop_nom_numDoc.value
               ) {
                   alert( " El documento ingresado ya existe ..."  );
                   return false; 
               }
        }                

        return true;
    }


    function addPersona () {       

        var cantNom   = parseInt(document.formNom.prop_cantNom.value) + parseInt(1);        
        var cantVidas = document.formNom.prop_cantVidas.value ;        

        if ( cantNom > cantVidas ) {            
          alert (" La nómina debe tener " + cantVidas + " personas");
          return false; 
        }         

       if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.opcion.value="addPersona";
            document.formNom.submit();   
            return true;
        } 
        return false;
    }

    function Grabar () {
        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.opcion.value = "grabarNominaVO";
            document.formNom.submit();   
            return true;
        }  
        return false;
    }

    function Enviar () {

        var cantNom   = document.formNom.prop_cantNom.value ;
        var cantVidas = document.formNom.prop_cantVidas.value ;
        if( cantNom == cantVidas ) {

            if( ValidarEdad() ) {
                desbloquea();
                document.formNom.opcion.value="enviarPropuesta";
                document.formNom.submit();            
                return true;
            } else {
                return false;
            }

        } else {
            alert(" La nómina no puede ser enviada. Debe tener " + cantVidas + " personas " ); 
            return true;
        }

    }    


    function delPersona (param) {
        if (confirm("Esta usted seguro que desea eliminar la persona de la nómina ?  ")) {
            desbloquea();
            document.formNom.prop_del_orden.value = document.getElementById(param).value;
            document.formNom.opcion.value="delPersona"; 
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

    function ControlarFecha (fecha) {
       var edad =  calcular_edad ( fecha, getFechaActual () );

        if ( ! edad || edad < 1) {
            alert ("Fecha de nacimiento incorrecta");
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
         if (document.formNom.prop_nom_fechaNac.value == "" ) {            
           alert ("Fecha de nacimiento incorrecta");
           document.formNom.prop_nom_fechaNac.focus ();
          return false; 
        }

   }

    function ControlarDNI ( dni ) {
       
        if ( document.formNom.prop_nom_tipDoc.value == '80') {
            if ( ! ValidoCuit ( document.getElementById('prop_nom_numDoc').value.trim() )) {
                return document.getElementById( 'prop_nom_numDoc').focus ();
            }
        } else {
            if (document.formNom.prop_nom_numDoc.value.length < 7) {
                alert ("Documento inválido !");
                return document.formNom.prop_nom_numDoc.focus ();
            } 
        }

        return true;
    }

    function ControlarFechaEdad (fecha, desde) {

        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));

//        var edad =  calcular_edad (fecha, desde );
        if (edad > 64) {
            alert ("Debe tener a lo sumo 64 años de edad !!!");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        }  else if (  edad < 18) {
            alert ("Debe ser mayor a 18 años \n a la fecha de inicio de vigencia !!");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
    }

    function ValidarEdad() {        
        var rama = document.getElementById('prop_rama').value ;
        if (rama ==22) {
            var cantVidas = document.formNom.prop_cantVidas.value ;
            var fechaVig  = "<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>";

            for (i=0;i < cantVidas; i++) {            
                var nac  = document.getElementById('prop_fechaNac_'+i).value;
                if (nac != "no info") {
                    var Fecha_nac = new Date (FormatoFec( nac));
                    var Fecha_desde = new Date (FormatoFec( fechaVig));
                    var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));
                    if ( ! edad || edad > 64 || edad < 18 ) {
                        var j = i+1;
                        alert ("Fecha de nacimiento " + nac + " del Orden " + j + " es incorrecta, debe tener a lo sumo 64 años \n a la fecha de inicio de vigencia");
                        return false;
                    }
                }
            }            
        } 
        return true;
    }

</script>
<body>
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
        <TD align="center" valign="top" width='100%'>            
            <TABLE border='0' width='100%'>             
                <FORM method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNom' id='formNom'>                
                <input type="hidden" name="opcion"         id="opcion"           value='' >
                <input type="hidden" name="siguiente"      id="siguiente"        value='Volver' >
                <input type="hidden" name="prop_proceso"   id="prop_proceso"     value="<%=codProceso%>"  >
                <input type="hidden" name="prop_codBoca"   id="prop_codBoca"     value="<%=codBoca%>"  >
                <input type="hidden" name="prop_cantVidas" id="prop_cantVidas"   value="<%=cantVidas%>"  >
                <input type="hidden" name="prop_del_orden" id="prop_del_orden"   value=""  >
                <input type="hidden" name="prop_rama"      id="prop_rama"        value="<%=codRama%>"  >
                <input type="hidden" name="volver"         id="volver"
                       value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" >

                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   
                            <TR>
                                <TD  valign="middle" align="center" class='titulo'>Propuesta de <%= oProp.getDescRama() %></TD>
                            </TR>
                            <TR>
                                <TD align="left" class='titulo'>Propuesta Nº:                                
                                    <input type="text" name="prop_numero" id="prop_numero"  size="10" maxleng="20" value="<%=numPropuesta%>"  disabled >
                                </TD>
                            </TR>                        
                            <TR>
                                <TD  colspan='4' valign="middle" align="left" class='titulo'>Cantidad de Asegurados de la Propuesta: <%= cantVidas %></TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>
                <TR>
                    <TD class='titulo'>Ingrese desde aqu&iacute; los asegurados:</TD>
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y nombre</th>
                                <th width="150px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th width="100px">Mano</th>
                                <th  width="60px">&nbsp;</th>
                            </thead>
                            <TD> <input id='prop_nom_orden'  name='prop_nom_orden'  type='TEXT' value='<%=posOrden%>' style="WIDTH: 50px;" disabled></TD>
                            <TD> <input id='prop_nom_ApeNom' name='prop_nom_ApeNom' type='TEXT' value='' style="WIDTH: 200px;"></TD>
                            <TD>                                    
                                <SELECT id='prop_nom_tipDoc' name='prop_nom_tipDoc' style="WIDTH: 150px"  class="select">
                                    <OPTION value="80"> CUIL</OPTION>
<%                          if (codRama != 21) {
    %>
                                    <OPTION value="96"> DNI</OPTION>
<%                          }
    %>
                                </SELECT>	
                            </TD>        
                            <TD> <input type='TEXT' id='prop_nom_numDoc'   name='prop_nom_numDoc'   style="WIDTH: 140px;" value=''   size='12' maxlength='11'  onkeypress="return Mascara('D',event);"
                                        class="inputTextNumeric" onchange="ControlarDNI (this);"></TD>
<% if (oProp.getCodRama()== 21) { %>

                            <TD> <input type="text" id='prop_nom_fechaNac' name='prop_nom_fechaNac' style="WIDTH: 80px;"
                                        size="8"  maxlength='10' onblur="ControlarFecha (validaFecha ( this ));"
                                        onkeypress="return Mascara('F',event);" value=''> </TD>
<% } else { %>
                            <TD> <input type="text" id='prop_nom_fechaNac' name='prop_nom_fechaNac' style="WIDTH: 80px;"
                                        size="8"  maxlength='10' onblur="ControlarFechaEdad (validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);" value=''> </TD>

<% //System.out.println(" fecha fvigencia " + Fecha.showFechaForm(oProp.getFechaIniVigPol()) );
   }  %>
                            <TD>
                                <select id='prop_nom_mano' name='prop_nom_mano' style="WIDTH:100px" class="select">
                                    <option value="D">Diestro</option>
                                    <option value="I">Zurdo</option> 
                                </select>
                            </TD>

                            <TD> <input type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="addPersona();"  ></TD>
                        </TABLE>
                    </TD>
                </TR>           
<% 
        if (cantNominas > 0) { 
%>                
                <TR>
                    <TD class='titulo'>N&oacute;mina de asegurados</TD>
                </TR>
                <TR>
                    <TD>
                       <table  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Cert.</th>
                                <th width="200px">Nombre y Apellido</th>
                                <th width="150px">Tipo</th>                                                            
                                <th width="140px">Documento</th>                                                            
                                <th width="80px">Fecha Nac.</th>
                                <TH width="100px">Mano</TH>                                                           
                                <th width="60px">&nbsp;</th>                                                         
                            </thead>
<%

            LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;

            for( int i=0; i < cantNominas; ++i) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNom.get(i);
                int    orden       = oAseg.getOrden();
                if (orden > posOrden) { posOrden = orden; }
                String tipoDoc     = oAseg.getTipoDoc();  
                String descTipoDoc = oAseg.getDescTipoDoc();
                String numDoc      = oAseg.getNumDoc();
                String nombre      = oAseg.getNombre();
                String fechaNac    = (oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()));
%>
                            <TR>                                  
                                <TD    style="WIDTH: 50px;"  align='right'><%=orden%>&nbsp;</TD>

                                <input type="hidden" id='prop_nom_orden_<%=i%>' name='prop_nom_orden_<%=i%>' value='<%=orden%>' >
                                <input type="hidden" id='prop_tipoDoc_<%=i%>'   name='prop_tipoDoc_<%=i%>' value='<%=tipoDoc%>' >
                                <input type="hidden" id='prop_numDoc_<%=i%>'    name='prop_numDoc_<%=i%>' value='<%=numDoc%>' >

<input type="hidden" id='prop_fechaNac_<%=i%>'    name='prop_fechaNac_<%=i%>' value='<%=fechaNac%>' >

                                <TD    style="WIDTH: 200px;" align='left'>&nbsp;<%=nombre%></TD>                         
                                <TD    style="WIDTH: 150px;" align='left'>&nbsp;<%=descTipoDoc%></TD>                         
                                <TD    style="WIDTH: 140px;" align='right'><%=numDoc%>&nbsp;</TD>                         
                                <TD    style="WIDTH: 80px;"  align='right'><%=fechaNac%>&nbsp;</TD>                         

<%                              if (oAseg.getmano() == null || oAseg.getmano ().equals ("")) {
%>
                                <TD align='center'>no info</TD>
<%                              } else {
%>
                                <TD align='center'><%= (oAseg.getmano().equals ("D") ? "Diestro" : "Zurdo") %>&nbsp;</TD>
<%                              }
%>

                                <TD> <input type='BUTTON' value='Borrar' style="WIDTH: 60px;" class="boton" onClick="delPersona('prop_nom_orden_<%=i%>');"  ></TD>


                            </TR>
<%
            }
            posOrden += 1;
%>
                        </TABLE>		
                    </TD>
                </TR>
<%
        } 
%>
                <input type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNominas%>"  >
                </FORM>            
                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <TR bgcolor="#E8F2F6"> 
                                <TD valign="top" bgcolor="#C8E0EA" class="txt2">                                
                                    <I>
                                     <P>&nbsp;Estimado, para su mayor comodidad usted puede ingresar la n&oacute;mina de asegurados desde una planilla
                                     <BR>&nbsp;Excel modelo, que podrá bajarse desde esta misma p&aacute;gina. Si usted ya se baj&oacute; alguna vez la 
                                     <BR>&nbsp;planilla para la solicitud de otra propuesta, podr&aacute; reutilizarla.
                                    <BR>
                                    <BR>
                                    <P>&nbsp;Si asi lo desea, por favor siga las siguientes instrucciones: 
                                    <BR>
                                    <BR>                         
                                    &nbsp;1 - Si a&uacute;n no se ha bajado la planilla Excel, por favor hagalo
                                        <A class="link" target='_blank' href='<%= Param.getAplicacion()%>files/manuales/nominaBenef.xls'>            
                                            <B> desde aqu&iacute;. </B>
                                        </A>  Recuerde que usted <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;puede reusar la misma planilla utilizada en la carga de otra propuesta.<BR>

                                    &nbsp;2 - Lea con mucha atenci&oacute;n las instrucciones de la primera hoja. La n&oacute;mina la deber&aacute; <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;completar en la segunda hoja.<BR>
                                    &nbsp;3 - Luego de completar la carga de la n&oacute;mina, grabe el archivo en su disco (desde el men&uacute; del Explorador, Archivo --> Guardar como...)<BR>
                                    &nbsp;4 - Haga click en Examinar para buscar el archivo en su disco, y luego <BR> 
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;haga click en Cargar Nomina.<BR>    
                                    </I>
                                        
                                        <FORM id='fromPropuesta' METHOD="POST" ACTION="/benef/propuesta/upload.jsp?num_propuesta=<%=numPropuesta%>&prop_cantVidas=<%=cantVidas%>&prop_rama=<%=codRama%>" ENCTYPE="multipart/form-data">                  
                                            <TABLE border="0" cellpadding="0" cellspacing="4" width="100%" >                                     
                                                <TR>                                                                        
                                                    <TD>                            
                                                        <input type="FILE"   name= "FILE1"   id="FILE1" SIZE="50">
                                                       <input type="submit" name="Enviar" value="Cargar Nomina">
                                                    </TD>                     
                                                </TR>
                                            </TABLE>
                                        </FORM>                                    
                                    &nbsp;<LABEL style='color:red;'><I><U>IMPORTANTE:</U></I></LABEL> &nbsp;&nbsp;la carga desde esta via pisa la nomina ya ingresada manualmente<BR>
                                    &nbsp;o desde otro archivo Excel.<BR>    
                        </TABLE>		
                    </TD>
                </TR>


                <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <TABLE border='0' align='left' class="" width='700'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="center">
                                    <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">
                                    &nbsp;&nbsp;    
                                    <%--                                            
                                    <input type="button" name="cmdGrabar"  value="Grabar"  height="20px" class="boton" onClick="Grabar();">
                                    &nbsp;&nbsp;                                                
                                    --%>
                                    <input type="button" name="cmdEnviar"  value="Enviar Propuesta"    height="20px" class="boton" onClick="Enviar();">
                                </TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>

            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>

</TABLE>
<script>
document.getElementById ('prop_nom_orden').value = <%= posOrden %>;
CloseEspere();
</script>
</body>
</html>
