<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.SeteoProd"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Vigencia"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Hashtable"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
    Usuario usu = (Usuario) session.getAttribute("user"); 

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }
    int iCodProd = Integer.parseInt (request.getParameter ("cod_prod") == null ? "0" :
                                     request.getParameter ("cod_prod"));

    SeteoProd      oSeteoProd       = (SeteoProd) request.getAttribute ("seteo");

    if (oSeteoProd != null ) {
        System.out.println ("mca_no_gestionar jsp --> " + oSeteoProd.getmcaNoGestionar());
        System.out.println ("cod_sub_rama     jsp --> " + oSeteoProd.getcodSubRama() );
    }
    
//    LinkedList lLista = (LinkedList)  request.getAttribute("vigencias"); 
//    if (lLista == null) { 
//        lLista = new LinkedList(); 
//    }

    String  abm     = request.getParameter("abm");

System.out.println (abm);

    String disabled = "disabled";
    if (abm==null) {
        abm = "ALTA";
    }

    if (abm.equals("ALTA")) {
        disabled = "";
    }  else if (abm.equals("MODIFICACION")) {
        disabled = "disabled";
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
</head>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript' language="JavaScript">
    function Salir () {
      window.location.replace("<%= Param.getAplicacion()%>servlet/SetProductorServlet?opcion=getAllSeteoProd");
    }

    function Grabar() {         

        document.getElementById('cod_sub_rama').value =
            oFrameSubRama.document.getElementById('cod_subrama').options
        [ oFrameSubRama.document.getElementById('cod_subrama').selectedIndex ].value;

        if (confirm("Desea grabar el SeteoProd  ... ?  ")) {         
             if ( ValidarDatos() ) {
                if ( document.getElementById ("mca_no_gestionar").checked === true ) {
                    document.getElementById ("mca_no_gestionar").value = "X";
                } else {
                    document.getElementById ("mca_no_gestionar").value = "";
                }
                document.form1.action        = "<%= Param.getAplicacion() %>servlet/SetProductorServlet";
                document.form1.opcion.value  = "grabarSeteoProd";                
                document.form1.accion.value  = "grabar";                
                document.getElementById('cod_rama').disabled = false;
                document.getElementById('cod_prod').disabled = false;

                document.form1.submit();            
                return true;  
            }
        } else {
        return false;
        }
    }


    function Traer () {

        document.getElementById('cod_sub_rama').value =
            oFrameSubRama.document.getElementById('cod_subrama').options
        [ oFrameSubRama.document.getElementById('cod_subrama').selectedIndex ].value;
        document.form1.action        = "<%= Param.getAplicacion() %>servlet/SetProductorServlet";
        document.form1.opcion.value  = "obtenerDatos";
        document.getElementById('cod_rama').disabled = false;
        document.getElementById('cod_prod').disabled = false;

        document.form1.submit();
        return true;
    }

    function ValidarDatos() {

        if (document.getElementById('cod_rama').value == "0") {
            alert (" Debe informar la rama !!! ");               
            return document.getElementById('cod_rama').focus();
        }  
        if (document.getElementById('cod_sub_rama').value == "0") {
            alert (" Debe informar la sub rama !!! ");               
            return document.getElementById('oFrameSubRama').focus();
        }  

        if (document.getElementById('cod_prod').value == "0") {
            alert (" Debe informar el productor  !!! ");               
            return document.getElementById('cod_prod').focus();
        }  
        // ------------
        // Prima Minima 
        objPrimaMin = document.getElementById('prima_min');   
        if (objPrimaMin.value == "") { 
             objPrimaMin.value = "0" 
        }
      
        objPrimaMin.value = parseInt (objPrimaMin.value);        
        if (isNaN(objPrimaMin.value) || (objPrimaMin.value < 0) ){
            alert (" Prima Minima debe ser mayor o igual a 0  !!! ");               
            if (isNaN(objPrimaMin.value)) {
                document.form1.prima_min.value = "0";
            }
            return document.getElementById('prima_min').focus();
        }

        return true;
    }

    function DoChangeSubRama(codSubRama){             
        document.getElementById('cod_sub_rama').value  = codSubRama;                
    }

    function DoChangeRama() {  
        document.getElementById('cod_sub_rama').value  = 0;           
        var codRama     = document.form1.cod_rama.options[ document.form1.cod_rama.selectedIndex ].value;                      
        var codSubRama  = 0;
        if (codRama == 99 ) {
            codSubRama = 999;
        }
        var vABM        = document.form1.abm.value;
        var sUrl = "<%= Param.getAplicacion()%>abm/setProd/rs/formSubRama.jsp" + "?cod_rama="      + codRama     +
                                                                                "&cod_sub_rama="  + codSubRama  +
                                                                                "&abm="           + vABM ; 
        if (oFrameSubRama){
            oFrameSubRama.location = sUrl;
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
    <tr>
        <td>  
            <form action="" method="post" name="form1" >
            <input type="hidden" name="cod_sub_rama"  id="cod_sub_rama"   value="<%=(oSeteoProd!=null ? oSeteoProd.getcodSubRama() : 2)%>" />
            <input type="hidden" name="abm"       id="abm"    value="<%=abm%>" />
            <input type="hidden" name="opcion"    id="opcion" value=""/>
            <input type="hidden" name="accion"    id="accion" value=""/>
            <input type="hidden" name="cod_seteo" id="cod_seteo" value="<%=(oSeteoProd != null ? oSeteoProd.getcodSeteo() : 0 )%>"/>
<%--            <input type="hidden" name="cant_vigencia" value="<%= (lLista.size() == 0 ? 6 : lLista.size())%>"/>
--%>
            <table width='100%' cellpadding='2' cellspacing='2' border='0' align="center"
                   class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'>FORMULARIO DE SETEOS DEL PRODUCTOR</td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class="text" valign="top" width="80" nowrap >Seleccione Rama:&nbsp;</td>
                    <td align="left"  class="text" width="500px" >
                        <select name="cod_rama" id="cod_rama" class="select" <%=disabled%> onchange="DoChangeRama();" style="width: 500px;height: 19px;" >
                        <option value='0'>Selecione una Rama</option>
                        <option value='99' <%= ( oSeteoProd !=null && oSeteoProd.getcodRama() == 99 ? "selected" : "" )%> >TODAS LAS RAMAS</option>
<%                      LinkedList  lTabla = new LinkedList ();
                        Tablas      oTabla = new Tablas ();
                        HtmlBuilder ohtml  = new HtmlBuilder();
                        lTabla = oTabla.getRamas ();
                        out.println (ohtml.armarSelectTAG(lTabla, ( oSeteoProd !=null ) ? oSeteoProd.getcodRama() : 10 ) );
%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  class="text" valign="top" >Seleccione Sub Rama:&nbsp;</td>
                    <td align="left"  class="text" width="500px" height="22"  >
                        <iframe  id="oFrameSubRama" name="oFrameSubRama" style="width: 500px;height:22px;" marginheight="0" marginwidth="0" marginheight="0" align="left"  frameborder="0"  scrolling="no"
                            src="<%= Param.getAplicacion()%>abm/setProd/rs/formSubRama.jsp?cod_rama=<%=(oSeteoProd!=null)?oSeteoProd.getcodRama():0%>&cod_sub_rama=<%=(oSeteoProd!=null)?oSeteoProd.getcodSubRama():0%>&abm=<%=(abm==null)?"ALTA":abm%>" >
                        </iframe>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text'>Seleccione productor</td>
                    <td align="left">
                        <select class='select' name="cod_prod" id="cod_prod" <%=disabled%> style="width: 500px;height: 19px;">
                            <option value='0' >Selecione productor</option>
                      <%
                      LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                         for (int i= 0; i < lProd.size (); i++) {
                                Usuario oProd = (Usuario) lProd.get(i);
                                if (oProd.getiCodProd() < 80000) {
                                    out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " +
        (oSeteoProd != null && oSeteoProd.getcodProd() == oProd.getiCodProd() ? "selected" :
            ( iCodProd > 0 && oProd.getiCodProd() == iCodProd? "selected": " ") ) + " >" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                }
                            }
                      %>
                            </select>
                    </td>
                </tr>
                    <td width='15'>&nbsp;</td>
                    <td  colspan="2" class='text'>Después de seleccionar Rama-Subrama-Productor haga clic aqui para obtener los datos ya cargados a nivel general para la rama-subrama
                        <input type="button"  name="traer" value=" Obtener datos " height="20px" class="boton" onclick="Traer ();"/>
                    </td>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Fecha D&eacute;bito:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="dia_debito" id="dia_debito"  size="20" maxlength="2"
                               value="<%=( oSeteoProd != null  ?  oSeteoProd.getdiaDebito() : 0 ) %>"
                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                        &nbsp;&nbsp;<strong>Este dato tiene efecto para todas las ramas/subramas</strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Prima m&iacute;nima:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="prima_min" id="prima_min"  size="20" maxlength="7"
                               value="<%=(oSeteoProd!=null ) ? (oSeteoProd.getminPrima () == 0 ? "" : oSeteoProd.getminPrima ()) : "" %>"
                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >M&aacute;xima comisi&oacute;n (Cotizadores):&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="max_comision_cot" id="max_comision_cot"  size="20" maxlength="7"
                               value="<%=(oSeteoProd!=null ) ? (oSeteoProd.getmaxComisionCot() == 0 ? "" : oSeteoProd.getmaxComisionCot() ) : "" %>"
                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                        &nbsp;&nbsp;<strong>M&aacute;xima comisi&oacute;n que el productor puede manipular en el cotizador</strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Max. tope de premio (Cotizadores):&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="max_tope_premio_cot" id="max_tope_premio_cot"  size="20" maxlength="7"
                               value="<%=(oSeteoProd!=null ) ? (oSeteoProd.getmaxTopePremioCot() == 0 ? "" : oSeteoProd.getmaxTopePremioCot() ) : "" %>"
                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                        &nbsp;&nbsp;<strong>Porcentaje max. de incremento de premio en el cotizador.</strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Porc. de Recargo retenido de comisi&oacute;n (Cotizadores):&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="porc_recargo_retenido" id="porc_recargo_retenido"  size="20" maxlength="7"
                               value="<%=(oSeteoProd!=null ) ? (oSeteoProd.getporcRecargoRetenido() == 0 ? "" : oSeteoProd.getporcRecargoRetenido() ) : "" %>"
                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                        &nbsp;&nbsp;<strong>Es el porc. de comisi&oacute;n retenida en el reparto cuando supera el punto de inflexion al manipular el premio </strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Marcar si no se debería gestionar al productor:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="checkbox" name="mca_no_gestionar" id="mca_no_gestionar"
                               value="<%= (oSeteoProd != null && oSeteoProd.getmcaNoGestionar() != null ? oSeteoProd.getmcaNoGestionar() : "") %>"
                               <%= (oSeteoProd != null && oSeteoProd.getmcaNoGestionar() != null ? "checked" : "") %> />
                        &nbsp;&nbsp;<strong>Si esta tildado no se gestiona la deuda </strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Mail de gestión de deuda:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="mail_gestion_deuda" id="mail_gestion_deuda" size="80" maxlength="150"
                               value="<%=(oSeteoProd!=null ) ? (oSeteoProd.getmailGestionDeuda() == null ? "" : oSeteoProd.getmailGestionDeuda() ) : "" %>"/>
                        <br/><strong>mail donde se enviará la gestión de deuda </strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Excepciones de emisi&oacute;n:&nbsp;</td>
                    <td align="left" class='text'>
                        <select name="permiso_emision" id="permiso_emision" class="select">
                            <option value="" <%= (oSeteoProd != null && oSeteoProd.getpermisoEmision() == null ? "selected" : " ") %>>Emisi&oacute;n normal</option>
                            <option value="BA" <%= (oSeteoProd != null &&  oSeteoProd.getpermisoEmision() != null && oSeteoProd.getpermisoEmision().equals("BA") ? "selected" : " ") %>>Emisi&oacute;n bloqueada</option>
                            <option value="AU" <%= (oSeteoProd != null &&  oSeteoProd.getpermisoEmision() != null && oSeteoProd.getpermisoEmision().equals("AU") ? "selected" : " ") %>>Se deber&aacute; autorizar</option>
                        </select>
                        <br/><strong>se aplica para la emisi&oacute;n de la rama/subrama, incluye planes especiales de la misma</strong>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap >Limite mensual de emisi&&acute;n:</td>
                    <td align="left" class='text'>
                        <input type="text" name="limite_emision" id="limite_emision"  size="20" maxlength="7"
                               value="<%=((oSeteoProd!=null ) ? (oSeteoProd.getlimiteEmision() == 0 ? "" : oSeteoProd.getlimiteEmision() ) : "" ) %>"
                               onKeyPress="return Mascara('D',event);" class="inputTextNumeric"/>
                    </td>
                </tr>
<%--
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" valign="top" class='text'>Cantidad max. cuotas:&nbsp;<br/><br/><br/><br/><br/><br/><br/><br/><br/></td>
                    <td align="left" >
                        <table width='180' cellpadding='2' cellspacing='2' border='0'>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='text' nowrap>Max.Cant.Cuotas</td>
                                <td class='text' nowrap>$ cuota m&iacute;nima</td>
                            </tr>
<%                  if (lLista.size() == 0){%>
                            <tr>
                                <td class='text'>Mensual&nbsp;&nbsp;&nbsp;</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_0" id="CANT_CUOTAS_0" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_0" id="CUOTA_MINIMA_0" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                                    <input type="hidden" name="COD_VIGENCIA_0" id="COD_VIGENCIA_0" value="1"/>
                                </td>
                            </tr>
                            <tr>
                                <td class='text'>Bimestral</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_1" id="CANT_CUOTAS_1" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_1" id="CUOTA_MINIMA_1" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_1" id="COD_VIGENCIA_1" value="2">
                                </td>
                            </tr>
                            <tr>
                                <td class='text'>Trimestral</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_2" id="CANT_CUOTAS_2" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_2" id="CUOTA_MINIMA_2" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_2" id="COD_VIGENCIA_2" value="3">
                                </td>
                            </tr>
                            <tr>
                                <td class='text'>Cuatrimestral</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_3" id="CANT_CUOTAS_3" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_3" id="CUOTA_MINIMA_3" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_3" id="COD_VIGENCIA_3" value="4">
                                </td>
                            </tr>
                            <tr>
                                <td class='text'>Semestral</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_4" id="CANT_CUOTAS_4" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_4" id="CUOTA_MINIMA_4" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_4" id="COD_VIGENCIA_4" value="5">
                                </td>
                            </tr>
                            <tr>
                                <td class='text'>Anual</td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_5" id="CANT_CUOTAS_5" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_5" id="CUOTA_MINIMA_5" value="0"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_5" id="COD_VIGENCIA_5" value="6">
                                </td>
                            </tr>

<%                  }  
                    for (int i=0; i < lLista.size (); i++) {
                        Vigencia oVigencia = (Vigencia) lLista.get (i);
%>                       
                            <tr>
                                <td class='text'><%= oVigencia.getdescVigencia() %></td>
                                <td class='text'>
                                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_<%=i%>" id="CANT_CUOTAS_<%=i%>" value="<%= oVigencia.getcantCuotas() %>"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </td>
                                <td class='text'>&nbsp;&nbsp;&nbsp;
                                    <input class="inputTextNumeric" type="text" size="5" name="CUOTA_MINIMA_<%=i%>" id="CUOTA_MINIMA_<%=i%>" value="<%= oVigencia.getcuotaMinima() %>"
                                           onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                    <input type="hidden" name="COD_VIGENCIA_<%=i%>" id="COD_VIGENCIA_<%=i%>" value="<%= oVigencia.getcodVigencia() %>">
                                </td>
                            </tr>
<%                   }
    %> 
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td> 
                    <td class='valor' colspan='2'>Nota:&nbsp;<br/>
                                     Cantidad de cuotas = -1 significa que la vigencia no es cotizable.<br/>
                                     Cantidad de cuotas = 0 significa que la vigencia no esta seteada para el productor<br/>
                                     Cantidad de cuotas > 0 tiene prevalencia sobre el valor seteado por default para la rama/subrama. 
                    </td>
                </tr>
--%>
                <tr valign="bottom" >
                    <td width="100%" align="center" colspan='3'>
                        <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp&nbsp;&nbsp;&nbsp;
                                    <input type="button"  name="grabar" value="Grabar" height="20px" class="boton" onclick="Grabar();">
                                </td>
                            </tr>
                        </TABLE>		
                    </td>
                </tr>

            </table>
            </form>
        </td>
    </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
  </table>
</body>
<script>
     CloseEspere();
     // DoChangeRama(); 
</script>