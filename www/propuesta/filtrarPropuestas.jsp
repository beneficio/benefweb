<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    LinkedList lProp = (LinkedList) request.getAttribute("propuestas");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    String sPri         = oDicc.getString(request,"F2pri","S");
    int iCodProd        = oDicc.getInt (request, "F2cod_prod");
    String sNombre      = oDicc.getString (request, "F2nombre");
    String sFechaDesde   =  oDicc.getString (request, "F2f_desde");
    String sFechaHasta   =  oDicc.getString (request, "F2f_hasta");
    
    int iNumPoliza      = oDicc.getInt (request, "F2num_poliza");
    int iNumPropuesta   = oDicc.getInt (request, "F2num_propuesta");
    int iCodRama        = oDicc.getInt (request, "F2cod_rama");

    int iNumPolizaSelec = oDicc.getInt (request, "F2num_propuesta_sel");
    int iCodRamaSelec   = oDicc.getInt (request, "F2cod_rama_sel");
    int iEstado         = oDicc.getInt (request, "F2estado");

    oDicc.add("F2pri", sPri );
    oDicc.add("F2nombre", sNombre);
    oDicc.add("F2cod_prod", String.valueOf(iCodProd));
    oDicc.add("F2num_propuesta", String.valueOf (iNumPropuesta));
    oDicc.add("F2num_poliza", String.valueOf (iNumPoliza));
    oDicc.add("F2cod_rama", String.valueOf (iCodRama));
    oDicc.add("F2num_propuesta_sel", String.valueOf (iNumPolizaSelec));
    oDicc.add("F2cod_rama_sel", String.valueOf (iCodRamaSelec));
    oDicc.add("F2f_desde", sFechaDesde);
    oDicc.add("F2f_hasta", sFechaHasta);
    oDicc.add("F2estado", String.valueOf (iEstado));
    
    session.setAttribute("Diccionario", oDicc);

    String sPath            = 
    "&F2pri=N&F2nombre=" + sNombre + "&F2cod_rama_sel=0" + "&F2estado=" + iEstado  +  
    "&F2cod_prod=" + iCodProd  + "&F2f_desde=" + sFechaDesde  +"&F2f_hasta=" + sFechaHasta  +
    "&F2num_propuesta=" + iNumPropuesta + "&F2num_poliza=" + iNumPoliza +
    "&F2num_propuesta_sel=0&F2cod_rama=" + iCodRama + "&opcion=getAllProp" ;

    HtmlBuilder ohtml   = new HtmlBuilder();
    Tablas oTabla       = new Tablas ();
    LinkedList lTabla   = new LinkedList ();
    int size            = (lProp == null ? 0 : lProp.size());

    Date dFechaFTP = null;
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript">
    var usuarios = ["VEFICOVICH","VILLALOBO","PINO","MCARBALLO","ADELGRECO","GLUCERO","FTRIDICO" ];
    
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Ver ( numProp, estado , tipo, rama ) {
        
        document.form1.numPropuesta.value        = numProp;
        document.form1.num_propuesta.value       = numProp;
        document.form1.cod_rama.value            = rama;
        document.form1.F2num_propuesta_sel.value = numProp;

        if ( estado == '0' || estado == '4' ) {
            if (tipo == 'P' || tipo == 'R') {
                  if ( rama == '9' ) {
                      document.form1.action = "<%= Param.getAplicacion() %>servlet/CaucionServlet";
                  } else {
                    document.form1.action = "<%= Param.getAplicacion() %>servlet/PropuestaServlet";
                  }
                document.form1.opcion.value = "getPropuestaBenef";
            } else {
                if ( tipo === "E") {
                    document.form1.action = "<%= Param.getAplicacion() %>servlet/EndosoServlet";
                    document.form1.opcion.value = "editEndoso";
                } else {
                    document.form1.action = "<%= Param.getAplicacion() %>propuesta/printEndoso.jsp";
                    document.form1.opcion.value = "printEndoso";
                }
            }
        } else  {
            if (tipo == 'P' || tipo == 'R') {
                if (rama == '9' ) {
                    document.form1.action = "<%= Param.getAplicacion() %>propuesta/printCaucion.jsp";
                    document.form1.opcion.value = "printCaucion";
                } else {
                    document.form1.action = "<%= Param.getAplicacion() %>propuesta/printPropuesta.jsp";
                    document.form1.opcion.value = "printPropuesta";
                }
             } else {
                document.form1.action = "<%= Param.getAplicacion() %>propuesta/printEndoso.jsp";
                document.form1.opcion.value = "printEndoso";
             }
             document.form1.volver.value = "-1";
        }
        document.form1.submit();
    }

   function PrintCertif ( numCertif, tipo, tcert ) {
        // alert( "  certif " + numCertif + " tipo " + tipo);
        document.form1.action = "<%= Param.getAplicacion() %>certificado/printCertificado.jsp";
        document.form1.opcion.value     = "getPrintCert";        
        document.form1.numCert.value    = numCertif;
        document.form1.tipo.value       = tipo; 
        document.form1.tipo_cert.value  = tcert; 
     
        document.form1.submit();
    }


    function addCertif ( numProp, numCertif, codRama, tcert ) {
        var nombre = prompt('Ingrese ante quien será presentado el certificado', ' ');
            if (nombre !== null) {
                document.form1.presentar.value     = nombre;
                document.form1.num_propuesta.value = numProp;
                document.form1.numCert.value       = numCertif;
                document.form1.cod_rama.value      = codRama;
                document.form1.tipo_cert.value      = tcert;
                document.form1.action              = "<%= Param.getAplicacion() %>servlet/CertificadoServlet";
                document.form1.opcion.value        = "addCertificadoProp";
                document.form1.volver.value        = "getAllProp";
                document.form1.submit();
                return true;
            } else {
                return false;
            }
    }

    function Buscar () { 
        
        if (document.form1.F2num_propuesta.value == "") {
            document.form1.F2num_propuesta.value = "0";
        }

        if (document.form1.F2num_poliza.value == "") {
            document.form1.F2num_poliza.value    = "0";
        }

        if ( document.form1.tipo_usuario.value == "0") {
            if (document.form1.F2cod_prod.value == "0" && 
                document.form1.F2nombre.value   == "" && 
                document.form1.F2cod_rama.value == "0" && 
                document.form1.F2estado.value   == "0" &&
                document.form1.F2f_desde.value  == "" && 
                document.form1.F2f_hasta.value == "" && 
                document.form1.F2num_propuesta.value == "0" && 
                document.form1.F2num_poliza.value    == "0" ) {
                    alert (" Debe seleccionar algún filtro válido" );
                    return false;
                }
        }

        permitidos=/[^0-9.]/;
        if(permitidos.test(document.form1.F2num_propuesta.value)){
            alert("En la celda número de propuesta hay caracteres que no son números, por favor verifique");
            return document.form1.F2num_propuesta.focus();
        }

        if(permitidos.test(document.form1.F2num_poliza.value)){
            alert("En la celda de número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.F2num_poliza.focus();
        }

        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/PropuestaServlet";
            document.form1.opcion.value  = 'getAllProp';
            document.form1.submit(); 
            return true;
       } else {
            return false;
       }
    }

    function CambiarEstado ( num ) {

        var existe = usuarios.indexOf(document.getElementById ("usuario").value ); 
        if ( existe === -1 ) {
            alert ( "USUARIO NO AUTORIZADO ") ;
            return false;
        } else { 
            if (confirm ("Esta seguro que desea autorizar la emisión de la propuesta ?")) {
                    document.form1.prop_numero.value = num;
                    document.form1.action = "<%= Param.getAplicacion()%>servlet/PropuestaServlet";
                    document.form1.opcion.value  = "autorizarProp";
                    document.form1.submit();
                    return true;
                } else {
                    return false;
            }
        }
    }
    
    //agregado flavio
    function Eliminar (num) {
    var existe = usuarios.indexOf(document.getElementById ("usuario").value ); 
        if ( existe === -1 ) {
            alert ( "USUARIO NO AUTORIZADO ") ;
            return false;
        } else { 
        if (confirm ("Esta usted seguro que desea ELIMINAR la propuesta ?")) {
            document.form1.prop_num_prop.value = num;
            document.form1.action = "<%= Param.getAplicacion()%>servlet/PropuestaServlet";
            document.getElementById ('opcion').value = 'eliminarProp';
            document.form1.submit();
            return true;
        } else {
            return false;
        }
        }
    }
    //fin
    </script>
