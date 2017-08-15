/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;

import java.io.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.util.LinkedList;
import java.text.*;
import com.business.util.*;
import com.business.db.*;
import com.business.beans.Portal;
import com.business.beans.Usuario;
import com.business.beans.Persona;
import com.business.beans.Certificado;
import com.business.beans.Poliza;
import com.business.beans.Manual;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;
import net.tanesha.recaptcha.ReCaptchaImpl;
import net.tanesha.recaptcha.ReCaptchaResponse;
     
/**
 *
 * @author Rolando Elisii
 */
public class PortalServlet extends HttpServlet {
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
            String op =  request.getParameter("opcion");
            Connection dbCon = null;
            LinkedList lProd = null;

            if (op == null ) {
                home (request, response);
            } else if (op.equals("home_producto")) {
                homeProducto (request, response);
            } else if (op.equals("setContacto")) {
                setContacto(request, response);
            } else if (op.equals ("registrar")) {
                registrar (request, response);
            } else if (op.equals ("productoDetalle")) {
                productoDetalle (dbCon, lProd, request, response);
            } else if (op.equals ("red_productores")) {
                productores (request, response);
            }else if (op.equals ("getCertificado")) {
                getCertificado (request, response);
            } else if (op.equals ("getCopiaPoliza")) {
                getCopiaPoliza (request, response);
            } else if (op.equals ("descargas")) {
                descargas (request, response);
            } else if (op.equals ("getCaucion")) {
                productoDetalle (dbCon, lProd, request, response);
            } else if (op.equals ("probarCaptcha")) {
                probarCaptcha ( request, response);
            }
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void home (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
    Connection dbCon = null;
        LinkedList lProd = new LinkedList();
        try {
        if (Param.getRealPath () == null) {
            Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
            db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
        }

        dbCon = db.getConnection();

        ControlDeUso oControl = new ControlDeUso ("WEB",request.getRemoteAddr());
        oControl.setearAcceso(dbCon, 34);

        lProd = AllProductos(dbCon, 1, 1, 999);

        request.setAttribute ("productos",lProd);
        doForward (request, response, "/portal/index.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        db.cerrar(dbCon);
    }
  }

    protected void homeProducto (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        String sTitulo = "";
        int iNivel  = 2;
        int iSubNivel = 2;
        Connection dbCon = null;
        LinkedList lProd = new LinkedList();
        try {
        int  iRama = Integer.parseInt (request.getParameter("rama"));
        switch (iRama) {
            case 999: sTitulo = "seguros de personas";
            break;
            case 10: sTitulo = "accidentes personales";
            break;
            case 22: sTitulo = "vida colectivo personas";
            break;
            case 222: sTitulo = "vida colectivo empresas";
            break;
            case 25: sTitulo = "salud";
            break;
            case 23: sTitulo = "saldo deudor";
            break;
            default:  sTitulo = "sepelio";
          }
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }
            dbCon = db.getConnection();

            lProd = AllProductos(dbCon, iNivel,iSubNivel, iRama);

            if (lProd != null && lProd.size() == 1 ) {
                productoDetalle (dbCon, lProd, request, response);
            } else {
                request.setAttribute ("productos",lProd);
                request.setAttribute ("titulo", sTitulo );
                doForward (request, response, "/portal/home_producto.jsp");
            }
    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        db.cerrar(dbCon);
    }
  }

