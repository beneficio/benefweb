<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" import="java.util.*, com.business.beans.*, com.business.util.*, com.business.interfaces.*" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  Usuario oUser   = (Usuario) session.getAttribute("user");
    Usuario oPersona = (Usuario) request.getAttribute("usuario");
    if (oUser.getiCodTipoUsuario() != 0 && oPersona.getiNumSecuUsu() == -1 ) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    if (oPersona != null &&
        oPersona.getiCodTipoUsuario() != 0 &&
        oPersona.getmenu() == 0 ) {
        oPersona.setmenu(oPersona.getiCodTipoUsuario());
    }
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language="JavaScript">
            
          function Submitir () {
                if (document.formPersona.usuario.value == "") {
                    alert (" Usuario inválido ! ");
                    return false;
                }
                if (document.formPersona.numDoc.value == "" || 
                    document.formPersona.numDoc.value == "0") {
                    alert (" Documento inválido ! ");
                    return false;
                }
                if (document.formPersona.password.value == "") {
                    alert ("La password es inválida !");
                    return false;
                }
                if ( document.formPersona.password.value != document.formPersona.confPassword.value ) {
                    alert ("La password y la confirmación de password deben coincidir ! ");
                    return false;
                }

                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 2  
                    && document.formPersona.usuario.value.toUpperCase().indexOf("C") != 0) {
                    alert (" El usuario tipo CLIENTE debe comenzar  siempre con 'C' seguido del número de cliente!! ");
                    return false;
                }
                        
                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 1  
                    && (document.getElementById('cod_prod').value == "0" || document.getElementById('cod_prod').value == "") ) {
                    alert (" Debe ingresar el codigo de productor ");
                    return false;
                }
                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 1
                    && document.formPersona.usuario.value !=  document.getElementById('cod_prod').value ) {
                    alert (" El usuario tiene que ser igual al codigo de productor ");
                    return false;
                }

                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 1
                    && parseInt (document.getElementById('cod_prod').value) < 80000
                    && document.getElementById('cod_org_ant').value != ''
                    && document.getElementById('cod_org_ant').value != '0' ) {
                    alert (" Ingrese organizador anterior solo cuando modifica datos de un organizador ");
                    return false;
                }
                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 1
                    && parseInt (document.getElementById('cod_prod').value) >= 80000
                    && document.getElementById('cod_prod_ant').value != ''
                    && document.getElementById('cod_prod_ant').value != '0' ) {
                    alert (" Ingrese productor anterior solo cuando modifica datos de un productor ");
                    return false;
                }

                if (document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value == 2  
                    && (document.getElementById('num_tomador').value == "0" || document.getElementById('num_tomador').value == "") ) {
                    alert (" Debe ingresar el número de cliente ");
                    return false;
                }

                var menu = document.getElementById('menu').options [ document.getElementById('menu').selectedIndex].value;
                var tipoUsuario = document.getElementById('tipoUsuario').options [ document.getElementById('tipoUsuario').selectedIndex].value;


                if ( tipoUsuario == "0" && !( menu == "0" || menu == "4" || menu == "3")) {
                    alert (" MENU INVALIDO PARA EL TIPO DE USUARIO SELECCIONADO ");
                    return false;
                }

                if ( tipoUsuario == "1" && !( menu == "1" || menu == "4" || menu == "5")) {
                    alert (" MENU INVALIDO PARA EL TIPO DE USUARIO SELECCIONADO ");
                    return false;
                }

                if ( tipoUsuario == "2" &&  menu != "2") {
                    alert (" MENU INVALIDO PARA EL TIPO DE USUARIO SELECCIONADO ");
                    return false;
                }

               for (var i = 0; i < document.formPersona.elements.length; i++) {
                    var obj = document.formPersona.elements.item(i);
                    obj.disabled  =  false;
                }

                document.formPersona.submit();
                return true;
          }

          function CambiarPersona (TipoDni) {
              if (TipoDni == "80") { // cuit
                document.getElementById('PersonaFisica').style.visibility = "hidden";
                document.getElementById('PersonaJuridica').style.visibility = "visible";
              } else {
                document.getElementById('PersonaFisica').style.visibility = "visible";
                document.getElementById('PersonaJuridica').style.visibility = "hidden";
              }
          } 

          function CambiarTipo ( TipoUsu ) {
              if (TipoUsu == '0' ) { // interno
                document.getElementById('tipoProd').style.visibility = "hidden";
                document.getElementById('tipoCliente').style.visibility = "hidden";
              } else {
                if (TipoUsu == '1' ) { // productor                
                    document.getElementById('tipoProd').style.visibility = "visible";
                    document.getElementById('tipoCliente').style.visibility = "hidden";
                } else {
                    if (TipoUsu == '2' ) { // cliente
                        document.getElementById('tipoProd').style.visibility = "hidden";
                        document.getElementById('tipoCliente').style.visibility = "visible";
                    }
                }
              }
          } 
          
          function Grabar () {

            if (confirm("Usted esta seguro que desea grabar ? ")) {
                Submitir ();
            } else {
                return false;
            }
          }

          function Salir () {

            if (confirm(" Desea grabar los cambios antes de salir ? ")) {
                Submitir ();
            } else {
                document.formPersona.action = "<%= Param.getAplicacion()%>index.jsp";
                document.formPersona.submit();
                return true;
            }
          }
            
          function Volver () {
            if (document.formPersona.volver.value == "getAllUsuarios") {
                document.formPersona.opcion.value = "getAllUsuarios";
                document.formPersona.submit();
                return true;
            } else {
                     if (document.formPersona.volver.value == "filtrar") { 
                        document.formPersona.action = "<%= Param.getAplicacion()%>usuarios/filtrarUsuarios.jsp";
                     }  else { 
                        document.formPersona.action = "<%= Param.getAplicacion()%>index.jsp";
                     }
                     document.formPersona.submit();
                     return true;
                   }
            }

          function SetearUsuario (codProd) {
            if (codProd == "" || codProd == 0) {
                document.formPersona.usuario.disabled = false;
                document.formPersona.usuario.value = "";
            } else {
                document.formPersona.usuario.value = codProd;
                document.formPersona.usuario.disabled = true;
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
                    <jsp:param name="usuario" value="<%= oUser.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= oUser.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= oUser.getusuario()%>" />
                </div>
            </td>
        </tr>
    <tr>
        <td valign="top" align="center">
<!-- body del formulario  de Persona -->	
<form name="formPersona" id="formPersona" method="POST" action="<%= Param.getAplicacion()%>servlet/setAccess">
    <input type="hidden" name="opcion" id="opcion" value="addUsuario"/>
    <input type="hidden" name="siguiente" id="siguiente"/>
    <input type="hidden" name="estado" id="estado" value="<%= request.getParameter ("estado")%>"/>
    <input type="hidden" name="volver" id="volver" value='<%= (request.getParameter ("volver") == null ? "" : request.getParameter ("volver")) %>'/>
    <input type="hidden" name="numSecuUsu" id="numSecuUsu" value="<%= oPersona.getiNumSecuUsu()%>"/>
    <input type="hidden" name="numero" value="<%= oPersona.getNumero()==null ? "" : oPersona.getNumero()%>"/>
    <input type="hidden" name="dpto" value="<%= oPersona.getDepto()==null ? "" : oPersona.getDepto()%>"/>
    <input type="hidden" name="piso" value="<%= oPersona.getPiso()==null ? "" : oPersona.getPiso()%>"/>

<%--    <input type="hidden" name="pri" value ="N">
    <input type="hidden" name="Fusuario" value="<%= request.getParameter ("Fusuario")%>">
    <input type="hidden" name="Fnombre" value="<%= request.getParameter ("Fnombre")%>">
    <input type="hidden" name="Fdocumento" value="<%= request.getParameter ("Fdocumento")%>">
    <input type="hidden" name="FtipoUsuario" value="<%= request.getParameter ("FtipoUsuario")%>">
    <input type="hidden" name="Fcod_prod" value="<%= request.getParameter ("Fcod_prod")%>">
    <input type="hidden" name="Fnum_tomador" value="<%= request.getParameter("Fnum_tomador")%>">
--%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <tr>
            <td height="30px" valign="middle" align="center" class='titulo'>DATOS DE ACCESO</td>
        </tr>
        <tr>
            <td>
                <table  HEIGHT="20"  align="left" style="margin-left: 15px;">
                    <TR valign="top">
                        <TD width="120px"  class='text'  align="left">Tipo de usuario:</TD>
                        <TD nowrap width="600px"  class='text' colspan='3'  align="left">
                            <select class='link' name='tipoUsuario' id='tipoUsuario' onchange="CambiarTipo (this.value);" <%= (oPersona.getiNumSecuUsu() != -1 ? "disabled" : " ")%> >
                                <option value='0' <%= (oPersona.getiCodTipoUsuario () == 0 ? "selected" : " " )%>>INTERNO</option>
                                <option value='1' <%= (oPersona.getiCodTipoUsuario () == 1 ? "selected" : " " )%>>PRODUCTOR</option>
                                <option value='2' <%= (oPersona.getiCodTipoUsuario () == 2 ? "selected" : " " )%>>CLIENTE</option>
                            </select>  
                        </TD>
                    </TR>
                    <TR valign="top">
                        <TD width="120px"  class='text'  align="left">Usuario de acceso:</TD>
                        <TD nowrap  class='text' colspan='3'  align="left">
                            <INPUT type="text" name="usuario" id="usuario" value="<%= oPersona.getusuario ()==null ? "" : oPersona.getusuario()%>" size="10" maxlengh="20" <%= (oPersona.getiNumSecuUsu() == -1 ? "" : "disabled")%>>
                            &nbsp;(Recuerde que para los productores el usuario es el cod. de productor)
                        </TD>
                    </TR>
                    <TR valign="top">
                        <TD width="80px"  class='text' nowrap  align="left" >Password:</TD>
                        <TD class='text' width='200px' align="left" ><INPUT type="<%= (oUser.getusuario().equals("PINO") ? "text": "password")%>" name="password" id="password" value="<%= oPersona.getpassword ()==null ? "" : oPersona.getpassword()%>" size="10" maxlengh="20"></TD>
                        <TD width="100px"  class='text' nowrap align="left">Confirma password:</TD>
                        <TD class='text' width='300px' align="left"><INPUT type="password" name="confPassword" id="confPassword" value="<%= oPersona.getpassword ()==null ? "" : oPersona.getpassword()%>" size="10" maxlengh="20"></TD>
                    </TR>
                    <tr>
                        <td  valign="top"  class='text' colspan='4' align="left">
                            <div id="tipoProd" name="tipoProd"  align="left" style="WIDTH:700px">
                            Cod. de productor:&nbsp;<INPUT type="text" name="cod_prod" id="cod_prod" value="<%= oPersona.getiCodProd () %>" size="5" maxlengh="5" 
                            onchange='SetearUsuario (this.value);' <%= (oPersona.getiNumSecuUsu() == -1 ? "" : "disabled")%> onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                            &nbsp;(Si es Organizador, el cod. debe ser mayor a 80000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            Organizador:&nbsp;<INPUT type="text" name="organizador" id="organizador" value="<%= oPersona.getorganizador () %>" size="5" maxlengh="5"
                             <%= (oPersona.getiNumSecuUsu() == -1 || (oPersona.getorganizador () == 0 && oUser.getiCodTipoUsuario() == 0) ? "" : "disabled")%> 
                            onkeypress="return Mascara('D',event);" class="inputTextNumeric">&nbsp;(Para Organizadores = 0)
                            <br>Cod. anterior:&nbsp;<INPUT type="text" name="cod_prod_ant" id="cod_prod_ant" value="<%= oPersona.getcodProdAnt()%>" size="5" maxlengh="5"
                            <%= (oPersona.getiNumSecuUsu() == -1 || oUser.getiCodTipoUsuario() == 0 ? "" : "disabled")%> onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            Org. anterior:&nbsp;<INPUT type="text" name="cod_org_ant" id="cod_org_ant" value="<%= oPersona.getcodOrgAnt()%>" size="5" maxlengh="5"
                            <%= (oPersona.getiNumSecuUsu() == -1 || oUser.getiCodTipoUsuario() == 0 ? "" : "disabled")%>
                            onkeypress="return Mascara('D',event);" class="inputTextNumeric">

                            </div>
                            <div id="tipoCliente" name="tipoCliente"  align="left" style="WIDTH:200px">
                            Número de cliente:&nbsp;<INPUT type="text" name="num_tomador" id="num_tomador" value="<%= oPersona.getiNumTomador() %>" size="6" maxlengh="6"  <%= (oPersona.getiNumSecuUsu() == -1 ? "" : "disabled")%> onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                            </div>
                        </td>
                    </tr>
                    <TR valign="top">
                        <TD  class='text' align="left" nowrap align="left">Oficina:</TD>
                        <TD class='text' colspan='3' align="left">
                            <select name="oficina" class="select" id="oficina" <%= (oUser.getiCodTipoUsuario () == 0 ? " " : "disabled")%> >
<%  
                     lTabla = oTabla.getDatos ("OFICINA");
                     out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oPersona.getoficina()))); 
