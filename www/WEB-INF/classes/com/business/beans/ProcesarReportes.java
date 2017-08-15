/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;
import java.io.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.*;
//import sun.net.ftp.*;
//import sun.net.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
/**
 *
 * @author Rolando Elisii
 */
    public class ProcesarReportes {


    public static void ProcesarReporte (Connection dbCon, LinkedList lReportes)
       throws SurException {
       CallableStatement cons  = null;
       ResultSet rs = null;
       String sPath = "/opt/tomcat/webapps/benef/files/reportes/";
       StringBuilder sbNombre = new StringBuilder();
       int cantRegistros  = 0;
       String sError = "";
       try {

           for (int i=0; i< lReportes.size();i++) {
               Reportes oRep = (Reportes) lReportes.get(i);

               System.out.println ("\n ------------------------- Reporte N  " + oRep.getnumReporte() + " ----------------------");

               StringBuilder sNombre = new StringBuilder();
               sNombre.append(sPath);
               sNombre.append(oRep.getnomArchivo());

               try { 
                    sError = ""; 
                    dbCon.setAutoCommit(false);
                    cons = dbCon.prepareCall(db.getSettingCall(oRep.getfuente()));
                    cons.registerOutParameter(1, java.sql.Types.OTHER);

                    for (int ii= 0; ii< oRep.getParametros().size(); ii++) {
                        ParametroReporte oParam = (ParametroReporte) oRep.getParametros().get(ii);
                        if (oParam.getnomParametro().equals("NUM_REPORTE")) {
                            cons.setInt (oParam.getorden()+1, oParam.getnumReporte());
                        } else {

                            System.out.print ("parametro " +  oParam.getnomParametro() + " :");
                            System.out.println (oParam.getvalorParametro());

                            if (oParam.gettypeParametro().equals("STRING") ) {
                                if (oParam.getvalorParametro() == null) {
                                     cons.setNull (oParam.getorden()+1, java.sql.Types.VARCHAR);
                                } else {
                                     cons.setString (oParam.getorden()+1, oParam.getvalorParametro());
                                     sbNombre.append("_").append(oParam.getvalorParametro());
                                }
                            } else if (oParam.gettypeParametro().equals("INTEGER") ) {
                                cons.setInt (oParam.getorden()+1, Integer.valueOf(oParam.getvalorParametro()));
                                sbNombre.append("_").append(oParam.getvalorParametro());
                            } else if (oParam.gettypeParametro().equals("DATE") ) {
                                 if (oParam.getvalorParametro() == null ){
                                     if (oParam.getmcaHoy() != null && oParam.getmcaHoy().equals("X")) {
                                         java.util.Date dHoy = new java.util.Date();
                                         cons.setDate (oParam.getorden()+1, Fecha.convertFecha
                                             (Fecha.add (dHoy , oParam.getsumaDias())));
                                             sbNombre.append("_").append(Fecha.convertFecha
                                             (Fecha.add (dHoy , oParam.getsumaDias())));
                                     } else {
                                         cons.setNull(oParam.getorden()+1, java.sql.Types.DATE);
                                     }
                                 } else {
                                     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                                     Date dateParam = formatter.parse(oParam.getvalorParametro());
                                     cons.setDate (oParam.getorden()+1, Fecha.convertFecha
                                             (dateParam ));
                                     sbNombre.append("_").append(oParam.getvalorParametro());
                                 }
                            }
                        }
                    }
                    if (oRep.getsobreescribe().equals("N")) {
                        sNombre.append(sbNombre.toString()).append("_").append(Fecha.getFechaActual().replace("/", "").replace("-", ""));
                    }

                    cons.execute();

                    sNombre.append(".csv");
     System.out.println ("---");
     System.out.println ("nombre del archivo:" + sNombre.toString());

                    FileOutputStream fos = new FileOutputStream (sNombre.toString());
                    OutputStreamWriter osw = new OutputStreamWriter (fos,"utf-8");

                    rs = (ResultSet) cons.getObject(1);
                    if (rs != null) {
                         while (rs.next()) {
                             if (rs.getString ("CAMPO") != null ) {
                                 if (rs.getInt ("OP") > 1 ) {
                                     cantRegistros += 1;
                                 }
                                 osw.write(rs.getString ("CAMPO"));
                                 osw.write('\n');
                             } else {
                                 System.out.println ("HAY REGISTROS NULOS EN EL REPORTE");
                                 sError = "HAY REGISTROS NULOS EN EL REPORTE";
                             }
                         }
                         rs.close();
                     }

                     osw.close();
                    fos.close();

                    LinkedList  <RepDestino> lDes = getAllDestinos ( dbCon, oRep.getnumReporte() );
                    int cantDestinos = 0;                      
                    if (lDes != null && lDes.size() > 0 ){ 
                        for (int ii= 0;ii < lDes.size();ii++) {
                            cantDestinos += 1;
                            RepDestino oDes = (RepDestino) lDes.get(ii);
                            if (oDes.gettipoDestino().equals(("SAMBA"))) { 
                                 ftpFile (oRep, sNombre.toString(), oDes); 
                            } else if (oDes.gettipoDestino().equals("EMAIL")) {
                                if (oDes.getmail() == null) { 
                                     System.out.println ("ERROR: DESTINO MAIL PERO EL MISMO NO ESTA INFORMADO");
                                     sError = sError + "ERROR: DESTINO MAIL PERO EL MISMO NO ESTA INFORMADO";
                                } else { 
                                     if (oDes.getenviarSiempre().equals("S") || 
                                             (oDes.getenviarSiempre().equals("N") && cantRegistros > 0 ) ) {
                                         sError = sError + mailFile (oRep, sNombre.toString(), oDes ); 
                                     }
                                }
                            } else if (oDes.gettipoDestino().equals("DROPBOX") || 
                                        oDes.gettipoDestino().equals("ONEDRIVE") || 
                                        oDes.gettipoDestino().equals("DRIVE")) {
                                sError = sError + fileServer (oRep, sNombre.toString(), oDes);
                            }
                        }

                    }
                    
                    if (oRep.gettipoEjecucion().equals("A") || cantDestinos == 0 ){ 
                        File eliminar = new File (sNombre.toString());
                        if ( ! eliminar.delete() ) { 
                            System.out.println ( "no pudo eliminar el archivo: " + sNombre.toString());
                        }
                    }
                
               } catch (SQLException se ) {
                   System.out.println ("Cancelación SQL: " + se.getMessage());
                   sError = se.getMessage();
               } catch (Exception e) {
                   System.out.println ("Cancelación : " + e.getMessage());
                }finally {
                    if ( ! sError.equals("")) { 
                        mailInfo(dbCon, oRep, sError);
                    }
                }
           }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void ftpFile (Reportes oRep, String sNombre, RepDestino oDes)
       throws SurException {
       FTPClient ftpClient = null;
       StringBuilder slog = new StringBuilder ();

       try {
           String sNombreArchivo = sNombre.substring(sNombre.lastIndexOf('/') );

//           System.out.println ( "sNombre " + sNombre);
//           System.out.println ( "sNombreArchivo " + sNombreArchivo);

            ftpClient = new FTPClient ();
            ftpClient.connect("192.168.2.167");
           int reply = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(reply)) {
                ftpClient.disconnect();
                throw new Exception("Exception in connecting to FTP Server");
            }
            slog.append("ftp - Conexion con SAMBA: ok\n");
            ftpClient.login ("ftpjava","ggp2005");
            ftpClient.type(ftpClient.ASCII_FILE_TYPE);
            ftpClient.enterLocalActiveMode();

            String sPath = "";
            if (oDes.getpath() != null) {
                sPath = oDes.getpath();
                
                ftpClient.changeWorkingDirectory(sPath);

                slog.append(sPath + "\n");
                
                File file=new File( sNombre);

                InputStream in = new FileInputStream(file);
                
                ftpClient.storeFile(sPath + sNombreArchivo, in);
                in.close();

                slog.append("ftp - put ").append( ftpClient.pwd()).append(" : ok\n");
            }

            System.out.println (slog.toString());

            ftpClient.disconnect();

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

    private static String fileServer (Reportes oRep, String sNombre, RepDestino oDes)
       throws SurException {
//       StringBuilder sPath = new StringBuilder("/opt/tomcat/webapps/benef/files/");
       StringBuilder sPath = new StringBuilder("/root/Dropbox/webapps");
         String sError = "";
       try {
  //         if (oDes.gettipoDestino().equals("DROPBOX")) {
    //           sPath.append( "dropbox");
      //     } else if (oDes.gettipoDestino().equals("ONEDRIVE")) {
        //       sPath.append( "onedrive");
          // } else if (oDes.gettipoDestino().equals("DRIVE")) {
            //   sPath.append( "drive");
           //} 
           
            String sNombreArchivo = sNombre.substring(sNombre.lastIndexOf('/') );

            File inFile = new File(sNombre);
            File outFile = new File(sPath.append(oDes.getpath()).append("/").append(sNombreArchivo).toString());
          
            FileInputStream in = new FileInputStream(inFile);
            FileOutputStream out = new FileOutputStream(outFile);

            int c;
            while( (c = in.read() ) != -1)
                    out.write(c);

            in.close();
            out.close();

        } catch (Exception e) {
            sError = e.getMessage(); 
        } finally { 
           return sError;
       }
       
    }
    
    private static String  mailFile (Reportes oRep, String sNombre, RepDestino oDes)
       throws SurException {
        
	FileInputStream fis = null;
        FileOutputStream fos = null;
        ZipOutputStream zipos = null;
        String sError = "";
        
       try {
           String sNombreArchivo = sNombre.substring(sNombre.lastIndexOf('/') );
           String pZipFile       = "/opt/tomcat/webapps/benef/files/reportes/" + sNombreArchivo.replace(".csv", ".zip");
           
// zipear archivo
            byte[] buffer = new byte[1024];
            try {
                   
                    // fichero a comprimir
                    fis = new FileInputStream("/opt/tomcat/webapps/benef/files/reportes/" + sNombreArchivo);
                    File aComprimir = new File (sNombreArchivo);
                    OutputStream outComprimir = new FileOutputStream(aComprimir);
                    byte[] buf = new byte[1024];
                    int len1;
                    while ((len1 = fis.read(buf)) > 0) {
                      outComprimir.write(buf, 0, len1);
                    }                            

                    fis = new FileInputStream(sNombreArchivo);
                    // fichero contenedor del zip
                    fos = new FileOutputStream(pZipFile);
                    // fichero comprimido
                    zipos = new ZipOutputStream(fos);

                    ZipEntry zipEntry = new ZipEntry( sNombreArchivo );
                    zipos.putNextEntry(zipEntry);
                    int len = 0;
                    // zippear
                    while ((len = fis.read(buffer, 0, 1024)) != -1) 
                            zipos.write(buffer, 0, len);
                    // volcar la memoria al disco
                    zipos.flush();
            } catch (Exception e) {
                    throw e;
            } finally {
                    // cerramos los files
                    zipos.close(); 
                    fis.close(); 
                    fos.close(); 
            } // end try
           

           StringBuilder sMensaje = new StringBuilder();
           
           sMensaje.append("Fecha: ").append(Fecha.showFechaForm(new Date())).append("<br>").append("<br>");
           sMensaje.append(oRep.getdescripcion().replace("á", "&aacute;").replace("é", "&eacute;").replace("í", "&iacute;").replace("ó", "&oacute;").replace("ú", "&uacute;")).append("<br>").append("<br>");           
           sMensaje.append("Este mail es enviado automaticamente por un proceso. Por favor, no responda");
           
            try { 
                Email mail = new Email();
                mail.setSource      ("webmaster@beneficio.com.ar");
                mail.setSubject     ("Beneficio - " + oRep.getnumReporte() + ": " + oRep.gettitulo());
                mail.addContent     (sMensaje.toString());

                mail.addAttach(pZipFile);

                mail.setDestination(oDes.getmail());
                mail.sendMultipart(); //Message("text/html");
            } catch (Exception ee) {
                sError = ee.getMessage();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
           return sError;
       }
    } 

    private static void mailInfo (Connection dbCon, Reportes oRep, String sInfo)
       throws SurException {
        
       try {
           StringBuilder  sMensaje = new StringBuilder();
            String from     = "webmaster@beneficio.com.ar";
            boolean  _serverMailGmail = false;
            boolean debug   = false;
            Email mail = new Email();

            // ------------------------------
            // Configuracion Local mail Gmail
            if ( _serverMailGmail ) {
                mail.setEnableStarttls(true);
            }
            mail.setSource      (from);
            String subject  = "Beneficio Web - ERROR en ProcesarReportes: Nro. " + oRep.getnumReporte();

            sMensaje.delete(0, sMensaje.length());
            sMensaje.append(sInfo);

            mail.setSubject     (subject);
            mail.addContent     (sMensaje.toString());
            LinkedList lDest = mail.getDBDestinos(dbCon, 0, "ERROR");            
            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                mail.setDestination(oPers.getEmail());
                mail.sendMultipart(); //Message("text/html");
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
    
    public static LinkedList getAllReportes (Connection dbCon, int numReporte,
                                            String sFrecuencia, String sUsuario)
       throws SurException {
       CallableStatement cons  = null;
       ResultSet rs = null;
       LinkedList lRep = new LinkedList ();
       try {

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("RPT_GET_ALL_REPORTES(?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt    (2, numReporte);
           if (sFrecuencia.equals( "all")) {
               cons.setNull (3, java.sql.Types.VARCHAR);
           } else {
               cons.setString (3, sFrecuencia);
           }
           cons.setString (4, sUsuario);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    Reportes oRep = new Reportes();
                    oRep.setnumReporte      (rs.getInt ("NUM_REPORTE"));
                    oRep.settipoEjecucion   (rs.getString("TIPO_EJECUCION"));
                    oRep.setfrecuencia      (rs.getString("FRECUENCIA"));
                    oRep.setdia             (rs.getInt("DIA"));
                    oRep.setnomArchivo      (rs.getString("NOM_ARCHIVO"));
                    oRep.setusuario         (rs.getString("USUARIO"));
                    oRep.setcategoriaUsuario(rs.getString("CATEGORIA_USUARIO"));
                    oRep.setdescripcion     (rs.getString("DESCRIPCION"));
                    oRep.setfuente          (rs.getString("FUENTE"));
                    oRep.setestado          (rs.getString("ESTADO"));
                    oRep.settitulo          (rs.getString("TITULO"));
                    oRep.setsobreescribe    (rs.getString ("SOBREESCRIBE"));
                    oRep.setcarpetaDestino  (rs.getString ("CARPETA_DESTINO"));

                    oRep.setParametros(oRep.getDBParametros(dbCon));
                    lRep.add(oRep);
                }
                rs.close();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lRep;
        }
    }

    public static LinkedList getAllDestinos ( Connection dbCon, int numReporte )
       throws SurException {
       CallableStatement cons  = null;
       ResultSet rs = null;
       LinkedList <RepDestino> lDes = new LinkedList ();
       try {
           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("RPT_GET_ALL_DESTINOS (?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt    (2, numReporte);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    RepDestino oDes = new RepDestino();
                    oDes.setnumReporte      (rs.getInt ("NUM_REPORTE"));
                    oDes.setnumDestino      (rs.getInt ("NUM_DESTINO"));
                    oDes.settipoDestino     (rs.getString ("TIPO_DESTINO"));
                    oDes.setmail            (rs.getString ("MAIL"));
                    oDes.setpath            (rs.getString ("PATH"));
                    oDes.setusuario         (rs.getString ("USUARIO"));
                    oDes.setclave           (rs.getString("CLAVE"));  
                    oDes.setenviarSiempre   (rs.getString ("ENVIAR_SIEMPRE"));
                    lDes.add(oDes);
                }
                rs.close();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lDes;
        }
    }
    
    public static void main(String[] args)  throws Exception{
        Connection dbCon = null;
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sFrecuencia = "D";
        int    iReport    = 0;

        try {
            if (Param.getRealPath () == null) {
                Param.realPath (_file);
            }

           db.realPath (_file);

            dbCon = db.getConnection();
            if (args.length != 0) {
                sFrecuencia = args [0];
                iReport     = Integer.parseInt(args [1]);
            }

           LinkedList lReportes = getAllReportes (dbCon, iReport, sFrecuencia,"BATCH");

           if (lReportes.size() > 0) {
               ProcesarReporte (dbCon, lReportes);
           }

        } catch (Exception e) {
            System.out.println (e.getMessage());
        } finally {
            try {
                if (dbCon != null) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }

    }

}