</head>
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
    <tr>
        <td valign="top" align="center" width="90%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet">
                <input type="hidden" name="F2pri" id="F2pri" value="N"/>
                <input type="hidden" name="F2num_propuesta_sel" id="F2num_propuesta_sel" value="0"/>
                <input type="hidden" name="F2cod_rama_sel"  id="F2cod_rama_sel" value="0"/>
                <input type="hidden" name="formato"         id="formato"        value="HTML"/>
                <input type="hidden" name="opcion"          id="opcion"         value="getPropuestaBenef"/>
                <input type="hidden" name="numPropuesta"    id="numPropuesta"   value="0"/>
                <input type="hidden" name="num_propuesta"   id="num_propuesta"  value="0"/>
                <input type="hidden" name="prop_numero"     id="prop_numero"    value="0"/>
                <input type="hidden" name="prop_num_prop"     id="prop_num_prop"    value="0"/>
                <input type="hidden" name="cod_rama"        id="cod_rama"       value="10"/>
                <input type="hidden" name="numCert"         id="numCert"        value="0"/>
                <input type="hidden" name="tipo"            id="tipo"           value="0"/>
                <input type="hidden" name="presentar"       id="presentar" />
                <input type="hidden" name="tipo_cert"       id="tipo_cert"      value="PR"/>
                <input type="hidden" name="volver"          id="volver"         value="filtrarPropuestas"/>
                <input type="hidden" name="usuario"         id="usuario"   value="<%= usu.getusuario() %>"/>                
                <input type="hidden" name="tipo_usuario"    id="tipo_usuario"   value="<%= usu.getiCodTipoUsuario() %>"/>
                <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo'>CONSULTA DE PROPUESTAS GENERADAS VIA WEB</TD>
                    </TR>
