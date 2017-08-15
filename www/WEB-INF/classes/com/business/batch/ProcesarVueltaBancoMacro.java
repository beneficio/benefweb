/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.batch;

import com.business.db.db;
import com.business.util.Fecha;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Vector;
import java.io.File;
 
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.UserInfo;

import com.business.beans.Persona;
import com.business.util.SUserInfo;
import com.business.util.SurException;
import com.business.util.Parametro;
import com.business.util.Param;
import com.business.util.Email;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import org.apache.commons.vfs2.impl.StandardFileSystemManager;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import org.jconfig.handler.XMLFileHandler;
 
public class ProcesarVueltaBancoMacro {
 
public static void main(String[] args) throws Exception{
    Connection dbCon = null; 
    String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
    CallableStatement cons  = null;
    ResultSet rs = null;
StandardFileSystemManager manager = new StandardFileSystemManager();
ConfigurationManager configurationManager = null;
File configurationFile        = null;
XMLFileHandler xmlFileHandler = null;
Configuration configuration   = null;

  try {
        System.out.println("------------------- INICIO");
        
        File config=new File(_file);
        if(!config.exists()){
            // ------------------------------------------------------------
            // En caso que si no toma los datos del config.xml
            // Configurar los Datos de conexion.
            // ------------------------------------------------------------

            System.out.println(" ************************************ ") ;
            System.out.println(" No se encontro el archivo config.xml") ;
            System.out.println(" ************************************ ") ;
            throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
        } else {
            Param.realPath (_file);            
            db.realPath(config.getAbsolutePath()) ;
            dbCon = db.getConnection();
            System.out.println("************************************************ ") ;
            System.out.println("* Se recupero informacion del archivo config.xml") ;
            System.out.println("************************************************ ") ;
        }

        configurationManager = ConfigurationManager.getInstance();
        configurationFile = new File( _file ); 
        xmlFileHandler = new XMLFileHandler(); 
        xmlFileHandler.setFile(configurationFile);
        try {
            configurationManager.load(xmlFileHandler, "bancoMacro");
        } catch(ConfigurationManagerException e) { 
            e.printStackTrace();
        }

        configuration = configurationManager.getConfiguration("bancoMacro");
        
        String host = configuration.getProperty("serverAddress", null, "bancoMacro"); 
        String user = configuration.getProperty("userId", null, "bancoMacro");  
        int    port = Integer.parseInt (configuration.getProperty("port", null, "bancoMacro")); 
        String pass = configuration.getProperty("password", null, "bancoMacro");  
        String localPath = configuration.getProperty("localDirectory", null, "bancoMacro");  
        String remotePath = configuration.getProperty("remoteDirectoryRequest", null, "bancoMacro");  
          
System.out.println ("serverAddress " + host);
        
        Parametro oParam = new Parametro ();
        oParam.setsCodigo("COD_SERVICIO_BANCO_MACRO");
        String nroServicio = oParam.getDBValor(dbCon);

System.out.println ("nroServicio --> " + nroServicio);

        JSch jsch = new JSch();
        Session session = jsch.getSession(user, host, port);
        UserInfo ui = new SUserInfo(pass, null);
        
        session.setUserInfo(ui);
        session.setPassword(pass);
        session.connect();
 
        ChannelSftp sftp = (ChannelSftp)session.openChannel("sftp");
        sftp.connect();
 
        sftp.cd(remotePath.replace("/", "")); // -- > REEMPLAZAR POR BANCO EN PRODUCCION
        
        int leidos = 0;
        
        Vector<ChannelSftp.LsEntry> list = sftp.ls("DPPPdat_" + nroServicio + "*.lis");

        for(ChannelSftp.LsEntry entry : list) {
            File existeFile = new File (localPath +  entry.getFilename());
            leidos += 1;
            
System.out.println ("archivo leido:" +  entry.getFilename());

            // SI NO EXISTE EL ARCHIVO EN LA CARPETA LOCAL QUIERE DECIR QUE AUN NO LO PROCESE
            if (! existeFile.exists()) {
                // HAGO EL UPLOAD DE LOS 3 ARCHIVOS RESPECTIVOS QUE AUN NO PROCESE
                sftp.get(entry.getFilename(), localPath +  entry.getFilename());
                
                String nomFileDet = "DPPPdet_" + entry.getFilename().substring(8);
                String nomFileTot = "DPPPtot_" + entry.getFilename().substring(8);
                
                sftp.get( nomFileDet, localPath +  nomFileDet);
                
                sftp.get( nomFileTot, localPath +  nomFileTot);
                
                // OBTENGO LA FECHA DE PROCESO DEL NOMBRE DEL ARCHIVO
                String sFechaProceso = entry.getFilename().substring(18, 24);

System.out.println ("sFechaProceso" + sFechaProceso);

                // OBTENGO EL NUMERO SECUENCIAL DEL NOMBRE DEL ARCHIVO
                int iSecuencia    = Integer.parseInt(entry.getFilename().substring(13, 17).trim());

System.out.println ("Secuencia" + iSecuencia);

                String DATE_FORMAT = "ddMMyy";
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

                java.util.Date dFechaProceso = sdf.parse( sFechaProceso);
                
                // INSTANCIO EL ARCHIVO .dat OBTENIDO PARA PROCESAR EL CONTENIDO
                File localFile = new File (localPath +  entry.getFilename());                            

                dbCon = db.getConnection();

                BufferedReader di = new BufferedReader(new FileReader(localFile));
                String linea;
                // PROCESO EL CONTENIDO DEL ARCHIVO
                int numFila = 0;
                do {
                    linea = di.readLine();
                    if (linea == null) {
                        break;
                    }  else {
                        numFila += 1;
                        String sTipoReg =  linea.substring(0, 1);

System.out.println ("-----------------------------------------------------------");
System.out.println ("Archivo Procesado: " + nomFileDet);

                        dbCon.setAutoCommit(true);
                        cons = dbCon.prepareCall(db.getSettingCall( "BMACRO_GRABAR_REGISTRO (?, ?, ?, ?, ?, ?, ?)"));
                        cons.registerOutParameter(1, java.sql.Types.INTEGER);
                        cons.setDate     (2, Fecha.convertFecha(dFechaProceso) );
                        cons.setInt      (3, iSecuencia);
                        cons.setString   (4, sTipoReg);
                        cons.setString   (5, linea);
                        cons.setString   (6, "BATCH");
                        cons.setString   (7, nomFileDet);
                        cons.setString   (8, nomFileTot);

                       cons.execute();
                    }
                } while ( true );
                
                sftp.rm(nomFileTot);                
                sftp.rm(nomFileDet);
                sftp.rm(entry.getFilename());
            }
        }

        
        System.out.println("Archivos leidos ---> " + leidos);
        
        // ENVIAR MAIL CON LOS ARCHIVO DE CONTROL ADJUNTO    
        EnviarMail (dbCon, nroServicio, localPath, _file);                
 
        sftp.exit();
        sftp.disconnect();
        session.disconnect();
 
        System.out.println("----------------- FIN");
            }
            catch (Exception e) {
                throw new SurException (e.getMessage());
            } finally {
                try {
                    if (rs != null ) rs.close() ;
                    if (cons != null ) cons.close();
                } catch (SQLException se) {
                    throw new SurException (se.getMessage());
                }
                dbCon.close();;
            }
    }

