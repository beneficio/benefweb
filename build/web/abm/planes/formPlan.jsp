<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Plan"%>
<%@page import="com.business.beans.PlanCosto"%>
<%@page import="com.business.beans.PlanVigencia"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
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

    Plan      oPlan       = (Plan) request.getAttribute ("plan");
    PlanCosto oPlanCosto  = (PlanCosto) request.getAttribute ("costo");
    LinkedList lVig       = (LinkedList) request.getAttribute("vigencias");
    String  abm     = request.getParameter("abm");
    
    String incluyeSellados = "S"; 

    String titulo   = "ERROR AL OBTENER INFORMACION....";
    String disabled = "disabled";
    String readOnly = "readonly";
    if (abm==null) {
        abm = "ALTA";
    }

    if (abm.equals("ALTA")) {
        titulo = "ALTA DEL PLAN ";
        disabled = "";
        readOnly = "";
    } else if (abm.equals("CONSULTA")) {
        titulo = "CONSULTA DEL PLAN ";
        disabled = "disabled";
        readOnly = "";
    } else if (abm.equals("MODIFICACION")) {
        titulo = "MODIFICACION DEL PLAN ";
        disabled = "";
        readOnly = "";
    }

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript' language="JavaScript" >
    function Salir () {
           
        if (document.form1.abm.value == 'CONSULTA') { 
            window.location.replace("<%= Param.getAplicacion()%>servlet/PlanServlet?opcion=getAllPlanes");
        } else {
            if (confirm("Desea grabar el plan antes de salir ... ?  ")) {
                if ( ValidarDatos() ) {                 
                    document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";

                    if (document.form1.cod_plan.value=="No Asignado"){
                        // alert("No Asignado");
                        document.form1.cod_plan.value=0;
                    } 
     
                    document.form1.opcion.value  = "grabarPlan";                
                    document.form1.accion.value  = "salir";                
                    document.form1.submit();            
                    return true;  
                } else {
                    return false;
                }          
            }             
            window.location.replace("<%= Param.getAplicacion()%>servlet/PlanServlet?opcion=getAllPlanes");
            
        }
    }


    function Continuar () {
           
        if (document.form1.abm.value == 'CONSULTA') {             
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
            document.form1.opcion.value  = "getAllProductores";                
            document.form1.accion.value  = "continuar";                
            document.form1.submit();            
            return true;  
        } else {
            //if (confirm("Desea grabar el plan  ... ?  ")) {         
                if ( ValidarDatos() ) {                 

                    if (document.form1.cod_plan.value=="No Asignado"){
                        // alert("No Asignado");
                        document.form1.cod_plan.value=0;
                    } 
                    document.form1.action           = "<%= Param.getAplicacion() %>servlet/PlanServlet";
                    document.form1.opcion.value     = "grabarPlan";                
                    document.form1.accion.value  = "continuar";                
                    document.form1.submit();            
                    return true;  
                } else {
                    return false;
                }          
            //}             
            window.location.replace("/abm/planes/formPlanProductor.jsp");            
        }
    }

    function Grabar() {         
         if ( ValidarDatos() ) {

            if (document.form1.cod_plan.value=="No Asignado"){
                //alert("No Asignado");
                document.form1.cod_plan.value=0;
            }
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
            document.form1.opcion.value  = "grabarPlan";
            document.form1.accion.value  = "grabar";
            document.form1.submit();
            return true;
        }
        return false;
    }

    function ValidarDatos() {
        //alert (document.getElementById('cod_sub_rama').value);

        if (Trim(document.getElementById('desc_plan').value) == "") {
            alert (" Debe informar la descripción del plan");               
            return document.getElementById('desc_plan').focus();
        }

        if (document.getElementById('cod_rama').value == "0") {
            alert (" Debe informar la rama !!! ");               
            return document.getElementById('cod_rama').focus();
        }  
        if (document.getElementById('cod_sub_rama').value == "0") {
            alert (" Debe informar la sub rama !!! ");               
            return document.getElementById('oFrameSubRama').focus();
        }  

        if (document.getElementById('cod_producto').value == "0" ||
            document.getElementById('cod_producto').value == "") {
            alert (" Debe informar el codigo de producto !!! ");
            return document.getElementById('cod_producto').focus();
        }

        if (document.getElementById('cod_rama').value != "10") {
            if (document.getElementById('cod_agrup_cob').value == "0" ||
                document.getElementById('cod_agrup_cob').value == "") {
                alert (" Debe informar el codigo de agrupador de cobertura para ramas de VIDA!!! ");
                return document.getElementById('cod_agrup_cob').focus();
            }
        }

        // ------------
        // Prima Minima 
        for (i= 1; i< 7; i++ ) {
            
            if ( document.getElementById('vigencia_' + i ).checked  ) {
                

                document.getElementById('vigencia_' + i ).value = "true";
                
                objPrima = document.getElementById('prima_' + i );
                objPrima.value = parseFloat (objPrima.value);
                if (isNaN(objPrima.value) || (objPrima.value <= 0)    ){
                    alert (" Prima debe ser informada !!! ");
                    if (isNaN(objPrima.value)) {
                        document.getElementById('prima_' + i ).value = 0;
                    }
                    return document.getElementById('prima_' + i ).focus();
                }
                // Premio 
                objPremio = document.getElementById('premio_' + i );
                objPremio.value = parseFloat (objPremio.value);
                if (isNaN(objPremio.value) || (objPremio.value <= 0)    ){
                    alert (" Premio debe ser mayor a 0  !!! ");
                    if (isNaN(objPremio.value)) {
                        document.getElementById('premio_' + i ).value = 0;
                    }
                    return document.getElementById('premio_' + i ).focus();
                }

                objPremioMin = document.getElementById('premio_min_' + i );
                objPremioMin.value = parseFloat (objPremioMin.value);
                if (isNaN(objPremioMin.value) || (objPremioMin.value < 0) ){
                    alert (" Premio debe ser 0 o mayor a 0  !!! ");
                    if (isNaN(objPremioMin.value)) {
                        document.getElementById('premio_min_' + i ).value = 0;
                    }
                    return document.getElementById('premio_min_' + i ).focus();
                }

                objMaxCuotas = document.getElementById('max_cuotas_' + i );
                objMaxCuotas.value = parseFloat (objMaxCuotas.value);
                if (isNaN(objMaxCuotas.value) || 
                    (objMaxCuotas.value < 0)  ||
                    (objMaxCuotas.value > 12 )  ){
                    alert (" Maxima cantidad de cuotas inválido !!! ");
                    return document.getElementById('max_cuotas_' + i ).focus();
                }
                if (document.getElementById('cod_facturacion_' + i).value == "0") {
                    alert (" Debe  informar la facturacion  !!! ");
                    return document.getElementById('cod_facturacion_' + i).focus();
                }
            } else {
                document.getElementById('vigencia_' + i ).value = "false";
            }
        }

        if (document.getElementById('cod_ambito').value == "0") {
            alert (" Debe informar el Ambito !!! ");               
            return document.getElementById('cod_ambito').focus();
        }  
//        if (document.getElementById('cod_vigencia').value == "0") {
//            alert (" Debe informar la Vigencia !!! ");
//            return document.getElementById('cod_vigencia').focus();
//        }

        if (document.getElementById('cod_rama').value == "10" && 
            document.getElementById('cod_actividad').value == "0" ) {
            alert (" Debe informar una actividad  !!! ");                           
            return document.getElementById('cod_actividad').focus();
        }  
        return true;
    }

    function ValidarCosto() {

        objEdadMin = document.getElementById('costo_edad_min');
        objEdadMin.value = parseInt (objEdadMin.value);        

        if (isNaN(objEdadMin.value) || (objEdadMin.value <= 0)  ){
            alert (" Debe informar  la edad minima  !!! ");               
            if (isNaN(objEdadMin.value)) {
                document.form1.costo_edad_min.value = 0;
            }
            return document.getElementById('costo_edad_min').focus();
        }

        objEdadMax = document.getElementById('costo_edad_max');        
        objEdadMax.value = parseInt (objEdadMax.value);        
        if (isNaN(objEdadMax.value) || (objEdadMax.value <= 0)  ){
            alert (" Debe informar  la edad maxima  !!! ");               
            if (isNaN(objEdadMax.value)) {
                document.form1.costo_edad_max.value = 0;
            }
            return document.getElementById('costo_edad_max').focus();
        }
        if (objEdadMin.value > objEdadMax.value   ) {
           alert (" La edad maxima no puede ser menor a la edada minima  !!! ");               
           return document.getElementById('costo_edad_min').focus();
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
        var vABM        = document.form1.abm.value;
        var sUrl = "<%= Param.getAplicacion()%>abm/planes/rs/formSubRama.jsp" + "?cod_rama="      + codRama     + 
                                                                                "&cod_sub_rama="  + 0  + 
                                                                                "&abm="           + vABM ; 
        if (oFrameSubRama){
            oFrameSubRama.location = sUrl;
        }
        return true;
    }    
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
        <td>
            <form action='' method="post" name="form1" >
            <input type="hidden" name="cod_sub_rama"  id="cod_sub_rama"
                   value="<%=(oPlan!=null ? oPlan.getcodSubRama() : 0)%>" />
            <input type="hidden" name="abm"           id="abm"   value="<%=abm%>" />
            <input type="hidden" name="mca_publica"   id="mca_publica"
                   value="<%=(oPlan!=null && oPlan.getmcaPublica()!=null ? oPlan.getmcaPublica() : "" )%>"/>
            <input type="hidden" name="opcion"   id="opcion" value=""/>
            <input type="hidden" name="accion"   id="accion" value=""/>
            <input type="hidden" name="costo_categoria" id="costo_categoria" value="<%=(oPlanCosto!=null)?oPlanCosto.getcodCategoria():""%>" <%=disabled%>/>
            <input type="hidden" name="costo_importe" id="costo_importe" value="<%=(oPlanCosto!=null)?oPlanCosto.getcosto ():""%>" <%=disabled%>/>
            <input type="hidden" name="costo_min_pers" id="costo_min_pers" value="<%=(oPlanCosto!=null)?oPlanCosto.getcantPersonaMin ():""%>" <%=disabled%> />
            <input type="hidden" name="costo_edad_min" id="costo_edad_min"  value="<%=(oPlanCosto!=null)?oPlanCosto.getedadMin ():""%>" <%=disabled%>/>
            <input type="hidden" name="costo_edad_max" id="costo_edad_max" value="<%=(oPlanCosto!=null)?oPlanCosto.getedadMax ():""%>" <%=disabled%>/>
            <table width='100%' cellpadding='2' cellspacing='2' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>

                <tr>
                    <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PLANES</u></td>
                </tr>
                <tr>
                    <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'> <%=titulo%></td>
                </tr>

                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'>Plan N° :</td>
                    <td align="left" class='text'>
                        <input name="cod_plan" id="cod_plan" value="<%=(oPlan!=null ? oPlan.getcodPlan() : "No Asignado")%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric"  readonly >
                    </td>
                </tr>

                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1' >Descripci&oacute;n  :</td>
                
                    <td align="left" class='text'>
                        <input type="text" name="desc_plan" id="desc_plan"
                               value="<%=(oPlan!=null && oPlan.getdescripcion()!=null )?oPlan.getdescripcion():""%>" size="75"  maxlength="100" <%=disabled%>>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1' >C&oacute;digo Producto:</td>
                    <td align="left" class='text'>
                        <input type="text" name="cod_producto" id="cod_producto"
                               value="<%=(oPlan!=null ? oPlan.getcodProducto () : 0)%>" size="10"  maxlength="3" <%=disabled%>
                               onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                        &nbsp;&nbsp;&nbsp;C&oacute;digo de Cobertura:&nbsp;
                        <input type="text" name="cod_agrup_cob" id="cod_agrup_cob"
                               value="<%=(oPlan!=null ? oPlan.getcodAgrupCobertura() : 0)%>" size="10"  maxlength="3" <%=disabled%>
                               onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  class="text" valign="top" >Estado:&nbsp;</td>
                    <td align="left"  class="text">
                        <SELECT name="estado" id="estado" class="select" <%=disabled%> >
                        <option value='PEN' <%=(oPlan==null || oPlan.getestado() == null || oPlan.getestado().equals("PEN"))?"selected":""%>>PENDIENTE</option>
                        <option value='ACT' <%=(oPlan!=null && oPlan.getestado() != null && oPlan.getestado().equals("ACT"))?"selected":""%>>ACTIVO</option>
                        <option value='ANU' <%=(oPlan!=null && oPlan.getestado() != null && oPlan.getestado().equals("ANU"))?"selected":""%>>ANULADO</option>
                        </SELECT>                                    
                    </td>
                </tr>


                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  class="text" valign="top" >Seleccione Rama:&nbsp;</td>
                    <td align="left"  class="text">
                        <SELECT name="cod_rama" id="cod_rama" class="select" <%=disabled%> onchange="DoChangeRama();" style="width: 500px;height: 22px;">
                        <option value='0'>Selecione una Rama</option>
<%                      LinkedList  lTabla = new LinkedList ();
                        Tablas      oTabla = new Tablas ();
                        HtmlBuilder ohtml  = new HtmlBuilder();
                        lTabla = oTabla.getRamas ();
                        out.println(ohtml.armarSelectTAG(lTabla,(oPlan!=null)?oPlan.getcodRama():0));  

%>
                        </SELECT>                                    
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  class="text" valign="top" >Seleccione Sub Rama:&nbsp;</td>
                    <td align="left"  class="text">
                        <iframe  id="oFrameSubRama" name="oFrameSubRama" style="width: 500px;height:22px;" marginheight="0" marginwidth="0"
                                 marginheight="0" align="top"  frameborder="0"  scrolling="no"
                            src="<%= Param.getAplicacion()%>abm/planes/rs/formSubRama.jsp?cod_rama=<%=(oPlan!=null)?oPlan.getcodRama():0%>&cod_sub_rama=<%=(oPlan!=null)?oPlan.getcodSubRama():0%>&abm=ALTA" >
                        </iframe>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  class="text" valign="top" >Ambito:&nbsp;</td>
                    <td align="left"  class="text">
                        <SELECT name="cod_ambito" id="cod_ambito" class="select" <%=disabled%> >
                           <option value='0'>Seleccione Ambito </option>
                       <%
                       lTabla = oTabla.getDatosOrderByDesc ("COT_AMBITO");
                       out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(  (oPlan!=null)?oPlan.getcodAmbito():0 ) ) );
                       %>
                        </SELECT>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'  width='' height=''>Franquicia:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="text" name="franquicia" id="franquicia"  size="20" maxlength="12" value="<%=(oPlan != null) ? oPlan.getfranquicia () : "" %>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td colspan="2" width="100%">
                        <table border="0" cellpadding="2" cellspacing="2" width="100%">
                            <tr>
                                <td width="120" class="subtitulo" nowrap>Vigencias</td>
                                <td  width="60" align="center" class="subtitulo" nowrap>Prima</td>
                                <td  width="60" align="center" class="subtitulo" nowrap>Premio</td>
                                <td  width="60" align="center" class="subtitulo" nowrap>Premio m&iacute;nimo</td>
                                <td  width="120" align="center" class="subtitulo" nowrap>Max. cuotas</td>
                                <td  width="200" align="center" class="subtitulo" nowrap>Facturaci&oacute;n</td>
                            </tr>