<%          if (usu.getiCodTipoUsuario() != 0) {
                        if (usu.getiCodTipoUsuario () == 1 && usu.getiCodProd () < 80000) {
    %>

                            <input type="hidden" name="F2cod_prod" value="0"/>
<%                      }
            %>
                <tr>
                    <td width='100%' align="left" class='subtitulo' valign="top">
Estimado, usted puede combinar varios filtros a la vez, sino selecciona ningún filtro visualizar&aacute; las propuestas 
de los &uacute;ltimos 7 d&iacute;as. La cantidad máxima de propuestas a listar es 100.  
                    </td>
                </tr>
<%          }
    %>
                <tr>
                    <td align="center" valign="top">
                        <table border='0' align="center" cellpadding='2' cellspacing='0' width='100%'>
<%                      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
    %>
                            <tr>
                                <td colspan='4' align="left" class="text">
                                    Puede filtrar por una o varias condiciones:
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="text" width="100">Productor:</td>
                                <td class="text" align="left" width='400' colspan='3'>
                                    <select class='select' name="F2cod_prod" id="F2cod_prod">
                                        <option value='0' >Todos los productores</option>
<%                              LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                 for (int i= 0; i < lProd.size (); i++) {
                                        Usuario oProd = (Usuario) lProd.get(i);
                                        out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                    }
    %>
                                    </select>
                                </td>
                            </tr>

