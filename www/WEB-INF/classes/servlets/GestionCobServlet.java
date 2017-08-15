package servlets;    
      
import java.io.*;
import java.util.LinkedList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;    
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;
import java.sql.CallableStatement;
import javax.servlet.*;
import javax.servlet.http.*;
import com.business.beans.GestionCabDetalle;
import com.business.beans.GestionTexto;
import com.business.beans.CabeceraGestion;
import com.business.beans.ProcesarReportes;
import com.business.beans.Usuario;
import com.business.beans.TemplateTabla;
import com.business.util.Parametro;
import com.business.db.db;
import com.business.util.Email;
import com.business.util.Fecha;
import com.business.util.SurException;
import com.business.util.Param;
import jxl.*;
import jxl.JXLException;
import java.text.SimpleDateFormat;
import java.util.Locale;

public class GestionCobServlet extends HttpServlet {    
protected void doGet(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException 
{
        processRequest(request, response);
}
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException 
    {
        processRequest(request, response);
    }    
    
   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException 
   {
      try {
        String op =  request.getParameter ("opcion");
        
        if (op.equals ("getProcesarGestion")) {
           getProcesarGestion (request,response); 
        } else if (op.equals ("setImportarExcel")) {
           setImportarExcel (request,response); 
        } else if (op.equals ("setProcesarEnvios")) {
           setProcesarEnvios(request,response); 
        } else if (op.equals ("getPopUp")) {
           getPopUp (request,response);
        } else if (op.equals ("procAutomat")) {
           getGestionAutomatica (request,response);
        }

      } catch (SurException se) {
          goToJSPError (request,response, se);
      } catch (Exception e) {
          goToJSPError (request,response, e);
      }
    }

    private void getPopUp(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException, SurException
    {
        Connection dbCon = null;

        try{
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int codTexto  = Integer.parseInt (request.getParameter ("cod_texto"));

	    GestionTexto oGestionTexto  = new GestionTexto();
            oGestionTexto.setCodTexto(codTexto);
    	    dbCon = db.getConnection();

            oGestionTexto.getDB (dbCon);

            if (oGestionTexto.getCodError() < 0 ) {
                throw new SurException( (oGestionTexto.getMensajeError()));
            }

            request.setAttribute("gestionTexto"  , oGestionTexto);
            doForward (request, response, "/gestionCob/PopUpTexto.jsp");


      } catch (SurException se) {
          throw new SurException (se.getMessage());
      } catch (Exception e) {
          throw new SurException (e.getMessage());
      } finally {
          db.cerrar(dbCon);
      }
    }
   
    private void getProcesarGestion (HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException, SurException 
    {        
        Connection dbCon = null;     
         CallableStatement cons = null;
         ResultSet rs = null;

        try{
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int codGestion      = Integer.parseInt (request.getParameter ("cod_gestion") == null ? "0" :
                                                     request.getParameter ("cod_gestion"));
            int codTemplate     =  Integer.parseInt (request.getParameter ("cod_template") == null ? "3" :
                                                     request.getParameter ("cod_template"));
            String tipoProceso  = (request.getParameter ("tipo_proceso") == null ? "M" : request.getParameter ("tipo_proceso") );

            LinkedList   lCampos             = new LinkedList ();
            LinkedList   lTexto              = new LinkedList  ();     
	    GestionTexto oGestionTexto       = new GestionTexto();
	    CabeceraGestion oCabeceraGestion = new CabeceraGestion();

    	    dbCon = db.getConnection();			

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_TEMPLATE_TABLA(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, codTemplate);
            cons.execute();

            rs =  (ResultSet) cons.getObject(1);
            if (rs != null ) {
                while (rs.next()) {
                    TemplateTabla oT = new TemplateTabla();
                    oT.setCodTemplate   (rs.getInt("COD_TEMPLATE"));
                    oT.setdescripcion   (rs.getString("DESCRIPCION"));
                    oT.setdetalle       (rs.getString("DETALLE"));
                    oT.setnumCampo      (rs.getInt("NUM_CAMPO"));
                    oT.setobligatorio   (rs.getString("OBLIGATORIO"));
                    oT.settipoDato      (rs.getString("TIPO_DATO"));
                    oT.setvalidaMailProd(rs.getString("VALIDA_MAIL_PROD"));
                    lCampos.add(oT);
                }
                rs.close();
            }
            cons.close();

            if (tipoProceso.equals("M")) {
                oGestionTexto.setUsuario     (oUser.getusuario());
            } else {
                oGestionTexto.setUsuario     ("AUTOMAT");
            }
            oGestionTexto.setCodTemplate (codTemplate);
            lTexto = oGestionTexto.getDBTextos(dbCon);	
            //--
	    //Obtengo los  textos  disponubles
            if (oGestionTexto.getCodError() < 0) {
                throw new SurException (oGestionTexto.getMensajeError());
            }		
	    //Obtengo la ultima gestion si es cero
            if (tipoProceso.equals ("M")) {
                oCabeceraGestion.setUsuario    (oUser.getusuario());
            } else {
                // PROCESO AUTOMATICO, NO SE TIENE QUE CARGAR NINGUN EXCEL
                oCabeceraGestion.setUsuario    ("AUTOMAT");
            }
	    oCabeceraGestion.setCodGestion (codGestion);
            oCabeceraGestion.setCodTemplate(codTemplate);

            oCabeceraGestion.getDB(dbCon);
	    if (oCabeceraGestion.getCodError() < 0) {
               throw new SurException (oCabeceraGestion.getMensajeError());
             }

            request.setAttribute("listaCampos", lCampos);
            request.setAttribute("listAllTexto", lTexto);        
            request.setAttribute("ultimaGestion"  , oCabeceraGestion);

            if (tipoProceso.equals("A")) { // reporte de No gestionar
                LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 86 , "D","BATCH");

                if (lReportes.size() > 0) {
                   ProcesarReportes.ProcesarReporte(dbCon, lReportes);
                }
            }
            doForward (request, response, "/gestionCob/procesarGestion.jsp");	
			
	    	
      } catch (SurException se) {
          throw new SurException (se.getMessage());
      } catch (Exception e) {
          throw new SurException (e.getMessage());
      } finally {
          db.cerrar(dbCon);
      }
    }

protected void setImportarExcel(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException, SurException {

LinkedList hFilaAux   = new LinkedList();
LinkedList nameCol    = new LinkedList();
LinkedList typeCol    = new LinkedList();
LinkedList validaCol  = new LinkedList();
int iErrores  = 0;
Connection dbCon       = null;
CabeceraGestion oCabeceraGestion = new CabeceraGestion();

int     cantidadFilasExcel = 0 ;
int     lineaExcel = 0;
int     iFilaSize = 0;
String par = "[0-9]*";
boolean bError = false;
boolean bRechazarArchivo = false;
boolean bWarning = false;
 CallableStatement cons = null;
 ResultSet rs = null;

try {
    String email   =  new String();
    Usuario oUser  = (Usuario) (request.getSession().getAttribute("user"));

    int iCodTexto   = Integer.parseInt (request.getParameter ("cod_texto"));
    int codGestion  = Integer.parseInt (request.getParameter ("cod_gestion"));
    int codTemplate = Integer.parseInt (request.getParameter("cod_template"));
    String nameFile = request.getParameter ("name_file");

    String pathReal     = this.getServletConfig().getServletContext().getRealPath("/files/gestionCob/") ;
    String pathRealBack = this.getServletConfig().getServletContext().getRealPath("/files/gestionCob/back") ;

    String path     = pathReal + "/" + nameFile;
    int indice = 0;
    int colProductor = -1;
    
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_TEMPLATE_TABLA(?)"));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.setInt (2, codTemplate);
    cons.execute();
    rs =  (ResultSet) cons.getObject(1);
    if (rs != null ) {
        while (rs.next()) {
            nameCol.add(indice, rs.getString ("DESCRIPCION"));
            typeCol.add(indice, rs.getString ("TIPO_DATO"));
            validaCol.add(indice, rs.getString("OBLIGATORIO"));
            if (rs.getString ("VALIDA_MAIL_PROD").equals("S")) {
                colProductor = indice;
            }
            indice += 1;
        }
        rs.close();
    }
    cons.close();

    this.getInfoByXlsGestion (hFilaAux, typeCol, nameCol, path, 0 );

    cantidadFilasExcel = hFilaAux.size() ;

    if (hFilaAux!=null  && hFilaAux.size() > 0) {
        iFilaSize     = hFilaAux.size();// Filas del  Excel
        oCabeceraGestion.setCodGestion(codGestion);
        oCabeceraGestion.setCodTexto( iCodTexto );
        oCabeceraGestion.setUsuario(oUser.getusuario() );
        oCabeceraGestion.setFilaArchivo(cantidadFilasExcel);
        oCabeceraGestion.setArchivo(nameFile);
        oCabeceraGestion.setDB(dbCon);

        if (oCabeceraGestion.getCodError() < 0 ) {
            throw new SurException(oCabeceraGestion.getMensajeError());
        }
        oCabeceraGestion.setDBResetDetalle(dbCon);
        if (oCabeceraGestion.getCodError() < 0 ) {
            throw new SurException(oCabeceraGestion.getMensajeError());
        }

        codGestion = oCabeceraGestion.getCodGestion();

        for ( int i=0 ; i< iFilaSize ; i++ ){
            GestionCabDetalle oGCDetalle = new GestionCabDetalle();
            lineaExcel = i+1;
            bError = false;
            bWarning = false;
            StringBuilder sMensaje = new StringBuilder();
            Hashtable has     = (Hashtable)hFilaAux.get(i);

         String productor  = ((String)has.get("PRODUCTOR")) == null?"":((String)has.get("PRODUCTOR")).trim();
         if (colProductor > -1) {
                Usuario oProductor = new Usuario();
//                oProductor.setiCodProd(Integer.parseInt(productor.substring(5)));
                oProductor.setiCodProd(Integer.parseInt( ((String)has.get(nameCol.get(colProductor))).trim().substring(5)));

                oProductor.getDBProductor(dbCon);
                if (oProductor.getiNumError() < 0 && oProductor.getiNumError() != -100 ) {
                    throw new SurException (oProductor.getsMensError());
                }
                oGCDetalle.setCodProd   (Integer.parseInt(productor.substring(5)));
                oGCDetalle.setCodOrg    (Integer.parseInt(productor.substring(0,5)));

                if (oProductor.getiNumError() != -100){
                    email = oProductor.getEmail();
                    if (oProductor.getEmail()==null ){
                        sMensaje.append("El productor :  ").append(productor).append(" no tiene informado el mail . Fila nro. = ").append(lineaExcel).append("\n");
                        bWarning = true;
                        iErrores += 1;
                    }
                } else {
                    sMensaje.append("El productor:").append(productor).append("  no existe . Fila nro. = ").append(lineaExcel).append("\n");
                    bWarning = true;
                    iErrores += 1;
                }
        }
        for (int ii=0;ii< nameCol.size();ii++) {
              String sValida = (String) validaCol.get(ii);
              String sTipo   = (String) typeCol.get(ii);
              String sNombre = (String) nameCol.get(ii);

              if ( sValida.equals("S")) {
                  if (sTipo.equals("TYPE_DOUBLE")) {
                      double datoDouble = ((Double)has.get(sNombre) ==null? 0 :
                                           (Double)has.get(sNombre));
                      if (datoDouble == 0) bError = true;
                  } else {
                      String datoString = ((String)has.get(sNombre))==null?"":
                                          ((String)has.get(sNombre)).trim();

                      if ( (sTipo.equals("TYPE_NUMERIC") && datoString.equals("0") ) ||
                           (sTipo.equals("TYPE_STRING") && datoString.equals ("0"))) bError = true;
                  }
                  if (bError == true) {
                      sMensaje.append("Fila ").append(lineaExcel).append(": campo ").append(sNombre).append(" vacio").append("\n");
                      iErrores += 1;
                      break;
                  }
              }
          } // for

            oGCDetalle.setcodGestion(oCabeceraGestion.getCodGestion());
            oGCDetalle.setFila      (lineaExcel);
            oGCDetalle.setCodEstado (bError == true || bWarning == true  ? 1 : 0);
            oGCDetalle.setDesEstado (sMensaje.toString());
            oGCDetalle.setCodProdDc (productor);
            oGCDetalle.setEmail     (email);

        for (int iii=0;iii< nameCol.size();iii++) {
              String sNombre = (String) nameCol.get(iii);
              if (sNombre.equals("SC")) {
                    oGCDetalle.setCodRama (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }
              if (sNombre.equals("SS")) {
                    oGCDetalle.setCodSubRama (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }
              if (sNombre.equals("POLIZA")) {
                    oGCDetalle.setNumPoliza (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }
              if (sNombre.equals("ENDOSO")) {
                    oGCDetalle.setEndoso (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }
              if (sNombre.equals("ASEGURADO")) {
                    oGCDetalle.setAsegurado((String)has.get(sNombre) == null?"":((String)has.get(sNombre)).trim());
              }

              if (sNombre.equals("MONEDA")) {
                    oGCDetalle.setCodMon (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }

            SimpleDateFormat sd = new SimpleDateFormat ("MM/dd/yy");

            if (sNombre.equals("FPAGO")) {
                String fpago      = ((String)has.get(sNombre)) == null? null :((String)has.get(sNombre)).trim();

                if ( ! fpago.equals("00/00/0000")) {
                    oGCDetalle.setFechaUltPago (sd.parse(fpago));
                }
            }

            if (sNombre.equals("FVCTO")) {
                String fvcto      = ((String)has.get(sNombre))== null? null :((String)has.get(sNombre)).trim();
                if ( ! fvcto.equals("00/00/0000")) {
                    oGCDetalle.setFechaVenc(sd.parse (fvcto));
                }
            }

              if (sNombre.equals("CUOTA")) {
                    oGCDetalle.setNumCuota(Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }

              if (sNombre.equals("CCUOTA")) {
                    oGCDetalle.setTotalCuotas (Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }

              if (sNombre.equals("IMPCUOTAMES")) {
                    oGCDetalle.setImpCuotaMes(((Double)has.get(sNombre)== null? 0 : (Double)has.get(sNombre)));
              }

              if (sNombre.equals("IMPCUOTAATR")) {
                    oGCDetalle.setImpCuotaVenc (((Double)has.get(sNombre)== null? 0 : (Double)has.get(sNombre)));
              }

              if (sNombre.equals("NETORENDIR")) {
                    oGCDetalle.setImpNetoRendir (((Double)has.get(sNombre)== null? 0 : (Double)has.get(sNombre)));
              }

              if (sNombre.equals("OBSERVACIONES")) {
                    oGCDetalle.setObservaciones ((String)has.get(sNombre) == null?"":((String)has.get(sNombre)).trim());
              }
              if (sNombre.equals("CUIT")) {
                    oGCDetalle.setCuit((String)has.get(sNombre) == null?"":((String)has.get(sNombre)).trim());
              }
              if (sNombre.equals("PERIODO")) {
                    oGCDetalle.setperiodo(Integer.parseInt((String)has.get(sNombre) == null?"0":((String)has.get(sNombre)).trim()));
              }

          } // for

            oGCDetalle.setDB(dbCon);
            if (oGCDetalle.getCodError() < 0) {
                throw new SurException(oGCDetalle.getMensajeError());
            }

            if (bError) bRechazarArchivo = true;
        } // for
        //--Guardo la  cabecera de la gestion

        if (bRechazarArchivo) {
            oCabeceraGestion.setCodEstado(1);
            oCabeceraGestion.setDB(dbCon);
            System.out.println("Hay errores :" + iErrores);
        } 
    }

    doForward (request, response, "/servlet/GestionCobServlet?opcion=getProcesarGestion&cod_gestion=" + oCabeceraGestion.getCodGestion() + "&cod_template=" + codTemplate);

} catch(Exception e){
    throw new SurException (e.getMessage());
}
}

protected void getGestionAutomatica (HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException, SurException {

Connection dbCon       = null;
CabeceraGestion oCabeceraGestion = new CabeceraGestion();
try {

    System.out.println ("entro en getGestionAutomatica");

    int iCodTexto   = Integer.parseInt (request.getParameter ("cod_texto"));
    int codGestion  = Integer.parseInt (request.getParameter ("cod_gestion"));
    int codTemplate = Integer.parseInt (request.getParameter ("cod_template"));
    int codEstado   = Integer.parseInt (request.getParameter ("est_gestion"));


    dbCon = db.getConnection();
    if (codEstado == 2 || codEstado == 3 ) {
        oCabeceraGestion.setCodGestion( 0 ); // nueva gestion
    } else {
        oCabeceraGestion.setCodGestion(codGestion);
    }
    oCabeceraGestion.setCodTexto( iCodTexto );
    oCabeceraGestion.setUsuario( "AUTOMAT" );
    oCabeceraGestion.settipoProceso("A");
    oCabeceraGestion.setArchivo(null);

    oCabeceraGestion.setDB(dbCon);

    System.out.println ("paso el oCabeceraGestion.setDB(dbCon) " + oCabeceraGestion.getCodGestion());
    System.out.println ("paso el oCabeceraGestion.setDB(dbCon) error " + oCabeceraGestion.getCodError());

    if (oCabeceraGestion.getCodError() < 0 ) {
        throw new SurException(oCabeceraGestion.getMensajeError());
    }
    oCabeceraGestion.setDBResetDetalle(dbCon);
    if (oCabeceraGestion.getCodError() < 0 ) {
        throw new SurException(oCabeceraGestion.getMensajeError());
    }

    oCabeceraGestion.setDBGestionAutomatica(dbCon);
    if (oCabeceraGestion.getCodError() < 0 ) {
        throw new SurException(oCabeceraGestion.getMensajeError());
    }

     LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 85 , "D","BATCH");

     if (lReportes.size() > 0) {
           ProcesarReportes.ProcesarReporte(dbCon, lReportes);
     }

    doForward (request, response, "/servlet/GestionCobServlet?opcion=getProcesarGestion&cod_gestion=" + oCabeceraGestion.getCodGestion() + "&cod_template=" + codTemplate + "&tipo_proceso=A" );

 } catch(Exception e){
    throw new SurException (e.getMessage());
 }
}

protected void setProcesarEnvios(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException, SurException {
 Connection dbCon = null;
 CallableStatement cons = null;
 ResultSet rs = null;
 try {

     System.out.println ("Entro en setProcesarEnvios -->" + request.getParameter ("cod_gestion"));
     
     Usuario oUser   = (Usuario) (request.getSession().getAttribute("user"));
     int codGestion  = Integer.parseInt (request.getParameter ("cod_gestion"));
     int codTemplate = Integer.parseInt (request.getParameter ("cod_template"));
     String sPrueba = request.getParameter ("prueba");

     dbCon = db.getConnection();
     CabeceraGestion oCab = new CabeceraGestion();
     oCab.setCodGestion(codGestion);
     oCab.setUsuario(oUser.getusuario());
     oCab.getDB(dbCon);
     if (oCab.getCodError() < 0) {
         throw new SurException(oCab.getMensajeError());
     }

     boolean _serverMailGmail = false;

    String sUrl = "https://www.beneficioweb.com.ar";

    dbCon.setAutoCommit(false);
    cons = dbCon.prepareCall(db.getSettingCall("CO_GET_ALL_PROCESAR_ENVIO(?,?,?,?,?,?,?,?)"));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.setInt (2, oCab.getCodGestion());
    cons.setInt (3, oCab.getCodTemplate());
    cons.setString (4, oCab.getTexto());
    cons.setString (5, oCab.getfirma());
    cons.setString (6, sUrl);
    cons.setString (7, oCab.gettitulo());
    cons.setString (8, sPrueba);
    cons.setInt    (9, oCab.getCodTexto());

           
    cons.execute();                  
    rs =  (ResultSet) cons.getObject(1);
    String sErrorEnvio;
    boolean bError = false;
    int cantMail = 0;
    GestionCabDetalle oDet = new GestionCabDetalle();
    oDet.setcodGestion(oCab.getCodGestion());

    while (rs.next()){
	try {

System.out.println ("entro en rs.next " + rs.getString ("EMAIL") + "    prodcutor " + rs.getString("PRODUCTOR") );

        
        
            sErrorEnvio  = null;
            Email mail = new Email();

            // ------------------------------
            // Configuracion Local mail Gmail                              
            if (_serverMailGmail){
                mail.setEnableStarttls(true);
            }

            if (rs.getString ("EMAIL") == null || rs.getString ("BODY") == null ||
                rs.getString("PRODUCTOR") == null ||  rs.getString("COD_PROD_DC") == null ) {
                sErrorEnvio = " DATOS NULOS ";
                bError = true;
            } else {

                String sRemitente = oCab.getremitente();
                if (rs.getString ("REMITENTE") != null ) {
                    sRemitente = rs.getString ("REMITENTE");
                }
                mail.setSource(sRemitente);

                if (oCab.getusermail() != null) {
                    mail.setUser(oCab.getusermail());
                }
                if (oCab.getpassword() != null) {
                    mail.setPassword(oCab.getpassword());
                }
                if (sPrueba.equals("S")) {
                    mail.setDestination(sRemitente);
                } else {
                    mail.setDestination(rs.getString ("EMAIL"));
                }

                if (rs.getString ("CCO") != null && ! rs.getString ("CCO").equals ("")) {
                    mail.setCCO(rs.getString ("CCO"));
                } else {
                    if (oCab.getcco() != null ) {
                        mail.setCCO(oCab.getcco());
                    }
                }
                mail.setSubject("BENEFICIO S.A. - " + oCab.gettitulo() + " - " + rs.getString("PRODUCTOR") + " (" + rs.getString("COD_PROD_DC") + ")" );
                mail.addContent(rs.getString ("BODY"));
                mail.addCID("cidimage01", "/opt/tomcat/webapps/benef/images/template/tem44.jpg");

                System.out.println ("antes de mandar el mail " + mail.getDestination() + " CCO " + mail.getCCO()  );
                
                mail.sendMultipart(); //Message("text/html");
                cantMail = cantMail + 1;
            }
            }catch (Exception eMail ){
                bError = true;
                sErrorEnvio = "Error: " + eMail.getMessage();
            }

            oDet.setCodProd(rs.getInt("COD_PROD"));
            oDet.setCodProdDc(rs.getString ("COD_PROD_DC"));
            oDet.setCodEstado(sErrorEnvio == null ? 0 : 1 );
            oDet.setDesEstado(sErrorEnvio);
            oDet.setDBEstadoEnvioProductor(dbCon);

            if (oDet.getCodError()< 0) {
                throw new SurException(oDet.getMensajeError());
            }
	} 

     if (sPrueba.equals("N")) {
        oCab.setCodEstado(bError ? 3 : 2);
        oCab.setMailsEnviados(cantMail);
        oCab.setDB(dbCon);
        
        if (oCab.getCodError() < 0) {
            throw new SurException(oCab.getMensajeError());
        }

        if (oCab.gettipoProceso().equals("A")) {
             LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 85 , "D","BATCH");

             if (lReportes.size() > 0) {
                   ProcesarReportes.ProcesarReporte(dbCon, lReportes);
             }

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_PRELIQ_ONLINE");
            String sEstado  =  oParam.getDBValor(dbCon);

            if (sEstado.equals("N")) {
                oParam.setsCodigo("ESTADO_PRELIQ_ONLINE");
                oParam.setsValor("S");
                oParam.setsUserid(oUser.getusuario());
                oParam.setDB(dbCon);
            }

         }

     }

    request.setAttribute("mensaje",(bError ? "El proceso de envia ha finalizado con errores" : "El proceso de envío ha sido exitoso") );
    request.setAttribute("volver", Param.getAplicacion() + "servlet/GestionCobServlet?opcion=getProcesarGestion&cod_gestion=" + oCab.getCodGestion() + "&cod_template=" + codTemplate + "&tipo_proceso=" + oCab.gettipoProceso());
    doForward (request, response, "/include/MsjHtmlServidor.jsp");

   }catch (Exception e){
            throw new SurException (e.getMessage());
   }finally{
            try {
                if (cons != null) cons.close ();
                if (rs   != null) rs.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
    }
 }  //setProcesarEnvios

private static String replaceValueTemplate ( HashMap valueToReplace , String template )
        throws Exception
    {
        try {
            StringBuilder templateStb = new StringBuilder (template) ;
            Set set = valueToReplace.entrySet();
            Iterator i = set.iterator();
            while(i.hasNext()){
                Map.Entry me = (Map.Entry)i.next();                
                String dato = (String) me.getKey();
                int index = templateStb.indexOf(dato);
                while (index != -1 ) {                    
                    templateStb.replace(index , index + dato.length() , (String)me.getValue());
                    index = templateStb.indexOf(dato);
                }
            }
            return templateStb.toString();
        } catch (Exception e)  {
            throw new SurException (e.getMessage());
        }
    }

// usado en gestion de cobranza
protected void getInfoByXlsGestion (LinkedList hFilaOk, LinkedList pColTypes, LinkedList pColName , String pPath , int pPage)
	throws JXLException,IOException{
    try {
        File  f = new File(pPath);
        WorkbookSettings wbSettings = new WorkbookSettings();

//        wbSettings.setEncoding("ISO-8859-1");

        wbSettings.setLocale(new Locale("es", "AR"));
        wbSettings.setExcelDisplayLanguage("AR");
        wbSettings.setExcelRegionalSettings("AR");


        Workbook workbook = Workbook.getWorkbook(f, wbSettings);

        //	Tomo la primera hoja
        Sheet sheet = workbook.getSheet(0);
        boolean  ok		= false;
        boolean error       = false;
        int cantFilas	= sheet.getRows();
        int cantColumnas     = pColName.size();
        //--
        int iFilaOk = 0;
        for (int iFila = 0; iFila < cantFilas; iFila++){
            Hashtable  hasColOk    = new Hashtable();
            Hashtable  hasColError = new Hashtable();
            String stringAB        = "";
            error = false;
            if ( iFila > 0 ) {
                if ( sheet.getCell( 0,iFila).getContents() == null || sheet.getCell( 0,iFila).getContents().isEmpty() ) {
                    break;
                }
                for (int iCol = 0; iCol < cantColumnas; iCol++ ){
                    Cell celda = sheet.getCell(iCol,iFila);
                    if (((String)pColTypes.get(iCol)).equals("TYPE_DOUBLE")){
                            if (celda.getContents() == null || celda.getContents().trim().isEmpty() ) {
                                hasColOk.put(pColName.get(iCol), Double.parseDouble("0"));
                            } else {
                                NumberCell nc = (NumberCell) celda;
                                Double  numberb2 = nc.getValue();
                                hasColOk.put(pColName.get(iCol), numberb2);
                            }
                    } else if (((String)pColTypes.get(iCol)).equals("TYPE_NUMERIC")){
                            if (celda.getContents() == null || celda.getContents().trim().isEmpty() ) {
                                hasColOk.put(pColName.get(iCol), "0" );
                            } else {
                                    if ( celda.getType() == CellType.NUMBER){
                                    hasColOk.put(pColName.get(iCol),celda.getContents());
                                    } else {
                                        error = true;
                                        hasColError.put(String.valueOf(iCol), celda.getContents());
                                    }
                            }
                    } else if(((String)pColTypes.get(iCol)).equals("TYPE_STRING")) {
                            hasColOk.put(pColName.get(iCol),celda.getContents());

                    } else if (((String)pColTypes.get(iCol)).equals("TYPE_DATE")) {
                            if ( ! celda.getContents().trim().isEmpty() && celda.getContents().trim().equals("00/00/0000") ) {
                                hasColOk.put(pColName.get(iCol),"00/00/0000" );
                            } else {
                                if ( celda.getType() == CellType.DATE ) {
                                    hasColOk.put (pColName.get(iCol),celda.getContents());
                                } else {
                                    error = true;
                                    hasColError.put(String.valueOf(iCol), celda.getContents());
                                }
                            }
                    }
                }// for de las columnas
                if ( ! error ) {
                    hFilaOk.add(iFilaOk, hasColOk); //-- guardo la HasTable con los campos de la  celda
                    iFilaOk += 1;
                } else {
                    for (int ii=0; ii < hasColError.size(); ii++) {
                        if (hasColError.containsKey(String.valueOf(ii))) {
                        }
                    }
                }
            }// if la fila es mayor a cero
        }//--for de las  filas
	   // Finalmente cerramos el workbook y liberamos la memoria
        workbook.close();

    } catch (IOException e) {
        throw new IOException ("Error " +e.getMessage());
    }
    }


/** Initializes the servlet.
 **/
 public void init(ServletConfig config) throws ServletException {
        super.init(config);
 }
    
    /** Destroys the servlet.
     */
public void destroy() {
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
	} catch (Exception e) {
                goToJSPError (request,response, e);
	}  // try		

    } // doForward
     public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) 
     throws ServletException, IOException {
	try {
                request.setAttribute("javax.servlet.jsp.jspException", t);
		getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        } catch (Exception e) {
                goToJSPError (request,response, e);
	}
        // try		
    } // goToJSPError
}