<%                          for (int i=0;i< lVig.size();i++) {
                               PlanVigencia oVig = (PlanVigencia) lVig.get(i);
                                
                                if (oVig.getimpPremio() > 0 ) { 
                                    incluyeSellados   = oVig.getincluyeSellados();
                                }
                               
                                int cantMeses = 1;
                                if ( oVig.getcodVigencia() >= 1 && oVig.getcodVigencia() <= 4 )
                                   cantMeses = oVig.getcodVigencia();
                                else if ( oVig.getcodVigencia() == 5 )
                                   cantMeses = 6;
                                else if ( oVig.getcodVigencia() == 6 || oVig.getcodVigencia() == 8)
                                    cantMeses = 12;
                                else if ( oVig.getcodVigencia() == 9)
                                    cantMeses = 9;
%>
                            <tr>
                                <td align="left" class="text"  nowrap><input type="checkbox" name="vigencia_<%= oVig.getcodVigencia() %>" id="vigencia_<%= oVig.getcodVigencia() %>" <%= (oVig.getimpPremio() != 0 ? "checked": "") %> <%= readOnly %>>&nbsp;<%= oVig.getdescripcion()%> &nbsp;
<%                              if (oVig.getcodVigencia() == 7 ) {
    %>
                                    <input type="text" name="cant_dias" id="cant_dias" class="inputTextNumeric" size='2' maxlength='2' onKeyPress="return Mascara('D',event);"
                                    value="<%=oVig.getcantMaxDias()%>" >
<%                              }
    %>
                                </td>
                                <td align="center" nowrap><input type="text" name="prima_<%= oVig.getcodVigencia() %>" id="prima_<%= oVig.getcodVigencia() %>" class="inputTextNumeric" maxlength="10" size="10" value="<%= Dbl.DbltoStr(oVig.getimpPrima(),2) %>" onKeyPress="return Mascara('N',event);" <%= readOnly %> /></td>
                                <td align="center" nowrap><input type="text" name="premio_<%= oVig.getcodVigencia() %>" id="premio_<%= oVig.getcodVigencia() %>" class="inputTextNumeric" maxlength="10" size="10" value="<%= Dbl.DbltoStr(oVig.getimpPremio(),2) %>" onKeyPress="return Mascara('N',event);" <%= readOnly %>/></td>
                                <td align="center" nowrap><input type="text" name="premio_min_<%= oVig.getcodVigencia() %>" id="premio_min_<%= oVig.getcodVigencia() %>" class="inputTextNumeric" maxlength="10" size="10" value="<%= Dbl.DbltoStr(oVig.getminPremio() ,2) %>" onKeyPress="return Mascara('N',event);" <%= readOnly %>/></td>
                                <td align="center" class="text" nowrap><input type="text" name="max_cuotas_<%= oVig.getcodVigencia() %>" id="max_cuotas_<%= oVig.getcodVigencia() %>" class="inputTextNumeric" maxlength="10" size="10" value="<%= oVig.getcantMaxCuotas() %>" onKeyPress="return Mascara('D',event);" <%= readOnly %>/>
                                    &nbsp;&nbsp;defualt: <%= oVig.getcantMaxCuotasVig() %>&nbsp;cuotas.
                                    <input type="hidden" name="max_cuotas_<%= oVig.getcodVigencia() %>_vig" id="max_cuotas_<%= oVig.getcodVigencia() %>_vig" value="<%= oVig.getcantMaxCuotasVig() %>" />
                                </td>
                                <td nowrap>
                                    <select name="cod_facturacion_<%= oVig.getcodVigencia() %>" id="cod_facturacion_<%= oVig.getcodVigencia() %>">
                                        <option value="0" <%= (oVig.getiCodFacturacion() == 0 ? "selected" : " ") %> >Seleccione facturacion </option>
<%                                  if ( oVig.getcodVigencia() >= 1 ) {
    %>
                                        <option value="1"  <%= (oVig.getiCodFacturacion() == 1 ? "selected" : " ") %> >Mensual </option>
<%                                      }     
    %>
<%                                  if ( cantMeses % 2 == 0 && oVig.getcodVigencia() < 10  ) {
    %>
                                        <option value="2"  <%= (oVig.getiCodFacturacion() == 2 ? "selected" : " ") %> >Bimestral </option>
<%                                  }
    %>
<%                                  if ( cantMeses % 3 == 0  && oVig.getcodVigencia() < 10 ) {
    %>
                                        <option value="3"  <%= (oVig.getiCodFacturacion() == 3 ? "selected" : " ") %> >Trimestral </option>
<%                                  }
    %>
<%                                  if ( cantMeses % 4 == 0  && oVig.getcodVigencia() < 10) {
    %>
                                        <option value="4"  <%= (oVig.getiCodFacturacion() == 4 ? "selected" : " ") %> >Cuatrimestral </option>
<%                                  }
    %>
<%                                  if ( cantMeses % 6 == 0  && oVig.getcodVigencia() < 10) {
    %>
                                        <option value="5"  <%= (oVig.getiCodFacturacion() == 5 ? "selected" : " ") %> >Semestral </option>
<%                                  }
    %>
<%                                  if ( cantMeses % 9 == 0  && oVig.getcodVigencia() < 10) {
    %>
                                        <option value="9"  <%= (oVig.getiCodFacturacion() == 9 ? "selected" : " ") %> >9 meses </option>
<%                                  }
    %>
    
<%                                  if ( cantMeses % 12 == 0  && oVig.getcodVigencia() < 10) {
    %>
                                        <option value="6"  <%= (oVig.getiCodFacturacion() == 6 ? "selected" : " ") %> >Anual </option>
<%                                  }
    %>
                                    </select>
                                </td>
                            </tr>
<%                           }
    %>
                        </table>
                    </td>
                </tr>   
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'  width='' height=''>El premio incluye sellados:&nbsp;</td>
                    <td align="left" class='text'>
                        <input type="radio" name="incluye_sellados" id="incluye_sellados_s"  value="S"
                               <%=(incluyeSellados == null || incluyeSellados.equals ("")|| incluyeSellados.equals ("N") ? "" : "checked") %> <%=disabled%> />SI&nbsp;&nbsp;&nbsp; 
                        <input type="radio" name="incluye_sellados" id="incluye_sellados_n" value="N"
                               <%=(incluyeSellados == null || incluyeSellados.equals ("")|| incluyeSellados.equals ("N") ? "checked" : "" ) %> <%=disabled%> />NO
                    </td>
                </tr>
                        
          <tr> 
                <td width='15'>&nbsp;</td>
                <td align="left"  class="text" valign="top" >Actividad (Categoria):&nbsp;</td>
                <td class='text' >
                    <select id="cod_actividad" name="cod_actividad" class="select" style="width:750px;" <%=disabled%>  >
                    <option value='0'>Selecione una Actividad</option>  