    protected LinkedList AllProductos (Connection dbCon, int iNivel, int iSubNivel, int iRama)
    throws ServletException, IOException, SurException {
        CallableStatement proc  = null;
        ResultSet rs            = null;
        LinkedList lProd = new LinkedList();

        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("POR_GET_ALL_PORTAL (?, ?, ?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setInt (2, iNivel );
            proc.setInt (3, iSubNivel );
            proc.setInt (4, iRama);
            proc.execute();
            rs = (ResultSet) proc.getObject(1);

            if (rs != null ) {
                while (rs.next()) {
                  Portal oP = new Portal();
                  oP.setcodRama   (rs.getInt ("COD_RAMA"));
                  oP.setcodPortal   (rs.getInt ("COD_PORTAL"));
                  oP.setdescRama    (rs.getString ("DESC_RAMA"));
                  oP.settitulo      (rs.getString ("TITULO"));
                  oP.setsubtitulo   (rs.getString ("SUBTITULO"));
                  oP.setimageMin    (rs.getString ("IMAGEN_MIN"));
                  oP.settexto       (rs.getString ("TEXTO"));
                  oP.setnivel       (rs.getInt ("NIVEL"));
                  oP.setsubNivel    (rs.getInt ("SUB_NIVEL"));
                  oP.setimagen      (rs.getString ("IMAGEN"));
                  oP.setfechaDesde  (rs.getDate ("FECHA_DESDE"));
                  oP.setfechaHasta  (rs.getDate ("FECHA_HASTA"));
                  oP.setemail       (rs.getString ("EMAIL"));
                  oP.setimagenSlider(rs.getString ("IMAGEN_SLIDER"));
                  lProd.add(oP);
                }
                rs.close();
            }
            proc.close();
    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (proc != null) proc.close();
            if (rs != null) rs.close();
        } catch (SQLException se) {
            throw new SurException(se.getMessage());
        }
        return lProd;
    }
  }

    protected void productores (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lProd = new LinkedList();
        CallableStatement proc  = null;
        ResultSet rs            = null;
        try {
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }

            dbCon = db.getConnection();

            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("POR_GET_ALL_PRODUCTORES ()"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.execute();
            rs = (ResultSet) proc.getObject(1);

            if (rs != null ) {
                while (rs.next()) {
                  Usuario oUser = new Usuario();
                  oUser.setPcia         (rs.getString ("COD_PROVINCIA"));
                  oUser.setsDesProvincia(rs.getString ("PROVINCIA"));
                  oUser.setLocalidad    (rs.getString ("LOCALIDAD"));
                  oUser.setiNumSecuUsu  (rs.getInt ("CANTIDAD"));
                  lProd.add(oUser);
                }
                rs.close();
            }
            proc.close();

            request.setAttribute ("productores",lProd);
            doForward (request, response, "/portal/redProductores.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (proc != null) proc.close();
            if (rs != null) rs.close();
        } catch (SQLException se) {
            throw new SurException(se.getMessage());
        }
        db.cerrar(dbCon);
    }
  }

    protected void productoDetalle (Connection dbCon, LinkedList lProd, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        try {
            int iCodPortal = -1;
            if (lProd != null) {
                iCodPortal = ((Portal) lProd.get(0)).getcodPortal();
            } else {
                if ( ! request.getParameter ("opcion").equals("getCaucion")) {
                    iCodPortal = Integer.parseInt (request.getParameter("cod_portal"));
                } else {
                    iCodPortal = Integer.parseInt (request.getParameter("rama"));
                }
            }

            if (dbCon == null ) {
                if (Param.getRealPath () == null) {
                    Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                    db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
                }
                dbCon = db.getConnection();
            }

            ControlDeUso oControl = new ControlDeUso ("WEB",request.getRemoteAddr());
            oControl.setearAcceso(dbCon, 35);

            Portal oP = new Portal();
            oP.setcodPortal(iCodPortal);
            oP.getDB(dbCon);

            oP.getDBAllTextos(dbCon);

            if (oP.getmcaTabla() != null && oP.getmcaTabla().equals("X")) {
                oP.getDBTabla(dbCon);
            }

            request.setAttribute ("producto", oP);
            doForward (request, response, "/portal/productoDetalle.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        db.cerrar(dbCon);
    }
  }

     public void setContacto (HttpServletRequest request, HttpServletResponse response) throws SurException {
        Connection dbCon = null;
         try {
            if (Param.getRealPath() ==  null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }

            String emailDestino = request.getParameter ("email_destino");
            String asunto       = request.getParameter ("asunto");
            String nombre       = request.getParameter ("nombre");
            String prov         = request.getParameter ("provincia");
            String localidad    = request.getParameter ("localidad");
            String tel          = request.getParameter ("telefono");
            String email        = request.getParameter ("email");
            String motivo       = request.getParameter ("motivo");
            String consulta     = request.getParameter ("consulta");

            StringBuilder sMensaje = new StringBuilder ();
            StringBuilder sSubject = new StringBuilder ();
            Email oEmail = new Email ();

            sSubject.append("Formulario de contacto ").append(motivo).append(": ").append(asunto);
            oEmail.setSubject(sSubject.toString());

            sMensaje.append("   FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
            sMensaje.append("NOMBRE     : ").append(nombre).append("\n");
            sMensaje.append("PROVINCIA  : ").append(prov ).append("\n");
            sMensaje.append("LOCALIDAD  : ").append(localidad).append("\n");
            sMensaje.append("TELEFONO   : ").append( tel ).append( "\n");
            sMensaje.append("EMAIL      : ").append(email).append("\n\n");
            sMensaje.append("CONSULTA   : ").append(consulta).append("\n");
            oEmail.setContent(sMensaje.toString());
            oEmail.setDestination(emailDestino);

            oEmail.sendMessage(); // Batch();

            request.setAttribute("enviado",  "ok");
            doForward (request, response, "/portal/contacto.jsp");

        } catch (Exception e) {
            throw new SurException ("Error: " + e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

     public void probarCaptcha (HttpServletRequest request, HttpServletResponse response) throws SurException {
        Connection dbCon = null;
        String  ok = "La solicitud se ha enviado con exito, muy pronto nos contactaremos con usted.";
         try {
            if (Param.getRealPath() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }
System.out.println ("entro en pruebaCaptcha ");


            String remoteAddr = request.getRemoteAddr();

            ReCaptchaImpl reCaptcha = new ReCaptchaImpl();

            reCaptcha.setPrivateKey("6LcIJvISAAAAAJ_wuDUld3vTjsPQcKOI_VpqywoU");

            String challenge = request.getParameter("recaptcha_challenge_field");

System.out.println (challenge);

            String uresponse = request.getParameter("recaptcha_response_field");

System.out.println (uresponse);

            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

System.out.println (reCaptchaResponse.getErrorMessage());

            if ( !  reCaptchaResponse.isValid()) {
              ok = "captcha_invalido";
            }
            request.setAttribute("ok", ok);
            doForward (request, response, "/portal/registracionForm.jsp?error=incorrect-captcha-sol");
        } catch (Exception e) {
            throw new SurException ("Error al registrar el Usuario " + e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

     public void registrar (HttpServletRequest request, HttpServletResponse response) throws SurException {
        Connection dbCon = null;
        String  ok = "La solicitud se ha enviado con exito, muy pronto nos contactaremos con usted.";
         try {
            if (Param.getRealPath() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }

/*            String remoteAddr = request.getRemoteAddr();
            ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
            reCaptcha.setPrivateKey("your_private_key");

            String challenge = request.getParameter("recaptcha_challenge_field");
            String uresponse = request.getParameter("recaptcha_response_field");
            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

            if (  reCaptchaResponse.isValid()) {
              out.print("Answer was entered correctly!");
            } else {
              out.print("Answer is wrong");
            }
*/
            Usuario oUser = new Usuario ();
            oUser.setTipoDoc   (request.getParameter("tipoDoc"));
            oUser.setDoc       (request.getParameter("numDoc"));
            oUser.setRazonSoc  (request.getParameter("nombre"));
            if (request.getParameter("matricula") != null && request.getParameter("matricula").equals ("")) {
                oUser.setmatricula ( 0 );
            } else {
                oUser.setmatricula (Integer.parseInt (request.getParameter("matricula")));
             }
            oUser.setTel1      (request.getParameter("tel1"));
            oUser.setEmail     (request.getParameter("email"));
            oUser.setsObservacion(request.getParameter("comentarios"));
            oUser.setusuario( request.getParameter("usuario"));


            dbCon = db.getConnection();
            oUser.getDBRecuperarAcceso(dbCon);

            if (oUser.getiNumError() < 0) {
                throw new SurException(oUser.getsMensError());
            }

            StringBuilder sMensaje = new StringBuilder ();
            StringBuilder sSubject = new StringBuilder ();
            Email oEmail = new Email ();

            sSubject.append("Beneficio Web - Solicitud de acceso web ");
            oEmail.setSubject(sSubject.toString());


            sMensaje.append("   FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
            sMensaje.append("NOMBRE y APELLIDO: ").append(oUser.getRazonSoc()).append("\n");
            sMensaje.append("USUARIO          : ").append(oUser.getusuario()).append("\n");
            sMensaje.append("DOCUMENTO        : ").append(oUser.getDoc()).append( "\n");
            sMensaje.append("MATRICULA        : ").append(oUser.getmatricula()).append("\n");
            sMensaje.append("TELEFONOS        : ").append(oUser.getTel1 ()).append("\n");
            sMensaje.append("EMAIL            : ").append(oUser.getEmail()).append("\n\n");
            sMensaje.append("COMENTARIOS      : ").append(oUser.getsObservacion()).append("\n\n\n");
            if (oUser.getiNumError() != 0) {
                sMensaje.append("ERROR: " ).append(oUser.getsMensError());
             } else {
                sMensaje.append("SE ENVIA USUARIO/CLAVE AL MAIL:").append(oUser.getEmail());
             }

            oEmail.setContent(sMensaje.toString());
            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "REGISTRO");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                oEmail.sendMessage ();
            }

            if (oUser.getiNumError() == 0) {
                sMensaje.delete(0, sMensaje.length());
                sSubject.delete(0, sMensaje.length());
                Email oEmail2 = new Email ();

                sSubject.append("Beneficio Web - Solicitud de acceso web ");
                oEmail2.setSubject(sSubject.toString());

                sMensaje.append("   FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
                sMensaje.append("NOMBRE y APELLIDO: ").append(oUser.getRazonSoc()).append("\n");
                sMensaje.append("COD. de PRODUCTOR: ").append(oUser.getiCodProd()).append("\n");
                sMensaje.append("DOCUMENTO        : ").append(oUser.getDoc()).append( "\n");
                sMensaje.append("MATRICULA        : ").append(oUser.getmatricula()).append("\n");
                sMensaje.append("EMAIL            : ").append(oUser.getEmail()).append("\n\n");
                sMensaje.append("USUARIO DE ACCESO: ").append(oUser.getusuario()).append("\n");
                sMensaje.append("CLAVE DE ACCESO  : ").append(oUser.getpassword()).append("\n");

                oEmail2.setContent(sMensaje.toString());
                oEmail2.setDestination(oUser.getEmail());
                oEmail2.sendMessage();
                ok = "Se enviaron los datos de acceso a la/s cuenta de correo " +oUser.getEmail() ;
            }
            request.setAttribute("ok", ok);
            doForward (request, response, "/portal/registracionForm.jsp");
        } catch (Exception e) {
            throw new SurException ("Error al registrar el Usuario " + e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getCertificado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Certificado oCert = new Certificado ();

            oCert.settipoCertificado("PZ");
            oCert.setnumPoliza(request.getParameter ("poliza") == null ||
                                  request.getParameter ("poliza").equals ("") ? 0 :
                                  Integer.parseInt (request.getParameter ("poliza")));
           oCert.setnumDoc(request.getParameter ("dni") );

           oCert.setuserId         ("WEB");
            
            if (Param.getRealPath() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }

           dbCon = db.getConnection();

           oCert.setDBCertificadoWeb (dbCon);   

// setear el control de acceso
            ControlDeUso oControl = new ControlDeUso ("WEB", request.getRemoteAddr() );
            oControl.setearAcceso(dbCon, 32);
// fin de setear el control de acceso

            if (oCert.getnumCertificado() > 0 ) {
               doForward (request, response, "/servlet/CertificadoServlet?opcion=getPrintCert&tipo_cert=PZ&numCert=" + oCert.getnumCertificado() + "&tipo=pdf");

            } else {
                String sMensaje = "";
                switch (oCert.getnumCertificado()) {
                    case -100: // la poliza no existe
                        sMensaje = "La p&oacute;liza solicitada no existe o hay alguna inconsistencia en la datos ingresados";
                        break;

                    case -50: // la poliza no existe
                        sMensaje = "LA PÓLIZA TIENE MAS DE 300 ASEGURADOS, solicitelo desde el  botón Contactar Asesor";
                        break;

                    case -300: // la poliza no esta vigente
                        sMensaje = "La p&oacute;liza no esta vigente";
                        break;

                    case -400: // existe deuda
                        sMensaje = "La p&oacute;liza registra una deuda pendiente.";
                        break;

                    case -500: // LA PóLIZA esta anulada
                        sMensaje = "La p&oacute;liza esta anulada.";
                        break;
                    case -700: // LA PóLIZA esta anulada
                        sMensaje = "P&oacute;liza sin CUIC. Motivos: puede estar pendiente o no fue aprobada por la SSN.";
                        break;

                    default: // normal html
                        sMensaje = "Hubo alg&uacute;n problema en la emisión del certificado.";

                        Email oEmail = new Email ();
                        oEmail.setSubject("Beneficio Web - Aviso de ERROR ");
                        oEmail.setContent(sMensaje);
                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessage();
                        }
                }

                request.setAttribute("error_cert", sMensaje);
                doForward (request, response, "/portal/clientes.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getCopiaPoliza (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        Poliza oPol      = new Poliza ();
        String sTipoMens  = "";
        String sTipoMens2 = "";
        String sMens      = "";
        String sMensa     = "ok";
        String sFile    = "/opt/tomcat/webapps/benef/files/dc/";

        try {
// setear el control de acceso
            if (Param.getRealPath() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }

           dbCon = db.getConnection();

            dbCon = db.getConnection();
            ControlDeUso oControl = new ControlDeUso ("WEB",request.getRemoteAddr());
            oControl.setearAcceso(dbCon, 33);

            String dni = request.getParameter("dni");
            String numPoliza = request.getParameter("poliza");
            String endoso = "0";
            String rama = "";

            numPoliza  = Formatos.formatearCeros(numPoliza,7);
            endoso     = Formatos.formatearCeros(endoso,6);

            oPol.setnumPoliza (Integer.parseInt (numPoliza));
            oPol.setnumEndoso (0);
            oPol.setuserId    ("WEB");

            int estado = 0;

            oPol.getDBWeb (dbCon, dni);

            if (oPol.getiNumError() == -1) {
                throw new SurException(oPol.getsMensError());
            }
            if (oPol.getiNumError() == -100 ) {
                estado = 1;
            } else if ( oPol.getcodRama() == 9 ) {
                estado = 2;
            } else if ( oPol.getcodRama() == 21 && (oPol.getCuic() == null || (oPol.getCuic() != null && oPol.getCuic().equals("")))){
                estado = 3;
            } else if (oPol.getcantVidas() > 300 ) {
                estado = 4;
            }
            switch (estado) {
                case 1:
                    sMensa = "La póliza no existe en la web o hay alguna inconsistencia en los datos ingresados.";
                    break;

                case 2:
                    sMensa = "Rama no habilitada para emisi&oacute;n de copia de p&oacute;liza";
                    break;
                case 3:
                    sMensa = "P&oacute;liza sin CUIC. Motivos: puede estar pendiente o no fue aprobada por la SSN.";
                    break;

                case 4:
                    sMensa = "LA POLIZA TIENE MAS DE 300 ASEGURADOS, solicitela desde Contactar Asesor. Gracias";
                    break;

                default:
                    rama = String.valueOf (oPol.getcodRama());
                    int iFecCorte = 20101129;

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                    int iFechaEmision =  Integer.parseInt(
                                       sdf.format(
                                        (oPol.getnumEndoso() == 0 ? oPol.getfechaEmision() :
                                                                    oPol.getfechaEmisionEnd())));
                   if ( iFechaEmision <= iFecCorte ) {
                        sTipoMens = "ER";
                        sMens     = "LA COPIA DE POLIZA SE TIENE QUE ENVIAR DESDE EL AS400 ";
                    } else {
                        try {
                            String sFileSec = sFile + "poliza." + getNumSecuInfo (dbCon);
                            LinkedList lParams = new LinkedList();

                            lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "POLIZA" ));
                            lParams.add ("COMPAN=16");
                            lParams.add ("SECION=" + rama);
                            lParams.add ("POLIZA=" + numPoliza);
                            lParams.add ("OPERAC=1");
                            lParams.add ("ENDOSO=" +  endoso);
                            lParams.add ("POLCUO=CP");
                            lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                            CreateFile(dbCon, "POLIZA", lParams, sFileSec  );

                            Parametro oParam = new Parametro ();
                            oParam.setsCodigo("DC_CLIENT_COMANDO");
                            String sCommand = oParam.getDBValor(dbCon);

                            oParam.setsCodigo("DC_CLIENT_SERVER");
                            String sServer = oParam.getDBValor(dbCon);
                            
                            // Execute a command with an argument that contains a space
                            String[] commands = new String[]{sCommand , sFileSec, sServer };
                            Process child = Runtime.getRuntime().exec(commands);

                            // Se obtiene el stream de salida del programa
                            InputStream is = child.getInputStream();

                            // Se prepara un bufferedReader para poder leer la salida más comodamente.
                            BufferedReader br = new BufferedReader (new InputStreamReader (is));

                            // Se lee la primera linea
                            String aux = br.readLine();
                            sTipoMens =  aux.substring (0,2);
                            sTipoMens2 = aux.substring (0,8);
                            sMens     = aux.substring(3);
                        } catch (Exception e) {
                            sTipoMens = "ER";
                            sMens     = e.getMessage();
                        }
                    }

                   if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                        StringBuilder sMensaje = new StringBuilder ();
                        sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE COPIA DE POLIZA/ENDOSO.\n\n");
                        sMensaje.append("FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
                        sMensaje.append("El usuario ");
                        sMensaje.append("WEB");
                        sMensaje.append(" ha solicitado la copia de la siguiente póliza/endoso: \n\n");
                        sMensaje.append("RAMA  : ").append(rama );
                        sMensaje.append("POLIZA: ").append(Formatos.showNumPoliza( Integer.parseInt (numPoliza))).append( "\n");
                        sMensaje.append("ENDOSO: ").append(Formatos.showNumPoliza( Integer.parseInt (endoso))).append("\n\n");
                        sMensaje.append("La cuenta de correo destino debería ser: ").append(request.getParameter ("email"));
                        sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                        sMensaje.append(sMens).append("\n\n");
                        sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                        Email oEmail = new Email ();
                        oEmail.setSubject("SOLICITUD DE COPIA DE POLIZA" );
                        oEmail.setContent(sMensaje.toString());

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "COPIA_POLIZA");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessage();
                        }
                   }
            }
            
            request.setAttribute ("poliza_mens", sMensa);
            doForward (request, response, "/portal/clientes.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    private static void CreateFile (Connection dbCon,
                                  String sOperacion,
                                  LinkedList lParams,
                                  String sFile )
            throws SurException {

/* Operaciones posibles:
"POLIZA"
"CUPON"
"PRELIQ"
"CTACTE"
"LIQUI"
"RENOPEN"
"COMIS"
*/
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;

        try {
           fos = new FileOutputStream ( sFile );
           osw = new OutputStreamWriter (fos, "8859_1");
           bw = new BufferedWriter (osw);

           for (int i=0; i < lParams.size();i++) {
                bw.write( (String) lParams.get(i) + "\n");
           }

            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("CreateFile:" + e.getMessage());
        } finally {
            try {
                bw.close();
                osw.close();
                fos.close();
            } catch (IOException ee) {
                throw new SurException (ee.getMessage());
            }
        }
    }

  private static int getNumSecuInfo (Connection dbCon) throws SurException {
       CallableStatement cons  = null;
       int lote  = 0;
       try {

           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("GET_NUM_SECU_INFO ()"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.execute();

           lote = cons.getInt(1);

       } catch (Exception e) {
            throw new SurException (e.getMessage());

        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lote;
        }
    }

    private static String getProgramaDC (Connection dbCon, String sOperacion )
            throws SurException {
       CallableStatement cons  = null;

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS_DESCRIPCION (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "PROGRAMA_DC");
           cons.setString (3, sOperacion);
           cons.execute();

           return cons.getString (1);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    protected void descargas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lArch = new LinkedList();
        CallableStatement proc  = null;
        ResultSet rs            = null;
        try {
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));

            }
            dbCon = db.getConnection();

            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("POR_GET_ALL_MANUALES ()"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.execute();
            rs = (ResultSet) proc.getObject(1);

            if (rs != null ) {
                while (rs.next()) {
                    Manual oM = new Manual ();
                    oM.settitulo    (rs.getString("TITULO"));
                    oM.setcategoria (rs.getString("CATEGORIA"));
                    oM.setmensaje   (rs.getString("MENSAJE"));
                    oM.setlink      (rs.getString("LINK"));
                    oM.setmcaBaja   (rs.getString("MCA_BAJA"));
                    oM.setorden     (rs.getInt("ORDEN"));
                    oM.setcodManual (rs.getInt("CODIGO"));
                    oM.settipoUsuario(rs.getInt("TIPO_USUARIO"));
                    lArch.add   (oM);
                }
                rs.close();
            }
            proc.close();

            request.setAttribute ("archivos",lArch);
            doForward (request, response, "/portal/formDownload.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (proc != null) proc.close();
            if (rs != null) rs.close();
        } catch (SQLException se) {
            throw new SurException(se.getMessage());
        }
        db.cerrar(dbCon);
    }
  }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    public void doForward(HttpServletRequest request, HttpServletResponse response,
            String nextPage) throws  ServletException, IOException {
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
