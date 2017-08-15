/*
 * setAccess.java
 *
 * Created on 14 de enero de 2005, 17:46
 */

package servlets;    
       
import java.io.*;
import java.util.LinkedList;
import java.text.SimpleDateFormat;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import javax.servlet.*;
import javax.servlet.http.*;
import com.business.beans.ProductorCobertura;
import com.business.beans.Usuario;
import com.business.beans.Persona;
import com.business.util.*;
import com.business.db.db;

/**
 *
 * @author  surprogra
 * @version
 */
public class setAccess extends HttpServlet {
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    /** Destroys the servlet.
     */
    public void destroy() {
    }
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
      try {
        String op =  request.getParameter ("opcion");
        
        if (op.equals ("LOG")) {
           logUser (request,response); 
        } else if (op.equals("LOGNEW")) {
           logUserNew (request,response);
        } else if (op.equals("LOGOUT")) {
           logOutUser (request,response);
        } else if (op.equals("LOGOUTNEW")) {
           logOutUserNew (request,response);
        } else if (op.equals("ADDPROC")) {
           SetearUsoSistema (request, response);
        } else if (op.equals ("registrar")) {
            registrar (request, response);
        } else if (op.equals ("getAllUsuarios")) {
            getAllUsuarios(request, response);
        } else if (op.equals ("getUsuario")) {
            getUsuario (request, response);
        } else if (op.equals ("addUsuario")) {
            addUsuario (request, response);
        } else if (op.equals ("cambiarEstado")) {
            cambiarEstado (request, response);
        }  else if (op.equals ("changePass")) {
            cambiarClave (request, response);
        }  else if (op.equals ("getSumas")) {
            getSumasAseguradas (request, response);
        }  else if (op.equals ("addProdCob")) {
            this.addCoberturas (request, response);
        } else if (op.equals ("addSumas")) {
            this.addCoberturasDefault  (request, response);
        }
        
      } catch (SurException se) {
          goToJSPError (request,response, se);
      } catch (Exception e) {
          goToJSPError (request,response, e);
      }
    }
    
    private void SetearUsoSistema (HttpServletRequest request, HttpServletResponse response)  
       throws ServletException, IOException, SurException {
    Connection dbCon = null;     
      try {
            dbCon = db.getConnection();                             
            String proc = request.getParameter ("procedencia");
            HttpSession session = request.getSession(true);            
            if (proc != null) {
                ControlDeUso oControl = (ControlDeUso) session.getAttribute("controlUso");  
                oControl.setearAcceso(dbCon, Integer.parseInt (proc)); 
            }
      } catch (SurException se) {
          throw new SurException (se.getMessage());
      } finally {
          db.cerrar(dbCon);
      }
    }

    private void cambiarClave (HttpServletRequest request, HttpServletResponse response)  
       throws ServletException, IOException, SurException {
    Connection dbCon = null;     
      try {
            dbCon = db.getConnection();                             
            HttpSession session = request.getSession(true);            

            Usuario oUser = (Usuario) session.getAttribute("user");
            
            Usuario oNewUser = new Usuario ();
            oNewUser.setusuario(oUser.getusuario());
            oNewUser.setpassword(request.getParameter ("password").toUpperCase());
            
            oNewUser.getDBExiste(dbCon);
            
            if (oNewUser.getiNumError() == 100 || oNewUser.getiNumError() == 200) {
                request.setAttribute("mensaje", "ERROR: La clave NO es correcta o el Usuario NO esta habilitado");
            } else {
                
                if (request.getParameter ("newPassword").toUpperCase().equals(oUser.getpassword())) {
                    request.setAttribute("mensaje", "ERROR: La clave debe ser distinta a la clave actual !");
                } else {
                    oUser.setDBCambiarClave(dbCon, request.getParameter ("newPassword").toUpperCase());
                
                    if ( oUser.getiNumError() != 0 ) {
                        throw new SurException (oUser.getsMensError());
                    }
                    ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                    if (oControl == null) {
                        oControl = new ControlDeUso(oUser.getusuario(), request.getRemoteAddr(), oUser.getiCodProd()); 
                    }
                    oControl.setearAcceso(dbCon, 25);
                    request.setAttribute("mensaje", "La clave ha sido cambiada con exito. Debe volver a ingresar con la nueva clave. Muchas gracias.");
                }
            }
      
            request.setAttribute("volver", Param.getAplicacion() + "portal/extranet.jsp");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      

      } catch (SurException se) {
          throw new SurException (se.getMessage());
      } finally {
          db.cerrar(dbCon);
      }
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
      String op =  request.getParameter ("opcion");

        if (op.equals ("LOG") || op.equals("LOGNEW")) {
            getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        } else {
            processRequest(request, response);
        }
    }

    public void logUser (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        LinkedList lProductores = null;
        LinkedList lClientes = null;
        String sFlag   = getServletContext().getRealPath("/files/ftppino/web_ctl.bloq");
        boolean bBloquear = false;
        try {
            Usuario user        = new Usuario ();
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
            }

           db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));

           dbCon = db.getConnection();
           user.setusuario (request.getParameter("usuario").toUpperCase());
           user.setpassword(request.getParameter("password").toUpperCase());

           user.getDBExiste(dbCon);

           HttpSession session = request.getSession();

           File fFlag = new File (sFlag);
           if (fFlag.exists()) {
               bBloquear = true;
           }

           if (user.getiNumError() == 0 && ! bBloquear ) {
                    session.setAttribute("user", user);

                        ControlDeUso oControl = new ControlDeUso(user.getusuario(),
                                                                request.getRemoteAddr(),
                                                                user.getiCodProd(),
                                                                request.getParameter("browser"),
                                                                request.getParameter("version"),
                                                                request.getParameter("OS"));
                        oControl.setearAcceso(dbCon, 1);
                        session.setAttribute("controlUso", oControl);

                        if (user.getiCodTipoUsuario() == 0 || user.getiCodProd() > 79999) {
                            lProductores = new LinkedList ();
                            lClientes    = new LinkedList ();
                            try {
                                this.getAllProductores(dbCon, user, lProductores, lClientes);
                            } catch (Exception ee) {
                                throw new SurException(ee.getMessage());
                            }

                        }

                        session.setAttribute("Productores", lProductores );
                        session.setAttribute("Clientes", lClientes );
                        doForward (request,response, "/index.jsp?alerta=" + user.getsAlerta());
               
           } else if ( bBloquear ) {
                    request.setAttribute("mensaje", "Estamos actualizando el sistema, por favor, vuelva a intentar en unos minutos. \nSepa disculpar las moestias. Muchas gracias");
                    request.setAttribute("volver", Param.getAplicacion() + "index.htm");
                    doForward (request, response, "/include/MSJServidor.jsp");
           } else if (user.getiNumError() == 100 || user.getiNumError() == 200) {
                    request.setAttribute("mensaje", user.getsMensError());
                    request.setAttribute("volver", Param.getAplicacion() + "index.htm");
                    doForward (request, response, "/include/MSJServidor.jsp");
            } else if (user.getiNumError() == 300) {
                    session.setAttribute("user", user);
                    doForward (request, response, "/usuarios/formChangePassword.jsp");
            } else if (user.getiNumError() == -1) {
                throw  new SurException( user.getsMensError());
            }

        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    public void logUserNew (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        LinkedList lProductores = null;
        LinkedList lClientes = null;
        String sFlag   = getServletContext().getRealPath("/propiedades/web_ctl.bloq");
        boolean bBloquear = false;
        String existeBloqueo = "N";
        try {  
            Usuario user        = new Usuario ();
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
            }

            String sSigte = (request.getParameter("siguiente") == null ? "portal/extranet.jsp" : request.getParameter("siguiente"));
            db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
           
            dbCon = db.getConnection();  
            user.setusuario (request.getParameter("usuario").toUpperCase());
            user.setpassword(request.getParameter("password").toUpperCase());
            
            user.getDBExiste(dbCon);

            HttpSession session = request.getSession();


           File fFlag = new File (sFlag);
           if (fFlag.exists() ) {
               bBloquear = true;
               existeBloqueo = "S";
           }

           if (user.getiNumError() == 0 && (user.getusuario().equals("GLUCERO") || user.getusuario().equals("AGLANC") || user.getusuario().equals("PINO")) ) {
               bBloquear =  false;
           }

           if (user.getiNumError() == 0 && ! bBloquear) {
                    session.setAttribute("user", user);
                    ControlDeUso oControl = new ControlDeUso(user.getusuario(),
                                                            request.getRemoteAddr(),
                                                            user.getiCodProd(),
                                                            request.getParameter("browser"),
                                                            request.getParameter("version"),
                                                            request.getParameter("OS"));
                    oControl.setearAcceso(dbCon, 1);
                    session.setAttribute("controlUso", oControl);

                    if (user.getiCodTipoUsuario() == 0 || user.getiCodProd() > 79999) {
                        lProductores = new LinkedList ();
                        lClientes    = new LinkedList ();
                        try {
                            this.getAllProductores(dbCon, user, lProductores, lClientes);
                        } catch (Exception ee) {
                            throw new SurException(ee.getMessage());
                        }

                    }

                    session.setAttribute("Productores", lProductores );
                    session.setAttribute("Clientes", lClientes );

                    doForward (request,response, "/index.jsp?alerta=" + user.getsAlerta() + "&flag=" + existeBloqueo + "&pri=S");

           } else if ( bBloquear ) {
                    session.setAttribute("user", user);   
                    request.setAttribute("mensaje", "Estamos actualizando el sistema, por favor, vuelva a intentar en unos minutos. Sepa disculpar las molestias. Muchas gracias");
                    request.setAttribute("volver", Param.getAplicacion() + "portal/extranet.jsp");
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else if (user.getiNumError() == 100 || user.getiNumError() == 200) {
                    request.setAttribute("mensaje", user.getsMensError());
                    request.setAttribute("volver", Param.getAplicacion() + sSigte );
                    doForward (request, response, "/include/MSJServidor.jsp");                      
            } else if (user.getiNumError() == 300) {
                    session.setAttribute("user", user);
                    doForward (request, response, "/usuarios/formChangePassword.jsp");                      
            } else if (user.getiNumError() == -1) {
                throw  new SurException( user.getsMensError());
            }
           
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    public void getAllProductores (Connection dbCon , Usuario user, LinkedList lProductores, LinkedList lClientes)
    throws ServletException, IOException, SurException {

        CallableStatement cons = null;
        ResultSet rs           = null;
        try {

                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_PROD_CLIENTES(?, ?, ?, ?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt (2, user.getiCodTipoUsuario());
                
                if (user.getzona() == 0) {
                    cons.setNull(3, java.sql.Types.INTEGER);
                } else {
                    cons.setInt (3, user.getzona ());
                }
                cons.setInt (4, user.getiCodProd());
                if (user.getoficina() == 0) {
                    cons.setNull(5, java.sql.Types.INTEGER);
                } else {
                    cons.setInt (5, user.getoficina());
                }
                

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        Usuario prod = new Usuario ();
                        prod.setDoc         (rs.getString ("DOCUMENTO"));
                        prod.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                        prod.setiCodTipoUsuario(rs.getInt ("TIPO_USUARIO"));                                
                        prod.setsHabilitado  (rs.getString ("HABILITADO"));
                        prod.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                        prod.setiCodProd    (rs.getInt ("COD_PROD"));
                        prod.setNom         (rs.getString ("NOMBRE"));
                        prod.setApellido    (rs.getString ("APELLIDO")); 
                        prod.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                        prod.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                        prod.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                        prod.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                        prod.setNumIB       (rs.getString ("NUMERO_IB"));
                        prod.setSexo        (rs.getString ("SEXO"));
                        prod.setEmail       (rs.getString ("EMAIL"));
                        prod.setFax         (rs.getString ("FAX"));
                        prod.setTel1        (rs.getString ("TELEFONO1"));
                        prod.setsDesPersona (rs.getString ("DESCRIPCION"));
                        prod.setoficina     (rs.getInt    ("OFICINA"));
                        prod.setiNumTomador (rs.getInt    ("NUM_TOMADOR"));
                        prod.setsCodProdDC  (rs.getString ("COD_PROD_DC"));

                        if (prod.getiCodTipoUsuario() == 1) {
                            lProductores.add (prod); 
                        } else {
                            lClientes.add (prod);
                        }
                   }
                    rs.close();
                }
                cons.close();
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            try {
                if (rs   != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

        
    public void getAllUsuarios (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement proc = null;
        try {
            Usuario user        = (Usuario) (request.getSession().getAttribute("user"));
            
            String sEstado = (request.getParameter ("estado") == null ? "A" : request.getParameter ("estado"));
            LinkedList lUsuarios = new LinkedList ();
            
            dbCon = db.getConnection();  
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_USUARIOS (?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setString (2, sEstado);

            proc.execute();
            
            ResultSet rs = (ResultSet) proc.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Usuario oUser = new Usuario ();
                    oUser.setDoc         (rs.getString ("DOCUMENTO"));
                    oUser.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    oUser.setdescTipoDoc (rs.getString ("DESC_TIPO_DOC"));
                    oUser.setusuario      (rs.getString ("USUARIO"));
                    oUser.setpassword     (rs.getString ("CLAVE"));
                    oUser.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    oUser.setsHabilitado  (rs.getString ("HABILITADO"));
                    oUser.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    oUser.setUsuario     (rs.getString ("USERID"));
                    oUser.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    oUser.setiCodProd    (rs.getInt ("COD_PROD"));
                    oUser.setsObservacion(rs.getString ("OBSERVACION"));
                    oUser.setNom         (rs.getString ("NOMBRE"));
                    oUser.setApellido    (rs.getString ("APELLIDO")); 
                    oUser.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    oUser.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    oUser.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    oUser.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    oUser.setNumIB       (rs.getString ("NUMERO_IB"));
                    oUser.setSexo        (rs.getString ("SEXO"));
                    oUser.setEmail       (rs.getString ("EMAIL"));
                    oUser.setFax         (rs.getString ("FAX"));
                    oUser.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    oUser.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    oUser.setTel1        (rs.getString ("TELEFONO1"));
                    oUser.setTel2        (rs.getString ("TELEFONO2"));
                    oUser.setsDesPersona (rs.getString ("DESCRIPCION") );
                    
                    lUsuarios.add(oUser);
                }
                rs.close();
            }
            
            request.setAttribute("usuarios", lUsuarios );
            doForward (request,response, "/usuarios/consultaUsuarios.jsp");  
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            try {
                if (proc != null) proc.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    public void getUsuario (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();  
            Usuario user        = new Usuario ();
            
//           int iNumSecuUsu = request.getParameter ("numSecuUsu") == null ? -1 :
//                Integer.parseInt (request.getParameter ("numSecuUsu"));
//           user.setiNumSecuUsu(iNumSecuUsu);

            if (request.getParameter("usuario") == null ) {
                user.setiNumSecuUsu(-1);
            } else {
                user.setusuario(request.getParameter("usuario"));
            
                user.getDBUsuario(dbCon);
                if (user.getiNumError() < 0) {
                    throw new SurException(user.getsMensError());
                }
            }
            
            request.setAttribute("usuario", user );
            doForward (request,response, "/usuarios/formUsuario.jsp");  
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    public void getSumasAseguradas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();  
            Usuario user     = new Usuario ();
           
//            int iNumSecuUsu = request.getParameter ("numSecuUsu") == null ? -1 :
//                Integer.parseInt (request.getParameter ("numSecuUsu"));
//            user.setiNumSecuUsu(iNumSecuUsu);
            user.setusuario(request.getParameter("usuario"));
            
            user.getDBUsuario(dbCon);
            
            request.setAttribute("productor", user );
            doForward (request,response, "/usuarios/formSumasAseg.jsp");  
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    public void cambiarEstado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();  
//            int iNumSecuUsu = request.getParameter ("numSecuUsu") == null ? -1 :
//            Integer.parseInt (request.getParameter ("numSecuUsu"));
            Usuario user        = new Usuario ();
//            user.setiNumSecuUsu(iNumSecuUsu);
            user.setusuario(request.getParameter ("usuario"));
            user.getDBUsuario(dbCon);

            if (user.getiNumError() < 0) {
                throw new SurException(user.getsMensError());
            } else {
                user.setDBCambiarEstado (dbCon);
            }
            
            String sVolver = "/benef/servlet/setAccess?opcion=getAllUsuarios&estado=" + request.getParameter ("estado");
            
            if (request.getParameter ("volver").equals ("filtrar")) {
                sVolver = "/benef/usuarios/filtrarUsuarios.jsp";
            }
            
            if ( user.getsHabilitado() != null && ! user.getsHabilitado().equals ("X")) {
                if (user.getsHabilitado().equals("S")) {
                    request.setAttribute("mensaje", "El usuario fue Habilitado con exito. ");
                } else {
                    request.setAttribute("mensaje", "El usuario fue Deshabilitado con exito. ");
                }
            } else {
                request.setAttribute("mensaje", "El usuario no pudo ser actualizado. ");
            }
            
            request.setAttribute("volver", sVolver );
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    
    public void logOutUser (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        try {
      
            HttpSession session = request.getSession();
            session.setAttribute("user", null);
            session.setAttribute("Productores", null);
            session.setAttribute("Clientes", null);

            session.invalidate();
            
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location","/benef/index.htm");

        } catch (Exception se) {
            throw new SurException  (se.getMessage());
        }
    }

    public void logOutUserNew (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        try {

            HttpSession session = request.getSession();
            session.setAttribute("user", null);
            session.setAttribute("Productores", null);
            session.setAttribute("Clientes", null);

            session.invalidate();


            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location", Param.getAplicacion() + "portal/extranet.jsp");

        } catch (Exception se) {
            throw new SurException  (se.getMessage());
        }
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
    
     public void registrar (HttpServletRequest request, HttpServletResponse response) throws SurException {
        Connection dbCon = null;
         try {       
            db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));            
            if (Param.getAplicacion() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml")); 
            }

            Usuario oUser = new Usuario ();
            oUser.setTipoDoc   (request.getParameter("tipoDoc"));
            oUser.setDoc       (request.getParameter("numDoc"));
            oUser.setRazonSoc  (request.getParameter("nombre"));
            oUser.setTel1      (request.getParameter("tel1"));
            oUser.setTel2      (request.getParameter("tel2"));
            oUser.setEmail     (request.getParameter("email"));
            oUser.setsObservacion(request.getParameter("comentarios"));
            oUser.setiCodProd  (request.getParameter("cod_prod") == null || request.getParameter("cod_prod").equals ("") ? 0 : Integer.parseInt (request.getParameter("cod_prod")));
            oUser.setoficina   (request.getParameter("oficina") == null || request.getParameter("oficina").equals ("") ? 1 : Integer.parseInt (request.getParameter("oficina")));            

            String sTD = "DNI";
            if (oUser.getTipoDoc().equals ("80") ) 
                sTD = "CUIT";
            else if (oUser.getTipoDoc().equals ("89") ) 
                sTD = "LE";
            else if (oUser.getTipoDoc().equals ("90") ) 
                sTD = "LC";
            
            String sOficina = "no informado";
            if (oUser.getoficina() == 2 ) 
                sOficina = "BUENOS AIRES";
            else if (oUser.getoficina ()== 3 ) 
                sOficina = "SALTA";
            else if (oUser.getoficina () == 1 ) 
                sOficina = "ROSARIO";
            
            

            dbCon = db.getConnection(); 
//             oUser.getDBRegistracion(dbCon);
             
            StringBuilder sMensaje = new StringBuilder ();
            StringBuilder sSubject = new StringBuilder ();
            Email oEmail = new Email ();

            sSubject.append("Beneficio Web - Aviso Solicitud de Registración N ").append( oUser.getiNumSecuUsu());
            oEmail.setSubject(sSubject.toString());

            sMensaje.append("   FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
            sMensaje.append("NOMBRE y APELLIDO: ").append(oUser.getRazonSoc()).append("\n");
            sMensaje.append("COD. de PRODUCTOR: ").append(oUser.getiCodProd()).append("\n");
            sMensaje.append("OFICINA          : ").append(sOficina).append("\n");
            sMensaje.append("DOCUMENTO        : ").append(sTD ).append(" " ).append(oUser.getDoc()).append( "\n");
            sMensaje.append("TELEFONOS        : ").append(oUser.getTel1 ()).append("   ").append(oUser.getTel2 ()).append("\n");
            sMensaje.append("EMAIL            : ").append(oUser.getEmail()).append("\n\n");
            sMensaje.append("COMENTARIOS      : ").append(oUser.getsObservacion()).append("\n");

            oEmail.setContent(sMensaje.toString());
            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "REGISTRO");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
              //  oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }

            request.setAttribute("mensaje", "La <b>solicitud fue enviada con exito. Pronto un representante se contactará con usted.<br><br> Muchas Gracias.");

            request.setAttribute("volver",  "/benef/index.htm");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
        } catch (Exception e) {
            throw new SurException ("Error al grabar el Usuario " + e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
     
     public void addUsuario (HttpServletRequest req, HttpServletResponse resp) 
     throws IOException, ServletException, SurException {
         Connection dbCon    = null;
         HttpSession session = req.getSession(true);
         Usuario user        = (Usuario) session.getAttribute("user");

         Usuario oUsuario    = new Usuario ();
        
         dbCon = db.getConnection();
         SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");         
         try {
             oUsuario.setiNumSecuUsu(Integer.parseInt (req.getParameter ("numSecuUsu")));
             if (oUsuario.getiNumSecuUsu() != -1) {
                oUsuario.setusuario     (req.getParameter("usuario").toUpperCase() );
                oUsuario.getDBUsuario(dbCon);
             } else {

                oUsuario.setiCodTipoUsuario(Integer.parseInt (req.getParameter ("tipoUsuario")));
                
                oUsuario.setTipoDoc      (req.getParameter("tipoDoc"));
                oUsuario.setDoc          (req.getParameter("numDoc").trim());             
                oUsuario.setCategoria    (oUsuario.getTipoDoc().equals ("80") ? "J" : "F");                 
             }
             
             oUsuario.setTel1         (req.getParameter("tel1").trim());
             oUsuario.setTel2         (req.getParameter("tel2").trim());
             
             oUsuario.setFax          (req.getParameter("fax").trim());
             oUsuario.setEmail        (req.getParameter("email").trim());
             oUsuario.setCodCondIVA   (Integer.parseInt(req.getParameter("Sel_iva")));                             
             
             oUsuario.setCuit         (req.getParameter ("cuit")); 
             if ( oUsuario.getCategoria().equals("F") ) {
                oUsuario.setNom       (req.getParameter("nombre").trim());
                oUsuario.setApellido  (req.getParameter("apellido").trim());
                String fNac = (req.getParameter("fNac") == null ? "" : req.getParameter ("fNac"));                
             } else {
                oUsuario.setRazonSoc     (req.getParameter("razonSoc"));
                oUsuario.setNumIB        (req.getParameter("numIB"));
                oUsuario.setCodCondIB    (Integer.parseInt (req.getParameter("Sel_ib")));
             }
             
             oUsuario.setpassword   (req.getParameter ("password"));
             
             switch (oUsuario.getiCodTipoUsuario() ) {
                 case 0:
                    oUsuario.setsHabilitado("S");                                      
                    oUsuario.setusuario     (req.getParameter("usuario"));
                    oUsuario.setiNumTomador (0);
                    oUsuario.setiCodProd    (0);
                     oUsuario.setmenu(req.getParameter ("menu") != null ?
                                    Integer.parseInt(req.getParameter ("menu") ) : 0);
                    break;
                 
                 case 1:
                    oUsuario.setsHabilitado("S");
                    oUsuario.setiCodProd   (req.getParameter ("cod_prod").equals ("") ? 0 : Integer.parseInt (req.getParameter ("cod_prod")));
                    
                    if (Integer.parseInt (req.getParameter ("cod_prod")) < 80000) {
                        oUsuario.setorganizador   (req.getParameter ("organizador").equals ("") ? 0 : Integer.parseInt (req.getParameter ("organizador")));                        
                    } else {
                        oUsuario.setorganizador (0);
                    }
                    oUsuario.setcodProdAnt(req.getParameter ("cod_prod_ant").equals ("") ? 0 : Integer.parseInt (req.getParameter ("cod_prod_ant")));
                    oUsuario.setcodOrgAnt(req.getParameter ("cod_org_ant").equals ("") ? 0 : Integer.parseInt (req.getParameter ("cod_org_ant")));
                    
                    oUsuario.setusuario    (String.valueOf(oUsuario.getiCodProd()));
                    oUsuario.setiNumTomador(0);
                    oUsuario.setmenu(req.getParameter ("menu") != null ?
                            Integer.parseInt(req.getParameter ("menu") ) : 1);
                     break;

                 default:
                    oUsuario.setsHabilitado("S");                                      
                    oUsuario.setusuario    (req.getParameter("usuario"));                     
                    oUsuario.setiCodProd   (0);                    
                    oUsuario.setiNumTomador(req.getParameter ("num_tomador").equals ("") ? 0 : Integer.parseInt (req.getParameter ("num_tomador")));                    
                    oUsuario.setmenu(req.getParameter ("menu") != null ? 
                            Integer.parseInt(req.getParameter ("menu") ) : 2); 
             }

            oUsuario.setoficina (req.getParameter ("oficina").equals ("") ? 0 : Integer.parseInt (req.getParameter ("oficina")));
            oUsuario.setzona    (req.getParameter ("zona").equals ("") ? 0 : Integer.parseInt (req.getParameter ("zona")));             
             
// DATOS DEL DOMICILIO 
                
            oUsuario.setCalle         (req.getParameter("calle"));
            oUsuario.setNumero        (req.getParameter("numero"));
            oUsuario.setPiso          (req.getParameter("piso"));
            oUsuario.setDepto         (req.getParameter("dpto"));
            oUsuario.setLocalidad     (req.getParameter("localidad"));
            oUsuario.setCodigoPostal  (req.getParameter("codPostal"));
            oUsuario.setPcia          (req.getParameter("Sel_pcia"));
            oUsuario.setsSistGestion  (req.getParameter("Sel_gestion"));
            oUsuario.setPais          (req.getParameter("Sel_pais"));

            oUsuario.setsObservacion(req.getParameter ("observacion"));
             
            oUsuario.setUsuario(user.getusuario());
             
            oUsuario.setDB     (dbCon); 
            
            if (oUsuario.getiNumSecuUsu() < 0) {
                    if (oUsuario.getiNumSecuUsu() == -2) {
                        req.setAttribute("mensaje", "El usuario ya existe cargado.Por favor, verifique por la consulta de usuarios la existencia. ");
                    } else {
                        req.setAttribute("mensaje", "El usuario no pudo ser actualizado ");
                    }
            } else {
                req.setAttribute("mensaje", "El usuario N° " + oUsuario.getusuario() + " fue actualizado exitosamente.<br> En el caso que el usuario sea nuevo recuerde que debe habilitarlo ");
            }

            String sVolver =  Param.getAplicacion() + "servlet/setAccess?opcion=getAllUsuarios&estado=" + req.getParameter ("estado");

            if (req.getParameter ("volver") != null && 
                !req.getParameter ("volver").equals("")) {
                    if (req.getParameter ("volver").equals("getAllUsuarios")) {
                        req.setAttribute("volver", sVolver);
                    } else if (req.getParameter ("volver").equals("filtrar")) {
                                sVolver =  Param.getAplicacion() + "usuarios/filtrarUsuarios.jsp";
                                req.setAttribute("volver", sVolver);                        
                    }
            }
  
// PARA TODOS LOS USUARIOS - A PEDIDO DE VICTOR 21/06/2012
            if (oUsuario.getiCodTipoUsuario() == 1) {
                if  ( ! ( user.getFax().trim ().equals (oUsuario.getFax().trim()) && 
                    user.getTel1().trim().equals (oUsuario.getTel1().trim() ) &&
                    user.getTel2().trim().equals (oUsuario.getTel2().trim() ) && 
                    user.getEmail().trim().equals (oUsuario.getEmail().trim() ) &&                    
                    user.getCalle().trim().equals (oUsuario.getCalle().trim()) &&                  
                    user.getNumero().trim().equals (oUsuario.getNumero().trim() ) &&                    
                    user.getDepto().trim().equals (oUsuario.getDepto().trim()) &&                    
                    user.getPiso().trim().equals (oUsuario.getPiso().trim()) &&                    
                    user.getLocalidad().trim().equals (oUsuario.getLocalidad().trim()) &&                    
                    user.getCodigoPostal().trim().equals (oUsuario.getCodigoPostal().trim()) &&                     
                    user.getPcia().trim().equals (oUsuario.getPcia().trim()) &&                     
                    user.getsObservacion().trim().equals ( oUsuario.getsObservacion().trim())) ) {
                    
                   this.sendEmailChangeUser(dbCon, user, oUsuario);
                
                }
            }

            this.doForward(req, resp, "/include/MsjHtmlServidor.jsp");
            
        } catch (Exception e) {
            throw new SurException ("Error al grabar el Usuario " + e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
     }

    protected void sendEmailChangeUser (Connection dbCon, Usuario user, Usuario oUsuario)
    throws ServletException, IOException, SurException {
        StringBuilder sMensaje = new StringBuilder();
        String sMsgCuotas = "";
        try {
            
            sMensaje.append("AVISO DE MODIFICACION DE DATOS DEL PRODUCTOR ").append( user.getsDesPersona()).append(" - Cod. ").append(user.getiCodProd()).append("\n");
            sMensaje.append("-------------------------------------------------------------------------------------\n\n");

            sMensaje.append("El productor ha modificado desde la web la siguiente información:\n");
           
            if  (!  user.getFax().trim ().equals (oUsuario.getFax().trim())) 
                sMensaje.append("FAX: ").append(oUsuario.getFax().trim()).append("\n");
            if  (!  user.getTel1().trim().equals (oUsuario.getTel1().trim() ))
                sMensaje.append("TELEFONO : ").append(oUsuario.getTel1().trim()).append("\n");
            if  (!  user.getTel2().trim().equals (oUsuario.getTel2().trim() ))
                sMensaje.append("TELEFONO: ").append(oUsuario.getTel2().trim()).append("\n");
            if  (!  user.getEmail().trim().equals (oUsuario.getEmail().trim() ))                    
                sMensaje.append("EMAIL: ").append(oUsuario.getEmail().trim()).append("\n");
            if  (!  user.getCalle().trim().equals (oUsuario.getCalle().trim()) )                  
                sMensaje.append("DIRECCION - CALLE : ").append(oUsuario.getCalle().trim()).append("\n");
            if  (!  user.getNumero().trim().equals (oUsuario.getNumero().trim()))                    
                sMensaje.append("DIRECCION - NUMERO: ").append(oUsuario.getNumero().trim()).append("\n");
            if  (!  user.getDepto().trim().equals (oUsuario.getDepto().trim()))                    
                sMensaje.append("DIRECCION - DEPTO : ").append(oUsuario.getDepto().trim()).append("\n");
            if  (!  user.getPiso().trim().equals (oUsuario.getPiso().trim()))                    
                sMensaje.append("DIRECCION - PISO  : ").append(oUsuario.getPiso().trim()).append("\n");
            if  (!  user.getLocalidad().trim().equals (oUsuario.getLocalidad().trim()))                    
                sMensaje.append("DIRECCION - LOCALIDAD : ").append(oUsuario.getLocalidad().trim()).append("\n");
            if  (!  user.getCodigoPostal().trim().equals (oUsuario.getCodigoPostal().trim()))                     
                sMensaje.append("DIRECCION - COD.POSTAL: ").append(oUsuario.getCodigoPostal().trim()).append("\n");
            if  (!  user.getPcia().trim().equals (oUsuario.getPcia().trim()))                     
                sMensaje.append("DIRFECCION - PCIA: ").append(oUsuario.getPcia().trim()).append("\n");
            if  (!  user.getsObservacion().trim().equals (oUsuario.getsObservacion().trim()))
                sMensaje.append("OBSERVACIONES: ").append(oUsuario.getsObservacion().trim()).append("\n");
            
            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();
            StringBuilder sSub = new StringBuilder();
            sSub.append("Beneficio Web - AVISO de MODIFICACION DE DATOS DEL PRODUCTOR (").append(user.getiCodProd()).append(")");
            oEmail.setSubject(sSub.toString());

            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0 , "MODIF_PRODUCTOR");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                 //   oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        }
    }
    
    protected void addCoberturas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            int codRama      = Integer.parseInt (request.getParameter("cod_rama"));
            int codProd      = Integer.parseInt (request.getParameter("cod_prod"));
            int numSecuUsu   = Integer.parseInt (request.getParameter("numSecuUsu"));
            
            dbCon = db.getConnection();
  
            int iCantCob = Integer.parseInt ( request.getParameter ("CANT_COB"));
             boolean bChange = false;
            
            for (int ii = 1; ii <= iCantCob; ii++) {                
                 if (Dbl.StrtoDbl (request.getParameter ("SUMA_" + ii)) != Dbl.StrtoDbl (request.getParameter ("SUMA_ANT_" + ii))) {
                    bChange = true;
                    break;
                 }
            }
    
            if (bChange) {           
                for (int i = 1; i <= iCantCob; i++) {
                    ProductorCobertura oCob = new ProductorCobertura ();

                    oCob.setcodRama      (codRama);
                    oCob.setcodSubRama   (Integer.parseInt (request.getParameter ("SUB_RAMA_" + i)));
                    oCob.setcodProd      (codProd );
                    oCob.setcodCob       (Integer.parseInt (request.getParameter ("COB_" + i)));
                    oCob.setmaxSumaAseg  (Dbl.StrtoDbl (request.getParameter ("SUMA_" + i)));
                    oCob.setuserId ( ((Usuario) request.getSession().getAttribute("user")).getusuario());
                    oCob.setnumOrden(i);

                    oCob.setDB(dbCon); 

                    if (oCob.getiNumError() != 0) {
                        throw new SurException (oCob.getsMensError());
                    }
                }
            }

            request.setAttribute("mensaje", "Las sumas han sido grabadas exitosamente.</br><br><br> Muchas Gracias.");
            request.setAttribute("volver", Param.getAplicacion() + "servlet/setAccess?opcion=getSumas&cod_rama=" + codRama + "&numSecuUsu=" + numSecuUsu );             
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void addCoberturasDefault (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            int codRama      = Integer.parseInt (request.getParameter("cod_rama"));
            int iCodProd     = Integer.parseInt (request.getParameter("cod_prod") == null ? "99999999" :
                                                 request.getParameter("cod_prod") );
            String usuario   = (request.getParameter("usuario") == null ? "" : request.getParameter("usuario"));

            dbCon = db.getConnection();
  
            int iCantCob = Integer.parseInt ( request.getParameter ("CANT_COB"));
             boolean bChange = false;
            
            for (int ii = 1; ii <= iCantCob; ii++) {                
                 if (Dbl.StrtoDbl (request.getParameter ("SUMA_" + ii)) != Dbl.StrtoDbl (request.getParameter ("SUMA_ANT_" + ii)) ||
                     Dbl.StrtoDbl (request.getParameter ("SUMA_MIN_" + ii)) != Dbl.StrtoDbl (request.getParameter ("SUMA_MIN_ANT_" + ii)) ) {
                    bChange = true;
                    break;
                 }
            }
    
            if (bChange) {           
                for (int i = 1; i <= iCantCob; i++) {
                    if (Dbl.StrtoDbl (request.getParameter ("SUMA_" + i)) > 0 &&
                        Dbl.StrtoDbl (request.getParameter ("SUMA_MIN_" + i)) <=
                        Dbl.StrtoDbl (request.getParameter ("SUMA_" + i)) ) {
                            ProductorCobertura oCob = new ProductorCobertura ();

                            oCob.setcodRama      (codRama);
                            oCob.setcodSubRama   (Integer.parseInt (request.getParameter ("SUB_RAMA_" + i)));
                            oCob.setcodProd      ( iCodProd );
                            oCob.setcodCob       (Integer.parseInt (request.getParameter ("COB_" + i)));
                            oCob.setmaxSumaAseg  (Dbl.StrtoDbl (request.getParameter ("SUMA_" + i)));
                            oCob.setminSumaAseg  (Dbl.StrtoDbl (request.getParameter ("SUMA_MIN_" + i)));
                            oCob.setuserId ( ((Usuario) request.getSession().getAttribute("user")).getusuario());
                            oCob.setnumOrden(i);

                            oCob.setDB(dbCon);

                            if (oCob.getiNumError() != 0) {
                                throw new SurException (oCob.getsMensError());
                            }
                    }
                }
            }

             String sMensaje = "Las sumas han sido grabadas exitosamente.";
             String sVolver  = "";

             if ( usuario.equals("") ) {
                sVolver = Param.getAplicacion() + "abm/formSumasAseg.jsp?cod_rama=" + codRama + "&numSecuUsu=-1&cod_prod=" + iCodProd;
            } else  {
                sVolver = Param.getAplicacion() + "servlet/setAccess?opcion=getSumas&cod_rama=" + codRama + "&usuario=" + usuario;
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
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) throws ServletException, IOException {
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