<%                  lTabla = oTabla.getActividades ("PLANES");
                    out.println(ohtml.armarSelectTAG(lTabla, (oPlan!=null)?oPlan.getcodActividad ():0)); 
%>
                    </select>
            </td>
          </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left"  valign="top" class='text' nowrap colspan='1' >Condiciones  :</td>
                    <td align="left" class='text'>
                        <TEXTAREA cols='90' rows='10'  name="condicion" id="condicion"  <%=disabled%>><%=(oPlan!=null && oPlan.getcondiciones()!=null)?oPlan.getcondiciones():""%></TEXTAREA>
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1' >Medida Seg :</td>
                    <td align="left" class='text'>
                        <TEXTAREA cols='90' rows='10'  name="medida_seg" id="medida_seg"  <%=disabled%> ><%=(oPlan!=null && oPlan.getmedidaSeg()!=null )?oPlan.getmedidaSeg():""%></TEXTAREA>
                    </td>
                </tr>
<%--
                <tr>
                    <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'>COSTOS</td>
                </tr>

                
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'>Categoria :</td>
                    <td align="left" class='text'>
                        <input name="costo_categoria" id="costo_categoria" size='10' maxlength='10' value="<%=(oPlanCosto!=null)?oPlanCosto.getcodCategoria():""%>" <%=disabled%>   onKeyPress="return Mascara('D',event);" class="inputTextNumeric" >
                    </td>
                </tr>

               <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'  width='' height=''>Costo :</td>
                    <td align="left" class='text'>
                        <input type="text" name="costo_importe" id="costo_importe"  size="20" maxlength="12" value="<%=(oPlanCosto!=null)?oPlanCosto.getcosto ():""%>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                    </td>
                </tr>
           
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'>Cantidad Minima de Personas :</td>
                    <td align="left" class='text'>
                        <input name="costo_min_pers" id="costo_min_pers" size='10' maxlength='10'  value="<%=(oPlanCosto!=null)?oPlanCosto.getcantPersonaMin ():""%>" <%=disabled%>   onKeyPress="return Mascara('D',event);" class="inputTextNumeric" >
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'>Edad Minima :</td>
                    <td align="left" class='text'>
                        <input name="costo_edad_min" id="costo_edad_min" size='10' maxlength='10' value="<%=(oPlanCosto!=null)?oPlanCosto.getedadMin ():""%>" <%=disabled%>   onKeyPress="return Mascara('D',event);" class="inputTextNumeric" >
                    </td>
                </tr>
                <tr>
                    <td width='15'>&nbsp;</td>
                    <td align="left" class='text' nowrap colspan='1'>Edad Maxima :</td>
                    <td align="left" class='text'>
                        <input name="costo_edad_max" id="costo_edad_max" size='10' maxlength='10' value="<%=(oPlanCosto!=null)?oPlanCosto.getedadMax ():""%>" <%=disabled%>   onKeyPress="return Mascara('D',event);" class="inputTextNumeric" >
                    </td>
                </tr>
--%>                
               
                <TR valign="bottom" >
                    <td width="100%" align="center" colspan='3'>
                        <table  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp
                                    <% if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>
                                    <input type="button"  name="grabar" value="Grabar" height="20px" class="boton" onclick="Grabar();">&nbsp;
                                    <% } %>
                                    <input type="button" name="cmdProd"  value=" Continuar" height="20px" class="boton" onclick="Continuar()">
                                </td>
                            </tr>
                        </TABLE>		
                    </td>
                </tr>
            </TABLE>
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