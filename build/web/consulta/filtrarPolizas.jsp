<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Grupo"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.business.util.Parametro"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%
    LinkedList lPolizas = (LinkedList) request.getAttribute("polizas");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    int iSize           = (lPolizas == null ? 0 : lPolizas.size());    
    String sPri         = oDicc.getString(request,"F1pri","S");
    int iCodProd        = oDicc.getInt (request, "F1cod_prod");
    int iNumTomador     = oDicc.getInt (request, "F1num_tomador");
    String sNombre      = oDicc.getString (request, "F1nombre");
//    String sDocumento   = oDicc.getString (request, "F1documento");    
    int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
    int iNumPropuesta   = oDicc.getInt (request, "F1num_propuesta");
    int iCodRama        = oDicc.getInt (request, "F1cod_rama");
    int iNumPolizaSelec = oDicc.getInt (request, "F1num_poliza_sel");
    int iCodRamaSelec   = oDicc.getInt (request, "F1cod_rama_sel");
    int iGrupo          = oDicc.getInt (request, "F1grupo");
    Date dFechaDesde    = oDicc.getDate(request, "F1fecha_desde");
    Date dFechaHasta    = oDicc.getDate(request, "F1fecha_hasta");
    String sEstado       = oDicc.getString (request, "F1estado");

    oDicc.add("F1pri", sPri );
    oDicc.add("F1nombre", sNombre);
    oDicc.add("F1estado", sEstado); //TODAS, NO VIGENTES, VIGENTES
    oDicc.add("F1cod_prod", String.valueOf(iCodProd));
    oDicc.add("F1num_tomador", String.valueOf (iNumTomador));
    oDicc.add("F1num_propuesta", String.valueOf (iNumPropuesta));
    oDicc.add("F1num_poliza", String.valueOf (iNumPoliza));
    oDicc.add("F1cod_rama", String.valueOf (iCodRama));
    oDicc.add("F1num_poliza_sel", String.valueOf (iNumPolizaSelec));
    oDicc.add("F1cod_rama_sel", String.valueOf (iCodRamaSelec));
    oDicc.add("F1grupo", String.valueOf (iGrupo));
    oDicc.add("F1fecha_desde", (dFechaDesde == null ? null : Fecha.showFechaForm(dFechaDesde)));
    oDicc.add("F1fecha_hasta", (dFechaHasta == null ? null : Fecha.showFechaForm(dFechaHasta)));
    
    session.setAttribute("Diccionario", oDicc);

    String sPath  = "&F1pri=N&F1nombre=" + sNombre +  "&F1grupo=" + iGrupo +
    "&F1cod_prod=" + iCodProd  + "&F1num_tomador=" + iNumTomador +
    "&F1num_propuesta=" + iNumPropuesta + "&F1num_poliza=" + iNumPoliza +
    "&F1num_poliza_sel=0&F1cod_rama_sel=0&F1cod_rama=" + iCodRama + "&opcion=getAllPol" +
    (dFechaDesde == null ? "" : "&F1fecha_desde=" + Fecha.showFechaForm(dFechaDesde)) +
    (dFechaHasta == null ? "" : "&F1fecha_hasta=" + Fecha.showFechaForm(dFechaHasta)) +
     "&F1estado=" + sEstado;

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    Date dFechaFTP = null;
    String sMercadoPago = "N";

    Connection dbCon = null;
    try {
        dbCon = db.getConnection();
        dbCon.setAutoCommit(false);

            Parametro oParam = new Parametro ();

            if ( usu.getiCodTipoUsuario() == 0 ) {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_INTERNO");
            } else  {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_PROD");
            }
                
            sMercadoPago = oParam.getDBValor(dbCon);

    } catch (Exception se) {
            throw new SurException (se.getMessage());
    } finally {
            db.cerrar(dbCon);
    }

    String sEstadoSelect = sEstado;
    if (sEstadoSelect == null || sEstadoSelect.equals("") ) {
        sEstadoSelect = "VIGENTE";
    }

    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js" defer="defer"></script>
    <script language="javascript">

    function  VerPoliza  ( rama, poliza ) {


       document.form1.action = '<%= Param.getAplicacion()%>servlet/ConsultaServlet';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.opcion.value  = 'getPol';
       document.form1.submit();
     //   OpenEspere ();
        return true;
    }

    function  VerEndosos ( rama, poliza ) {

       document.form1.action = '<%= Param.getAplicacion()%>servlet/ConsultaServlet';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.opcion.value  = 'getAllEnd';
       document.form1.submit(); 
     //   OpenEspere ();
        return true;
    }


    function  VerCobranza( rama, poliza ) {

       document.form1.action = '<%= Param.getAplicacion()%>servlet/ConsultaServlet';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.opcion.value  = 'getAllCob';
       document.form1.submit(); 
    //    OpenEspere ();
        return true;
    }

    function ExportarXLS ( opcion ) {
        alert ("la cantidad máxima de pólizas son 5000. La consulta puede durar unos minutos, por favor espere ! ");
        var propuesta = LTrim(Trim (document.form1.F1num_propuesta.value));
        var poliza    = LTrim( Trim(document.form1.F1num_poliza.value));
        var numCliente= LTrim( Trim(document.form1.num_cliente.value));

        if (propuesta === "") {
            propuesta = "0";
        }

        if ( poliza === "") {
            poliza = "0";
        }

        if ( numCliente === "") {
            numCliente = "0";
        }

        permitidos=/[^0-9.]/;
        if(permitidos.test(propuesta)){
            alert("En la celda número de propuesta hay caracteres que no son números, por favor verifique");
            return document.form1.F1num_propuesta.focus();
        }

        if(permitidos.test(poliza)){
            alert("En la celda de número de p&oacute;liza hay caracteres que no son números, por favor verifique");
            return document.form1.F1num_poliza.focus();
        }

        if(permitidos.test(numCliente)){
            alert("En la celda de número de Cliente hay caracteres que no son números, por favor verifique");
            return document.form1.numCliente.focus();
        }

        document.form1.F1num_propuesta.value = propuesta;
        document.form1.F1num_poliza.value    = poliza;

        if (parseFloat (numCliente) > 0 ) {
            document.form1.F1num_tomador.value = numCliente;
        }

        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/ConsultaServlet";
            if ( opcion == 'poliza') {
                document.form1.opcion.value  = 'getAllPolXLS';
            } else {
                document.form1.opcion.value  = 'getAllEndXLS';
            }
            
            document.form1.submit();
//            OpenEspere ();
            return true;
       } else {
            return false;
       }
    }

    function Buscar () { 

        var propuesta = LTrim( Trim (document.form1.F1num_propuesta.value));
        var poliza    = LTrim(Trim(document.form1.F1num_poliza.value));
        var numCliente= LTrim( Trim(document.form1.num_cliente.value));

        if (propuesta === "") {
            propuesta = "0";
        }

        if ( poliza === "") {
            poliza = "0";
        }

        if (numCliente === "") {
            numCliente = 0;
        }

        permitidos=/[^0-9.]/;
        if(permitidos.test(propuesta)){
            alert("En la celda número de propuesta hay caracteres que no son números, por favor verifique");
            return document.form1.F1num_propuesta.focus();
        }

        if(permitidos.test(poliza)){
            alert("En la celda de número de p&oacute;liza hay caracteres que no son números, por favor verifique");
            return document.form1.F1num_poliza.focus();
        }

        if(permitidos.test(numCliente)){
            alert("En la celda de número de Cliente hay caracteres que no son números, por favor verifique");
            return document.form1.num_cliente.focus();
        }

        document.form1.F1num_propuesta.value = propuesta;
        document.form1.F1num_poliza.value    = poliza;

        if (parseFloat (numCliente) > 0 ) {
            if (document.form1.tipo_usuario.value === "0") {
                document.form1.F1num_tomador.options[document.form1.F1num_tomador.selectedIndex].value = numCliente;
            } else {
                document.form1.F1num_tomador.value = numCliente;
            }
        }

        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/ConsultaServlet";
            document.form1.opcion.value  = 'getAllPol';
            document.form1.submit(); 
      //      OpenEspere ();
            return true;
       } else {
            return false;
       }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function Submitir(evt) {
           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode === 13) {
            Buscar ();
          }
    }

        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }

    function  MercadoPago ( rama, poliza ) {

        var mensaje = '';

        $.post('<%= Param.getAplicacion()%>portal/authority.html', { 
            numDoc: '30693157923', 
            polizaNumber: poliza, 
            ramaCode: rama, 
            origen: 'POLIZA', 
            backPage: 'consulta/filtrarPolizas.jsp', 
            idtransaction: '3' }, 
        function(result) {
        
        if(result.success === true) {
            window.location.href = "<%= Param.getAplicacion()%>" + result.redirect;
        }else{ 
            if(result.message != null || result.message != '') {
 //               $('#msg_payment').html(result.message);
                mensaje = result.message;
            } else {
//                $('#msg_payment').html('Por favor, intente nuevamente.');
                mensaje = 'Por favor, intente nuevamente.';
            }
//            $('#msg_payment').show();
              alert (mensaje);
            }
        }, 'json');
    
    return true;
    }
    </script>
