<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Producto"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.CotizadorNomina"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
     Usuario usu = (Usuario) session.getAttribute("user");
     Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");
     Producto   oProd = (Producto) request.getAttribute("producto");
     if ( oCot.getlNomina() == null || oCot.getlNomina().size() == 0  ) {
            oCot.getlNomina().add(new CotizadorNomina());
     }
     //System.out.println("cotizarVC_sol2.jsp -------------> " + oCot.getmcaNominaExcel());
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Cotizador Vida Colectivo</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>    
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/css/jquery.dataTables.css"/>

    <!-- libreria jquery desde el cdn de google o fallback local -->
    
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>    
    <script type="text/javascript" language="javascript" src="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/js/jquery.dataTables.min.js"></script>

    <script src="<%= Param.getAplicacion()%>script/formatos.js"></script>

<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->


<script type="text/javascript">


    $(document).ready(function()
    {
        $('#example').DataTable({                                 
            "language": {
                "sProcessing":    "Procesando...",
                "sLengthMenu":    "Mostrar _MENU_ registros",
                "sZeroRecords":   "No se encontraron resultados",
                "sEmptyTable":    "Ningún dato disponible en esta tabla",
                "sInfo":          "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                "sInfoEmpty":     "Mostrando registros del 0 al 0 de un total de 0 registros",
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
                }
            }
            
        });


    });


</script>

<script type="text/javascript">

var SITE = SITE || {};

SITE.fileInputs = function() {
  var $this = $(this),
      $val = $this.val(),
      valArray = $val.split('\\'),
      newVal = valArray[valArray.length-1],
      $button = $this.siblings('.button'),
      $fakeFile = $this.siblings('.file-holder');
  if(newVal !== '') {
    $button.text('Elegir Otro?');
    if($fakeFile.length === 0) {
      $button.after('<span class="file-holder">' + newVal + '</span>');
    } else {
      $fakeFile.text(newVal);
    }
  }
};

$(document).ready(function() {

  $('.file-wrapper input[type=file]').bind('change focus click', SITE.fileInputs);


    $('.bt-addrmv').live('click', function(event) {

         var cantVidas  = parseInt($('#CANT_PERSONAS').val ());

         if ( cantVidas == 1 || cantVidas == 0 ) {
             alert ("No puede eliminar todas las personas de la nomina");
             return false;

         } else {
            event.preventDefault();
            $(this).parents('.form-file').remove();
            var aseg  = parseInt($('#CANT_PERSONAS').val ()) - 1;
            $('#CANT_PERSONAS').val (aseg);
         }
    });

    $("#CANT_PERSONAS").change(function(){

        var aseg  = $('#CANT_PERSONAS').val ();
        if ( aseg == '' || aseg == '0' ) {
           return true;
        }

        if ( parseInt (aseg) > 250 ) {
           alert ("Por favor utilice la opción 1 para cotizar más de 250 asegurados !!");
           $('#CANT_PERSONAS').focus ();
           return false;
        }
        var asegActual = 0;

        if ( $('.form-file.dynamic-content').length > 0 ) {
            asegActual  = $('.form-file.dynamic-content').size();
        }

        var cant        =  parseInt (aseg) - asegActual;
        var agregar = true;

        if ( asegActual > aseg ) {
            agregar = false;
             cant  =  asegActual - parseInt (aseg);
        }

        if (cant > 0 ) {
            if (agregar == true) {
                for ( var i = 0; i < cant; i++ ) {
                    $('.form-file.dynamic-content').eq(0).clone().appendTo('.t-component').children('.wrap-elements').each (
                        function (index, value ) {
                            $(this).children('.quantity.vidas').each (
                                function (index, value ) {
                                   $(this).val('0');
                                }
                            );
                        }
                    );
                }
                //begin regenerar name
                $('.form-file.dynamic-content').each ( function (ind ) {
                    $(this).children('.wrap-elements').children('.quantity.vidas').each (function (index, value ) {
                        var data = $(this).attr('name');
                        var arr = data.split('_');
                        $(this).attr('name', arr[0] + '_' + ind);
                    })
                });
                // End regenar name

            } else {
                for ( var i = 0; i < cant; i++ ) {
                    $('.form-file.dynamic-content').eq(0).remove ();
                }
            }
         }
    });

});

    function Ir (sigte) {
        document.getElementById("siguiente").value = sigte;
        document.form1.submit();        
        return true;
    }

    function ControlarFechaEdad (fecha, campo ) {

        var edad = 0;
        var desde = new Date();

        if (fecha != "0" && fecha != "") {
            if (fecha.length > 0 && fecha.length < 3 ) {
                edad = parseInt (fecha);
            } else {
                var Fecha_nac = new Date (FormatoFec( fecha));
                var Fecha_desde = new Date (FormatoFec( desde));
                edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));
            }

            if (edad > 64) {
                alert ("Debe tener a lo sumo 64 años de edad !!!");
                document.form1. campo.value = "";
                campo.focus ();
                return false;
            }  else if (  edad < 18) {
                alert ("Debe ser mayor a 18 años \n a la fecha de inicio de vigencia !!");
                campo.value = "";
                campo.focus ();
                return false;
            } else {
                return true;
            }
        }
    }
    
    function SendCotizar ()
    {
        

        var url    = "<%= Param.getAplicacion()%>servlet/CotizadorVCServlet?opcion=getCotizacion_Xls";
        var action = url;

        
        $( "#form1" )
                 .attr( "enctype", "multipart/form-data" )
                 .attr( "encoding", "multipart/form-data" )
                 .attr( "action", action).submit();
        return true;

    }

