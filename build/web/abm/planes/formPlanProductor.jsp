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

    // Plan    oPlan   = (Plan) request.getAttribute ("plan");


    String  abm     = request.getParameter("abm");
    int     codPlan = Integer.parseInt(request.getParameter("cod_plan"));
    LinkedList lPlanProd  = (LinkedList) request.getAttribute ("productores");
    int cantPlanProd = 0;
    if (lPlanProd!=null) {
        cantPlanProd = lPlanProd.size();
    }

    // System.out.println(" abm (Productores )" + abm);
    // System.out.println(" cod_plan " + request.getParameter("cod_plan"));    

    String titulo   = "ERROR AL OBTENER INFORMACION....";
    String disabled = "disabled";
    if (abm==null) {
        abm = "ALTA";
    }

    if (abm.equals("ALTA")) {
        titulo = "ACTUALIZACION - INFORMACION DE PRODUCTORES ";
        disabled = "";
    } else if (abm.equals("CONSULTA")) {
        titulo = "CONSULTA - INFORMACION DE PRODUCTORES  ";
        disabled = "disabled";
    } else if (abm.equals("MODIFICACION")) {
        titulo = "ACTUALIZACION - INFORMACION DE PRODUCTORES ";
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
    function Continuar () {           
        document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
        document.form1.opcion.value  = "getAllSumas";                
        //document.form1.accion.value  = "grabar";                
        document.form1.submit();            
    }

    function AddProd() {         
        if ( ValidarDatos () ) {
             document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
             document.form1.opcion.value  = "grabarPlanProd";
             document.form1.accion.value  = "grabar";
             document.form1.cod_prod.value = document.form1.cod_prod_select.value;
             document.form1.submit();
             return true;
        }
    }

    function DelPlanProd(coProd) {
        if (confirm("Desea eliminar al productor ... ?  ")) {         
            // alert(" codprod " + document.getElementById(coProd).value + " plan " +document.form1.cod_plan.value)
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/PlanServlet";
            document.form1.opcion.value  = "borrarPlanProd";                
            document.form1.cod_prod.value = coProd;
            document.form1.submit();            
            return true;  
        }
    }

    function ValidarDatos() {

        if (document.getElementById('cod_prod_select').value == "0") {
            alert (" Debe informar el productor  !!! ");               
            return document.getElementById('cod_prod_select').focus();
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
            <INPUT type="hidden" name="abm"      id="abm"            value="<%=abm%>" >      
            <INPUT type="hidden" name="opcion"   id="opcion" value=""> 
            <INPUT type="hidden" name="accion"   id="accion" value="">
            <INPUT type="hidden" name="cod_prod" id="cod_prod" value="0">
            <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   

                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PLANES </U></TD>
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

<%      if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>
                <TR>                                   
                    <TD  colspan='4' valign="middle" align="left" class='titulo'>Carga de Productores </TD>
                </TR>

                <TR>
                    <TD class='titulo'>Ingrese desde aqu&iacute; los productores.</TD>                 
                <TR>

                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='85%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="280px">Productor</th>
                                <th width="100px">Maxima Comision</th>
                                <th  width="60px">&nbsp;</th>
                            </thead>
                            <TD align="center">
                                <select class='select' name="cod_prod_select" id="cod_prod_select">
                                    <option value='0' >SELECIONE PRODUCTOR</option>
                                    <option value='99999999' >PARA TODOS LOS PRODUCTORES</option>
                              <%
                              LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                 for (int i= 0; i < lProd.size (); i++) {
                                        Usuario oProd = (Usuario) lProd.get(i);                                        
                                        out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " /*+ (oProd.getiCodProd() == codProd ? "selected" : " ") */ + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                    }
                              %>
                                </select>
                            </TD> 

                            <TD align="left" class='text'>
                                <INPUT type="text" name="com_max" id="com_max"  size="20" maxleng="20" value="0" onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                            </TD>
                            
                            <TD> <INPUT type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="AddProd();"  ></TD>                                                   
                        </TABLE>
                    </TD>
                </TR>    
<%      } %>

                <TR>
                    <TD class='titulo'>Lista de productores asociados al Plan.</TD>                 
                <TR>

                <TR>
                    <TD>
                       <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Cod.Prod.</th>
                                <th width="280px">Descripcion</th>
                                <th width="100px">Max.Comision</th>
                                <th width="60px">&nbsp;</th>                                                         
                            </thead>
<%  
        
        if (cantPlanProd > 0) { 
            for( int i=0; i < lPlanProd.size(); ++i) {
                PlanProductor oPlanProd = (PlanProductor)lPlanProd.get(i);
%>
                            <TR>                             
                                <INPUT type="hidden" id='cod_prod_<%=i%>'   name='cod_prod_<%=i%>' value='<%=oPlanProd.getcodProd() %>'>                                     
                                <INPUT type="hidden" id='desc_prod_<%=i%>'  name='desc_prod_<%=i%>' value='<%=(oPlanProd.getcodProd() == 99999999 )?"PARA TODOS LOS PRODUCTORES":oPlanProd.getdescProd() %>'>     
                                <INPUT type="hidden" id='max_com_<%=i%>'    name='max_com_<%=i%>' value='<%=oPlanProd.getcomisionMax () %>'>                                     
                                
                                <TD align='right'><%=oPlanProd.getcodProd()%>&nbsp;</TD>                         
                                <TD align='left'>&nbsp;<%=(oPlanProd.getcodProd() == 99999999 )?"PARA TODOS LOS PRODUCTORES":oPlanProd.getdescProd() %></TD>                         
                                <TD align='right'><%=Dbl.DbltoStr(oPlanProd.getcomisionMax(),2)%>&nbsp;</TD> 

 
<%              if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>
                                <TD> <INPUT type='BUTTON' value='Borrar' style="WIDTH: 60px;" class="boton" onClick="DelPlanProd('<%=oPlanProd.getcodProd()%>');"  ></TD>
<%              } else { %>
                               <TD align='right'>&nbsp;</TD> 
<%              }  %>
                            </TR>
<%
            }
        } else {
%>
                            <TR>                                                             
                                <TD align='left' colspan='4' class='titulos'>&nbsp;No tiene productores informados </TD>                         
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

                                    <input type="button" name="cmdProd"  value=" Continuar " height="20px" class="boton" onclick="Continuar()">
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