%>
                            </select>&nbsp;(Si es productor, ingrese la oficina con la que trabaja. Si es empleado de la empresa ingrese su oficina)
                        </TD>
                    </TR>
                    <TR valign="top">
                        <TD  class='text' align="left" nowrap align="left">Zona:</TD>
                        <TD class='text' colspan='3' align="left">
                            <select name="zona" class="select" id="zona" <%= (oUser.getiCodTipoUsuario () == 0 ? " " : "disabled")%>>
<%  
                                 lTabla = oTabla.getDatos ("ZONA");
                                 out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oPersona.getzona()))); 
%>
                            </select>&nbsp;(Para los productores ingrese la zona asignada, Si es un usuario interno y no es Comercial, ingrese zona Sin asignar)
                        </TD>
                    </TR>
<%              if (oUser.getiCodTipoUsuario() == 0) {
    %>
                    <TR valign="top">
                        <TD  class='text' nowrap align="left">Men&uacute;:</TD>    
                        <TD class='text' align="left">
                            <select name="menu" class="select" id="menu" <%= (oUser.getusuario ().equals ("HERNAN") || oUser.getusuario ().equals ("GLUCERO") || oUser.getusuario ().equals ("DANIEL")|| oUser.getusuario ().equals ("ADELGRECO") || oUser.getusuario ().equals ("VEFICOVICH") || oUser.getusuario ().equals ("PINO")|| oUser.getusuario ().equals ("VVIANELLO") ? " " : "disabled")%>>
                                <option value="0" <%= oPersona.getmenu() == 0 ? "selected" : " " %>>Menú por defecto USUARIO INTERNO</option>
                                <option value="1" <%= oPersona.getmenu() == 1 ? "selected" : " " %>>Menú por defecto PRODUCTOR/ORGANIZADOR</option>
                                <option value="2" <%= oPersona.getmenu() == 2 ? "selected" : " " %>>Menú por defecto CLIENTES</option>
                                <option value="4" <%= oPersona.getmenu() == 4 ? "selected" : " " %>>No cotiza/No emite propuestas (Productores/Internos)</option>
                                <option value="3" <%= oPersona.getmenu() == 3 ? "selected" : " " %>>Usuarios internos/Prestadores de AMF</option>
                                <option value="5" <%= oPersona.getmenu() == 5 ? "selected" : " " %>>Call Center</option>
                            </select>
                        </TD>
                            <TD  class="text" nowrap align="left">Sistema gesti&oacute;n:</TD>
                            <TD width="280px" align="left">
                                <select name="Sel_gestion" id="Sel_gestion" style="WIDTH: 190px"  class="select">
                                    <option value='' <%= (oPersona.getsSistGestion() == null || oPersona.getsSistGestion().equals ("") ? "selected" :  "") %> >Seleccione sistema</option>
<%                                      lTabla.clear();
                                        lTabla = oTabla.getDatos ("SIST_GESTION");
                                        out.println(ohtml.armarSelectTAG(lTabla, oPersona.getsSistGestion() == null ? "" :  oPersona.getsSistGestion()));
%>
                                </select>
                            </TD>
                    </TR>
<%  }
    %>
               </table>
            </td>
        </tr>
        <TR>
            <TD height="30px" valign="middle" align="center" class='titulo'>DATOS DE LA PERSONA</TD>
        </TR>
        <tr>
            <td  width="20%" align="left" style="padding-left:15px" class='text' align="left">Tipo de Documento:
                <SELECT style="WIDTH: 120px" name="tipoDoc" onchange="CambiarPersona (this.value);" class="select" id="tipoDoc" <%= (oPersona.getiNumSecuUsu() == -1 ? "" : "disabled")%>>
                    <option value='00' <%= oPersona.getTipoDoc().equals ("0") ? "selected" : " " %>>CI Policia Federal</option>
                    <option value='80' <%= oPersona.getTipoDoc().equals ("80") ? "selected" : " " %>>CUIT</option>
                    <option value='89' <%= oPersona.getTipoDoc().equals ("89") ? "selected" : " " %>>LE</option>
                    <option value='90' <%= oPersona.getTipoDoc().equals ("90") ? "selected" : " " %>>LC</option>
                    <option value='96' <%= oPersona.getTipoDoc().equals ("96") ? "selected" : " " %>>DNI</option>
            </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N° Documento:&nbsp;&nbsp;<INPUT name="numDoc" value="<%= oPersona.getDoc()==null ? "" : oPersona.getDoc()%>" size="13" onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%= (oPersona.getiNumSecuUsu() == -1 ? "" : "disabled")%>>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td  valign="top"  width="100%" height="60" class='text' align="left">
                <div id="PersonaFisica" name="PersonaFisica"  align="left" style="POSITION: absolute; height:60px; WIDTH:720px">
                    <table WIDTH="100%" HEIGHT="60"  border='0' align="left" style="margin-left: 15px;">
                        <TR valign="top">
                            <TD width="100px"  class='text'>Nombre:</TD> 
                            <TD width="250px"  class='text'><INPUT type="text" name="nombre" value="<%= oPersona.getNom()==null ? "" : oPersona.getNom()%>" size="40" maxlengh="50" ></TD>
                            <TD width="100px"  class='text' align="right">Apellido:</TD>
                            <TD  class='text'><INPUT type="text" name="apellido" value="<%= oPersona.getApellido()==null ? "" : oPersona.getApellido()%>" size="40" maxlengh="50"></TD>
                        </TR>
                    </table> 
                </div>
                <div id="PersonaJuridica" name="PersonaJuridica" style="POSITION: relative; height:60px; WIDTH:720px"> 
                    <TABLE  WIDTH="100%" HEIGHT="60"  align="left" style="margin-left: 15px;">
                         <TR>
                            <TD width="100px" align="left" class='text'>Raz&oacute;n Social:</TD>
                            <TD width="250px" align="left" class='text' colspan='3'> <INPUT type="text" name="razonSoc" id="razonSoc"  size="40" maxleng="50" value="<%= oPersona.getRazonSoc()==null ? "" : oPersona.getRazonSoc()%>" ></TD>