    static boolean EnviarMail (Connection dbCon, String nroConvenio, String path,String _file){

        boolean _serverMailGmail = false;
        CallableStatement cons  = null;
        CallableStatement cons2 = null;
        ResultSet rs = null;
        ResultSet rs2 = null;
        StringBuilder sMensaje = new StringBuilder(); 
        int mailEnviados = 0;
        try {
            
            if (Param.getRealPath() == null) {
                Param.realPath (_file);
            }
            
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_ALL_RESPUESTA\" (?)}");
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString  (2, "BATCH"); 

            cons.execute();
            rs =  (ResultSet) cons.getObject(1);
            if (rs != null ) {
                while (rs.next()) {
                    String from     = "webmaster@beneficio.com.ar";
                    boolean debug   = false;
                    Email mail = new Email();

                    // ------------------------------
                    // Configuracion Local mail Gmail
                    if ( _serverMailGmail ) {
                        mail.setEnableStarttls(true);
                    }
                    mail.setSource      (from);
                    String subject  = "Beneficio Web - AVISO DE COBRANZA BANCO MACRO - DEUDA PREVIA ";
                    
                    sMensaje.delete(0, sMensaje.length());
                    sMensaje.append("Se proceso un nuevo archivo de cobranza del banco.<br><br>");
                    sMensaje.append("FECHA DE PROCESO: ").append(Fecha.showFechaForm( rs.getDate ("FECHA_PROCESO")) ).append("<br><br>");
                    sMensaje.append("NRO. ARCHIVO    : ").append(rs.getInt ("SECUENCIA")).append("<br><br>");

System.out.println (path + rs.getString ("ARCHIVO_DET") );

                    cons2 = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_ALL_COBROS\" (?,?)}");
                    cons2.registerOutParameter(1, java.sql.Types.OTHER);
                    cons2.setDate (2, Fecha.convertFecha(rs.getDate("FECHA_PROCESO")));
                    cons2.setInt  (3, rs.getInt ("SECUENCIA")); 
                    cons2.execute();
                    rs2 =  (ResultSet) cons2.getObject(1);
                    if (rs2 != null ) {
                        int fila = 0;
                        while (rs2.next()) {
                            if (fila == 0) {
                                fila += 1;
                                sMensaje.append("Productor").append(";").append("Num.Preliq").append(";").append("Importe").append(";").append("Forma.Pago");
                                sMensaje.append(";").append("Num.Cheque").append(";").append("Banco").append(";").append("F.Presenta").append(";").append("F.Ingreso").append(";").append("F.Imputa");
                                sMensaje.append(";").append("Estado").append(";").append("Motivo.Rechazo").append("<br>");
                            }
                            sMensaje.append (rs2.getString("PRODUCTOR")).append(";").append (rs2.getInt ("NUM_PRELIQ")).append(";");
                            sMensaje.append(rs2.getDouble("IMPORTE")).append(";").append(rs2.getString ("FORMA_PAGO"));
                            sMensaje.append(";").append(rs2.getString ("NUM_CHEQUE")).append(";").append(rs2.getString("BANCO_CHEQUE"));
                            sMensaje.append(";").append(rs2.getString("FECHA_PRESENTA")).append(";").append(rs2.getString("FECHA_INGRESO")).append(";").append(rs2.getString("FECHA_IMPUTA"));
                            sMensaje.append(";").append(rs2.getString ("ESTADO_CHEQUE")).append(";").append(rs2.getString ("MOTIVO_RECHAZO")).append("<br>");
                        }
                    }
                    rs2.close();
                    cons2.close();

                    sMensaje.append("<br><br>El archivo " + rs.getString ("ARCHIVO_DET")+ " contiene el detalle de preliquidaciones cobradas.").append("<br>");
                    sMensaje.append("El archivo " + rs.getString ("ARCHIVO_TOT")+ " es un archivo de totales del respectivo archivo det").append("<br>");
                    
                    mail.setSubject     (subject);
                    mail.addContent     (sMensaje.toString());
                    mail.addAttach(path + rs.getString ("ARCHIVO_TOT") );
                    mail.addAttach(path + rs.getString ("ARCHIVO_DET") );
                    
System.out.println ("adjuntar --> " + path + rs.getString ("ARCHIVO_TOT"));
System.out.println ("adjuntar --> " + path + rs.getString ("ARCHIVO_DET"));

                    LinkedList lDest = mail.getDBDestinos(dbCon, 0, "BANCO_MACRO");            
                    for (int i=0; i < lDest.size();i++) {
                        Persona oPers = (Persona) lDest.get(i);
                        mail.setDestination(oPers.getEmail());
                        mail.sendMultipart(); //Message("text/html");
                    }
                    mailEnviados += 1;
                }
            }
            
            System.out.println ("Mail enviados ---> " + mailEnviados );
            

        } catch (Exception e) {
            System.out.println (e.getMessage());
        } finally { 
            try {
                if (rs != null) rs.close ();
                if (cons != null ) cons.close ();
            } catch (SQLException se) {
                System.out.println (se.getMessage()); 
            }
            return true; 
        }
    }
}