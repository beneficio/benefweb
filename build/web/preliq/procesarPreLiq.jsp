<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%> 
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.ErrorPreliq"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    boolean procesado  = (request.getAttribute("estadoproceso")==null?false:true);

    LinkedList lError =   (LinkedList)request.getAttribute("lError");
    int iCodProdSel = 99999;
    int iNumPreLiq = 	0;
    Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
    if (procesado) {
       iCodProdSel = oDicc.getInt (request, "preliq_cod_prod");
       iNumPreLiq  = oDicc.getInt (request, "preliq_numero");
    }    
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
        function Salir () {
            window.location.replace("<%= Param.getAplicacion()%>index.jsp");
        }

        function CambiarSelectProd ( accDir ) {
            var       i = 0;
            var bExiste = false;

            if ( (accDir.value == "" || accDir.value == "0")) {
                if (document.getElementById ('preliq_cod_prod').value != "0") {
                    document.getElementById ('preliq_cod_prod').value = "0";
                }
                return true;
            } else {
                for (i = 0; i < document.getElementById ('preliq_cod_prod').length; i++) {
                    if (document.getElementById ('preliq_cod_prod').options [i].value == accDir.value) {
                        bExiste = true;
                        break;
                    }
                }
                if ( bExiste ) {
                    document.getElementById ('preliq_cod_prod').value = accDir.value;
                    return true;
                } else {
                    alert (" Código inexistente  !! ");
                    accDir.value = "";
                    return false;
                }
            }
        }
        function Enviar () {
            /*
            if (document.getElementById ('preliq_cod_prod').value!='99999'){
                 if ( document.getElementById('preliq_numero').value.length==0 ||
                      document.getElementById('preliq_numero').value==0
                     ) {
                     alert ( 'Falta informa el número de Pre Liquidación ');
                     return document.getElementById('preliq_numero').focus();
                 }
            } */
            document.form1.action = "<%= Param.getAplicacion()%>servlet/PreliquidacionServlet";
            document.form1.submit();
        }

        function cleanInputCodProd() {
            document.getElementById ('prod_dir').value = '0';
        }
    </SCRIPT>
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
        <td valign="top" align="center">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PreLiquidacion">
               <input type="hidden" name="opcion" id="opcion" value="procesarPreLiq"/>
               <table width="700" border="0" align="center" cellspacing="4" cellpadding="2"
                      class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td height="30px" valign="middle" align="center" class='titulo'>PROCESO DE CARGA DE PRELIQUIDACIONES WEB</td>
                 </tr>
                    <tr>
                        <td align="center" valign="top" width="100%">
                            <table border='0' align="center" cellpadding='2' cellspacing='2'>
<%
    if (usu.getiCodTipoUsuario() == 0 ) {
%>
                                <tr>
                                    <td align="left" class="text"  >Productor:&nbsp;
                                        <select class='select' name="preliq_cod_prod" id="preliq_cod_prod" onchange="javascript: cleanInputCodProd(); " <%=(procesado)?"disabled":""%> >
<%
         out.print("<option value='" + 99999 + "' " + (iCodProdSel==99999 ? "selected" : " ") + ">" + "Todos los productores  </option>");
         LinkedList lProd = (LinkedList) session.getAttribute("Productores");
         for (int i= 0; i < lProd.size (); i++) {
             Usuario oProd = (Usuario) lProd.get(i);
             out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == iCodProdSel ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
         }
%>
                                        </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="return Mascara('D',event);"  <%=(procesado)?"disabled":""%> >
                                    </td>
                                </tr>
<%
    }
%>
                                <!--tr>
                                    <td align="left" class="text">
                                        <LABEL>N&uacute;mero de Preliquidaci&oacute;n : </LABEL>                                        
                                        <input name="preliq_numero" id="preliq_numero"  size='12' maxlength='8'  value="<%=iNumPreLiq%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=(procesado)?"disabled":""%> >
                                    </td>
                                </tr-->
                            </table>
                        </td>
                    </tr>

                   <% if (procesado) { %>
                    <tr>
                        <td class='titulo'>
                            <strong> Nro. Lote Procesado : </strong> <%=request.getAttribute("lote")%>
                        </td>
                    </tr>

                    <%     if  (lError != null && lError.size()>0) { %>
                    <tr>
                        <td class='subtitulo' >
                            <strong>Detalle de Error/es :</strong>
                        </td>
                    </tr>

                    <%         int cantError = 0;
                               for (int i=0 ; i < lError.size(); i++  ){
                                   cantError++;
                                   ErrorPreliq error = (ErrorPreliq)lError.get(i);
                    %>
                    <tr>
                        <td class="text" >
                           <strong><%=cantError%> )  Num Preliq:</strong> <%=error.getNumPreliq()%> <strong>Cod.Prod : </strong> <%=error.getCodProd()%> <strong>Error : </strong>[<%=error.getCodError()%>] <%=error.getDescError()%>
                        </td>
                    </tr>
                    <%
                                      /* out.println( " preliq  " + error.getNumPreliq());
                                       out.println( " cod prod " + error.getCodProd());
                                       out.println( " error " + error.getDescError());
                                       out.println( " cod.error " + error.getCodError());*/
                               }
                           }
                       }


                     %>


                   

                    <tr>
                        <td align="center">
                            <input type="button" name="cmdSalir" value="Salir" height="20px" class="boton" onClick="Salir();" >&nbsp;&nbsp;&nbsp;&nbsp;
                            
                            <%if (!procesado) { %>
                            <input type="button" name="cmdEnviar" value="Procesar"  height="20px" class="boton" onClick="Enviar();"  >
                            <% }%>
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
<script>
     CloseEspere();
</script>
</body>
</HTML>
