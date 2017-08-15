<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  
    Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml = new HtmlBuilder();
    Tablas     oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    Endoso oProp  = (Endoso) request.getAttribute ("propuesta");
    LinkedList lNom = (LinkedList) request.getAttribute ("nomina") ;        
    int cantNomina = lNom.size();       

    int    codProceso   = oProp.getCodProceso();
    String codBoca      = oProp.getBoca();
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;


    int posOrden = -1;
   
    String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;

        String documento    = oProp.getTomadorNumDoc();
        String domicilio    = (oProp.getTomadorDom()==null)?"":oProp.getTomadorDom();
        String localidad    = (oProp.getTomadorLoc()==null)?"":oProp.getTomadorLoc();
        String codigoPostal = (oProp.getTomadorCP()==null)?"":oProp.getTomadorCP();    
        String provincia    =  oProp.getTomadorDescProv();

        int nroCot       = oProp.getNumSecuCot    ();
        int cantCuotas   = oProp.getCantCuotas    ();
        int codEstado    = oProp.getCodEstado();

        String disabled = "disabled";
        if (codEstado == 0 || codEstado==4 ) {
            disabled = "";
        }

        if (oProp.getFechaIniVigPol() == null) {
            oProp.setFechaIniVigPol(new java.util.Date());
        }
    java.util.GregorianCalendar gc    = new java.util.GregorianCalendar();

        gc.setTime(oProp.getFechaIniVigPol());
        String fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script language="javascript">
    if ( history.forward(1) ) {
        history.replace(history.forward(1));
    }
    </script>
    </head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language='javascript'>
    function EliminarEndoso () {
        if ( confirm ("Esta usted seguro que desea eliminar definitivamente el endoso ?") ) {
            desbloquea();
            document.formNom.opcion.value = 'delEndoso'; 
            document.formNom.submit();            
            return true;
        } else {
            return false;
        }
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
          alert ("Ingrese el Apellido y Nombre");
          return false; 
        }
        
        if (document.formNom.prop_nom_numDoc.value == "" ) {            
          alert ("Ingrese el Documento");
          return false; 
        }

        if (document.formNom.prop_nom_numDoc.value.length > 11 ) {
          alert ("El documento no puede tener más de 11 caracteres");
          return false;
        }

        if (document.formNom.prop_nom_fechaNac.value == "" && document.formNom.prop_rama.value != "21" ) {            
          alert ("Ingrese Fecha Nacimiento");
          return false; 
        }

        if  ( !ControlarDNI ( document.formNom.prop_nom_numDoc.value ) ) {
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


        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.opcion.value="addPersona";
            document.formNom.submit();            
        }  
    }

    function Enviar () {
        
        var cantNom   = document.formNom.prop_cantNom.value ;
        var cantVidas = document.formNom.prop_cantVidas.value ;
        if (document.formNom.prop_cant_vidas_altas.value == "0" && document.formNom.prop_cant_vidas_bajas.value == "0") {
            alert ("Debe ingresar al menos un movimiento de Baja o Alta de asegurado" );
            return false;
        } else {
            if (confirm ("Usted esta seguro que desea enviar la propuesta de endoso ?")) {
                desbloquea();
                document.formNom.opcion.value="enviarEndoso";
                document.formNom.submit();            
                return true;
            } else {
                return false;
            }
        }
    }    


    function delPersona (tipo, num, item ) {
    if (document.formNom.prop_cantVidas.value == "1") {
        alert ("No puede eliminar al asegurado porque la nómina queda vacia");
        return false;
    } else {
        if (confirm("Esta usted seguro que desea eliminar la persona de la nómina ?  ")) {
            desbloquea();
            document.formNom.prop_del_tipo_doc.value = tipo;
            document.formNom.prop_del_num_doc.value  = num;
            document.formNom.prop_del_item.value     = item;
            
            document.formNom.opcion.value = 'delPersona'; 
            document.formNom.submit();            
            return true;
        } else {
            return false;
        }
     }
    }

    function cancelarEndosoAseg (tipo, num, estado ) {
        
        var total = 0;

        if (document.formNom.prop_cantVidas.value == "1") {
            if (estado == 'A') {
                alert ("No puede cancelar el endoso del asegurado porque la nomina queda vacia ");
                return false;
            }
        }

        if ( confirm ("Esta usted seguro que desea cancelar la modificación al asegurado  ") ) {
            desbloquea();
            document.formNom.prop_del_tipo_doc.value = tipo;
            document.formNom.prop_del_num_doc.value = num;
            
            document.formNom.opcion.value = 'cancelPersona'; 
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

        if (document.formNom.prop_rama.value != "21") {
            var edad =  calcular_edad (fecha, desde );
            if ( ! edad || edad > 64 || edad < 18) {
                alert ("Fecha de nacimiento inválida, la edad debería ser entre 18 y 64 años \n a la fecha de inicio de vigencia");
                document.formNom.prop_nom_fechaNac.value = "";
                document.formNom.prop_nom_fechaNac.focus ();
                return false;
            } else {
                return true;
            }
        }
    }

    function ControlarDNI ( dni ) {
       
        if ( document.formNom.prop_nom_tipDoc.value == '80') {
            if ( ! ValidoCuit (document.getElementById('prop_nom_numDoc').value)) {
                document.getElementById('prop_nom_numDoc').focus ();
                return false;
            }
        } else {
            if (document.formNom.prop_nom_numDoc.value.length < 7 ||
                document.formNom.prop_nom_numDoc.value.length > 8) {
                alert ("Documento inválido !");
                document.formNom.prop_nom_numDoc.focus ();
                return false;
            } 
        }

        return true;
    }
</script>
    <body  onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);"> 
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
            <table border='0' width='100%' class="fondoForm">
                <form method="post" action="<%= Param.getAplicacion()%>servlet/EndosoServlet" name='formNom' id='formNom'>
                <INPUT type="hidden" name="opcion"         id="opcion"           value='confEnd' >             
                <INPUT type="hidden" name="siguiente"      id="siguiente"        value='Volver' >    
                <INPUT type="hidden" name="prop_proceso"   id="prop_proceso"     value="<%= oProp.getCodProceso () %>"  >             
                <INPUT type="hidden" name="prop_codBoca"   id="prop_codBoca"     value="<%= oProp.getBoca () %>"  >
                <INPUT type="hidden" name="prop_cantVidas" id="prop_cantVidas"   value="<%= oProp.getCantVidas () %>"  >
                <INPUT type="hidden" name="prop_del_tipo_doc" id="prop_del_tipo_doc" value=""  >
                <INPUT type="hidden" name="prop_del_num_doc"  id="prop_del_num_doc"  value=""  >
                <INPUT type="hidden" name="prop_del_item"     id="prop_del_item"     value=""  >
                <INPUT type="hidden" name="prop_rama"      id="prop_rama"        value="<%= oProp.getCodRama   ()%>"  >                
                <INPUT type="hidden" name="cod_rama"       id="cod_rama"         value="<%=oProp.getCodRama   () %>"  >             
                <INPUT type="hidden" name="num_poliza"     id="num_poliza"       value="<%=oProp.getNumPoliza () %>"  >             
                <input type="hidden" name="prop_cant_vidas_altas" id="prop_cant_vidas_altas" value="<%=oProp.getCantVidasAltas ()%>">
                <input type="hidden" name="prop_cant_vidas_bajas" id="prop_cant_vidas_bajas" value="<%=oProp.getCantVidasBajas ()%>">
                <TR>
                    <TD>
                        <TABLE border='0' align='left'  width='100%'>               
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><U>FORMULARIO DE PROPUESTA DE ENDOSO</U></TD>
                            </TR>
                            <TR>                                
                                <td width='15'>&nbsp;</td>
                                <TD class='text' colspan='2' align='left'>
                                    <LABEL> <span style='color:red;'><U>IMPORTANTE:</U></span><b> Al finalizar la carga del endoso debe hacer click en el botón Enviar Endoso.<br>
                                            Caso contrario después de 1 hora el endoso será eliminado autom&acute;ticamente por el sistema.</b><BR><br>
                                    <span style='color:red;'>SI LA POLIZA YA ESTA RENOVADA LOS MOVIMIENTOS SE APLICARAN AUTOMATICAMENTE EN LA RENOVACION</span>
                                        <BR><br>
                                    </LABEL>

                                </TD>                                
                            </TR>
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'> A - Datos Generales</TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' nowrap>Propuesta Nº:</TD>
                                <TD align="left" class='text'>
                                    <INPUT type="text" name="prop_numero" id="prop_numero"  size="20" maxleng="20" value="<%= oProp.getNumPropuesta ()%>" disabled>
                                </TD>
                            </TR>
                            <TR>
                                <TD width='15'>&nbsp;</TD>
                                <TD align="left" class='text'>Productor:</TD>
                                <TD align="left" class='text'> <%=oProp.getdescProd () + " (" + oProp.getCodProd() + ")" %></TD>        
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left"  class="text" valign="top" >Rama:&nbsp;</TD>
                                <TD align="left"  class="text"><%= oProp.getDescRama ()%></TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left"  class="text" valign="top" >Num. P&oacute;liza:&nbsp;</TD>
                                <TD align="left"  class="text"><%= Formatos.showNumPoliza(oProp.getNumPoliza())%></TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='150'>Descripción del tomador:</TD>
                                <TD align="left" class='text' width='450'><%= (oProp.getTomadorRazon () == null ? "" : oProp.getTomadorRazon ()) %>&nbsp;<%= oProp.getTomadorNom () == null ? "" : oProp.getTomadorNom () %></TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Domicilio del tomador:</TD>
                                <TD align="left" class='text'><%=domicilio %>&nbsp;<%=localidad%>&nbsp;(<%=codigoPostal%>)&nbsp;<%= provincia %></TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Fecha de inicio del endoso:</TD>
                                <TD align="left" class='text'>
                                    <INPUT type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>" <%=disabled%> >&nbsp;(dd/mm/yyyy)
                                </TD>    
                            </TR>
                            <TR>                                
                                <td width='15'>&nbsp;</td>
                                <TD class='text' colspan='2' align='left'>
                                    <LABEL> <span style='color:red;'><U>Nota:</U></span><b> La Fecha de Inicio del endoso es tentativa y
                                            supeditada a la aprobaci&oacute;n de la misma por la compa&ntilde;ia.<br>
                                            Todas las propuestas enviadas después de las 12:00 hs. tendrá fecha de inicio de vigencia a partir del día siguiente.</b><BR><BR>
                                    </LABEL>
                                </TD>                                
                            </TR>
