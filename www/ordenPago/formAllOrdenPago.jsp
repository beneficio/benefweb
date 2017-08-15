<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.OrdenPago"%>
<%@page import="com.business.beans.CtaCteFac"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.OrdenPagoDet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
    Usuario usu = (Usuario) session.getAttribute("user");
    LinkedList <OrdenPago> lOrdenes = (LinkedList) request.getAttribute("ordenes");
    
    %>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="es-419"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="es-419"> <![endif]-->
<!--[if IE 9]>         <html class="no-js lt-ie10" lang="es-419"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419"> <!--<![endif]-->
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Orden de Pago Pendientes</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
 
<!-- libreria jquery desde el cdn de google o fallback local -->
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/themes/base/jquery.ui.all.css"/>
        
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"></script>

    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/css/jquery.dataTables.css"/>
    <script type="text/javascript" language="javascript" src="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/js/jquery.dataTables.min.js"></script>
   
<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<script type="text/javascript">
    var usuarios = ["VEFICOVICH","GLUCERO","PINO","AGLANC" ];
    $(document).ready(function()
    {
        $('#example').DataTable({
            "pageLength": 50,  
            "order": [[ 0, "desc" ]],
            "language": {
                "sProcessing":    "Procesando...",
                "sLengthMenu":    "Mostrar _MENU_ registros",
                "sZeroRecords":   "No se encontraron resultados",
                "sEmptyTable":    "Ningún dato disponible en esta tabla",
                "sInfo":          "Mostrando _START_ al _END_ de _TOTAL_ registros",
                "sInfoEmpty":     "No existen ordenes de pago pendientes",
                "sInfoFiltered":  "(filtrado de un total de _MAX_ registros)",
                "sInfoPostFix":   "",
                "sSearch":        "Buscar:",
                "sUrl":           "",
                "sInfoThousands":  ",",
                "sLoadingRecords": "Cargando...",
                "oPaginate": {
                    "sFirst":    "Primero",
                    "sLast":    "Último",
                    "sNext":    "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                },
                "columnDefs": [
                 { "searchable": true, "targets": 0}
               ]
            }

        });


    });

</script>
</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
<a href="#" class="close_message" title="cerrar aviso" onclick="document.getElementById('aviso').style.display='none';return false"></a>
</div><![endif]-->

<div class="wrapper">

    <!-- container -->
    <div class="container">

        <jsp:include page="/header.jsp">
            <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
            <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
            <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
        </jsp:include>
        <div class="menu">
            <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
        </div>

         <h1 class="title-section hcotizadores">Ordenes de Pago</h1>

         <!-- tabs -->

        <div class="tabs-container">
           
        <form action="<%= Param.getAplicacion()%>servlet/OrdenPagoServlet" method="post"
             name="form1" id="form1" >
            <input type="hidden" name="opcion"      id="opcion"    value="getFactura"/>
            <input type="hidden" name="volver" id="volver" value="getAllOrdenPago"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_secu_op" id="num_secu_op" value="0"/>
            <input type="hidden" name="tipo_usuario"   id="tipo_usuario"   value="<%= usu.getiCodTipoUsuario() %>"/>
            <input type="hidden" name="cuit" id="cuit" value="" />
            <input type="hidden" name="operacion" id="operacion" value="" />
            <input type="hidden" name="cod_prod" id="cod_prod" value="" />
                    
            <table id="example" class="display compact order-column cell-border row-border hover" cellspacing="0" width="100%">
                    <thead>
                            <tr>    
                                <th style="font-size: 12px;font-weight: bold;"># ID</th>
                                <th style="font-size: 12px;font-weight: bold;">Fecha<br>Carga</th>
                                <th style="font-size: 12px;font-weight: bold;"># OP</th>
                                <th style="font-size: 12px;font-weight: bold;">Fecha OP</th>
                                <th style="font-size: 12px;font-weight: bold;" data-class-name="num_factura"># Factura</th>
                                <th style="font-size: 12px;font-weight: bold; white-space: nowrap;" data-class-name="beneficiario">Beneficiario</th>
                                <th style="font-size: 12px;font-weight: bold;">Cod.Prod</th>
                                <th style="font-size: 12px;font-weight: bold;" data-class-name="estado">Estado</th>
                                <th style="font-size: 12px;font-weight: bold;">$ Iva</th>
                                <th style="font-size: 12px;font-weight: bold;">$ Factura</th>
                                <th style="font-size: 12px;font-weight: bold;">$ Orden Pago</th>
                                <th>&nbsp;</th>
                            </tr>
                    </thead>
                    <tbody>
<%                  for (int i=0;i<lOrdenes.size() ;i++) {
                        OrdenPago op =  (OrdenPago) lOrdenes.get(i);
                        String colorEstado = "";
                        switch ( op.getcodEstado()) { 
                            case 1: 
                                colorEstado = "green";
                                break;
                            case 3: 
                                colorEstado = "blue";
                                break;
                            case 5: 
                                colorEstado = "red";
                                break;
                            case 9: 
                                colorEstado = "#900C3F";
                                break;
                            default: 
                                colorEstado = "black";
                        }
    %>
                                    <tr>
                                        <td style="font-size: 12px;"><%= op.getNumSecuOp() %></td>
                                        <td style="font-size: 12px;"><%= Fecha.showFechaForm(op.getfechaTrabajo()) %></td>
                                        <td style="font-size: 12px;"><%= op.getnumOrden() %></td>
                                        <td style="font-size: 12px;"><%= (op.getfechaEmision() == null ? "" : Fecha.showFechaForm(op.getfechaEmision())) %></td>                                        
                                        <td style="font-size: 12px;"><%= op.getnumSuc() %>-<%= op.getnumFactura() %></td>
                                        <td style="font-size: 12px; white-space: nowrap;"><%= op.getbeneficiario().trim() %></td>
                                        <td style="font-size: 12px"><%= op.getcodProdDc() %></td> 
                                        <td style="font-size: 12px;color:<%= colorEstado %>;"><%= op.getdescEstado() %><br><%= (op.getdescErrorOP() == null ? "" : op.getdescErrorOP()) %> 
<%                                 if ( op.getcodEstado() == 5 && op.getcodErrorOP() == -300 && usu.getiCodTipoUsuario() == 0 ) {
    %>
    <a href="#" onClick="javascript:AgregarCuit ('<%= op.getcuit() %>',<%= op.getCodProd() %>,'ALTA');">Agregar</a>
<%                                  }
    %>
                                        </td>
                                        <td style="font-size: 12px;text-align: right;"><%= Dbl.DbltoStr(op.getimpIva(),2) %></td>
                                        <td style="font-size: 12px;text-align: right;"><%= Dbl.DbltoStr(op.getimpFactura(),2) %></td>
                                        <td style="font-size: 12px;text-align: right;"><%= Dbl.DbltoStr(op.getimpOrdenPago(),2) %></td>
                                        <td style="font-size: 12px;white-space: nowrap;" >
                                            <a href="#"  onclick="javascript:verFactura(<%= op.getNumSecuOp() %>);">Editar</a>&nbsp;&nbsp;
                                            <a href="#" onclick="javascript:anularFactura(<%= op.getNumSecuOp() %>);"><span style="color:red;">Anular</span></a>
                                        </td> 
                                    </tr>
<%                  }
    %>
                    </tbody>
            </table>
            </form>
        </div>

        <!--! tabs -->

            <jsp:include flush="true" page="/bottom.jsp"/>

    </div>
<!--! container -->
</div> <!--! wrapper -->
<script>
    function AgregarCuit ( cuit, codProd, oper ) {

        document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
        document.form1.opcion.value = "addCuitAfip";
        document.form1.cuit.value = cuit;
        document.form1.operacion.value = oper;
        document.form1.cod_prod.value = codProd;
        document.form1.submit();            
    }

function verFactura ( numSecuOp ) {    
    document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
    document.form1.opcion.value = "getFactura";
    document.form1.num_secu_op.value = numSecuOp;
    document.form1.submit();    
    return true;
}

function anularFactura ( numSecuOp ) {
    
    if ( confirm ("Esta seguro que desea anular la Orden de pago N " + numSecuOp)) { 
        document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
        document.form1.opcion.value = "deleteFactura";
        document.form1.num_secu_op.value = numSecuOp;
        document.form1.submit();    
        return true;
    } else {
        return false;
    }
}

</script>
</body>   
</html>

