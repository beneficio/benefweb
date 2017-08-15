<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="error.jsp"%> 
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.OpcionAjuste"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
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

    OpcionAjuste oOpcion = (OpcionAjuste) request.getAttribute ("opcion");

    String  abm     = request.getParameter("abm");

    String titulo   = "ERROR AL OBTENER INFORMACION....";
    String disabled = "disabled";
    if (abm==null) {
        abm = "ALTA";
    }

    if (abm.equals("ALTA")) {
        titulo = "ALTA DE LA OPCION DE AJUSTE ";
        disabled = "";
    } else if (abm.equals("CONSULTA")) {
        titulo = "CONSULTA DE LA OPCION DE AJUSTE ";
        disabled = "disabled";
    } else if (abm.equals("MODIFICACION")) {
        titulo = "MODIFICACION DE LA OPCION DE AJUSTE ";
        disabled = "";
    }

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" src="<%=Param.getAplicacion()%>script/x_core.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript'>
    function Salir () {
           
        if (document.form1.abm.value == 'CONSULTA') { 
            window.location.replace("<%= Param.getAplicacion()%>servlet/OpcionesServlet?opcion=getAllOpcion");
        } else {
            if (confirm("Desea grabar el opción de ajuste  ... ?  ")) {         
                if ( ValidarDatos() ) {                 
                    document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";

                    if (document.form1.cod_opcion.value=="No Asignado"){
                        // alert("No Asignado");
                        document.form1.cod_opcion.value=0;
                    } 

                    document.form1.opcion.value  = "grabarOpcion";                
                    document.form1.accion.value  = "salir";                
                    document.form1.submit();            
                    return true;  
                } else {
                    return false;
                }          
            }             
            window.location.replace("<%= Param.getAplicacion()%>servlet/OpcionesServlet?opcion=getAllOpcion");
            return true;
        }
    }


    function Continuar () {
           
        if (document.form1.abm.value == 'CONSULTA') {             
            document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
            document.form1.opcion.value  = "getAllProductores";                
            document.form1.accion.value  = "continuar";                
            document.form1.submit();            
            return true;  
        } else {
            //if (confirm("Desea grabar el opción de ajuste  ... ?  ")) {         
                if ( ValidarDatos() ) {                 
                    if (document.form1.cod_opcion.value=="No Asignado"){
                        // alert("No Asignado");
                        document.form1.cod_opcion.value= "0";
                    } 
                    document.form1.action           = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
                    document.form1.opcion.value     = "grabarOpcion";                
                    document.form1.accion.value  = "continuar";                
                    document.form1.submit();            
                    return true;  
                } else {
                    return false;
                }          
            //}             
            window.location.replace("/abm/opciones/formOpcionesProd.jsp");            
        }
    }

    function Grabar() {         

        if (confirm("Desea grabar la opción de ajuste  ... ?  ")) {         
             if ( ValidarDatos() ) {                 

                if (document.form1.cod_opcion.value == "No Asignado"){
                    //alert("No Asignado");
                    document.form1.cod_opcion.value=0;
                } 
                document.form1.action        = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
                document.form1.opcion.value  = "grabarOpcion";                
                document.form1.accion.value  = "grabar";                
                document.form1.submit();            
                return true;  
            }           
        } 
    }

    function ValidarDatos() {
        //alert (document.getElementById('cod_sub_rama').value);

        if (Trim(document.getElementById('desc_opcion').value) == "") {
            alert (" Debe informar la descripción del opción de ajuste");               
            return document.getElementById('desc_opcion').focus();
        }

        if (document.getElementById('cod_rama').value == "0") {
            alert (" Debe informar la rama !!! ");               
            return document.getElementById('cod_rama').focus();
        }  

        if (document.getElementById('cod_sub_rama').value == "0") {
            alert (" Debe informar la sub rama !!! ");               
            return document.getElementById('oFrameSubRama').focus();
        }  

        if (document.getElementById('cod_ambito').value == "0") {
            alert (" Debe informar el Ambito !!! ");               
            return document.getElementById('cod_ambito').focus();
        }  

        // ------------
        // Porc. de ajuste 
        objPorcAjuste = document.getElementById('porc_ajuste');        
        objPorcAjuste.value = parseInt (objPorcAjuste.value);        
        if (isNaN(objPorcAjuste.value) || (objPorcAjuste.value <= 0)    ){
            alert (" Porc. de ajuste debe ser mayor a 0  !!! ");               
            if (isNaN(objPorcAjuste.value)) {
                document.form1.porc_ajuste.value = 0;
            }
            return document.getElementById('porc_ajuste').focus();
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
            <INPUT type="hidden" name="cod_sub_rama"  id="cod_sub_rama"   value="<%=(oOpcion!=null ? oOpcion.getcodSubRama() : 0)%>" >   
            <INPUT type="hidden" name="abm"           id="abm"            value="<%=abm%>" >      
            <INPUT type="hidden" name="mca_publica"   id="mca_publica"    value="<%=(oOpcion!=null && oOpcion.getmcaPublica()!=null ? oOpcion.getmcaPublica() : "" )%>">      
            <INPUT type="hidden" name="opcion"        id="opcion" value=""> 
            <INPUT type="hidden" name="accion"        id="accion" value=""> 
            <table width='720' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>OPCIONES DE AJUSTE</U></TD>
                </TR>
                <TR>
                    <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'> <%=titulo%></TD>
                </TR>

                <TR>
                    <TD width='15'>&nbsp;</TD> 
                    <TD align="left" class='text' nowrap colspan='1'>Opci&oacute;n N° :</TD>
                    <TD align="left" class='text'>                    
                        <INPUT name="cod_opcion" id="cod_opcion" value="<%=(oOpcion!=null ? oOpcion.getcodOpcion() : "No Asignado")%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric"  readonly >
                    </TD>        
                </TR>                
                <TR>
                    <TD width='15'>&nbsp;</TD>
                    <TD align="left" class='text' nowrap colspan='1'>C&oacute;digo Rebaja:</TD>
                    <TD align="left" class='text'>
                        <INPUT name="cod_rebaja" id="cod_rebaja" value="<%=(oOpcion!=null ? oOpcion.getcodRebaja() : "No Asignado")%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                    </TD>
                </TR>
                <TR>
                    <TD width='15'>&nbsp;</TD>
                    <TD align="left" class='text' nowrap colspan='1'>C&oacute;digo Recargo:</TD>
                    <TD align="left" class='text'>
                        <INPUT name="cod_recargo" id="cod_recargo" value="<%=(oOpcion!=null ? oOpcion.getcodRecargo() : "No Asignado")%>" size='10' maxlength='10' onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                    </TD>
                </TR>

                <TR>
                    <td width='15'>&nbsp;</td>
                    <TD align="left" class='text' nowrap colspan='1' >Descripci&oacute;n  :</TD>
                
                    <TD align="left" class='text'>
                        <INPUT type="text" name="desc_opcion" id="desc_opcion"   value="<%=(oOpcion!=null && oOpcion.getdescripcion()!=null )?oOpcion.getdescripcion():""%>" size="75"  maxlength="100" <%=disabled%>>
                    </TD>
                </TR>
                <TR>
                    <td width='15'>&nbsp;</td>
                    <TD align="left"  class="text" valign="top" >Seleccione Rama:&nbsp;</TD>
                    <TD align="left"  class="text">
                        <SELECT name="cod_rama" id="cod_rama" class="select" <%=disabled%> onchange="DoChangeRama();">
                        <option value='0'>Selecione una Rama</option>
<%                      LinkedList  lTabla = new LinkedList ();
                        Tablas      oTabla = new Tablas ();
                        HtmlBuilder ohtml  = new HtmlBuilder();
                        lTabla = oTabla.getRamas ();
                        out.println(ohtml.armarSelectTAG(lTabla,(oOpcion != null) ? oOpcion.getcodRama() : 0 ) );  

%>
                        </SELECT>                                    
                    </TD>
                </TR>
                <TR>
                    <TD width='15'>&nbsp;</TD>
                    <TD align="left"  class="text" valign="top" >Seleccione Subrama:&nbsp;</TD>
                    <TD align="left"  class="text"  >                                
                        <iframe  id="oFrameSubRama" name="oFrameSubRama" width="250" height="20" marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"                                               
                            src="<%= Param.getAplicacion()%>abm/planes/rs/formSubRama.jsp?cod_rama=<%=(oOpcion!=null)?oOpcion.getcodRama():0%>&cod_sub_rama=<%=(oOpcion!=null)?oOpcion.getcodSubRama():0%>&abm=ALTA" >
                        </IFRAME>                                
                    </TD>
                </TR>    
                <TR>
                    <td width='15'>&nbsp;</td>
                    <TD align="left"  class="text" valign="top" >Ambito:&nbsp;</TD>
                    <TD align="left"  class="text">
                        <SELECT name="cod_ambito" id="cod_ambito" class="select" <%=disabled%> >
                           <option value='0'>Selecione Ambito </option>
                       <%
                       lTabla = oTabla.getDatosOrderByDesc ("COT_AMBITO");
                       out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(  (oOpcion!=null)?oOpcion.getcodAmbito():0 ) ) ); 
                       %>
                        </SELECT>                                    
                    </TD>
                </TR>
                <TR>
                    <td width='15'>&nbsp;</td>
                    <TD align="left" class='text' nowrap colspan='1'  width='' height=''>Porc. ajuste:&nbsp;</TD>
                    <TD align="left" class='text'>
                        <INPUT type="text" name="porc_ajuste" id="porc_ajuste"  size="20" maxlength="12" value="<%=(oOpcion!=null)?oOpcion.getporcAjuste ():""%>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                    </TD>
                </TR>                
                <TR valign="bottom" >
                    <td width="100%" align="center" colspan='3'>
                        <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                            <TR>
                                <TD align="center">
                                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp

                                    <% if (abm.equals("ALTA") || abm.equals("MODIFICACION")) { %>

                                    <input type="button"  name="grabar" value="Grabar" height="20px" class="boton" onclick="Grabar();">&nbsp;

                                    <% } %>

                                    <input type="button" name="cmdProd"  value=" Continuar" height="20px" class="boton" onclick="Continuar()">
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
     // DoChangeRama(); 
</script>