</head>
    <body>
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0"  id="tabla_general" >
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
            <td valign="top" align="center" width="100%">
                <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet">
                    <input type="hidden" name="opcion" id="opcion" value="getAllPol"/>
                    <input type="hidden" name="F1pri" id="F1pri" value="N"/>
                    <input type="hidden" name="volver" id="volver" value='filtrarPolizas'/>
                    <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="0"/>
                    <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="0"/>
                    <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>" />
                    <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm">
                        <tr>
                            <td valign="middle" align="center" class='titulo'>CONSULTA DE POLIZAS</td>
                        </tr>
    <%          if (usu.getiCodTipoUsuario() != 0) {
                            if (usu.getiCodTipoUsuario () == 1 && usu.getiCodProd () < 80000) {
        %>

                                <input type="hidden" name="F1cod_prod" value="<%= usu.getiCodProd () %>"/>
    <%                      } 
                %>
                    <input type="hidden" name="F1num_tomador" value="<%= ( usu.getiCodTipoUsuario() == 2 ?  usu.getiNumTomador () : 0) %>"/>
                    <tr>
                        <td width='75%' align="left" class='subtitulo' valign="top" >
                            <dl  ><dt style="min-height: 25px;" >Estimado, desde aqui usted podra:</dt>
                                <dd style="min-height: 25px;" >- Consultar P&oacute;lizas/endosos, premio, pagos/ reducciones/ d&eacute;bitos/ cr&eacute;ditos.</dd>
                                <dd style="min-height: 25px;" >- Solicitar el env&iacute;o via mail de copias de p&oacute;lizas y endosos.</dd>
                                <dd style="min-height: 25px;" >- Certificados de cobertura individuales</dd>
                                <dd style="min-height: 25px;" >- Seleccionar uno o varios filtros al mismo tiempo, la consulta traerá a como máximo 200 p&oacute;lizas</dd>
                                <dd style="min-height: 25px;" >- Exportar a excel el filtro seleccionado hasta un total de 5000 filas</dd>
<%                    if (sMercadoPago.equals ("S")) {
    %>
                                <dd><span style="color:red;vertical-align: bottom;" >- Financiar el saldo de la p&oacute;liza con tarjeta de cr&eacute;dito&nbsp;</span></dd>
                                <dd style="min-height: 25px;text-align: right;vertical-align: top;" >&nbsp;<img src="https://imgmp.mlstatic.com/org-img/banners/ar/medios/468X60.jpg" title="MercadoPago - Medios de pago" alt="MercadoPago - Medios de pago" width="468" height="60"/>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                </dd>
<%                    }
    %>
                            </dl>
                        </td>
                    </tr>
    <%          }
        %>
                    <tr>
                        <td align="left" valign="top">
                            <table border='0' align="left" cellpadding='3' cellspacing='3' width="100%">
    <%                      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
        %>
                                <tr>
                                    <td align="left" class="text" <%=(usu.getiCodTipoUsuario() == 0 ? " colspan='2'" : " ")%>>Productor:&nbsp;
                                        <select class='select' name="F1cod_prod" id="F1cod_prod">
                                            <option value='0' >Todos los productores</option>
    <%                              LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                     for (int i= 0; i < lProd.size (); i++) {
                                            Usuario oProd = (Usuario) lProd.get(i);
                                            out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                        }
        %>
                                        </select>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%                      if (usu.getiCodTipoUsuario() == 0) {
        %>
                                    Cliente:&nbsp;
                                        <select class='select' name="F1num_tomador" id="F1num_tomador">
                                            <option value='0' >Todos los clientes</option>
    <%                                  LinkedList lClientes = (LinkedList) session.getAttribute("Clientes");
                                        for (int i= 0; i < lClientes.size (); i++) {
                                            Usuario oProd = (Usuario) lClientes.get(i);
                                            out.print("<option value='" + String.valueOf (oProd.getiNumTomador()) + "' "+ (oProd.getiNumTomador() == iNumTomador ? "selected" : " ") + " >" + oProd.getsDesPersona() + " (" + oProd.getiNumTomador() + ")</option>");
                                        }
        %>
                                        </select>
    <%                      }
        %>
                                    </td>
                                </tr>

    <%                      }
        %>
                                <tr>
                                    <td align="left"  class="text" valign="top" nowrap width="240px" >Rama:&nbsp;
                                        <select name="F1cod_rama" id="F1cod_rama"   class="select">
                                            <option value='0' >Todas las rama</option>
        <%                           lTabla = oTabla.getRamas ();
                                     out.println(ohtml.armarSelectTAG(lTabla, iCodRama ));
        %>
                                        </select>
                                    </td>
                                        <td align="left" class='text' nowrap width="500px">
                                    N&uacute;mero P&oacute;liza:&nbsp;<input name="F1num_poliza" id="F1num_poliza"  size='12' maxlength='12'
                                                                                  value="<%= iNumPoliza %>"  onkeypress="return Mascara('D',event);"
                                                                                  class="inputTextNumeric"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left"  class="text">N&uacute;mero Cliente:&nbsp;<input name="num_cliente" id="num_cliente"  size='12' maxlength='12'
                                                                                  value="<%= ( usu.getiCodTipoUsuario() == 2 ?  usu.getiNumTomador () : iNumTomador ) %>"  onkeypress="return Mascara('D',event);"
                                                                                  class="inputTextNumeric" <%= ( usu.getiCodTipoUsuario() == 2 ?  "readonly" : " ") %> />
                                    </td>
                                    <td align="left"  class="text">(*) Nombre/R.Social Cliente:&nbsp;<input name="F1nombre" id="F1nombre" size='45' value="<%= sNombre %>"/></td>
                                </tr>
                                <tr>
                                    <td align="left"  class="text"  nowrap >Fecha de emision desde (dd/mm/a&ntilde;o)
                                    <input type="text" name="F1fecha_desde" id="F1fecha_desde" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaDesde == null ? "" : Fecha.showFechaForm(dFechaDesde))%>'/>
                                    </td>
                                    <td align="left"  class="text">
                                           &nbsp;hasta  (dd/mm/a&ntilde;o):&nbsp;
                                    <input type="text" name="F1fecha_hasta" id="F1fecha_hasta" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaHasta == null ? "" :  Fecha.showFechaForm(dFechaHasta))%>'/>
                                     </td>
                                </tr>
                                <tr>
                                    <td align="left"  class="text">Número Propuesta Web:&nbsp;<input name="F1num_propuesta" id="F1num_propuesta"  size='12' maxlength='12'
                                                                                                 value="<%= iNumPropuesta %>"  onkeypress="return Mascara('D',event);"
                                                                                                 class="inputTextNumeric"/>
                                    </td>
                                    <td align="left" class="text" colspan='2'>Filtrar por estado:&nbsp;
                                        <select class='select' name="F1estado" id="F1estado">
                                            <option value='TODAS' <%= ( sEstadoSelect.equals("TODAS") ? "selected" : " ") %>>TODAS LAS POLIZAS</option>
                                            <option value='VIGENTE' <%= ( sEstadoSelect.equals("VIGENTE") ? "selected" : " ") %>>VIGENTES</option>
                                            <option value='NO_VIGENTE' <%= ( sEstadoSelect.equals("NO_VIGENTE") ? "selected" : " ") %>>NO VIGENTES</option>
                                            <option value='ANULADA' <%= ( sEstadoSelect.equals("ANULADA") ? "selected" : " ") %>>ANULADAS</option>
                                        </select>
                                    </td>
                                </tr>
    <%                      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodTipoUsuario() == 1) {
        %>
                                <tr>
                                    <td align="left" class="text" colspan='2'>Poliza grupo:&nbsp;
                                        <select class='select' name="F1grupo" id="F1grupo">
                                            <option value='0'>Seleccione grupo</option>
    <%                                     lTabla = oTabla.getGrupos(usu.getusuario() );
                                            for (int i= 0; i < lTabla.size (); i++) {
                                                Grupo oG = (Grupo) lTabla.get(i);
                                                out.print("<option value='" + oG.getiCodGrupo() + "' "+ (oG.getiCodGrupo() == iGrupo ? "selected" : " ") + " >" + oG.getsDescripcion() + "</option>");
                                            }
                                            if (usu.getiCodTipoUsuario() == 0) {
                                                out.print("<option value='99999'>Todos los grupos</option>");
                                            }
        %>
                                        </select>
                                    </td>
                                </tr>

    <%                      } else {
        %>
        <input type="hidden" name="F1grupo" id="F1grupo"/>
    <%                     }
        %>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="left" class='text' >(*) Puede ingresar el valor parcialmente.&nbsp;
                                Por ej: ingresando Oscar, visualizar&aacute; todas las p&oacute;lizas en la que el cliente contenga Oscar<br/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" >
                            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" value="  Buscar  "  height="20px" class="boton" onClick="Buscar ();"/>
                            </td>
                        </tr>
                     </table>
                </form>
            </td>
        </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>

        <tr>
            <td>
               <table border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                    <tr>
                        <td>
                            <table border="0" width="100%" cellspacing="3">
                                <tr>
                                    <td height="20" class='titulo' width="40%" valign="bottom" align="left">Resultado de la consulta</td>
                                    <td width="60%" align="center" class="text">
                                        <img src="<%= Param.getAplicacion()%>images/XLS.gif"/>&nbsp;&nbsp;<a href="#" onclick="ExportarXLS('poliza');">Exportar solo polizas</a>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <img src="<%= Param.getAplicacion()%>images/XLS.gif"/>&nbsp;&nbsp;<a href="#" onclick="ExportarXLS('endoso');">Exportar todos los endosos </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class='text'>
                            <IMG src="<%= Param.getAplicacion()%>images/nuevoP.gif"/>&nbsp;Consulta y copias de P&oacute;liza -&nbsp;
                            <IMG src="<%= Param.getAplicacion()%>images/nuevoE.gif"/>&nbsp;Consulta y copias de Endosos -
                            <IMG src="<%= Param.getAplicacion()%>images/nuevoS.gif"/>&nbsp;Consulta de Cobranza
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"  width='100%'>
                            <pg:pager maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/ConsultaServlet"
                            maxIndexPages="20" export="currentPageNumber=pageNumber">
                            <pg:param name="keywords"/>

                            <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width='80%'>
                                <thead>
                                    <th width='20' nowrap>Rama</th>
                                    <th  width="60px">P&oacute;liza</th>
                                    <th  width="60px">Cliente</th>
                                    <th width="70px">Emisi&oacute;n</th>
                                    <th  width="130px" nowrap>Vigencias</th>
                                    <th  width="80px" nowrap>Estado</th>
                                    <th  width="120px" nowrap>Productor</th>
                                    <th  width="120px" nowrap>Cliente</th>
                                    <th nowrap align="left">Opciones</th>
                                </thead>
                               <% if (iSize  == 0 ){%>
                                <tr>
                                    <td colspan="8" height='25' valign="middle"><span style='color:red'>No existen p&oacute;lizas para la consulta realizada</span></td>
                                </tr>
    <%                         }
                               for (int i=0; i < iSize; i++)  {
                                     Poliza oPol = (Poliza) lPolizas.get(i);
                                     dFechaFTP   = oPol.getfechaFTP();
                                     String  sNumPoliza =  String.valueOf(oPol.getnumPoliza ());
                                     if (oPol.getcodRama() == 21 && oPol.getCuic() == null  ) {
                                         sNumPoliza = "<span style='color:red;'>CUIC<br>Pendiente</span>";
                                     }
        %>
                              <pg:item>
                                <tr>
                                    <td align="left" ><IMG src="<%= Param.getAplicacion()%>images/poliza.bmp" border='0'  style="cursor: hand;"
                                        onclick="VerPoliza ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"/>&nbsp;<%= oPol.getdescRama ()%>
                                    </td>
                                    <td align="center"><%= sNumPoliza%></td>
                                    <td align="right">&nbsp;<%= oPol.getnumTomador() %></td>
                                    <td align="center"><%= (oPol.getfechaEmision () == null ? " " : Fecha.showFechaForm(oPol.getfechaEmision ()))  %></td>
                                    <td align="center" nowrap><%= (oPol.getfechaInicioVigencia() == null ? "no informado" : Fecha.showFechaForm(oPol.getfechaInicioVigencia())) +
                                                         "-" + (oPol.getfechaFinVigencia ()==null ? "sin fin vig" :
                                                         Fecha.showFechaForm(oPol.getfechaFinVigencia ()))  %>
                                    </td>
                                    <td align="center" nowrap><%= oPol.getestado() %>&nbsp;</td>
                                    <td align="left" nowrap><%= oPol.getdescProductor ()%>&nbsp;</td>
                                    <td align="left" nowrap><%= oPol.getrazonSocialTomador ()%>&nbsp;</td>
                                    <td align="left" nowrap>
                                        <img src="<%= Param.getAplicacion()%>images/nuevoP.gif" onclick="VerPoliza ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"  style="cursor: hand;"/>&nbsp;&nbsp;
                                        <img src="<%= Param.getAplicacion()%>images/nuevoE.gif" border='0'  style="cursor: hand;" onclick="VerEndosos ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"/>&nbsp;&nbsp;
                                        <img src="<%= Param.getAplicacion()%>images/nuevoS.gif" border='0'  style="cursor: hand;" onclick="VerCobranza ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"/>
<%                      if (sMercadoPago.equals("S")) {
                            if (oPol.getimpSaldoPoliza() > 0 && ! oPol.getestado().equals("ANULADA") &&
                                  ! ( oPol.getcodRama() == 21 && oPol.getcodSubRama() == 1 ) &&
                                    ( oPol.getcodRama() != 21 || ( oPol.getcodRama() == 21 && oPol.getcodSubRama() == 2 && oPol.getCuic() != null ) ) ) {
    %>
                                        <input type="button" name="cmdSalir"  value="Pagar"  height="18px"  title="Pagar la póliza por MercadoPago"
                                           class="boton" onClick="MercadoPago ('<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"/>
<%                          }
                        }
    %>
                                    </td>
                                </tr>
                            </pg:item>
    <%                          }
        %>
                                 <thead>
                                    <th colspan="9">
                                        <pg:prev>
                                        <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
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
    <%              if (dFechaFTP != null) {
        %>
                   <tr>
                    <td align="left" class='subtitulo' height='25' valign="middle">Nota: informaci&oacute;n actualizada al <%= Fecha.showFechaForm(dFechaFTP) %></td>
                    </tr>
    <%              }
        %>
                </table>
            </td>
       </tr>
<%      }
%>
       <tr>
            <td valign="bottom" align="center">
                <jsp:include  flush="true" page="/bottom.jsp"/>
            </td>
       </tr>
    </table>
<script language="javascript">
var divHeight;
var obj = document.getElementById('tabla_general');

if(obj.offsetHeight)          {divHeight=obj.offsetHeight;}
else if(obj.style.pixelHeight){divHeight=obj.style.pixelHeight;}
document.write('<div id="mascara" style="width:100%;height:' + divHeight + 'px;position:absolute;top:0;left:0;' +
               'background-color:#F5F7F7;z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>' );
</script>
<!--<div id="mascara" style="position:fixed;top:0;left:0; width:100%;height:100%; background-color:#F5F7F7; z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>
-->
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:600px;height:100%;margin-top: -30px;margin-left: -300px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                    Espere por favor mientras se procesa la consulta...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>

<script>
     CloseEspere();
</script>
</body>
</HTML>
