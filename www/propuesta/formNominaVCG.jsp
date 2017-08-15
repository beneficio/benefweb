<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.business.beans.AseguradoPropuesta"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Beneficiario"%> 
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  Usuario usu = (Usuario) session.getAttribute("user");
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;
    int    codRama      = oProp.getCodRama();

    AseguradoPropuesta oTit = new AseguradoPropuesta();
    AseguradoPropuesta oCony = new AseguradoPropuesta();
    LinkedList lHijos = new LinkedList();
    LinkedList lAdher = new LinkedList();
    LinkedList lOtros = new LinkedList();
    
    int iGrupo = 1;
    int cantNomina = 0;
    double totalHijos   = 0;
    double totalAdher   = 0;
    double totalGrupo   = 0;
    int cantHijos       = 0;
    LinkedList <Beneficiario> lBenef =  null; 
    
    if (request.getAttribute("nominas") != null ) {
        LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;
        cantNomina = lNom.size();
        if (lNom.size() > 0 ) {
            for (int i=0; i< lNom.size();i++) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta) lNom.get(i);
                if (oAseg.getSubCertificado() == 0) {
                    lBenef = oAseg.getlBenef();
                }

                iGrupo = oAseg.getCertificado();
                totalGrupo = totalGrupo + oAseg.getimpPremio();
                switch (oAseg.getparentesco())   {
                     case 1 :
                         oTit = oAseg;
                         break;
                     case 2 :
                         oCony = oAseg;
                         break;
                     case 3 :
                        lHijos.add(oAseg);
                        totalHijos = totalHijos + oAseg.getimpPremio();
                        cantHijos += 1;
                         break;
                     case 4 :
                        lAdher.add(oAseg);
                        totalAdher  = totalAdher + oAseg.getimpPremio();
                         break;
                     default :lOtros.add(oAseg) ;
                }
            }
        }
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script language="javascript">
    if(history.forward(1)){
        history.replace(history.forward(1));
    }

        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }
    </script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript">
    var codRama     = <%= codRama %>;
    var codSubRama  = <%=  oProp.getCodSubRama() %>;
    var codProducto = <%=  oProp.getcodProducto() %>;
    var codProd     = <%=  oProp.getCodProd() %>;
    var numPropuesta = <%=  oProp.getNumPropuesta()%>;

    String.prototype.trim =  function() {
                    return (this.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
                }

    function Salir (opcion) {
       if (opcion === 'salir') { 
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
       } else {
           window.location.replace("<%= Param.getAplicacion()%>servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" + numPropuesta );
       }
    }
    
    function ValidarDatos( parentesco ) {
    var prefijo = "";
    var desc = "";
    if (parentesco === '3' && document.getElementById('prop_mca_hijos').value !== "S") {
        alert ("la cobertura seleccionada del titular es SIN HIJOS");
        return false;
    }

    switch( parentesco ){
        case 1: prefijo = 'tit_';
            desc = " titular ";
        break;
    case 2: prefijo = 'cony_';
        desc = " conyuge ";
        break;
    case 3: prefijo = 'hijo_';
        desc = " hijo ";
        break;
    default:
      prefijo = 'adher_';
      desc = " adherente ";
    }
        if ( parentesco === 1 || parentesco === 3 || parentesco === 4 ) {
            if (document.getElementById ( prefijo + 'nom_ApeNom').value === "" ) {
              alert ("Ingrese el Nombre y Apellido " + desc);
              return document.getElementById ( prefijo + 'nom_ApeNom').focus ();
            }
        }
        if (parentesco != 2 || (parentesco == 2 && document.getElementById ( prefijo + 'nom_ApeNom').value != "" )) {
            if (document.getElementById ( prefijo + 'nom_numDoc').value == "") {
              alert ("Documento inválido del " + desc);
              return document.getElementById ( prefijo + 'nom_numDoc').focus();
            }
            if  ( !ControlarDNI (document.getElementById ( prefijo + 'nom_tipDoc'),
                                 document.getElementById ( prefijo + 'nom_numDoc') ) ) {
                alert ("Documento inválido del " + desc);
                return document.getElementById ( prefijo + 'nom_numDoc').focus();
            }
            if ( document.getElementById ( prefijo + 'nom_fechaNac').value === "" ) {
              alert ("Ingrese Fecha Nacimiento del " + desc);
              return document.getElementById ( prefijo + 'nom_fechaNac').focus();
            }
        }
//        if ( !ValidarDoc() ){
//          return false;
//        }
        return true; 

    } 

    function ValidarDoc(){

        var cantNom  = document.formNom.prop_cantNom.value;                      

        for (i=0;i < cantNom ; i++){
            var tipo = document.getElementById('prop_tipoDoc_'+i).value;
            var doc = document.getElementById('prop_numDoc_'+i).value;
            
            if ( tipo === document.formNom.prop_nom_tipDoc.value && 
                 doc  === document.formNom.prop_nom_numDoc.value
               ) {
                   alert( " El documento ingresado ya existe ..."  );
                   return false; 
               }
        }                

        return true;
    }


    function addPersona (parentesco) {

    var prefijo = "";
    var cod_opcion    = oFrameTit.document.getElementById ('cod_cob').value.split("|")[0];
    var cod_agrup_tit = oFrameTit.document.getElementById ('cod_cob').value.split("|")[1];

    switch( parentesco ){
        case 1: prefijo = 'tit_';
        break;
    case 2: prefijo = 'cony_';
        break;
    case 3: prefijo = 'hijo_';
        break;
    default:
      prefijo = 'adher_';
    }

    if (parentesco === 3 ) {
        if (oFrameTit.document.getElementById ('mca_hijos_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }

        if ( ControlarFechaEdad (3, document.getElementById ("hijo_nom_fechaNac"), validaFecha(document.getElementById ("hijo_nom_fechaNac")), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>') === false ) {
            return false;
        }

        if ( document.getElementById ('hijo_mca_discapacitado').checked ) {
            document.getElementById ('hijo_mca_discapacitado').value = 'S';
        } else {
            document.getElementById ('hijo_mca_discapacitado').value = 'N';
        }
    }
    if ( parentesco === 4 ) {
        if (oFrameTit.document.getElementById ('mca_adherente_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_mca_adherente').value = oFrameTit.document.getElementById ('mca_adherente_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }
        if ( ControlarFechaEdad (4, document.getElementById ("adher_nom_fechaNac"), validaFecha(document.getElementById ("adher_nom_fechaNac")), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>') === false ) {
            return false;
        }

        if ( document.getElementById('prop_mca_adherente').value === 'N') {
            alert ("Producto no habilitado para la carga de adherentes ");
            document.getElementById ('adher_nom_ApeNom').value = "";
            document.getElementById ('adher_nom_numDoc').value = "";
            document.getElementById ('adher_nom_fechaNac').value = "";
            return false; 
        }
    }

   document.getElementById ( prefijo + 'nom_numDoc').value ===
       Trim(document.getElementById ( prefijo + 'nom_numDoc').value);
            

        if ( oFrameTit.document.getElementById ('cod_cob').value === "-1" ) {
            alert ("Seleccione una Suma Muerte vàlida para el titular de la pòliza");
            oFrameTit.document.getElementById ('cod_cob').focus ();
            return false;
        }


        document.formNom.prop_add_parentesco.value = parentesco;
       if ( ValidarDatos (parentesco) ) {
            document.formNom.opcion.value="grabarNominaVC";
            document.formNom.submit();   
            return true;
        } 
        return false;
    }

    function Enviar ( sigte ) {
    
        var numTarjeta  = document.getElementById ("num_tarjeta").value;
        var cbu         = document.getElementById ("cbu").value;
        
        if ( sigte === 'enviarVC' ) {
            if (numTarjeta !== "" && ( numTarjeta === '1111111111111111'.substr(0, numTarjeta.length) || 
                                       numTarjeta === '0000000000000000'.substr(0, numTarjeta.length)) ) { 
                alert ("Número de tarjeta inválida: " + numTarjeta)
                return false;
            }

            if (cbu !== "" && ( cbu === '1111111111111111111111'.substr(0, cbu.length) || 
                                cbu === '0000000000000000000000'.substr(0, cbu.length))) { 
                alert ("CBU o cuenta inválida: " + cbu + ". Corregir desde el formulario de carga antes de enviar.");
                return false;
            }
        }

        var cod_opcion    = oFrameTit.document.getElementById ('cod_cob').value.split("|")[0];
        var cod_agrup_tit = oFrameTit.document.getElementById ('cod_cob').value.split("|")[1];

        if (oFrameTit.document.getElementById ('edad_min_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_edad_min').value = oFrameTit.document.getElementById ('edad_min_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }
        if (oFrameTit.document.getElementById ('edad_max_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_edad_max').value = oFrameTit.document.getElementById ('edad_max_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }
        if (oFrameTit.document.getElementById ('edad_permanencia_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_edad_permanencia').value = oFrameTit.document.getElementById ('edad_permanencia_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }
        if (oFrameTit.document.getElementById ('mca_adherente_' + cod_opcion + "|" + cod_agrup_tit) ) {
            document.getElementById('prop_mca_adherente').value = oFrameTit.document.getElementById ('mca_adherente_' +
                                                              + cod_opcion + "|" + cod_agrup_tit ).value;
        }

        document.formNom.siguiente.value = sigte;
        if ( oFrameTit.document.getElementById ('cod_cob').value === "-1" ) {
            alert ("Seleccione una Suma Muerte valida para el titular de la pòliza");
            oFrameTit.document.getElementById ('cod_cob').focus ();
            return false;
        }

        if (document.formNom.siguiente.value === 'enviarVC' &&
            document.getElementById('prop_mca_hijos').value === "S" &&
            document.getElementById ('prop_cant_hijos').value === "0" ) {
            alert ("ATENCION: usted esta enviando la propuesta sin hijos. ");
        }

        if (document.getElementById('prop_mca_hijos').value === "N" &&
            parseInt (document.getElementById ('prop_cant_hijos').value) > 0 ) {
            alert ("El producto no incluye coberturas para hijos ");
            return false;
        }

        if (Trim(document.formNom.hijo_nom_ApeNom.value) !== "") {
            alert ("Usted ha ingresado el nombre de un hijo, por favor, eliminelo o haga clic en el botón 'Agregar Hijo'");
            document.formNom.hijo_nom_ApeNom.focus ();
            return false;
        }

        if (Trim(document.formNom.hijo_nom_numDoc.value) !== "") {
            alert ("Usted ha ingresado el documento de un hijo, por favor, eliminelo o haga clic en el botón 'Agregar Hijo'");
            document.formNom.hijo_nom_numDoc.focus ();
            return false;
        }

        if (Trim(document.formNom.adher_nom_ApeNom.value) !== "") {
            alert ("Usted ha ingresado el nombre de un adherente, por favor, eliminelo o haga clic en el botón 'Agregar Adherente'");
            document.formNom.adher_nom_ApeNom.focus ();
            return false;
        }

        if (Trim(document.formNom.adher_nom_numDoc.value) !== "") {
            alert ("Usted ha ingresado el documento de un adherente, por favor, eliminelo o haga clic en el botón 'Agregar Adherente'");
            document.formNom.adher_nom_numDoc.focus ();
            return false;
        }

        if ( ControlarFechaEdad (1, document.getElementById ("tit_nom_fechaNac"), validaFecha(document.getElementById ("tit_nom_fechaNac")), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>') === false ) {
            return false;
        }

        if ( Trim(document.getElementById ("cony_nom_ApeNom").value) !== ""  ) {
            if ( ControlarFechaEdad (2, document.getElementById ("cony_nom_fechaNac"), validaFecha(document.getElementById ("cony_nom_fechaNac")), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>') === false ) {
                return false;
            }
        }

        if (oFrameUpload) {
            if ( oFrameUpload.document.getElementById ("FILE1").value !== "" && 
                 oFrameUpload.document.getElementById ("FILE1").value !== " Adjunte archivo ") {
                 if (oFrameUpload.document.getElementById ("select_documento").value === "0") {
                    alert ("Seleccione tipo de documento que desea adjuntar ");
                    oFrameUpload.document.getElementById ("select_documento").focus ();
                    return false;
                } else {
                    alert ("Haga clic en Subir archivo  ");
                    oFrameUpload.document.getElementById ("enviarArchivo").focus ();
                    return false;
                }
            }
        }
        
        if (ValidarDatos (1) && ValidarDatos (2) && validarBeneficiarios () ) {
            document.formNom.opcion.value="grabarNominaVC";
            document.formNom.submit();
            OpenEspere ();
            return true;
        }
    }    


    function delPersona (parentesco, subCertificado) {
        document.formNom.prop_del_sub_certificado.value = subCertificado;
        document.formNom.opcion.value="delPersona";
        document.formNom.submit();
    }

    function ControlarFecha (fecha) {
       var edad =  calcular_edad ( fecha, getFechaActual () );

        if ( ! edad || edad < 1) {
            alert ("Fecha de nacimiento incorrecta");
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
         if (document.formNom.prop_nom_fechaNac.value === "" ) {            
           alert ("Fecha de nacimiento incorrecta");
           document.formNom.prop_nom_fechaNac.focus ();
          return false; 
        }

   }

    function ControlarDNI (tipo, dni ) {
       
        if ( tipo.value === '80') {
            if ( ! ValidoCuit ( dni.value.trim() )) {
                return dni.focus ();
            }
        } else {
            if ( dni.value.length < 7) {
                alert ("Documento inválido !");
                return dni.focus ();
            } 
        }

        return true;
    }

    function ControlarFechaEdad (categoria, campo, fecha, desde) {

        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));

        var edadMin = 0;
        var edadMax = 0;
        switch( categoria ) {
            case 1:
                if (isNaN (edad) === false ) {
                    document.getElementById('tit_edad').value = edad;
                }
                edadMin = document.getElementById ('prop_edad_min').value;
                edadMax = document.getElementById ('prop_edad_max').value;
                break;
            case 2:
                if (isNaN (edad) === false ) {
                    document.getElementById('cony_edad').value = edad;
                }                    
                edadMin = document.getElementById ('prop_edad_min_co').value;
                edadMax = document.getElementById ('prop_edad_max_co').value;
                break;
            case 3:
                if (isNaN (edad) === false ) {
                    document.getElementById('hijo_edad').value = edad;                
                }                    
                edadMin = document.getElementById ('prop_edad_min_hi').value;
                edadMax = document.getElementById ('prop_edad_max_hi').value;
                break;
            default:
                if (isNaN (edad) === false ) {
                    document.getElementById('adher_edad').value = edad;                
                }                    
                edadMin = document.getElementById ('prop_edad_min_ad').value;
                edadMax = document.getElementById ('prop_edad_max_ad').value;

        }
        var mcaDisc = document.getElementById ('hijo_mca_discapacitado').checked;

            if ( ! isNaN(edad) && edadMax !== 0 && edadMax !== "" && edad > edadMax  ) {
                if ( categoria !== 3 || ( categoria === 3 &&  mcaDisc === false ))  {
                    alert ("Debe tener a lo sumo " + edadMax + " años de edad !");
                    campo.value = "";
                    campo.focus ();
                    return false;
                }
                
            }  else if ( ! isNaN(edad) && edadMin !== 0 && edadMin !== "" &&  edad < edadMin ) {
                alert ("Debe ser mayor a " + edadMin + " años \n a la fecha de inicio de vigencia !");
                campo.value = "";
                campo.focus ();
                return false;
            }

        if ( categoria === 1 ) {
            if (isNaN (document.getElementById('tit_edad').value) === true ) {
               edad = -1;
            }

           var sUrl3 = "<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp" +
               "?cod_agrup_cob=" + document.formNom.prop_cod_agrup_cob_tit.value +
                "&cod_cob_opcion=" + document.getElementById ('prop_cod_cob_opcion').value + 
                "&cod_rama=" + codRama + "&cod_sub_rama=" + codSubRama +
                "&cod_producto=" + codProducto + "&cod_prod=" + codProd + "&parentesco=TI" + 
                "&edad=" + edad;

            if (oFrameTit ) {
                oFrameTit.location = sUrl3;
            }        
        }
    }

    function ControlarRangoEdad (campo, fecha, desde, edad_min, edad_max ) {

        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));

//        var edad =  calcular_edad (fecha, desde );
        if ( parseInt (edad_min) > 0 && parseInt(edad_max) > 0) {
            if (edad > edad_max) {
                alert ("Debe tener a lo sumo " + edad_max + " años de edad !!!");
                campo.value = "";
                campo.focus ();
                return false;
            }  else if (  edad < edad_min) {
                alert ("Debe ser mayor a 18 años \n a la fecha de inicio de vigencia !!");
                campo.value = "";
                campo.focus ();
                return false;
            } else {
                return true;
            }
        } else {
            return true;
        }
        
    }

    function DoChangeCobTit () {
    var cod_opcion = "0";
    var cod_agrup_tit = "0";
        if ( oFrameTit ) {
            cod_opcion    = oFrameTit.document.getElementById ('cod_cob').value.split("|")[0];
            cod_agrup_tit = oFrameTit.document.getElementById ('cod_cob').value.split("|")[1];

            if (oFrameTit.document.getElementById ('mca_hijos_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('imp_premio_anual_' + cod_opcion + "|" + cod_agrup_tit)) {
                document.getElementById('tit_premio_anual').value   = oFrameTit.document.getElementById ('imp_premio_anual_' +
                                                                       cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_min_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_min').value = oFrameTit.document.getElementById ('edad_min_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_max_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_max').value = oFrameTit.document.getElementById ('edad_max_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_permanencia_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_permanencia').value = oFrameTit.document.getElementById ('edad_permanencia_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_min_hi_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_min_hi').value = oFrameTit.document.getElementById ('edad_min_hi_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_max_hi_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_max_hi').value = oFrameTit.document.getElementById ('edad_max_hi_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_permanencia_hi_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_permanencia_hi').value = oFrameTit.document.getElementById ('edad_permanencia_hi_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_min_ad_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_min_ad').value = oFrameTit.document.getElementById ('edad_min_ad_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_max_ad_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_max_ad').value = oFrameTit.document.getElementById ('edad_max_ad_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('edad_permanencia_ad_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_edad_permanencia_ad').value = oFrameTit.document.getElementById ('edad_permanencia_ad_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }

            if (oFrameTit.document.getElementById ('mca_adherente_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_mca_adherente').value = oFrameTit.document.getElementById ('mca_adherente_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }

        }

       document.getElementById('prop_cod_cob_opcion').value = cod_opcion;
       document.getElementById('prop_cod_agrup_cob_tit').value = cod_agrup_tit;
       
       var edad = -1;
       if (isNaN (document.getElementById('tit_edad').value) === false ) {
           edad = document.getElementById('tit_edad').value;
       }
       
       var sUrl3 = "<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp" +
           "?cod_agrup_cob=" + document.formNom.prop_cod_agrup_cob_cony.value +
            "&cod_cob_opcion=" + cod_opcion + "&cod_rama=" + codRama + "&cod_sub_rama=" + codSubRama +
            "&cod_producto=" + codProducto + "&cod_prod=" + codProd + "&parentesco=CO" + 
            "&edad=" + edad;
        
        if (oFrameCon ) {
            oFrameCon.location = sUrl3;
        }
    }

    function DoChangeCobCony () {
    var cod_agrup_cony = "0";

        if ( oFrameCon ) {
            if (oFrameCon.document.getElementById ('cod_cob')){
                cod_agrup_cony = oFrameCon.document.getElementById ('cod_cob').value.split("|")[1];
            }

            var cod_opcion = document.getElementById('prop_cod_cob_opcion').value;

            if (oFrameCon.document.getElementById ('imp_premio_anual_' + oFrameCon.document.getElementById ('cod_cob').value)){
                document.getElementById('cony_premio_anual').value = oFrameCon.document.getElementById ('imp_premio_anual_' +
                                                                 oFrameCon.document.getElementById ('cod_cob').value).value;
            }
            if (oFrameCon.document.getElementById ('edad_min_' + cod_opcion + "|" + cod_agrup_cony) ) {
                document.getElementById('prop_edad_min_co').value = oFrameCon.document.getElementById ('edad_min_' +
                                                                  + cod_opcion + "|" + cod_agrup_cony ).value;
            }
            if (oFrameCon.document.getElementById ('edad_max_' + cod_opcion + "|" + cod_agrup_cony) ) {
                document.getElementById('prop_edad_max_co').value = oFrameCon.document.getElementById ('edad_max_' +
                                                                  + cod_opcion + "|" + cod_agrup_cony ).value;
            }
            if (oFrameCon.document.getElementById ('edad_permanencia_' + cod_opcion + "|" + cod_agrup_cony) ) {
                document.getElementById('prop_edad_permanencia_co').value = oFrameCon.document.getElementById ('edad_permanencia_' +
                                                                  + cod_opcion + "|" + cod_agrup_cony ).value;
            }

        }
        if (document.getElementById('prop_cod_agrup_cob_cony')) {
           document.getElementById('prop_cod_agrup_cob_cony').value = cod_agrup_cony;
        }
    }

function ActualizarPorcentaje () {
    
    var totalBenef = 0;
    for (var i=0; i < 4;i++) {
        var porcBenef = parseFloat ( document.getElementById ( 'benef_porcentaje_' + i ).value );

        if ( isNaN (porcBenef) ) porcBenef = 0;
        
        totalBenef += porcBenef;
        
    }

    document.getElementById ("benef_porcentaje_total").value = totalBenef;
    
    if (totalBenef > 100) {
        alert ("La suma de los porcentajes de todos los beneficiarios supera el 100%");
        document.getElementById ( 'benef_porcentaje_0' ).focus();
        return false;
    } else {
        document.getElementById ('benef_porcentaje_total').value = totalBenef;
        return true;
    }
  }
    
function validarBeneficiarios () {

    
    if (document.getElementById('prop_benef_herederos').value === 'S' || 
        document.getElementById('prop_benef_tomador').value === 'S' ) {   
        return true;
    }
    
    if ( Trim(document.getElementById ( 'benef_nombre_0').value) === '' &&
         Trim(document.getElementById ( 'benef_nombre_1').value) === '' &&
         Trim(document.getElementById ( 'benef_nombre_2').value) === '' &&
         Trim(document.getElementById ( 'benef_nombre_3').value) === '' ) {
        alert ("debe ingresar al menos un beneficiario, sino haga clic en Modificar datos y seleccione Herederos Legales");
        document.getElementById ( 'benef_nombre_1').focus();
        return false;
    }

    var noExisteParent = false;
    var cantConyuge    = 0;
    var saltoCelda     = false;
    var dniVacio       = false;
    var porcVacio      = false;
    var totalBenef     = 0;
    
    var i = 0;
    for ( i=0; i < 4;i++) {
        var nombre = "";
        if (document.getElementById ( 'benef_nombre_'   + (i + 1) )) {
            nombre    = Trim (document.getElementById ( 'benef_nombre_' + (i + 1) ).value );
        }
        var nombreAnt = Trim (document.getElementById ( 'benef_nombre_' + i ).value );

        if (nombre !== "" && nombreAnt === "") { 
            saltoCelda = true;
            break;
        }
        
        if ( nombreAnt !== "") { 
            var parentesco = document.getElementById ( 'benef_parentesco_' + i ).value;
            if (parentesco === "0") {
                noExisteParent = true;
                break;
            } else {
                if (parentesco === "2") {
                    cantConyuge += 1;
                    if (cantConyuge === 2) {
                        break;
                    }
                }
            }

            var dni = Trim(document.getElementById ( 'benef_num_doc_' + i ).value);
            if (dni === "0" || dni === "" ) {
                dniVacio = true;
                break;
            }

            var porcBenef = parseFloat ( document.getElementById ( 'benef_porcentaje_' + i ).value );
            if ( isNaN (porcBenef) ) { 
                porcBenef = 0;
            }            
            if (porcBenef === 0) {
                porcVacio = true;
            } else {
                totalBenef += porcBenef;
            }
                
        }
        
    }

    if ( saltoCelda === true ) {
        alert ("No debe dejar celdas intermedias de Beneficiarios vacias, complete de arriba hacia abajo");
        document.getElementById ( 'benef_nombre_' + i ).focus();
        return false;
    }
    if ( dniVacio === true ) {
        alert ("Ingrese DNI ");
        document.getElementById ( 'benef_num_doc_' + i ).focus();
        return false;
    }
    if ( noExisteParent === true ) {
        alert ("Seleccione parentesco ");
        document.getElementById ( 'benef_parentesco_' + i ).focus();
        return false;
    }
    if (cantConyuge === 2 ) {
        alert ("No puede haber conyuge repetido");
        document.getElementById ( 'benef_parentesco_' + i ).focus();
        return false;
    }
    if ( porcVacio === true ) {
        alert ("Ingrese Porcentaje ");
        document.getElementById ( 'benef_porcentaje_' + i ).focus();
        return false;
    }
    if (totalBenef !== 100) {
        alert ("La suma de los porcentajes de Beneficiarios debería ser 100% ");
        document.getElementById ( 'benef_porcentaje_' + i ).focus();
        return false;
    }
    return true;
}

</script>
<body  onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);">
    <table id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
        <td align="center" valign="top" width='100%'>
            <table border='0' width='100%'  class="fondoForm" >
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNom' id='formNom'>
                <input type="hidden" name="opcion"         id="opcion"          value=''/>
                <input type="hidden" name="siguiente"      id="siguiente"       value='formNominaVCG'/>
                <input type="hidden" name="prop_cantVidas" id="prop_cantVidas"  value="<%=cantVidas%>"/>
                <input type="hidden" name="prop_del_orden" id="prop_del_orden"  value="<%= iGrupo %>"/>
                <input type="hidden" name="prop_del_sub_certificado" id="prop_del_sub_certificado"  value=""/>
                <input type="hidden" name="prop_rama"      id="prop_rama"       value="<%=codRama%>"/>
                <input type="hidden" name="prop_grupo"     id="prop_grupo"      value="<%= iGrupo %>"/>
                <input type="hidden" name="prop_tipo_nomina"    id="prop_tipo_nomina"    value="<%= oProp.gettipoNomina() %>"/>
                <input type="hidden" name="prop_add_parentesco" id="prop_add_parentesco" value="99"/>
                <input type="hidden" name="volver"              id="volver"
                       value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" />
                <input type="hidden" name="prop_cod_cob_opcion" id="prop_cod_cob_opcion" value="<%= oTit.getcodCobOpcion() %>"/>
                <input type="hidden" name="prop_cod_agrup_cob_cony" id="prop_cod_agrup_cob_cony" value="<%= oCony.getcodAgrupCob() %>"/>
                <input type="hidden" name="prop_cod_agrup_cob_tit" id="prop_cod_agrup_cob_tit" value="<%= oTit.getcodAgrupCob() %>"/>
                <input type="hidden" name="prop_mca_hijos" id="prop_mca_hijos" value=""/>
                <input type="hidden" name="prop_numero" id="prop_numero" value="<%=numPropuesta%>"/>
                <input type="hidden" name="prop_cant_hijos" id="prop_cant_hijos" value="<%= cantHijos %>"/>
                <input type="hidden" name="prop_edad_min" id="prop_edad_min" value=""/>                
                <input type="hidden" name="prop_edad_max" id="prop_edad_max" value=""/>                
                <input type="hidden" name="prop_edad_permanencia" id="prop_edad_permanencia" value=""/>
                <input type="hidden" name="prop_edad_min_co" id="prop_edad_min_co" value=""/>
                <input type="hidden" name="prop_edad_max_co" id="prop_edad_max_co" value=""/>
                <input type="hidden" name="prop_edad_permanencia_co" id="prop_edad_permanencia_co" value=""/>
                <input type="hidden" name="prop_edad_min_hi" id="prop_edad_min_hi" value=""/>
                <input type="hidden" name="prop_edad_max_hi" id="prop_edad_max_hi" value=""/>
                <input type="hidden" name="prop_edad_permanencia_hi" id="prop_edad_permanencia_hi" value=""/>
                <input type="hidden" name="prop_edad_min_ad" id="prop_edad_min_ad" value=""/>
                <input type="hidden" name="prop_edad_max_ad" id="prop_edad_max_ad" value=""/>
                <input type="hidden" name="prop_edad_permanencia_ad" id="prop_edad_permanencia_ad" value=""/>
                <input type="hidden" name="prop_fecha_ini_vig" id="prop_fecha_ini_vig"
                       value="<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>"/>
                <input type="hidden" name="prop_mca_adherente" id="prop_mca_adherente" value=""/>
                <input type="hidden" name="num_tarjeta"    id="num_tarjeta"    value="<%= (oProp.getNumTarjCred() == null ? "" : oProp.getNumTarjCred()) %>"  />                
                <input type="hidden" name="cbu"            id="cbu"    value="<%= (oProp.getCbu() == null ? "" : oProp.getCbu()) %>"  />                
                <input type="hidden" name="prop_benef_herederos" id="prop_benef_herederos" value="<%= oProp.getbenefHerederos() %>"  />                
                <input type="hidden" name="prop_benef_tomador" id="prop_benef_tomador" value="<%= oProp.getbenefTomador() %>"  />                                
                 
                <tr>
                    <td>
                        <table border='0' align="center" width='100%'>
                            <tr>
                                <td valign="middle" align="center" class='titulo' colspan="2" height="25">Alta de n&oacute;mina de <%= oProp.getDescRama() %>&nbsp;-&nbsp;<%= oProp.getDescSubRama() %></td>
                            </tr>
                            <tr>
                                <td align="left" class='subtitulo' valign="middle" height="25">Propuesta Nº:&nbsp;<%=numPropuesta%></td>
                                <td valign="middle" align="right" class='subtitulo'>Grupo:&nbsp;<%= iGrupo %></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="30">Titular:</td>
                </tr>
                <tr>
                    <td>
                        <table  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody">
                            <thead>
                                <th>Apellido y nombre</th>
                                <th nowrap>Documento</th>
                                <th>Fecha Nac.</th>
                                <th>Edad</th>
                                <th width="60">Premio<br/>Anual</th>
                                <th width="260px" nowrap>Suma Muerte</th>
                            </thead>
                            <tr>
                                <td><input type='TEXT' id='tit_nom_ApeNom' name='tit_nom_ApeNom' value="<%=(oTit.getNombre() == null ? "" : oTit.getNombre())%>"
                                           style="width:180px;" class="text"/>
                                </td>
                                <td nowrap><select id='tit_nom_tipDoc' name='tit_nom_tipDoc' style="WIDTH:50px"  class="select">
                                        <option value="96" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("96") ? "selected" : "")%>>DNI</option>
                                        <option value="80" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("80") ? "selected" : "")%>>CUIL</option>
                                        <option value="90" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("90") ? "selected" : "")%>>LC</option>
                                        <option value="94" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("94") ? "selected" : "")%>>PAS</option>
                                    </select>
                                        &nbsp;
                                        <input type='TEXT' id="tit_nom_numDoc" name="tit_nom_numDoc" value="<%= (oTit.getNumDoc() == null ? "" : oTit.getNumDoc())%>"
                                           size='13' maxlength='11'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI (document.formNom.tit_nom_tipDoc, this);"/>
                                </td>
                                <td><input type="text" id="tit_nom_fechaNac" name="tit_nom_fechaNac" style="WIDTH:70px;" value="<%= oTit.getFechaNac() == null ? "":Fecha.showFechaForm(oTit.getFechaNac()) %>"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad (1, this, validaFecha(this), document.getElementById ('prop_fecha_ini_vig').value );"
                                            onkeypress="return Mascara('F',event);" class="text"/>
                                </td>
                                <td><input type="text" id="tit_edad" name="tit_edad"  value="<%= oTit.getFechaNac() == null ? "" :Fecha.calcularEdad(oTit.getFechaNac()) %>"
                                            size="3"  maxlength='2' readonly class="inputTextNumeric"/>
                                </td>
                                <td><input type='text' id="tit_premio_anual" name="tit_premio_anual" size='8' class="text" readonly value="<%= Dbl.DbltoStr(oTit.getimpPremio(),2) %>"/></td>
                                <td>
                                    <iframe  name="oFrameTit" id="oFrameTit" style="height: 30px;width: 260px;"  marginheight="0"
                                             marginwidth="0" align="top"  frameborder="0"  scrolling="no"
                                             src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp?cod_agrup_cob=<%= oTit.getcodAgrupCob() %>&cod_cob_opcion=<%= oTit.getcodCobOpcion() %>&cod_rama=<%=oProp.getCodRama()%>&cod_sub_rama=<%=oProp.getCodSubRama()%>&cod_producto=<%=oProp.getcodProducto()%>&cod_prod=<%= oProp.getCodProd()%>&parentesco=TI&edad=<%=( oTit.getFechaNac() == null ? -1 : Fecha.calcularEdad(oTit.getFechaNac()) ) %>" > 
                                    </iframe>
                                </td>
                            </tr>
<%                      if (oProp.getbenefHerederos().equals("N") && oProp.getbenefTomador().equals("N") ) {
    %>
                            <tr>
                                <td align="left" valign="middle" height="30" width="100%" colspan="6">
                                    <span class="subtitulo">
                                        Ingrese los Beneficiarios en caso de fallecimiento del titular:
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <table border="0" cellpadding="0" cellspacing="2" align="left">
                                        <thead>
                                            <th nowrap>Documento</th>
                                            <th width="140px">Nombre</th>
                                            <th nowrap>Parentesco</th>
                                            <th nowrap align="left">Porcentaje</th>                                          
                                        </thead>
<%                                  int indice = 0;
                                    double totalBenef = 0; 
                                    if (lBenef != null) {
                                        for (indice=0; indice< lBenef.size();indice++) {
                                            Beneficiario oBenef = (Beneficiario) lBenef.get(indice);
                                            totalBenef += oBenef.getporcentaje();
    %>
                                        <tr>
                                            <td><input type="text" id="benef_num_doc_<%= indice %>" name="benef_num_doc_<%= indice %>" value="<%= oBenef.getnumDoc() %>"
                                           size='12' maxlength='9'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI ('96'  , this);"/>
                                            </td>
                                            <td><input type="text" id="benef_nombre_<%= indice %>" name="benef_nombre_<%= indice %>" value="<%= oBenef.getrazonSocial() %>" size='40' maxlength='30'/>
                                            </td>
                                            <td><select id="benef_parentesco_<%= indice %>" name="benef_parentesco_<%= indice %>" style="WIDTH:80px;"  class="select">
                                                    <option value="0" >Seleccione</option>                                                    
                                                    <option value="2" <%= (oBenef.getparentesco() == 2 ? "selected" : "") %>>Conyuge</option>
                                                    <option value="3" <%= (oBenef.getparentesco() == 3 ? "selected" : "") %>>Hijo</option>
                                                    <option value="4" <%= (oBenef.getparentesco() == 4 ? "selected" : "") %>>Adherente</option>
                                                    <option value="6" <%= (oBenef.getparentesco() == 6 ? "selected" : "") %>>Otros</option>                                                    
                                                </select>&nbsp;
                                            </td>
                                            <td align="left">&nbsp;<input type="text" id="benef_porcentaje_<%= indice %>" name="benef_porcentaje_<%= indice %>" value="<%= Dbl.DbltoStr(oBenef.getporcentaje(),0) %>"
                                           size='6' maxlength='3'  onkeypress="return Mascara('D',event);" class="inputTextNumeric" 
                                           onchange="javascript:ActualizarPorcentaje ();" />&nbsp;%
                                            </td>
                                        </tr>
<%                                      }         
                                    }

                                    for (int indice2=indice; indice2< 4;indice2++) {

    %>
                                        <tr>
                                            <td><input type="text" id="benef_num_doc_<%= indice2 %>" name="benef_num_doc_<%= indice2 %>" value=""
                                           size='12' maxlength='9'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI ('96'  , this);"/>
                                            </td>
                                            <td><input type="text" id="benef_nombre_<%= indice2 %>" name="benef_nombre_<%= indice2 %>" value="" size='40' maxlength='30'/>
                                            </td>
                                            <td><select id="benef_parentesco_<%= indice2 %>" name="benef_parentesco_<%= indice2 %>" style="WIDTH:80px;"  class="select">
                                                    <option value="0">Seleccione</option>
                                                    <option value="2">Conyuge</option>
                                                    <option value="3">Hijo</option>
                                                    <option value="4">Adherente</option>
                                                    <option value="6">Otros</option>                                                    
                                                </select>&nbsp;
                                            </td>
                                            <td align="left">&nbsp;<input type="text" id="benef_porcentaje_<%= indice2 %>" name="benef_porcentaje_<%= indice2 %>" value="0"
                                                                          size='6' maxlength='3'  onkeypress="return Mascara('D',event);" class="inputTextNumeric" 
                                                                          onchange="javascript:ActualizarPorcentaje ();" />&nbsp;%
                                            </td>
                                        </tr>
    
<%                                  }
    %>
                                        <tr>
                                            <td align="right" class="subtitulo" colspan="3">Total:</td>
                                            <td align="left">&nbsp;<input type="text" id="benef_porcentaje_total" name="benef_porcentaje_total" value="<%= Dbl.DbltoStr(totalBenef,0) %>"
                                                                          size='6' maxlength='3'  onkeypress="return Mascara('D',event);" class="inputTextNumeric" readonly />&nbsp;%
                                            </td>
                                        </tr>
    
                                    </table>
                                </td>
                            </tr>
                                            
<%                      } else if ( oProp.getbenefHerederos().equals("S")) { 
    %>
                            <tr>
                                <td align="left" valign="middle" height="30" width="100%" colspan="6">
                                    <span class="subtitulo">
                                        Si quiere ingresar beneficiarios en caso de fallecimiento, haga clic en Modificar datos y seleccione Designaci&oacute;n de Beneficios
                                    </span>
                                </td>
                            </tr>
<%                          }                               
    %>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="30">Conyuge: (si no tiene conyuge deje el campo "Apellido y nombre" en blanco)</td>
                </tr>
                <tr>
                    <td>
                        <table  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody">
                            <thead>
                                <th>Apellido y nombre</th>
                                <th nowrap>Documento</th>
                                <th>Fecha Nac.</th>
                                <th>Edad</th>
                                <th width="60">Premio<br/>Anual</th>
                                <th width="260px" nowrap>Suma Muerte</th>
                            </thead>
                            <tr>
                                <td><input type="hidden" id='cony_nom_orden' name='cony_nom_orden' value='<%=(oCony.getSubCertificado() == 0 ? 1 :oCony.getSubCertificado()) %>' />
                                    <input id='cony_nom_ApeNom' name='cony_nom_ApeNom' type='TEXT' value="<%=(oCony.getNombre() == null ? "" : oCony.getNombre())%>"
                                           style="WIDTH: 180px;" class="text"/>
                                </td>
                                <td nowrap><select id='cony_nom_tipDoc' name='cony_nom_tipDoc' style="WIDTH:50px"  class="select">
                                        <option value="96" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("96") ? "selected" : "")%>>DNI</option>
                                        <option value="80" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("80") ? "selected" : "")%>>CUIL</option>
                                        <option value="90" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("90") ? "selected" : "")%>>LC</option>
                                        <option value="94" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("94") ? "selected" : "")%>>PAS</option>
                                    </select>&nbsp;
                                    <input type='TEXT' id="cony_nom_numDoc" name="cony_nom_numDoc"  value="<%= (oCony.getNumDoc() == null ? "" : oCony.getNumDoc())%>"
                                           size='13' maxlength='11'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI (document.formNom.cony_nom_tipDoc, this);"/>
                                </td>
                                <td><input type="text" id="cony_nom_fechaNac" name="cony_nom_fechaNac" style="WIDTH:70px;" value="<%= oCony.getFechaNac() == null ? "":Fecha.showFechaForm(oCony.getFechaNac()) %>"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad ( 2, this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                            onkeypress="return Mascara('F',event);"  class="text"/>
                                </td>
                                <td><input type="text" id="cony_edad" name="cony_edad"  value="<%=  oCony.getFechaNac() == null ? "" :Fecha.calcularEdad( oCony.getFechaNac()) %>"
                                            size="3"  maxlength='2' readonly class="inputTextNumeric"/>
                                </td>
                                <td  width="60"><input type='TEXT' id="cony_premio_anual" name="cony_premio_anual" size='8'  class="text"
                                           readonly value="<%= Dbl.DbltoStr(oCony.getimpPremio(),2) %>"/></td>
                                <td valign="middle">
                                    <iframe  name="oFrameCon" id="oFrameCon" style="height: 30px;width: 260px;" marginheight="0"
                                             marginwidth="0" align="top"  frameborder="0"  scrolling="no"
    src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp?cod_agrup_cob=<%= oCony.getcodAgrupCob() %>&cod_cob_opcion=<%= oCony.getcodCobOpcion() %>&cod_rama=<%=oProp.getCodRama()%>&cod_sub_rama=<%=oProp.getCodSubRama()%>&cod_producto=<%=oProp.getcodProducto()%>&cod_prod=<%= oProp.getCodProd()%>&parentesco=CO">
                                    </iframe>
                                </td>
                                <td><input type='button' value='Eliminar' class="boton" onClick="delPersona( 2, <%=oCony.getSubCertificado() %>);"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="30">Hijos: (por cada hijo que desea incorporar haga clic en el botón "Agregar hijo")</td>
                </tr>
                <tr>
                    <td>
                        <table  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody">
<%
        if (lHijos.size() > 0 ) {
                      int orden = 0;
                        for( int i=0; i < lHijos.size(); ++i) {
                            AseguradoPropuesta oAseg = (AseguradoPropuesta)lHijos.get(i);
                            orden              = oAseg.getSubCertificado();
                            String tipoDoc     = oAseg.getTipoDoc();
                            String descTipoDoc = oAseg.getDescTipoDoc();
                            String numDoc      = oAseg.getNumDoc();
                            String nombre      = oAseg.getNombre();
                            String fechaNac    = (oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()));
                            int edad           = (oAseg.getFechaNac() == null ? 0 : Fecha.calcularEdad (oAseg.getFechaNac()));
                            String sMcaDisc    = (oAseg.getsMcaDiscapacitado() == null ? "N" : oAseg.getsMcaDiscapacitado() );

%>
                            <tr>
                                <input type="hidden" id="hijo_nom_orden_<%=orden%>" name="hijo_nom_orden_<%=orden%>" value="<%=orden%>"/>
                                <td align='left'>&nbsp;<%=nombre%></td>
                                <td align='center' nowrap>&nbsp;<%=descTipoDoc%>&nbsp;<%=numDoc%>&nbsp;</td>
                                <td align='right'><%=fechaNac%>&nbsp;</td>
                                <td align='right'><%= edad %>&nbsp;</td>
                                <td  width="60"><input type='TEXT' id="hijo_premio_anual" name="hijo_premio_anual" size='8' class="inputTextNumeric" readonly value="<%= Dbl.DbltoStr(oAseg.getimpPremio(),2) %>"/></td>
                                <td><input type='BUTTON' value='Eliminar' class="boton" style="width:130px; " onClick="delPersona(3, <%=orden%>);"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" align="left"  class="text">
                                    <input type="checkbox" id="hijo_mca_discapacitado_<%=orden%>" name="hijo_mca_discapacitado_<%=orden%>"
                                           <%= (sMcaDisc.equals ("S") ? "checked" : "") %>  readonly />&nbsp;
                                     discapacitado
                                </td>
                            </tr>

<%
                        }
          }
%>
                            <tr>
                                <td><input id='hijo_nom_ApeNom' name='hijo_nom_ApeNom' type='TEXT' value="" style="WIDTH: 180px;"  class="text"/>
                                </td>
                                <td nowrap><select id='hijo_nom_tipDoc' name='hijo_nom_tipDoc' style="WIDTH:50px" class="select">
                                        <option value="96">DNI</option>
                                        <option value="80">CUIL</option>
                                        <option value="90">LC</option>
                                        <option value="94">PAS</option>
                                    </select>&nbsp;
                                    <input type='TEXT' id="hijo_nom_numDoc" name="hijo_nom_numDoc"
                                           size='13' maxlength='11'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI (document.formNom.hijo_nom_tipDoc, this);"/>
                                </td>
                                <td><input type="text" id="hijo_nom_fechaNac" name="hijo_nom_fechaNac" style="WIDTH:70px;"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad (3, this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                            onkeypress="return Mascara('F',event);"  class="text"/>
                                </td>
                                <td><input type="text" id="hijo_edad" name="hijo_edad" value=""  size="3"  maxlength='2' readonly class="inputTextNumeric"/></td>
                                <td  width="60">&nbsp;</td>
                                <td><input type='BUTTON'  name="cmdHijo"  value='Agregar  hijo' class="boton" style="width:130px;" onClick="addPersona ( 3 );"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" align="left"  class="text">
                                    <input type="checkbox" id="hijo_mca_discapacitado" name="hijo_mca_discapacitado" value="N" />&nbsp;
                                    Tildar si es discapacitado para que no valide edad m&aacute;xima
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="30">Adherentes:(por cada adherente que desea incorporar haga clic en el botón "Agregar adherente")</td>
                </tr>
                <tr>
                    <td>
                        <table  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody">
<%        if ( lAdher.size() > 0 ) {
                 int orden2 = 0;
                    for( int i=0; i < lAdher.size(); ++i) {
                        AseguradoPropuesta oAseg = (AseguradoPropuesta)lAdher.get(i);
                        orden2       = oAseg.getSubCertificado();
                        String tipoDoc     = oAseg.getTipoDoc();
                        String descTipoDoc = oAseg.getDescTipoDoc();
                        String numDoc      = oAseg.getNumDoc();
                        String nombre      = oAseg.getNombre();
                        int edad           = (oAseg.getFechaNac() == null ? 0 : Fecha.calcularEdad (oAseg.getFechaNac()));
                        String fechaNac    = (oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()));
%>
                            <tr>
                                <input type="hidden" id='adher_nom_orden_<%=orden2%>' name='adher_nom_orden_<%=orden2%>' value='<%=orden2%>' />
                                <td align='left'>&nbsp;<%=nombre%></td>
                                <td align='center' nowrap>&nbsp;<%=descTipoDoc%>&nbsp;<%=numDoc%>&nbsp;</td>
                                <td align='right'><%= fechaNac %>&nbsp;</td>
                                <td align='right'><%= edad %>&nbsp;</td>
                                <td  width="60"><input type='TEXT' id="adher_premio_anual" name="adher_premio_anual" size='8' class="inputTextNumeric"
                                           readonly value="<%= Dbl.DbltoStr(oAseg.getimpPremio(),2) %>"/></td>
                                <td><input type='BUTTON' value='Eliminar' class="boton"  style="width:130px; " onClick="delPersona (4, <%=orden2%>);"/></td>
                            </tr>
<%                  }
                 }
%>
                            <tr>
                                <td><input id='adher_nom_ApeNom' name='adher_nom_ApeNom' type='TEXT' value="" style="WIDTH: 180px;"  class="text"/>
                                </td>
                                <td nowrap><select id='adher_nom_tipDoc' name='adher_nom_tipDoc' style="WIDTH:50px" class="select">
                                        <option value="96">DNI</option>
                                        <option value="80">CUIL</option>
                                        <option value="90">LC</option>
                                        <option value="94">PAS</option>
                                    </select>&nbsp;
                                    <input type='TEXT' id="adher_nom_numDoc" name="adher_nom_numDoc"
                                           size='10' maxlength='11'  onkeypress="return Mascara('D',event);"  class="text"
                                            onchange="ControlarDNI (document.formNom.adher_nom_tipDoc, this);"/>
                                </td>
                                <td><input type="text" id="adher_nom_fechaNac" name="adher_nom_fechaNac" style="WIDTH:70px;"  class="text"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad (4, this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                            onkeypress="return Mascara('F',event);"/>
                                </td>
                               <td><input type="text" id="adher_edad" name="adher_edad" value=""  size="3"  maxlength='2' readonly class="inputTextNumeric"/></td>
                                <td width="60">&nbsp;</td>
                                <td><input type='BUTTON' value='Agregar Adherente'  class="boton" style="width:130px; " onClick="addPersona(4);"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="30">Adjunte  documentaci&oacute;n desde aqui:</td>
                </tr>
                <tr>
                    <td>
                        <iframe  name="oFrameUpload" id="oFrameUpload"  style="width: 750px;height: 120px;" marginwidth="0" marginheight="0" 
                                 align="top" frameborder="0"  scrolling="yes"
                                 src="<%= Param.getAplicacion()%>propuesta/rs/formUpload.jsp?num_propuesta=<%=numPropuesta%>&tipo_documento=0&certificado=1&sub_certificado=0">
                        </iframe>
                    </td>
                </tr>                              
                <tr>
                    <td class='subtitulo' align="left" valign="middle" height="20">Total Premio anual del grupo:</td>
                </tr>
                <tr>
                    <td>
                        <table border="0" align="left" cellpadding="3" cellspacing="3">
                            <tr>
                                <td class="text" align="left" width="140">Titular:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80">
                                    <input type="text" name="total_tit" id="total_tit" value="<%= Dbl.DbltoStr( oTit.getimpPremio() ,2) %>" 
                                           size="10" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Conyuge</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80">
                                    <input type="text" name="total_cony" id="total_cony" value="<%= Dbl.DbltoStr(oCony.getimpPremio(),2) %>" 
                                           size="10" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Hijos:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80">
                                    <input type="text" name="total_hijos" id="total_hijos" value="<%= Dbl.DbltoStr(totalHijos,2) %>" 
                                           size="10" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Adherentes:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80">
                                    <input type="text" name="total_adher" id="total_adher" value="<%= Dbl.DbltoStr(totalAdher,2) %>" 
                                           size="10" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td class="subtitulo" align="right">TOTAL PREMIO ANUAL</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80">
                                    <input type="text" name="total_grupo" id="total_grupo" value="<%= Dbl.DbltoStr(totalGrupo,2) %>" 
                                           size="10" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <input type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNomina%>"  />
                <tr valign="bottom" >
                    <td width="100%" align="center">
                        <input type="button" name="cmdModif"  value="Modificar Datos"  height="20px" class="boton" onClick="Enviar ('modificarVC');"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ('salir');"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar"  value="Grabar y calcular Premio"  height="20px" class="boton" onClick="Enviar('grabarVC');"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdEnviar"  value="Enviar Propuesta"    height="20px" class="boton" onClick="Enviar('enviarVC');"/>
                    </td>
                </tr>
               </form>
            </table>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
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
<div id="ventanita" style="display:none;position:absolute;top:80%;left :50%;width:600px;height:100%;margin-top: -30px;margin-left: -300px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                        Espere por favor que se esta procesando la opraci&oacute;n solicitada...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
//document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
//                                                  oFrameTit.document.getElementById ('cod_cob').value).value;
CloseEspere();
</script>
</body>
</html>