<%--
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='150' nowrap>Desea recibir el endoso ?:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="radio" value='S' name='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("S") ? "checked" : " ") %>>&nbsp;SI deseo recibir el endoso impreso <b>por CORREO</b><br>
                                    <input type="radio" value='N' name='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("N") ? "checked" : " ") %>>&nbsp;NO deseo recibir el endoso<br>
                                    <input type="radio" value='M' name='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("M") ? "checked" : " ") %>>&nbsp;Deseo recibir el endoso <b>v&iacute;a MAIL</b>
                                 </TD>                                
                            </TR>
                            <TR><td >&nbsp;</td>
                                <TD align="left" class='text' colspan='2'>Observaci&oacute;n :</TD>                                
                            </TR>
                            <TR>                           
                                <td width='15'>&nbsp;</td>
                                <TD width="100%" colspan='2'>
                                    <TEXTAREA cols='65' rows='3' name="prop_obs" id="prop_obs"><%= (oProp.getObservaciones() == null ? "" : oProp.getObservaciones () ) %></TEXTAREA>
                                </TD>
                            </TR>
--%>
                            <input type="hidden" name="prop_mca_envio_poliza" id="prop_mca_envio_poliza" value="N" >
                            <input type="hidden" name="prop_obs" id="prop_obs" value="<%= (oProp.getObservaciones() == null ? "" : oProp.getObservaciones () ) %>" >
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'><b>Cantidad de vidas:</b></TD>
                                <TD align="left" class='text'><b><%= (oProp.getCantVidas ())%></b></TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'> <img src='/benef/images/ok.gif' border='0'><b>Cantidad de Altas:</b></TD>
                                <TD align="left" class='text'><b><%=oProp.getCantVidasAltas ()%></b></TD>    
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'> <img src='/benef/images/nook.gif' border='0'><b>Cantidad de Bajas:</b></TD>
                                <TD align="left" class='text'><b><%=oProp.getCantVidasBajas ()%></b></TD>    
                            </TR>
                        </TABLE>
                    </TD>
                    </TR>