<%                      }
    %>
                            <tr>
                                <td align="left"  class="text" valign="top">Rama:</td>
                                <td align="left"  class="text" valign="top">
                                    <select name="F2cod_rama" id="F2cod_rama"   class="select">
                                        <option value='0' >Todas las rama</option>
    <%                           lTabla = oTabla.getRamas ();
                                 out.println(ohtml.armarSelectTAG(lTabla, iCodRama )); 
    %>
                                    </select>
                                </td>
                                <td align="left"  class="text" valign="top">Estado:</td>
                                <td align="left"  class="text" valign="top">
                                    <select name="F2estado" id="F2estado"   class="select">
                                        <option value='0' >Todos los estados</option>
                                        <option value='1' <%= (iEstado == 1 ? "selected" : "" )%> >PENDIENTES</option>
                                        <option value='2' <%= (iEstado == 2 ? "selected" : "" )%> >RECHAZADAS</option>
                                        <option value='3' <%= (iEstado == 3 ? "selected" : "" )%> >EMITIDAS</option>
                                    </select>
                                 </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text" nowrap>(*)Descripci&oacute;n Tomador:</td>
                                <td align="left"  class="text" colspan='3'><input name="F2nombre" id="F2nombre" size='45' value="<%= sNombre %>"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text">N&uacute;mero Propuesta:</td>
                                <td align="left"  class="text"><input name="F2num_propuesta" id="F2num_propuesta"  size='12' maxlength='12' value="<%= iNumPropuesta %>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric"/></td>
                                <td align="left" class='text'>(**) N&uacute;mero P&oacute;liza:</td>
                                <td align="left" class='text'><input name="F2num_poliza" id="F2num_poliza"  size='12' maxlength='12' value="<%= iNumPoliza %>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text">Fecha Desde:&nbsp;</td>
                                <td align="left"  class="text"><input name="F2f_desde" id="F2f_desde" size="10" maxlength='10' 
                                onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= (sFechaDesde == null ? "" : sFechaDesde) %>"/>&nbsp;(dd/mm/yyyy)</td>
                                <td align="left"  class="text">Fecha Hasta:&nbsp;</td>
                                <td align="left"  class="text"><input name="F2f_hasta" id="F2f_hasta" size="10"  maxlength='10'
                                onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= (sFechaHasta == null  ? "" : sFechaHasta) %>"/>&nbsp;(dd/mm/yyyy)</td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    <TR>
                        <TD valign="middle" align="left" class='text' >(*) Puede ingresar el valor parcialmente.&nbsp;
                        Por ej: ingresando Oscar, visualizará todas las pólizas en la que el cliente contenga Oscar<br/>
                        (**) <span style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                        </TD>
                    </TR>
                    <TR>
                        <TD align="center" >
                        <input type="button" name="cmdSalir"  value="Salir"  class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="Buscar"  class="boton" onClick="Buscar ();"/>
                        </TD>
                    </TR>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>
                <tr>
                    <td height="30px" valign="middle" align="center" class='titulo'>Resultado de la consulta</td>
                </tr>
                <tr>
                    <td height="100%"  valign="top">
                        <table border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:10;margin-bottom:10;">
                            <tr>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="30"  items="<%= size %>" url="/benef/servlet/PropuestaServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="1" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                                            <thead>
                                                <th align="center">Tipo</th>
                                                <th align="center" width='65'>Propuesta</th>
                                                <th align="center" width='30' nowrap>Rama</th>
                                                <th align="center" width='65'>Cotizacion</th>
                                                <th align="center" width='65'>Fecha Creaci&oacute;n</th>                                                
                                                <th align="center" width='145'>Estado</th> 
                                                <th align="center" width='65'>Póliza</th> 
                                                <th align="center" width='155'><%= (usu.getiCodTipoUsuario() == 0 ? "Productor" : "Cliente" )%></th>
                                                <th align="center" colspan='2' >&nbsp;</th>
                                                <th align="center">&nbsp;</th>
                                            </thead>
