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
    int     codOpcion = Integer.parseInt(request.getParameter("cod_opcion"));
    LinkedList lOpcionesProd  = (LinkedList) request.getAttribute ("productores");
    int cantOpcionProd = 0;
    if (lOpcionesProd!=null) {
        cantOpcionProd = lOpcionesProd.size();
    }

    // System.out.println(" abm (Productores )" + abm);
    // System.out.println(" cod_opcion " + request.getParameter("cod_opcion"));    

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
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript'>


    function Salir () {
           
        
            window.location.replace("<%= Param.getAplicacion()%>servlet/OpcionesServlet?opcion=getAllOpcion");
        
    }


    function Grabar  () {           
        document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
        document.form1.opcion.value  = "getAllSumas";                
        //document.form1.accion.value  = "grabar";                
        document.form1.submit();            

    }


    function AddProd() {         
        //alert("Grabar productor cod Plan = " + document.form1.cod_opcion.value + " prod " + document.form1.cod_prod.value);

        if (confirm("Desea grabar el productor ... ?  ")) {         
            if ( ValidarDatos () ) {                 
                 document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
                 document.form1.opcion.value  = "grabarOpcionProd";                
                 document.form1.accion.value  = "grabar";                
                 document.form1.submit();            
                 return true;  
            }           
       
        } 
    }

    function DelOpcionesProd (coProd) {
        if (confirm("Desea eliminar al productor ... ?  ")) {         
            // alert(" codprod " + document.getElementById(coProd).value + " plan " +document.form1.cod_opcion.value)
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
            document.form1.opcion.value  = "borrarOpcionProd";                
            document.form1.cod_prod.value = document.getElementById(coProd).value;
            
            //document.form1.accion.value  = "grabar";                
            document.form1.submit();            

            return true;  
        }
    }

    function ValidarDatos() {

        if (document.getElementById('cod_prod').value == "0") {
            alert (" Debe informar el productor  !!! ");               
            return document.getElementById('cod_prod').focus();
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
            <INPUT type="hidden" name="abm"      id="abm"    value="<%=abm%>" >      
            <INPUT type="hidden" name="opcion"   id="opcion" value=""> 
            <INPUT type="hidden" name="accion"   id="accion" value=""> 
            <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>OPCIONES DE AJUSTE </U></TD>
                </TR>
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'> <%=titulo%></TD>
                </TR>
                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   
                            <TR>
                                <TD align="left" class='titulo'>Opci&oacute;n N° :                                
                                    <INPUT name="cod_opcion" id="cod_opcion" value="<%=codOpcion%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric"  readonly >
                                </TD>
                            </TR>                        

                        </TABLE>		
                    </TD>
                </TR>

<%      if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>
                <TR>
                    <TD class='subtitulo'>Si el porc. de ajuste es distinto de cero tiene prevalencia sobre el porc. de ajuste general de la opción.</TD>                 
                <TR>

                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='85%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="280px">Productor</TH>
                                <th width="100px">Porc. ajuste</TH>
                                <th  width="60px">&nbsp;</TH>                                                         
                            </thead>
                            <TD align="center">
                                <select class='select' name="cod_prod" id="cod_prod">
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
                                <INPUT type="text" name="porc_ajuste" id="porc_ajuste"  size="20" maxleng="20" value="0" onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                            </TD>
                            <TD> <INPUT type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="AddProd();"  ></TD>                                                   
                        </TABLE>
                    </TD>
                </TR>    
<%      } %>

                <TR>
                    <TD class='titulo'>Lista de productores asociados a la opción de ajuste.</TD>                 
                <TR>

                <TR>
                    <TD>
                       <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Cod.Prod.</th>
                                <th width="280px">Descripcion</th>
                                <th width="100px">Porc. ajuste</th>
                                <th width="60px">&nbsp;</th>                                                         
                            </thead>
<%  
        
        if ( cantOpcionProd > 0) { 
            for( int i=0; i < lOpcionesProd.size(); ++i) {
                OpcionAjusteDet oOpcionProd = (OpcionAjusteDet)lOpcionesProd.get(i);
%>
                            <TR>                             
                                <INPUT type="hidden" id='cod_prod_<%=i%>'   name='cod_prod_<%=i%>' value='<%=oOpcionProd.getcodProd() %>'>                                     
                                <INPUT type="hidden" id='desc_prod_<%=i%>'  name='desc_prod_<%=i%>' value='<%=(oOpcionProd.getcodProd() == 99999999 )?"PARA TODOS LOS PRODUCTORES":oOpcionProd.getdescProd() %>'>     
                                <INPUT type="hidden" id='porc_ajuste_<%=i%>'    name='porc_ajuste_<%=i%>' value='<%=oOpcionProd.getporcAjuste () %>'>                                     
                                
                                <TD align='right'><%=oOpcionProd.getcodProd()%>&nbsp;</TD>                         
                                <TD align='left'>&nbsp;<%=(oOpcionProd.getcodProd() == 99999999 ) ? "PARA TODOS LOS PRODUCTORES" : oOpcionProd.getdescProd() %></TD>                         
                                <TD align='right'><%=Dbl.DbltoStr(oOpcionProd.getporcAjuste(),2)%>&nbsp;</TD> 

 
<%              if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>
                                <TD> <INPUT type='BUTTON' value='Borrar' style="WIDTH: 60px;" class="boton" onClick="DelOpcionesProd('cod_prod_<%=i%>');"  ></TD>                                                             
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
                                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">
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
