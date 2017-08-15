<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.*"%>
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

    String  abm     = request.getParameter("abm");
    int     codPlan = Integer.parseInt(request.getParameter("cod_plan"));
    LinkedList lPlanSuma = (LinkedList) request.getAttribute ("sumas");
    int cantPlanSuma = 0;
    if (lPlanSuma!=null) {
        cantPlanSuma = lPlanSuma.size();
    }

    String titulo   = "ERROR AL OBTENER INFORMACION....";
    String disabled = "disabled";
    if (abm==null) {
        abm = "ALTA";
    }

    if (abm.equals("ALTA")) {
        titulo = "ACTUALIZACION - INFORMACION DE SUMAS DE COBERTURAS ";
        disabled = "";
    } else if (abm.equals("CONSULTA")) {
        titulo = "CONSULTA - INFORMACION DE SUMAS DE COBERTURAS  ";
        disabled = "disabled";
    } else if (abm.equals("MODIFICACION")) {
        titulo = "ACTUALIZACION - INFORMACION DE SUMAS DE COBERTURAS ";
        disabled = "";
    }

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript'>
    function Salir () {                 
            window.location.replace("<%= Param.getAplicacion()%>servlet/PlanServlet?opcion=getAllPlanes");
    }

    function ContinuarX () {           

    }
    function AddProdX() {         
        alert("Grabar productor cod Plan = " + document.form1.cod_plan.value + " prod " + document.form1.cod_prod.value);

        if (confirm("Desea grabar el productor ... ?  ")) {         
             if ( ValidarDatos() ) {                 
                 document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
                 document.form1.opcion.value  = "grabarPlanProd";                
                 document.form1.accion.value  = "grabar";                
                 document.form1.submit();            
                 return true;  
            }           
       
        } 
    }

    function DelPlanProdX(coProd) {
        if (confirm("Desea eliminar al productor ... ?  ")) {         
            // alert(" codprod " + document.getElementById(coProd).value + " plan " +document.form1.cod_plan.value)
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
            document.form1.opcion.value  = "borrarPlanProd";                
            document.form1.cod_prod.value = document.getElementById(coProd).value;
            
            //document.form1.accion.value  = "grabar";                
            document.form1.submit();            

            return true;  
        }
    }

    function ValidarDatosX() {

        if (document.getElementById('cod_prod').value == "0") {
            alert (" Debe informar el productor  !!! ");               
            return document.getElementById('cod_prod').focus();
        }  
        //if (document.getElementById('com_max').value != "0") {
        //    alert (" LA comision debe ser diferente a 0  !!! ");               
        //    return document.getElementById('com_max').focus();
        //}  
        return true;
    }

    function Grabar() {         

        if (confirm("Desea grabar las sumas del plan  ... ?  ")) {         
                document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
                document.form1.opcion.value  = "grabarSumas";                
                document.form1.accion.value  = "grabar";                
                document.form1.submit();            
                return true;  
        } 
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
            <INPUT type="hidden" name="abm"      id="abm"      value="<%=abm%>" >
            <INPUT type="hidden" name="opcion"   id="opcion"   value="">
            <INPUT type="hidden" name="accion"   id="accion"   value="">
            <INPUT type="hidden" name="cant_cob" id="cant_cob" value="<%=cantPlanSuma%>"> 
            <table border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PLANES </u></TD>
                </TR>
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'> <%=titulo%></TD>
                </TR>
                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   
                            <TR>
                                <TD align="left" class='titulo'>Plan N° :                                
                                    <INPUT name="cod_plan" id="cod_plan" value="<%=codPlan%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric"  readonly >
                                </TD>
                            </TR>                        
                        </TABLE>		
                    </TD>
                </TR>

<%--      if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { --%>

<%--      } --%>
<%
        if (cantPlanSuma > 0) { 
            PlanSuma oSuma = (PlanSuma)lPlanSuma.get(0);
%>
                            
                            <TR>                                
                                <TD align="left" class='titulo'>Rama&nbsp;:&nbsp;<%=oSuma.getdescRama()%></TD>                                                                

                           </TR>                        
                            <TR>
                                <TD align="left" class='titulo'>Sub Rama&nbsp;:&nbsp;<%=oSuma.getdescSubRama()%></TD>                                
                           </TR>                        


<%         
        }
%>

                <TR>
                    <TD class='titulo'>Lista de coberturas .</TD>                 
                <TR>

                <TR>
                    <TD>
                       <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='90%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="80px">Cobertura</th>
                                <th width="120px" align="center">Suma Mininima</th>
                                <th width="120px">Suma Maxima</th>
                                <th width="40px">Mca.Cob.<BR>Incluida</th>
                            </thead>
<%  
        
        if (cantPlanSuma > 0) { 
            for( int i=0; i < lPlanSuma.size(); ++i) {
                PlanSuma oSuma = (PlanSuma)lPlanSuma.get(i);
%>
                               <TR>
                               <INPUT type="hidden" id='cod_cob_<%=i%>' name='cod_cob_<%=i%>' value='<%=oSuma.getcodCob() %>'>                                     
                               <TD align='left' ><%=oSuma.getdescCob()%></TD> 

                                <TD align='center'>
                                    <INPUT type="text" name="min_suma_<%=i%>" id="min_suma_<%=i%>"  size="20" maxleng="20" value="<%=oSuma.getminSumAseg()%>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </TD> 
                                <TD align='center'>
                                    <INPUT type="text" name="max_suma_<%=i%>" id="max_suma_<%=i%>"  size="20" maxleng="20" value="<%=oSuma.getmaxSumAseg()%>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                </TD>                                
                               

                                <TD align="center">
                                    <select class='select' name="mca_cob_inc_<%=i%>" id="mca_cob_inc_<%=i%>" <%=disabled%> >
                                        <option value='S' <%=(oSuma.getMcaCobIncluida().equals("S"))?"selected":""%>  >SI</option>
                                        <option value='N' <%=(!oSuma.getMcaCobIncluida().equals("S"))?"selected":""%>  >NO</option>
                                    </select>
                                </TD
                            </TR>
<%
            }
        } else {
%>
                            <TR>                                                             
                                <TD align='left' colspan='4' class='titulos'>&nbsp;No tiene coberturas informados </TD>                         
                            </TR>
<%
        } 
%>
                        </TABLE>		
                    </TD>
                </TR>
                <TR valign="bottom" >
                    <td width="100%" align="center" colspan='3'>
                        <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                            <TR>
                                <TD align="center">
                                    <BR><BR>
                                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp                                                                                 

                                    <% if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>

                                    <input type="button"  name="grabar" value="Grabar" height="20px" class="boton" onclick="Grabar();">&nbsp;

                                    <% } %>
                                </TD>
                            </TR>
                        </TABLE>		
                    </td>
                </tr>

            </TABLE>
            </form>        
        </td>
    </tr>
    <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
  </table>
</body>
<script>
     CloseEspere();     
</script>