<%--                            <TD width="100px" align="left" class='text'>F. Inicio Actividad:</TD>
                            <TD align="left" class='text'><INPUT type="text" name="fInicAct" id="fInicAct" size="11" value="<%= oPersona.getFechaInicAct()== null ? "" : Fecha.showFechaForm(oPersona.getFechaInicAct())%>" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"></TD>
--%>
                            <INPUT type="hidden" name="fInicAct" id="fInicAct" value="<%= oPersona.getFechaInicAct()== null ? "" : Fecha.showFechaForm(oPersona.getFechaInicAct())%>">
                        </TR>

                         <TR valign="top">      
                            <TD width="100px" class='text'>Condici&oacute;n&nbsp;de&nbsp;IB:</TD>
                            <TD width="250px" align="left" class='text'><select name="Sel_ib" id="Sel_ib" size="1" style="WIDTH: 215px" class="select" <%= (oUser.getiCodTipoUsuario() != 0 ? "disabled" : "") %>>
<%                          lTabla.clear();
                            lTabla = oTabla.getDatos ("CONDICION_IB");
                            out.println(ohtml.armarSelectTAG(lTabla, oPersona.getTipoDoc())); 
%>
                                </SELECT>
                            </TD>
                            <TD width="100px" class='text'>N&uacute;mero&nbsp;de&nbsp;IB:</TD>
                            <TD align="left" class='text'><INPUT type="text" name="numIB" id="numIB" value="<%= oPersona.getNumIB()==null ? "" : oPersona.getNumIB()%>" <%= (oUser.getiCodTipoUsuario() != 0 ? "disabled" : "") %>></TD>
                         </TR>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td class='text'  align="left">
                <TABLE WIDTH="100%" align="left" style="margin-left: 15px;">
                     <TR>
                            <TD width="100px" align="left" class='text'  align="left">Condici&oacute;n&nbsp;IVA:</TD>
                            <TD align="left" ><select name="Sel_iva" id="Sel_iva" size="1" style="WIDTH: 200px" class="select" <%= (oUser.getiCodTipoUsuario() != 0 ? "disabled" : "") %>>
