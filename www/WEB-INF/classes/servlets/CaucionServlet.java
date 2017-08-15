/*
 * PropuestaServlet.java
 *
 * Created on 28 de mayo de 2006, 19:57
 */  
  
package servlets;
import java.io.IOException;
import java.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
import javax.servlet.*;
import javax.servlet.http.*;
/**
 *
 * @author  Usuario
 * @version
 */
public class CaucionServlet extends HttpServlet {
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
    }

    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }

            String op =  request.getParameter("opcion");                     
            
            if (op.equals("verificarTomador"))    {
                verificarTomador (request, response);            
            } else if (op.equals("grabarPropuesta") || op.equals("CalcularPremio")) {
                grabarPropuesta(request, response);            
            }  else if (op.equals("enviarPropuesta")) {
                enviarPropuesta(request, response);                                            
            } else if (op.equals("getPropuestaBenef") ) {
                getPropuestaBenef(request, response);
            } else if (op.equals("printCaucion") ) {
                getPrintPropuesta(request, response);
            }  else if (op.equals("cambiarEstado") ) {
                setCambiarEstado (request, response);
            }


        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void setCambiarEstado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        Propuesta oProp = new Propuesta();
        try {

            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int  nroProp    = Integer.valueOf( request.getParameter("F2num_propuesta") == null
                                           ? "0" : request.getParameter("F2num_propuesta") );
            int  numPoliza  = Integer.valueOf( request.getParameter("F2num_poliza") == null
                                           ? "0" : request.getParameter("F2num_poliza") );

            if (oUser.getiCodTipoUsuario() == 0 && oUser.getmenu() == 4) {
                    request.setAttribute ("volver","-1");
                    request.setAttribute ("mensaje", "Acceso denegado " );
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                    dbCon = db.getConnection();
                    oProp.setNumPropuesta(nroProp);
                    oProp.setNumPoliza(numPoliza);
                    oProp.setCodEstado(5);

                    oProp.setDBEstadoCaucion (dbCon);
                    if (oProp.getCodError() < 0) {
                        throw new SurException (oProp.getDescError());
                    }
                    request.setAttribute ("volver","/benef/servlet/PropuestaServlet?opcion=getAllProp");
                    request.setAttribute ("mensaje", "La propuesta fue emitida con exito !!! " );
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");

//                    response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
//                    response.setHeader("Location", "/benef/servlet/PropuestaServlet?opcion=getAllProp");
            }


        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getPropuestaBenef (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        Connection        dbCon = null;
        Propuesta oProp = new Propuesta();
        AseguradoPropuesta oAseg = new AseguradoPropuesta();

        try {

            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int  nroProp    = Integer.valueOf( request.getParameter("numPropuesta") == null
                                           ? "0" : request.getParameter("numPropuesta") );
            int  codSubRama = Integer.valueOf( request.getParameter("codSubRama") == null
                                           ? "0" : request.getParameter("codSubRama") );

            if (oUser.getiCodTipoUsuario() == 0 && oUser.getmenu() == 4) {
                    request.setAttribute ("volver","-1");            
                    request.setAttribute ("mensaje", "Acceso denegado " );            
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                    
            } else {
                    if (nroProp == 0 ) {
                        oProp.setCodRama ( 9 );
                        oProp.setCodSubRama(codSubRama);
                        if (oUser.getiCodTipoUsuario() == 0 ){
                            oProp.setCodProd( -1);
                        } else {
                            oProp.setCodProd(oUser.getiCodProd());
                        }
                        oAseg.setTipoDoc("80");
                    } else {
                            dbCon = db.getConnection();
                            oProp.setNumPropuesta(nroProp);
                            oProp.setCantCuotas(1);
                            oProp.getDB(dbCon);

                            if (codSubRama > 0 && codSubRama != oProp.getCodSubRama()) {
                                oProp.setCodSubRama(codSubRama);
                                oProp.setImpPremio(0);
                                oProp.setImpPrimaTar(0);
                                oProp.setprimaPura(0);
                            }
                            if (oProp.getCodError() != 0 ){
                                throw new SurException( oProp.getDescError());
                            }
                            oAseg.setNumPropuesta(nroProp);
                            oAseg.getDBAseguradoCaucion(dbCon);

                            if (oAseg.getiNumError()!= 0) {
                                throw new SurException( oAseg.getsMensError());
                            }
                       

                     }
                    request.setAttribute ("propuesta", oProp);
                    request.setAttribute ("asegurado", oAseg);
                    doForward (request, response, "/propuesta/formPropuestaCaucion.jsp?codSubRama=" + codSubRama);
             }   
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                                

    protected void getPrintPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        Connection        dbCon = null;
        int  nroProp = Integer.valueOf( request.getParameter("numPropuesta") == null?"0":request.getParameter("numPropuesta"));
        try {
            dbCon = db.getConnection();  
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta   (nroProp);
            oProp.getDB(dbCon);

            if (oProp.getCodError() < 0 ) {
                throw new SurException( (oProp.getDescError()));
            }
            AseguradoPropuesta oAseg = new AseguradoPropuesta();
            oAseg.setNumPropuesta(nroProp);
            oAseg.getDBAseguradoCaucion(dbCon);
            if (oAseg.getiNumError() < 0 ) {
                throw new SurException( (oAseg.getsMensError()));
            }
            
            request.setAttribute ("propuesta", oProp);            
            request.setAttribute ("asegurado", oAseg);

            doForward (request, response, "/propuesta/report/caucionHTML.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
           
    }                                
    
    
    /*
     * Verificar datos con tomador de las polizs. Reemplaza al verifTomador
     */
    protected void verificarTomador (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        CallableStatement cons  = null;
        LinkedList        lTom  = new LinkedList();
        try {
            Usuario oUser  = (Usuario) (request.getSession().getAttribute("user"));
            String  nroDoc = request.getParameter ("verif_doc");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_P_TOMADOR(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString           (2, nroDoc);
            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    PersonaPoliza oTom = new PersonaPoliza();
                    oTom.setnumTomador      (rs.getInt    ("NUM_TOMADOR"));
                    oTom.settipoDoc         (rs.getString ("TIPO_DOC"));
                    oTom.setnumDoc          (rs.getString ("NUM_DOC"));
                    oTom.setrazonSocial     (rs.getString ("RAZON_SOCIAL"));
                    oTom.setcuit            (rs.getString ("CUIT"));
                    oTom.setcodCondicionIVA (rs.getInt    ("COD_CONDICION_IVA"));
                    oTom.setdomicilio       (rs.getString ("DOMICILIO"));
                    oTom.setlocalidad       (rs.getString ("LOCALIDAD"));
                    oTom.setcodPostal       (rs.getString ("COD_POSTAL"));
                    oTom.setprovincia       (rs.getString ("PROVINCIA"));
                    oTom.setapellido        (rs.getString ("RAZON_SOCIAL"));

                    lTom.add(oTom);
                }
                rs.close ();
            }

            request.setAttribute("tomadores", lTom);

            doForward (request, response, "/propuesta/PopUpVerificarTomador.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }    
    
    /*
     * Grabar datos de la propuesta.
     */
    protected void grabarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            int nroProp = 0;
            if ( request.getParameter ("prop_num_prop") != null &&
                 !request.getParameter ("prop_num_prop").equals("") ) {
                 nroProp  = Integer.parseInt( request.getParameter ("prop_num_prop") );
            }
            int codProd = 0;
            if ( request.getParameter ("prop_cod_prod") != null &&
                 !request.getParameter ("prop_cod_prod").equals("") ) {
               codProd  = Integer.parseInt( request.getParameter ("prop_cod_prod") );
            }

            int codVig = 0;
            if ( request.getParameter ("prop_vig") != null &&
                 !request.getParameter ("prop_vig").equals("") ) {
               codVig  = Integer.parseInt( request.getParameter ("prop_vig") );
            }


            int cantCuota = 0;
            if ( request.getParameter ("prop_cant_cuotas") != null &&
                 !request.getParameter ("prop_cant_cuotas").equals("") ) {
               cantCuota  = Integer.parseInt( request.getParameter ("prop_cant_cuotas") );
            }

            int numSocio = 0;
            if ( request.getParameter ("prop_numSocio") != null &&
                 !request.getParameter ("prop_numSocio").equals("") ) {
               numSocio  = Integer.parseInt( request.getParameter ("prop_numSocio") );
            }

//            String observacion   = request.getParameter ("prop_obs");

            int codFormaPago = 0;
            if ( request.getParameter ("prop_form_pago") != null &&
                 !request.getParameter ("prop_form_pago").equals("") ) {
               codFormaPago  = Integer.parseInt( request.getParameter ("prop_form_pago") );
            }

            double premio = 0;
            if ( request.getParameter ("prop_premio") != null &&
                 !request.getParameter ("prop_premio").equals("") ) {
               premio  = Dbl.StrtoDbl( request.getParameter ("prop_premio") );
            }

  
            int codEstado = 0;
            if ( request.getParameter ("prop_cod_est") != null &&
                 !request.getParameter ("prop_cod_est").equals("") ) {
                 codEstado  = Integer.parseInt( request.getParameter ("prop_cod_est") );
            }

            int codRama = 0;
            if ( request.getParameter ("prop_rama") != null &&
                 !request.getParameter ("prop_rama").equals("") ) {
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );
            }

            int codSubRama = 0;
            if ( request.getParameter ("prop_subrama") != null &&
                 !request.getParameter ("prop_subrama").equals("") ) {
                 codSubRama  = Integer.parseInt( request.getParameter ("prop_subrama") );
            }

 
            Propuesta oProp = new Propuesta();
            oProp.setCodProceso   (1);
            oProp.setBoca         ("WEB");
            oProp.setCodRama      (codRama);
            oProp.setNumPropuesta (nroProp);
            oProp.setCodSubRama   (codSubRama);
            oProp.setNumPoliza    (0);
            oProp.setCodCobFinal  (0);
            oProp.setCodMoneda    (1);
            oProp.setImpPremio    (premio);
            oProp.setCodFormaPago (codFormaPago);
            oProp.setImpCuota     (0);
            oProp.setCodProd      (codProd);
            oProp.setNumTomador   (numSocio);
            oProp.setPeriodoFact  (0);
            oProp.setCantCuotas   (cantCuota);
            oProp.setUserid       (oUser.getusuario());


 //           oProp.setmcaEnvioPoliza(request.getParameter ("prop_mca_envio_poliza") == null ? "S" : request.getParameter ("prop_mca_envio_poliza"));

            String fechaVigDesde = (request.getParameter ("prop_vig_desde")==null)?"":request.getParameter ("prop_vig_desde");

            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }
            oProp.setFechaFinVigPol(null);

            oProp.setCodVigencia(codVig);

//            if (request.getParameter ("prop_fac") != null) {
//                oProp.setCodFacturacion(Integer.parseInt (request.getParameter ("prop_fac")) );
//            }

            oProp.setCodEstado(codEstado);
  //          oProp.setObservaciones(observacion);
            oProp.setUserid(oUser.getusuario());

            dbCon = db.getConnection();

            oProp.setDB(dbCon);

            String sMensaje = "";
            String sRetorno = "";

            if (oProp.getNumPropuesta() > 0) {

                // ----------------------
                // DATOS DE FORMA DE PAGO
                // ----------------------
                // 1 - TARJETA DE CREDITO.-
                if ( oProp.getCodFormaPago() ==1 ) {
                    int codTarjCred = 0;
                    if ( request.getParameter ("pro_TarCred") != null &&
                         !request.getParameter ("pro_TarCred").equals("") ) {
                        codTarjCred  = Integer.parseInt( request.getParameter ("pro_TarCred") );
                    }

                    int codTarjBco = 0;
                    if ( request.getParameter ("pro_TarCredBco") != null &&
                         !request.getParameter ("pro_TarCredBco").equals("") ) {
                        codTarjBco  = Integer.parseInt( request.getParameter ("pro_TarCredBco") );
                    }
                    String nroTarjCred      = request.getParameter ("pro_TarCredNro");
                    String fechaVtoTarjCred = request.getParameter ("pro_TarCredVto");
                    String titularTarjCred  = request.getParameter ("pro_TarCredTit");

                    oProp.setCodTarjCred(codTarjCred);
                    oProp.setNumTarjCred(nroTarjCred);

                    if (fechaVtoTarjCred.equals("")) {
                        oProp.setVencTarjCred(null);
                    } else {
                        oProp.setVencTarjCred( Fecha.strToDate( fechaVtoTarjCred));
                    }
                    oProp.setCodBanco(codTarjBco);
                    oProp.setTitular(titularTarjCred);
                    oProp.setcodSeguridadTarjeta(request.getParameter ("pro_TarCredCodSeguridad"));

                    oProp.setDBTarjetaCredito(dbCon);

                // 2-3 - DEBITO .-
                } else if ( oProp.getCodFormaPago() == 2 || oProp.getCodFormaPago() == 3  ) {

                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null &&
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );
                    }
                    String cbu      = request.getParameter ("pro_CtaCBU");
                    String Sucursal = request.getParameter ("pro_CtaBcoSuc");
                    String titular  = request.getParameter ("pro_CtaTit");

                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);
                    oProp.setCbu(cbu);
                    oProp.setSucBanco(Sucursal);
                // DEBITO CUENTA
                } else if ( oProp.getCodFormaPago() == 4  ) {
                    String cbu      = request.getParameter ("pro_DebCtaCBU");
                    String titular  = request.getParameter ("pro_CtaTit");
                    oProp.setCbu     (cbu);
                    oProp.setTitular (titular);
                    oProp.setDBTarjetaDebitoCuenta(dbCon);
                } else {
                    // Otro forma de pago debe resetear otros campos de forma de Pago.
                    oProp.setDBFormaPagoReset(dbCon);
                }

                // ------------------
                // DATOS DEL TOMADOR
                // ------------------
                String tipoDocTomador = request.getParameter ("prop_tom_tipoDoc");
                String nroDocTomador  = request.getParameter ("prop_tom_nroDoc");
                String TomadorNom     = request.getParameter ("prop_tom_nombre");
                String TomadorApe     = request.getParameter ("prop_tom_apellido");

                int ivaTomador = 0;
                if ( request.getParameter ("prop_tom_iva") != null &&
                     !request.getParameter ("prop_tom_iva").equals("") ) {
                   ivaTomador  = Integer.parseInt( request.getParameter ("prop_tom_iva") );
                }
                String domTomador    = request.getParameter ("prop_tom_dom");
                String locTomador    = request.getParameter ("prop_tom_loc");
                String cpTomador     = request.getParameter ("prop_tom_cp");

                String mailTomador   = null; //request.getParameter ("prop_tom_email");
                String teTomador     = null; //request.getParameter ("prop_tom_te");
                String provTomador   = request.getParameter ("prop_tom_prov");
                String sCargo        = request.getParameter ("prop_tom_puesto");

                PersonaPoliza oTom   = new PersonaPoliza();
                oTom.setnumTomador  (numSocio);
                oTom.settipoDoc     (tipoDocTomador);
                oTom.setnumDoc      (nroDocTomador);
                oTom.setrazonSocial (TomadorApe + " " + TomadorNom);
                oTom.setnombre      (TomadorNom);
                oTom.setapellido    (TomadorApe);
                oTom.setcodCondicionIVA(ivaTomador);
                oTom.setdomicilio   (domTomador);
                oTom.setlocalidad   (locTomador);
                oTom.setcodPostal   (cpTomador );
                oTom.setmail        (mailTomador);
                oTom.settelefono    (teTomador);
                oTom.setprovincia   (provTomador);
                oTom.setcargo       (sCargo);

                oTom.setcodProceso        (oProp.getCodProceso());
                oTom.setcodBoca           (oProp.getBoca());
                oTom.setnumPropuesta      (oProp.getNumPropuesta());

                oTom.setDBTomadorCaucion  (dbCon);
// ------------------
// DATOS DEL ASEGURADO
// ------------------
                String tipoDocAsegurado = request.getParameter ("prop_ase_tipoDoc");
                String nroDocAsegurado  = request.getParameter ("prop_ase_nroDoc");
                String AseguradoNom     = request.getParameter ("prop_ase_nombre");
                String AseguradoApe     = request.getParameter ("prop_ase_apellido");

                String domAsegurado    = request.getParameter ("prop_ase_dom");
                String locAsegurado    = request.getParameter ("prop_ase_loc");
                String cpAsegurado     = request.getParameter ("prop_ase_cp");

                String mailAsegurado   = null; //request.getParameter ("prop_ase_email");
                String teAsegurado     = null; //request.getParameter ("prop_ase_te");
                String provAsegurado   = request.getParameter ("prop_ase_prov");

                AseguradoPropuesta oAseg = new AseguradoPropuesta();
       
                oAseg.setCodProceso     (1);
                oAseg.setNumPropuesta   (oProp.getNumPropuesta());
                oAseg.setCodBoca        (oProp.getBoca());
                oAseg.setCodRama        (9);
                oAseg.setOrden          (1);
                oAseg.setCodigoPosta    (cpAsegurado);
                oAseg.setDomicilio      (domAsegurado);
                oAseg.setNombre         (AseguradoNom);
                oAseg.setApellido       (AseguradoApe);
                oAseg.setNumDoc         (nroDocAsegurado);
                oAseg.setSubCertificado (0);
                oAseg.setTipoDoc        (tipoDocAsegurado);
                oAseg.setlocalidad      (locAsegurado);
                oAseg.setprovincia      (provAsegurado);

                oAseg.setDBAseguradoCaucion(dbCon);

                if (oAseg.getiNumError() < 0) {
                      throw new SurException ("Error en grabarPropuesta - setDBAseguradoCaucion:" + oAseg.getsMensError());
                }
                    int cantCob = request.getParameter ("prop_max_cant_cob") == null ? 0 : Integer.parseInt (request.getParameter ("prop_max_cant_cob"));
                    if (cantCob > 0) {
                        int    codCob = 0;
                        double impCob = 0;
                        AsegCobertura  oCob = new AsegCobertura();
                        oCob.setcodProceso  (oProp.getCodProceso());
                        oCob.setcodBoca     (oProp.getBoca());
                        oCob.setnumPropuesta(oProp.getNumPropuesta());

                        // Borro Coberturas .
                        oCob.delDBCobPropuesta(dbCon);

                        oCob.setcodRama     (oProp.getCodRama());
                        oCob.setcodSubRama  (oProp.getCodSubRama());
                        for (int i=1;i <=cantCob;i++  ) {
                            codCob = 0;
                            if ( request.getParameter ("prop_cob_cod_"+i) != null &&
                                 !request.getParameter ("prop_cob_cod_"+i).equals("") ) {
                                 codCob  =  Integer.parseInt( request.getParameter ("prop_cob_cod_"+i) );
                            }
                            impCob = 0;
                            if ( request.getParameter ("prop_cob_"+i) != null &&
                                 !request.getParameter ("prop_cob_"+i).equals("") ) {
                                 impCob  =  Dbl.StrtoDbl(request.getParameter ("prop_cob_"+i) );
                            }
                            oCob.setcodCob(codCob);
                            oCob.setimpSumaRiesgo(impCob);
                            // Grabo Cobertura.
                            oCob.setDBCobPropuesta(dbCon);
                        }
                    }

                    if (request.getParameter("opcion").equals("CalcularPremio")) {
                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location", "/benef/servlet/CaucionServlet?opcion=getPropuestaBenef&numPropuesta="  + oProp.getNumPropuesta() + "&codSubRama=" + oProp.getCodSubRama());
                    } else {
////----
                        oProp.setCodEstado   ( 1 );

                        oProp.setDBEstado(dbCon);

                        sRetorno  = Param.getAplicacion() + "propuesta/printCaucion.jsp?opcion=printCaucion&formato=HTML&cod_rama=9&numPropuesta=" + oProp.getNumPropuesta();

                        if (oProp.getCodError() < 0) {
                            switch (oProp.getCodError()) {
                                case -400 :
                                    sMensaje = "La propuesta no pudo ser enviada porque existe otra póliza con deuda del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                                    sRetorno  = "-1";
                                    break;
                                default:
                                    sMensaje =  oProp.getDescError();
                                    sRetorno  = "-1";
                            }
                        } else {
                            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                            oControl.setearAcceso(dbCon, 26 );
            // fin de setear el control de acceso

                            this.sendEmailPropuesta(dbCon, oUser, oProp, oAseg );
                            sMensaje = "La propuesta Nro.: " + oProp.getNumPropuesta() + " ha sido enviada con exito ! ";
                        }
                    }
                } else {
                    sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                    sRetorno = Param.getAplicacion() + "index.jsp";
                }

            request.setAttribute("mensaje", sMensaje);
            request.setAttribute("volver", sRetorno);
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (SurException se) {
            throw new SurException (se.getMessage());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    /*
     * Grabar nomina.
     */
    protected void grabarNomina (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         
            
            int numProceso = 0;                        
            if ( request.getParameter ("prop_proceso") != null && 
                 !request.getParameter ("prop_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("prop_proceso") );
            }            
            
            String codBoca = request.getParameter ("prop_codBoca");
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            int orden = 0;
            if ( request.getParameter ("prop_nom_orden") != null && 
                 !request.getParameter ("prop_nom_orden").equals("") ) {
               orden  = Integer.parseInt( request.getParameter ("prop_nom_orden") );
            }                       
            String apeNom = request.getParameter ("prop_nom_ApeNom");
            String tipDoc = request.getParameter ("prop_nom_tipDoc");
            String numDoc = request.getParameter ("prop_nom_numDoc");
            String mano   = request.getParameter("prop_nom_mano");
            
            dbCon = db.getConnection();
            AseguradoPropuesta oAseg = new AseguradoPropuesta();
            
            oAseg.setCodProceso(numProceso);
            oAseg.setCodBoca(codBoca);
            oAseg.setNumPropuesta(nroPropuesta);           
            oAseg.setCodRama(10);
            oAseg.setOrden(orden);           
            oAseg.setTipoDoc(tipDoc);
            oAseg.setNumDoc(numDoc);
            oAseg.setNombre(apeNom);                              
            oAseg.setmano(mano);
            
            String fechaNacimiento = (request.getParameter ("prop_nom_fechaNac")==null)?"":request.getParameter ("prop_nom_fechaNac");
            if (fechaNacimiento.equals("")) {
                oAseg.setFechaNac(null);
            } else {
                oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("prop_nom_fechaNac") ));                
            }    
            
            oAseg.setDB(dbCon);
            
            if (oAseg.getNumPropuesta() > 0) {      
                Propuesta oProp = new Propuesta();
                oProp.setCodProceso  ( oAseg.getCodProceso());
                oProp.setBoca        ( oAseg.getCodBoca() );
                oProp.setNumPropuesta( oAseg.getNumPropuesta());           
                oProp.setCodRama     ( oAseg.getCodRama()); 
                
                oProp.getDB(dbCon);
                
                LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);                              
                
                request.setAttribute("nominas", nominas);    
                request.setAttribute("propuesta", oProp);    
                
                doForward (request, response, "/propuesta/formNomina.jsp");  
                
            } else {    
                String sMensaje = "";                
                sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                 
            }    
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }       
    /*
     *  enviarPropuesta    
     */
    protected void enviarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                       
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }            
            dbCon = db.getConnection();         

            AseguradoPropuesta oAseg = new AseguradoPropuesta ();
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta( nroPropuesta);         
            oProp.setUserid      (oUser.getusuario());
            oProp.setCodEstado   ( 1 );                           
            
            oProp.setDBEstado(dbCon);

            oAseg.setNumPropuesta(nroPropuesta);
            String  sMensaje = "";
            String  sVolver  = Param.getAplicacion() + "propuesta/printCaucion.jsp?opcion=printCaucion&formato=HTML&cod_rama=9&numPropuesta=" + nroPropuesta;
            
            if (oProp.getCodError() < 0) {
                switch (oProp.getCodError()) {                
                    case -400 :
                        sMensaje = "La propuesta no pudo ser enviada porque existe otra póliza con deuda del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                        sVolver  = "-1";
                        break;

                    case -500:
                        sMensaje = "La propuesta no pudo ser enviada porque un asegurado de la nómina ya existe en otra póliza vigente. Por favor, contactese con su representante comercial. Muchas gracias ";
                        sVolver  = "-1";
                        break;
                    case -600:
                        sMensaje = "La propuesta no pudo ser enviada porque un asegurado de la nómina ya existe en otra póliza anulada con deuda. Por favor, contactese con su representante comercial. Muchas gracias ";
                        sVolver  = "-1";
                        break;
                    case -700:
                        sMensaje = "Ya existe otra póliza vigente de VCO del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                        sVolver  = "-1";
                        break;
                    case -800 :
                        sMensaje = "La propuesta YA FUE ENVIADA ";
                        sVolver  = "-1";
                        break;

                    default:
                        sMensaje =  oProp.getDescError();
                        sVolver  = "-1";
                }
            } else {
                 oProp.getDB(dbCon);
// setear el control de acceso
                 
                ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                oControl.setearAcceso(dbCon, 26 );
// fin de setear el control de acceso 

                this.sendEmailPropuesta(dbCon, oUser, oProp, oAseg );
                sMensaje = "La propuesta Nro.: " + nroPropuesta + " ha sido enviada con exito ! ";               
            }

            request.setAttribute("mensaje", sMensaje);                
            request.setAttribute("volver", sVolver);             
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                
    
    
    protected void sendEmailPropuesta (Connection dbCon, Usuario oUser, Propuesta oCot, AseguradoPropuesta oAseg)
    throws ServletException, IOException, SurException {
        StringBuffer sMensaje = new StringBuffer();

        try {
            oCot.getDB (dbCon);

            oAseg.getDBAseguradoCaucion(dbCon);

            sMensaje.append("AVISO DE ENVIO DE PROPUESTA DE " + oCot.getDescRama() + " - N° " + oCot.getNumPropuesta () + "\n");
            
            sMensaje.append("---------------------------------------\n\n");
            sMensaje.append("NUM PROPUESTA: " + oCot.getNumPropuesta () + "\n");            
            sMensaje.append("ENVIADA POR  : " + oUser.getApellido() + " " + oUser.getNom() + "\n");
            sMensaje.append("PRODUCTOR    : " + oCot.getdescProd() +"("+ oCot.getCodProd() +")\n");
//            sMensaje.append("NUM COTIZACION: " + String.valueOf(oCot.getNumSecuCot()) + "\n");
            sMensaje.append("FECHA        : " + (oCot.getFechaEnvioProd() == null ? " " : Fecha.showFechaForm(oCot.getFechaEnvioProd())) + ", " + (oCot.getHoraEnvioProd() == null ? " " : oCot.getHoraEnvioProd() ) + "\n");
            sMensaje.append("\n\n TOMADOR\n ");
            sMensaje.append("Descripción       :" + oCot.getTomadorRazon () + "\n");
            sMensaje.append("DNI               : " + oCot.getTomadorDescTipoDoc() + " " + oCot.getTomadorNumDoc() + "\n");
            sMensaje.append("Domicilio         : " + oCot.getTomadorDom() + " " + oCot.getTomadorLoc() + " (" + oCot.getTomadorCP() + ") - " + oCot.getTomadorDescProv() + "\n");
            sMensaje.append("Cargo             : " + oCot.getTomadorCargo()  + "\n");
            sMensaje.append("\n\n ASEGURADO\n ");
            sMensaje.append("Descripción       : " + oAseg.getApellido() + " " + oAseg.getNombre() + "\n");
            sMensaje.append("DNI               : " + oAseg.getDescTipoDoc() + " " + oAseg.getNumDoc() + "\n");
            sMensaje.append("Domicilio         : " + oAseg.getDomicilio() + " " + oAseg.getlocalidad() + " (" + oAseg.getCodigoPosta() + ") - " + oAseg.getdescProvincia() + "\n");

//          sMensaje.append("Como enviar póliza: " + oCot.getdescMcaEnviarPoliza() + "\n");
            sMensaje.append("Cond I.V.A        : " + (oCot.getTomadorDescCondIva() == null ? "no informado" : oCot.getTomadorDescCondIva()) + "\n");
            sMensaje.append(" \n");
            sMensaje.append("Características del seguro\n");
            sMensaje.append("-------------------------- \n");
            sMensaje.append("Vigencia          : " + oCot.getdescVigencia() + ", desde " + Fecha.showFechaForm(oCot.getFechaIniVigPol())+ "\n");
//            sMensaje.append("Facturación         : " + oCot.getDescFacturacion() + "\n");
            sMensaje.append(" \n");
            sMensaje.append("Suma asegurada      $" + Dbl.DbltoStrPadRight( oCot.getCapitalMuerte(),2, 15) + "\n");
            sMensaje.append(" \n");
            sMensaje.append("Presupuesto\n");
            sMensaje.append("-----------\n");
            sMensaje.append("Prima pura          $" + Dbl.DbltoStrPadRight( oCot.getprimaPura(),2, 15) + "\n");            
            sMensaje.append("Sub-Total           $" + Dbl.DbltoStrPadRight( oCot.getsubTotal(),2, 15) + "\n");
            sMensaje.append("Subtotal            $" + Dbl.DbltoStrPadRight( oCot.getprimaPura() + oCot.getrecAdmin() ,2, 15) + "\n");                        
            sMensaje.append(" GDA            "      + Dbl.DbltoStrPadRight( oCot.getporcGDA(),2, 5) +"%  $" + Dbl.DbltoStrPadRight( oCot.getgda(),2, 11) + "\n");
            sMensaje.append("Recargos finan. "      + Dbl.DbltoStrPadRight( oCot.getporcRecFinan(),2, 5) +"%  $" + Dbl.DbltoStrPadRight( oCot.getrecFinan(),2, 11) + "\n");
            sMensaje.append("Derecho de Emision  $" + Dbl.DbltoStrPadRight( oCot.getderEmi(),2, 15) + "\n");
            sMensaje.append("Prima Tarifa        $" + Dbl.DbltoStrPadRight( oCot.getImpPrimaTar(),2, 15) + "\n");
            sMensaje.append(" IVA "+ Dbl.DbltoStrPadRight( oCot.getporcIva(),2, 6) +"%        $" + Dbl.DbltoStrPadRight( oCot.getiva(),2, 15) + "\n");
            sMensaje.append(" Tasa SSN "+ Dbl.DbltoStrPadRight( oCot.getporcSsn(),2, 6) +"%   $" + Dbl.DbltoStrPadRight( oCot.getssn(),2, 15) + "\n");
            sMensaje.append(" Serv.Soc "+ Dbl.DbltoStrPadRight( oCot.getporcSoc(),2, 6) +"%   $" + Dbl.DbltoStrPadRight( oCot.getsoc(),2, 15) + "\n");
            sMensaje.append(" Sellado  "+ Dbl.DbltoStrPadRight( oCot.getporcSellado(),2, 6) +"%   $" + Dbl.DbltoStrPadRight( oCot.getsellado(),2, 15) + "\n");
            sMensaje.append(" Premio              $" + Dbl.DbltoStrPadRight( oCot.getImpPremio(),2, 15) + "\n");

            StringBuffer sFormaPago = new StringBuffer();
            sFormaPago.append("Forma de Pago:\n");
            sFormaPago.append (oCot.getdescFormaPago() + ", " + oCot.getCantCuotas() +" cuotas de $" + Dbl.DbltoStr(oCot.getImpCuota() ,2) + "\n");
            switch ( oCot.getCodFormaPago()) {
                case 1:
                    sFormaPago.append("Tarjeta:" + oCot.getDescTarjCred() + " Nº " + oCot.getNumTarjCred() + " (" + oCot.getcodSeguridadTarjeta() + ").\n" );
                    sFormaPago.append("Fecha Venc: " + Fecha.showFechaForm(oCot.getVencTarjCred())+ ".\n" );
                    sFormaPago.append("Titular:" + oCot.getTitular()+ ".\n" );
                    break;
                case 4:
                    sFormaPago.append("CBU:" + oCot.getCbu()+ ".\n");
                    sFormaPago.append("Titular:" + oCot.getTitular()+ ".\n");
                    break;
                default:
                    sFormaPago.append("\n");
            }

            sMensaje.append(sFormaPago.toString() + "\n");
                       
            sMensaje.append(" \n");

            if (oCot.getObservaciones() != null ) {
                sMensaje.append(" \n");
                sMensaje.append("Observaciones\n");
                sMensaje.append("---------------------------- \n");
                sMensaje.append(oCot.getObservaciones() + "\n");
            }

            sMensaje.append(" \n");            
            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("PROPUESTA " + oCot.getDescRama() + "/" + oCot.getDescSubRama() + " - N° " + oCot.getNumPropuesta());
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "CAUCION");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                //    oEmail.sendMessage();
                oEmail.sendMessageBatch();

            }
            
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        }
    }
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
        public void doForward(HttpServletRequest request, HttpServletResponse response,
        String nextPage) throws ServletException, IOException {
	try {
      		getServletConfig().getServletContext().getRequestDispatcher(nextPage).forward(request,response);
	} catch (IOException ioe) {
                goToJSPError (request,response, ioe);
	} catch (ServletException se) {
                goToJSPError (request,response, se);
	} catch (Exception e) {
                goToJSPError (request,response, e);
	}  // try		

    } // doForward
        
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) 
     throws ServletException, IOException {
	try {
                request.setAttribute("javax.servlet.jsp.jspException", t);
		getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
	} catch (IOException ioe) {
		System.out.println("LoginServlet IOException Forwarding Request: " + ioe);
	} catch (ServletException se) {
		System.out.println("LoginServlet ServletException Forwarding Request: " + se);
	} // try		

    } // doForward           
}