<%                                  if (size == 0){ 
    %>
                                            <tr>
                                                <td colspan="11">No existen propuestas a listar</td>
                                            </tr>
<%                                  }  
                                            for (int i=0; i < size ; i++) {
                                                Propuesta oProp = (Propuesta) lProp.get (i); 
                                                String sColor = "";
                                                String tipoPropuesta = "Endoso";
                                                if (oProp.getTipoPropuesta().equals("P")) 
                                                    tipoPropuesta = "P&oacute;liza";
                                                if (oProp.getTipoPropuesta().equals("R"))
                                                    tipoPropuesta = "Renovaci&oacute;n";
                                                
                                                switch (oProp.getCodEstado()) {
                                                    case 2:
                                                    case 7:
                                                    case 4: 
                                                        sColor = "color:red;";
                                                    case 1:
                                                    case 5: 
                                                        sColor = "color:green;";
                                                        break;
                                                    default: 
                                                        sColor = "color:black;";
                                                }
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="left" nowrap><%= tipoPropuesta %></td>
                                                <td align="right"><%= oProp.getNumPropuesta()%></td> 
                                                <td align="center" nowrap><%= oProp.getDescRama ()%></td>
                                                <td align="right"><%= oProp.getNumSecuCot()%></td>                                                 
                                                <td align="right"><%= Fecha.showFechaForm(oProp.getFechaTrabajo())%></td>                                                 
<%                                          if (oProp.getCodEstado() == 4) {
    %>
                                                <td align="center"><span style=<%= sColor %>><%= oProp.getdescEstado ()%>&nbsp;-Motivo:&nbsp;<%= (oProp.getDescError()==null)?"no informado" : oProp.getDescError()%></span></td>
<%                                          } else  {
    %>
                                                        <td align="center"><span style=<%= sColor %>><%= (oProp.getCodRama() == 21 && oProp.getCodEstado() == 3 ? (oProp.getdescEstado () + "<BR><span style='color:red;'>CUIC PENDIENTE</span>") : oProp.getdescEstado ()) %></span></td>
<%                                                  }
    %>
                                                <td align="right"><b>&nbsp;<%= Formatos.showNumPoliza(oProp.getNumPoliza ())%></b></td>
                                                <td align="left"><%= (oProp.getdescProd() == null ? "" : oProp.getdescProd()) %>&nbsp;</td>
<%                                          if (oProp.getCodEstado() == 0 || oProp.getCodEstado() == 4) {
    %>
                                                <td nowrap  align="center">
                                                    <span><IMG height='19' width='19' onClick="Ver('<%= oProp.getNumPropuesta()%>','<%= oProp.getCodEstado ()%>','<%= oProp.getTipoPropuesta ()%>', '<%= oProp.getCodRama() %>');"
                                                        alt="Editar la propuesta" src="<%= Param.getAplicacion() %>images/consultasPol.jpg"  border="0"  hspace="0" vspace="0" align="bottom" 
                                                        style="cursor: hand;">
                                                    </span>
                                                </td>
<%                                          } else {
                                                    if (oProp.getCodEstado() == 2 && usu.getiCodTipoUsuario() == 0) {
    %>
                                                <td nowrap  align="center">
                                                    <span><IMG height='17' width='17' onClick="CambiarEstado (<%= oProp.getNumPropuesta()%>);"
                                                        alt="Cambiar estado de la propuesta" src="<%= Param.getAplicacion() %>images/finalizar.gif"
                                                        border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                                </td>
<%                                                  } else {
    %>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<%                                                   }
                                            }
                                          if (oProp.getCodEstado() != 0) {
    %>
                                                <td nowrap  align="center">
                                                    <span><IMG onClick="Ver('<%= oProp.getNumPropuesta()%>','<%= oProp.getCodEstado ()%>','<%= oProp.getTipoPropuesta ()%>','<%= oProp.getCodRama ()%>');"
                                                            alt="Imprimir la propuesta" src="<%= Param.getAplicacion() %>images/imprimir.gif"  width='19' height='19' border="0"  
                                                            hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                                </td>
<%                                        if (oProp.getCodEstado() == 2) { //agregado flavio %>
                                                <td nowrap  align="center">
                                                    <span><IMG onClick="Eliminar ('<%= oProp.getNumPropuesta()%>');"
                                                            alt="Eliminar la propuesta" src="<%= Param.getAplicacion() %>images/nook.gif"  width='19' height='19' border="0"  
                                                            hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                                </td>
<%
}//hasta aca.  
                                          
                                          } else {
    %>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<%                                          }
    %>                                          
<%                                           if (oProp.getCodRama() != 9 && oProp.getNumCertificado() == 0 &&
                                               (oProp.getCodEstado()== 1  || oProp.getCodEstado()== 3 || oProp.getCodEstado()== 7  || 
                                                ( oProp.getFechaTrabajo() != null &&
                                                  Fecha.showFechaForm(oProp.getFechaTrabajo()).equals(Fecha.getFechaActual()) &&
                                                  oProp.getCodEstado() == 5 ))) {
    %>
                                                <td  align="center">
                                                    <span><IMG height='21' width='21' onClick="javascript:addCertif('<%= oProp.getNumPropuesta()%>','<%= oProp.getNumCertificado() %>','<%= oProp.getCodRama ()%>', '<%= (oProp.getTipoPropuesta().equals ("P") ? "PR" : "EN") %>');" 
                                                           alt="Emitir Certificado de Propuesta" src="<%= Param.getAplicacion() %>images/certificado3.gif" 
                                                            border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                                </td>                                                
<%                                          } else if ( oProp.getNumCertificado() != 0 ) { 
    %>
                                                <td nowrap  align="center">
                                                    <IMG height='20' width='20' onClick="PrintCertif ('<%=oProp.getNumCertificado() %>','pdf', '<%= (oProp.getTipoPropuesta().equals ("P") ? "PR" : "EN") %>');"  
                                                        alt="Ver el certificado en formato PDF " src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">&nbsp;                                               
                                                    <IMG height='20' width='20' onClick="PrintCertif ('<%= oProp.getNumCertificado()%>','html', '<%= (oProp.getTipoPropuesta().equals ("P") ? "PR" : "EN") %>');" 
                                                        alt="Ver el certificado en formato web" src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                </td>       
<%                                          } else {
    %>                
                                                <td>&nbsp;</td>
<%                                          }
    %>
                                             </tr>

                                        </pg:item> 
            <%                              }     
                %>
                                        <thead>
                                            <th colspan="11">
                                                <pg:prev>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Anterior]</a>
                                                </pg:prev>
                                                <pg:pages>
                                           <% if (pageNumber == currentPageNumber) { %>
                                                <b><%= pageNumber %></b>
                                           <% } else { %>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"><%= pageNumber %></a>										   
                                           <% } %>
                                                </pg:pages>
                                                <pg:next>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Siguiente]</a>
                                                </pg:next>
                                            </th>
                                        </thead>
                                    </table>	
                           </pg:pager>  
                                </td>   
                            </tr>
                        </table>
                    </td>
                </tr>
                <TR>
                    <TD valign="middle" class='text' align="left"><b>Referencias:</b></td>
                </TR>
                <tr>
                    <td height='70' valign="middle" >   
                        <table cellpadding='2' cellspacing='2' border='0' width='100%'>
                            <tr>
                                <td class='text' valign="top" width='34%'> 
                                    <IMG  width='19' height='19' src="<%= Param.getAplicacion() %>images/consultasPol.jpg"  border="0">&nbsp;Editar la propuesta<br>
                                    <IMG src="<%= Param.getAplicacion() %>images/imprimir.gif"  width='19' height='19' border="0">&nbsp;Visualizar/imprimir la propuesta
                                </td>
                                <td class='text' valign="top" width='33%'>
                                    <IMG height='21' width='21'  src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0">&nbsp;Emitir el certificado de propuesta
                                </TD>
                                <td class='text' valign="top" width='33%'>
                                    <IMG src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0">&nbsp;Visualizar el certificado en formato PDF<br>
                                    <IMG src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0">&nbsp;Visualizar el certificado en formato web
                                </TD>
                             </TR>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="left" class='texto'>
                        Sr. Productor, los estados posibles de su propuesta son: 
                        <br>
                        <ol type="i">
                                <li><span class='subtitulo'>EN CARGA:</span> significa que usted aún no completó la carga y no la ha enviado.
                                Para enviarla complete el formulario ingresando desde el icono Editar y luego de cargar la nómina de asegurados 
                                presione el botón "Generar Propuesta".-</li>
                                <li><span class='subtitulo'>ENVIADA PRODUCTOR:</span> la propuesta ya ha sido enviada a nuestro sector comercial.<br>
                                En un termino de 4 hs. usted recibirá la confirmación o rechazo de la misma. La podrá consultar desde "Propuestas --> Mis Propuestas".-</li>
                                <li><span class='subtitulo'>RE-ENVIADA PRODUCTOR:</span> la propuesta fue re-enviada luego de haber sido rechazada por algún problema en la carga.-</li>
                                <li><span class='subtitulo'>CONFIRMADA:</span> la propuesta ha sido aceptada por nuestro sector comercial.<br> La misma se encuentra en proceso de emisión.-</li>
                                <li><span class='subtitulo'>CONFIRMADA&nbsp;</span><span class='subtitulo' style="color:red;">CUIC PENDIENTE</span>:La SSN aún no asigno el CUIC a la póliza de Vida Obligatorio.-</li>
                                <li><span class='subtitulo'  style="color:red;">RECHAZADA:</span> en la columna de estado encontrará los motivos por los cuales se rechazó la propuesta.<br>
                                Usted puede corregirla y volver a enviarla  ingresando desde el icono Editar (siga los mismos pasos como si estuviera en estado "EN CARGA".- </li>
                                <li><span class='subtitulo' style="color:green;">EMITIDA:</span> La propuesta se ha convertido en póliza. Usted puede consultarla desde "Consultas --> Consulta de Pólizas"</li>
                        </ol>
                    </td>
                </tr>
<%      }
%>
   <TR>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