<%
        if (cantNomina > 0) { 
%>                
                <TR>
                    <TD class='subtitulo'>Utilize el botón Dar de Baja para eliminar asegurados de la nómina. Con el bot&oacute;n Cancelar usted podrá eliminar del endoso al asegurado seleccionado.</TD>                 
                <TR>
                <tr>
                    <td>
                        <TABLE border='0' align='left'  width='100%'>               
                            <TR valign="top">
                                <td width='15'>&nbsp;</td>
                                <td align="right" class='text' valign="top" colspan='2'><b><SPAN style='color:red'>Referencias:</span>
                                <img src='/benef/images/ok.gif' border='0'>&nbsp;:&nbsp;Asegurado dado de alta en el endoso<br>
                                <img src='/benef/images/nook.gif' border='0'>&nbsp;:&nbsp;Asegurado dado de baja en el endoso</b></TD>
                            </tr>
                        </table>
                    </td>
               </tr>
                <TR>
                    <TD>
                       <TABLE  border="0" cellspacing="0" cellpadding="2" align="center" class="TablasBody" style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Item</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="50px">Tipo</th>                                                            
                                <th width="140px">Documento</th>                                                            
                                <th width="80px">Fecha Nac.</TH>                                                            
                                <th width="70px">&nbsp;</th>                                                         
                                <th width="70px">&nbsp;</th>                                                         
                            </thead>
<%

            for( int i=0; i < cantNomina; ++i) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNom.get(i);
                String fechaNac    = (oAseg.getFechaNac() == null || Fecha.showFechaForm(oAseg.getFechaNac()).equals ("01/01/1900") ? "no informado" : Fecha.showFechaForm(oAseg.getFechaNac()));
                if (posOrden < oAseg.getOrden()) {
                    posOrden = oAseg.getOrden();
                }
%>
                            <TR>                                  
                                <TD    align='right'><%=oAseg.getOrden()%>&nbsp;</TD>

                                <INPUT type="hidden" id='prop_nom_orden_<%=i%>' name='prop_nom_orden_<%=i%>' value='<%=oAseg.getOrden()%>' >     
                                <INPUT type="hidden" id='prop_tipoDoc_<%=i%>'   name='prop_tipoDoc_<%=i%>' value='<%=oAseg.getTipoDoc()%>' >     
                                <INPUT type="hidden" id='prop_numDoc_<%=i%>'    name='prop_numDoc_<%=i%>' value='<%=oAseg.getNumDoc()%>' >     

                                <TD    align='left'>&nbsp;<%=oAseg.getNombre()%></TD>                         
                                <TD    align='left'>&nbsp;<%=oAseg.getDescTipoDoc()%></TD>                         
                                <TD    align='right'><%=oAseg.getNumDoc()%>&nbsp;</TD>                         
                                <TD    align='right'><%=fechaNac%>&nbsp;</TD>    
<%                      if (oAseg.getEstado () != null && oAseg.getEstado ().equals ("B") ) {
    %>
                                <TD align="center" > <img src='/benef/images/nook.gif' border='0' alt='Asegurado eliminado de la n&oacute;mina'></TD>                             
                                <TD align="center" > <INPUT type='BUTTON' name="cmdCancelar" value='Cancelar' style="WIDTH:70px;" class="boton" onClick="cancelarEndosoAseg('<%=oAseg.getTipoDoc()%>','<%=oAseg.getNumDoc()%>','<%= oAseg.getEstado () %>' );" alt='Cancelar el endoso del asegurado'></TD>                             
<%                      } else {
                                if (oAseg.getEstado () != null && oAseg.getEstado ().equals ("A") ) {
    %>
                                <TD align="center" > <img src='/benef/images/ok.gif' border='0' alt='Asegurado agregado a la n&oacute;mina'></TD>                             
                                <TD align="center" > <INPUT type='BUTTON' name="cmdCancelar" value='Cancelar' style="WIDTH:70px;" class="boton" onClick="cancelarEndosoAseg('<%=oAseg.getTipoDoc()%>','<%=oAseg.getNumDoc()%>','<%= oAseg.getEstado () %>');" alt='Cancelar el endoso del asegurado'></TD>                             
<%                              } else {
    %>
                                <TD align="center" > <INPUT type='BUTTON' name="cmddelAseg" value='Dar de Baja' style="WIDTH:80px;" class="boton" onClick="delPersona('<%=oAseg.getTipoDoc()%>','<%=oAseg.getNumDoc()%>', '<%=oAseg.getOrden()%>');" alt='Dar de baja al asegurado'></TD>
                                <TD align="center" >&nbsp;</td>
<%                                     }
                                }
    %>
                            </TR>
<%
            }