</script>
</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicaciÃ³n.
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

         <h1 class="title-section hcotizadores">cotizador de vida colectivo</h1>

         <!-- tabs -->

         <div class="tabs-container">

        <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">
            <input type="hidden" name="opcion"      id="opcion"     value="cotizador"/>
            <input type="hidden" name="siguiente"   id="siguiente"  value="solapa3"/>
            <input type="hidden" name="origen"      id="origen"     value="solapa2"/>
            <input type="hidden"   name="COD_RAMA"    id="COD_RAMA"   value="<%= oCot.getcodRama() %>"/>
            <input type="hidden"   name="COD_SUB_RAMA" id="COD_SUB_RAMA"    value="<%= oCot.getcodSubRama() %>"/>
            <input type="hidden"   name="COD_PRODUCTO"  id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>
            <input type="hidden"   name="COD_PROVINCIA" id="COD_PROVINCIA" value="<%= oCot.getcodProvincia() %>"/>
            <input type="hidden"   name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="<%= oCot.getcodVigencia() %>"/>
            <input type="hidden"   name="TOMADOR_APE"   id="TOMADOR_APE"   value="<%= oCot.gettomadorApe() %>"/>
            <input type="hidden"   name="COD_PROD"   id="COD_PROD"   value="<%= oCot.getcodProd() %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
            <input type="hidden" name="tipo_nomina" id="tipo_nomina"   value="<%= oProd.gettipoNomina() %>"/>
            <input type="hidden" name="COD_SUB_RAMA_DESC" id="COD_SUB_RAMA_DESC"  value="<%= oCot.getdescSubRama () %>"/>

            <input type="hidden" name="MCA_NOMINA_EXCEL" id="MCA_NOMINA_EXCEL"  value="<%= (oCot.getmcaNominaExcel()==null)?"":oCot.getmcaNominaExcel() %>"/>

            <ul class="tabs">
                <li><span class="step">1</span><a href="#" onclick="Ir ('solapa1');" title="datos generales">Datos Generales</a></li>
                <li class="active"><span class="step">2</span><a href="#" title="datos de asegurados">Datos de Asegurados</a></li>
                <li><span class="step">3</span><a href="#" onclick="Ir ('solapa3');" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>

            <!-- -->
            <div id="tab2" class="tab-content form">
            <div class="form-wrap">

            <h2>Usted puede elegir cotizar de una de estas 2 formas</h2>

            <h3>1) Utilizando nuestro excel para cargar la nomina</h3>

            <p>Si aun no lo bajo puede hacerlo haciendo <a href="#" title="">clic aqui.</a><br />
            Si ya lo tiene puede reutizarlo. Si lo acaba de bajar, grabe el archivo en su disco y copie la nomina en el mismo, luego ingrese el excel con la
            nomina desde aca y presione el boton enviar...
            </p>

            <div class="form-file">
                 <div class="wrap-elements w50">
                     <span class="file-wrapper">
                          <input type="file" name="photo" id="photo" />
                          <span class="file-holder"></span>
                          <span class="button">Elegir Archivo...</span>
                    </span>
                 </div>
                 <input type="button" name="" id="" value="Enviar Archivo" class="bt-form" onclick="SendCotizar();" />

            </div>

            <h3>2) Ingresando los datos necesarios para cotizar por asegurado:</h3>