<%                          lTabla.clear();
                            lTabla = oTabla.getDatos ("CONDICION_IVA");
                            out.println(ohtml.armarSelectTAG(lTabla, oPersona.getTipoDoc())); 
%>
                                </SELECT>
                            </TD>
                            <TD width="100px" align="left">&nbsp;</TD>
                            <TD align="left">&nbsp;</TD>
                    </TR>
                    <TR>
                        <TD class='text'  align="left">Fax:</TD>
                        <TD align="left" class='text'  align="left"><INPUT type="text" name="fax" value="<%= oPersona.getFax()==null ? "" : oPersona.getFax()%>" size="20" maxlengh="30"></TD>
                        <TD class='text'  align="left" colspan='2'>Mail:&nbsp;
                        <INPUT type="text" name="email" value="<%= oPersona.getEmail()==null ? "" : oPersona.getEmail()%>" size="50" maxlengh="150"  align="left"></TD>
                    </TR>
                    <TR>
                        <TD width="100px" class='text'  align="left">Tel&eacute;fonos:</TD>
                        <TD colspan="3" class='text'  align="left">
                            <INPUT type="text" name="tel1" value="<%= oPersona.getTel1()==null ? "" : oPersona.getTel1()%>"  size="20" maxleng="30">
                            <INPUT type="text" name="tel2" value="<%= oPersona.getTel2()== null ? "" : oPersona.getTel2()%>" size="20" maxleng="30">
                        </TD>
                    </TR>
                </TABLE>
            </td>
        </tr>
        <tr>
            <TD height="30px" valign="middle" align="center" class='titulo'>DATOS DEL DOMICILIO</TD>
        </tr>
        <tr>
            <td width="100%" height="55px" valign="top" align="left">
                <TABLE WIDTH="100%" align="left" style="margin-left: 15px;" class='text'>
                    <TR>
                        <TD width="70px"  align="left">Domicilio:</TD>
                        <TD width="280px" colspan='3' align="left"><INPUT type="text" name="calle" value="<%= oPersona.getCalle()==null ? "" : oPersona.getCalle() %>" size="35" maxlength="50">
        <%--                <TD width="70px">N&uacute;mero:</TD>
                        <TD><INPUT type="text" name="numero" value="<%= oPersona.getNumero()==null ? "" : oPersona.getNumero()%>" size="9">&nbsp;&nbsp;&nbsp;
                                        Depto:&nbsp;<INPUT type="text" name="dpto" value="<%= oPersona.getDepto()==null ? "" : oPersona.getDepto()%>" size="4" maxlengh="5">&nbsp;&nbsp;&nbsp;
                                        Piso:&nbsp;<INPUT type="text" name="piso" value="<%= oPersona.getPiso()==null ? "" : oPersona.getPiso()%>" size="4" maxlengh="10"></TD>