%>
                        </TABLE>		
                    </TD>
                </TR>
<%
        } 

        posOrden = posOrden + 1;
%>
                <INPUT type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNomina%>"  >  
                <TR>
                    <TD class='subtitulo'>Ingrese desde aqu&iacute; los asegurados a dar de alta:</TD>                 
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="150px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th  width="60px">&nbsp;</th>
                            </thead>
                            <TD> <INPUT id='prop_nom_orden'  name='prop_nom_orden'  type='TEXT' value='<%=posOrden%>' style="WIDTH: 50px;" disabled></TD>                         
                            <TD> <INPUT id='prop_nom_ApeNom' name='prop_nom_ApeNom' type='TEXT' value='' style="WIDTH: 200px;"></TD>                         
                            <TD>                                    
                                <SELECT id='prop_nom_tipDoc' name='prop_nom_tipDoc' style="WIDTH: 150px"  class="select">
                                    <OPTION value="80"> CUIL </OPTION>
<%                              if (oProp.getCodRama () != 21 ) {
    %>
                                    <OPTION value="96"> DNI </OPTION>
<%                              }
    %>
                                </SELECT>	
                            </TD>        
                            <TD> <INPUT type='TEXT' id='prop_nom_numDoc'   name='prop_nom_numDoc'   style="WIDTH: 140px;" value=''   size='12' maxlength='12'
                                        onkeypress="return Mascara('D',event);" class="inputTextNumeric"></TD>
                            <TD> <INPUT type="text" id='prop_nom_fechaNac' name='prop_nom_fechaNac' style="WIDTH: 80px;"  size="8"  maxlength='10' 
                                        onblur="ControlarFecha (validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);" value=''> </TD>
                            <TD> <INPUT type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="addPersona();"  ></TD>                                                   
                        </TABLE>
                    </TD>
                </TR>           
               <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <TABLE border='0' align='left' class="" width='700'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="center">
                                    <INPUT type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">
                                    &nbsp;&nbsp;&nbsp;&nbsp;    
                                    <INPUT type="button" name="cmdEliminar"  value="Eliminar Endoso"  height="20px" class="boton" onClick="EliminarEndoso ();">
                                    &nbsp;&nbsp;&nbsp;&nbsp;    
                                    <INPUT type="button" name="cmdEnviar"  value="Enviar Endoso"    height="20px" class="boton" onClick="Enviar();">                                                                                
                                </TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>

            </TABLE>
        </TD>
    </TR>
    </FORM>            
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>

</TABLE>
<script>
CloseEspere();
</script>
</body>
</html>