<%
if (oCot.getmcaNominaExcel()== null || oCot.getmcaNominaExcel().equals("") || !oCot.getmcaNominaExcel().equals("X"))
{

%>
            <div class="form-file"> 
                <div class="wrap-elements w50">
                    <label for="" class="nom-text">Cantidad de asegurados de la n&oacute;mina:</label>
                    <!--
                    <input type="text" name="CANT_PERSONAS" id="CANT_PERSONAS" class="cnomina" value="<%= oCot.getcantPersonas() %>"
                    -->
                    <input type="text" name="CANT_PERSONAS" id="CANT_PERSONAS" class="cnomina" value="<%= oCot.getlNomina().size() %>"
                            maxlength="3"  onKeyPress="return Mascara('D',event);" />
                </div>
            </div>

            <!-- tcomponent -->


        <div class="t-component c<%= (oProd.gettipoNomina().equals ("C1") ? "1" : "2") %>" id="nomina">


<%          if (oProd.gettipoNomina().equals("C1") ) {
%>

            <div class="form-file fhead">
                <div class="wrap-elements w15">
                     <label title="edad" class="txt-left">Edad</label>
                </div>
                <div class="wrap-elements w15">
                	 <label title="cantidad de asegurados" class="txt-left">Antiguedad</label>
                </div>
                 <div class="wrap-elements w30">
                    <label title="sumas asegurada de muerte" class="txt-left">Sueldo bruto mensual</label>
                </div>
                <div class="wrap-elements w15">
                    &nbsp;
                </div>
            </div>
<%          } else {
                if ( oProd.gettipoNomina().equals("C2")) {
%>
            <div class="form-file fhead">
                <div class="wrap-elements w15">
                     <label title="edad" class="txt-left">Edad</label>
                </div>
                <div class="wrap-elements w20">
                	 <label title="cantidad de asegurados" class="txt-left">Cant. de Sueldos</label>
                </div>
                 <div class="wrap-elements w30">
                    <label title="sumas asegurada de muerte" class="txt-left">Sueldo bruto mensual</label>
                </div>
                <div class="wrap-elements w30">
                    &nbsp;
                </div>
            </div>
<%              } else {
%>
            <div class="form-file fhead">
                <div class="wrap-elements w30">
                     <label title="edad" class="txt-left">Edad</label>
                </div>

                 <div class="wrap-elements w30">
                    <label title="sumas asegurada de muerte" class="txt-left">Suma Asegurada</label>
                </div>
                <div class="wrap-elements w30">
                    &nbsp;
                </div>
            </div>

<%             }
           }
%>

<%        for (int i=0; i < oCot.getlNomina().size(); i++) {
                CotizadorNomina oNom = (CotizadorNomina) oCot.getlNomina().get(i);

                if ( oProd.gettipoNomina().equals("C1") ) {
%>
<!-- C1: -->

             <div class="form-file dynamic-content" >
                <div class="wrap-elements w15">
                    <input type="text" name="age_<%= i %>" id="age" value="<%= (oNom.getfechaNac() != null ? Fecha.showFechaForm(oNom.getfechaNac()) : oNom.getedad()) %>"
                           class="quantity vidas" onkeypress="return Mascara('F',event);"
                           onblur="ControlarFechaEdad ( validaEdadFecha (this), this );" />
                </div>
                <div class="wrap-elements w15">
                	 <input type="text" name="ant_<%= i %>" id="ant" value="<%= oNom.getantiguedad() %>"
                                 class="quantity vidas" maxlength="2" onKeyPress="return Mascara('D',event);"/>
                </div>
                 <div class="wrap-elements w30">
                     <input type="text" name="pay_<%= i %>" id="pay" value="<%= Dbl.DbltoStr(oNom.getsueldo() ,2) %>"
                            class="quantity vidas" maxlength="8" onKeyPress="return Mascara('N',event);"/>
                </div>
                <div class="wrap-elements w15">
                     <button type="button" class="bt-addrmv">Remover</button>
                </div>
            </div>
<%               } else {
                    if ( oProd.gettipoNomina().equals("C2") ) {
%>
<!-- C2: -->
            <div class="form-file dynamic-content">
                <div class="wrap-elements w15">
                    <input type="text" name="age_<%= i %>" id="age" value="<%= (oNom.getfechaNac() != null ? Fecha.showFechaForm(oNom.getfechaNac()) : oNom.getedad()) %>"
                           class="quantity vidas"/>
                </div>
                <div class="wrap-elements w20">
                	 <input type="text" name="amo_<%= i %>" id="amo" value="<%= oNom.getcantSueldos() %>"
                                 class="quantity vidas" maxlength="3" onKeyPress="return Mascara('D',event);"/>
                </div>
                 <div class="wrap-elements w30">
                    <input type="text" name="pay_<%= i %>" id="pay" value="<%= Dbl.DbltoStr(oNom.getsueldo() ,2) %>"
                           class="quantity vidas" maxlength="8" onKeyPress="return Mascara('N',event);"/>
                </div>
                <div class="wrap-elements w15">
                     <button type="button" class="bt-addrmv" id="rmvbtn">Remover</button>
                </div>
            </div>
<%               } else {
%>
<!-- C3: -->
           <div class="form-file dynamic-content">
                <div class="wrap-elements w30">
                    <input type="text" name="age_<%= i %>" id="age" value="<%= (oNom.getfechaNac() != null ? Fecha.showFechaForm(oNom.getfechaNac()) : oNom.getedad()) %>"
                           class="quantity vidas"/>
                </div>
                 <div class="wrap-elements w30">
                    <input type="text" name="pay_<%= i %>" id="pay" value="<%= Dbl.DbltoStr(oNom.getsumaAsegMuerte(),2) %>"
                           class="quantity vidas" maxlength="9" onKeyPress="return Mascara('N',event);"/>
                </div>
                <div class="wrap-elements w15">
                     <button type="button" class="bt-addrmv" id="rmvbtn">Remover</button>
                </div>
            </div>
<%                      }
                }
            }
%>

           <!-- add more remove fields -->
<!--	    <div class="file button-file" id="cloneel">
                    <button type="button" class="bt-addrmv" id="addmore" >Agregar Asegurado</button>
            </div>
-->
            <!--! -->


            </div>

            <!-- tcomponent -->

<%


}
else //if (!oCot.getmcaNominaExcel().equals("X"))
{
%>

     <input type="text" name="CANT_PERSONAS" id="CANT_PERSONAS" class="cnomina" value="<%= oCot.getlNomina().size() %>"
                        maxlength="3"  onKeyPress="return Mascara('D',event);" />



<%        for (int i=0; i < oCot.getlNomina().size(); i++) {
                CotizadorNomina oNom = (CotizadorNomina) oCot.getlNomina().get(i);
                //System.out.println(oNom.getedad());
%>
<%             if ( oProd.gettipoNomina().equals("C1") ) { %>

                <input type="hidden" name="age_<%=i%>" id="age"  value="<%=oNom.getedad()%>" />
           	<input type="hidden" name="ant_<%=i %>" id="ant" value="<%= oNom.getantiguedad() %>"/>
                <input type="hidden" name="pay_<%=i %>" id="pay" value="<%= Dbl.DbltoStr(oNom.getsueldo() ,2) %>"/>

<%             } else if ( oProd.gettipoNomina().equals("C2") ) { %>

                <input type="hidden" name="age_<%=i%>"  id="age" value="<%=oNom.getedad()%>" />
                <input type="hidden" name="amo_<%=i %>" id="amo" value="<%= oNom.getcantSueldos() %>"/>
                <input type="hidden" name="pay_<%= i %>" id="pay" value="<%= Dbl.DbltoStr(oNom.getsueldo() ,2) %>"/>

<%             } else if ( oProd.gettipoNomina().equals("C3") ) { %>
            
                <input type="hidden" name="age_<%=i%>" id="age" value="<%=oNom.getedad()%>" />
                <input type="hidden" name="pay_<%=i%>" id="pay" value="<%=oNom.getsumaAsegMuerte()%>" />
            
<%             } %>
<%
          }
%>


    <table id="example" class="display" >
        <thead>
            <tr>
                <!--
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Fecha</th> -->
                <!--th>Error</th-->

<% if ( oProd.gettipoNomina().equals("C1") ) { %>
                <th>Edad</th>
                <th>Antiguedad</th>
                <th>Sueldo bruto mensual</th>

<% } else if ( oProd.gettipoNomina().equals("C2") ) { %>
                <th>Edad</th>
                <th>Cant. de Sueldos</th>
                <th>Sueldo bruto mensual</th>

<% } else if ( oProd.gettipoNomina().equals("C3") ) { %>
                <th>Edad</th>
                <th>Suma Asegrada</th>
<% } %>
            </tr>
         </thead>

       
         <tbody>

<%        for (int i=0; i < oCot.getlNomina().size(); i++) {
                CotizadorNomina oNom = (CotizadorNomina) oCot.getlNomina().get(i);

                System.out.println(oNom.getedad());
%>
<%             if ( oProd.gettipoNomina().equals("C1") ) { %>
            <tr>
                <td><%=oNom.getedad()%></td>
                <td><%=oNom.getantiguedad()%></td>
                <td><%=oNom.getsueldo()%></td>
            </tr>
<%             } else if ( oProd.gettipoNomina().equals("C2") ) { %>

            <tr>
                <td> <%=oNom.getedad()%></td>
                <td> <%= oNom.getcantSueldos() %></td>
                <td> <%= Dbl.DbltoStr(oNom.getsueldo() ,2) %> </td>
            </tr>
<%             } else if ( oProd.gettipoNomina().equals("C3") ) { %>
            <tr>
                <%--
                <td><%=oNom.getnombre()%></td>
                <td><%=oNom.getapellido()%></td>
                <td><%=Fecha.showFechaForm(oNom.getfechaNac())%> --%>
                <td><%=oNom.getedad()%></td>
                <td><%=oNom.getsumaAsegMuerte()%></td>
                <%--
                <td><%=oNom.getsMensErrorXls()%></td> --%>
           </tr>

<%             } %>
<%
          }
%>
        </tbody>
    </table>

<%
} //if (!oCot.getmcaNominaExcel().equals("X"))

%>
            </div><!-- form wrap -->


            </div>
           <!--! tab content .form-->

            <!-- button section -->
            <div class="form-file button-container">
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
                <input type="button" name="COTIZAR" id="COTIZAR"  value="cotizar" class="bt next" onclick="Ir ('solapa3');"/>
            </div>
            <!--! button section -->
        </form>
        </div>

        <!--! tabs -->
    </div>
    <!--! container -->
</div> <!--! wrapper -->
</body>
</html> 