--%>                    </TR>
                    <TR>
                        <TD width="70px" align="left">Localidad:</TD>
                        <TD width="280px" align="left"><INPUT type="text" name="localidad" value="<%= oPersona.getLocalidad()==null ? "" : oPersona.getLocalidad()%>" size="35"></TD>
                        <TD width="70px" align="left">C&oacute;digo&nbsp;Postal:</TD>
                        <TD align="left"><INPUT type="text" name="codPostal" value="<%= oPersona.getCodigoPostal()==null ? "" : oPersona.getCodigoPostal()%>" size="8" maxlength="8"></TD>
                        <TD colspan="4" align="left"></TD></TR>
                    <TR>		
                        <TD width="70px" align="left">Provincia:</TD>
                        <TD width="280px" align="left"><select name="Sel_pcia" id="Sel_pcia" style="WIDTH: 190px"  class="select">
<%                          lTabla.clear();
                            lTabla = oTabla.getDatos ("PROVINCIA");
                            out.println(ohtml.armarSelectTAG(lTabla, oPersona.getPcia())); 
%>
                            </SELECT>
                        </TD>
                        <INPUT TYPE="hidden" name="Sel_pais" id="Sel_pais" value="AR">
<%--                          lTabla.clear();
                            lTabla = oTabla.getDatos ("PAIS");
                            out.println(ohtml.armarSelectTAG(lTabla, oPersona.getTipoDoc())); 
--%>
                    </TR>
              </TABLE>
          </td>
      </tr>
      <tr>
        <TD height="30px" valign="middle" align="center" class='titulo'>COMENTARIOS</TD>
      </tr>
        <tr>
            <td width="100%" height="55px" valign="top" align="left">
                <table WIDTH="100%" align="left" style="margin-left: 15px;" class='text'>
                    <TR>
                        <TD width="100%"><TEXTAREA cols='70' rows='4' name='observacion' id='observacion'><%= (oPersona.getsObservacion () == null ? "" : oPersona.getsObservacion ()) %></textarea></TD>
                    </tr>
                </table>
            </td>
        </tr>
        <tr valign="bottom" >
            <td width="100%" align="center">
                <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                    <TR>
                        <TD align="center">
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdVolver" value="  Volver  "  height="20px" class="boton" onClick="Volver ();"/>&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="  Grabar  "  height="20px" class="boton" onClick="Grabar ();"/>
                        </TD>
                    </TR>
                </TABLE>		
            </td>
        </tr>
<script>
 CambiarPersona (document.formPersona.tipoDoc.value);
 CambiarTipo    (document.formPersona.tipoUsuario.value);
 numError = "<%= oPersona.getiNumError ()%>";
</script>
</form>

<!-- fin body del formulario   -->
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
