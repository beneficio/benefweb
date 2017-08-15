/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.batch;

import com.business.db.db;
import com.business.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;

/**
 *
 * @author Rolando Elisii
 */
public class ProcesarEnvioBancoMacro {

    private static DecimalFormat df2 = new DecimalFormat ("0000000000000.00");
    
    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        String sPathMacro  ="/opt/tomcat/webapps/benef/files/preliq/macro/"; 
        String sPathLog    ="/opt/tomcat/webapps/benef/files/trans/"; 
        CallableStatement cons  = null;
        CallableStatement cons1  = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        int cantLeidos = 2;
        double impLeidos = 0;
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;
        
        try {
            File config=new File(_file);
            if(!config.exists()){
                // ------------------------------------------------------------
                // En caso que si no toma los datos del config.xml
                // Configurar los Datos de conexion.
                // ------------------------------------------------------------

                System.out.println(" ********************************** ") ;
                System.out.println(" No se encontro el archivo config.xml") ;
                System.out.println(" ********************************** ") ;
                throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
            } else {
                db.realPath(config.getAbsolutePath()) ;
                dbCon = db.getConnection();
                System.out.println("*********************************************************************** ") ;
                System.out.println("* Se recupero informacion del archivo config.xml") ;
                System.out.println("*********************************************************************** ") ;
            }
            
            EnviarPreliquidaciones (dbCon);
//            EnviarDeudoresPorPremio (dbCon);
            
        } catch (Exception e ) {
            System.out.println (e.getMessage() );
        } finally {
            dbCon.close();;
        }
    }
    
    static void EnviarPreliquidaciones (Connection dbCon) {
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sPathMacro  ="/opt/tomcat/webapps/benef/files/preliq/macro/"; 
        String sPathLog    ="/opt/tomcat/webapps/benef/files/trans/"; 
        int cantLeidos = 2;
        double impLeidos = 0;
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;
        CallableStatement cons1 = null;
        ResultSet rs1           = null;
        CallableStatement cons  = null;
        ResultSet rs            = null;
        
        try {

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("COD_CONVENIO_MACRO_PROD");
            String nroConvenio = oParam.getDBValor(dbCon);

System.out.println ("convenio " + nroConvenio);

            String nroEnvio      = "";
            String sFechaProcesoEnvio = "";
            String sFechaProceso = "";
            StringBuilder sbHeader = new StringBuilder ();
            boolean bExistePreliq  = false;
            
            dbCon.setAutoCommit(false);
            cons1 = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_CABECERA\" (?)}");
            cons1.registerOutParameter(1, java.sql.Types.OTHER);
            cons1.setString  (2, "BATCH"); 

            cons1.execute();
            rs1 =  (ResultSet) cons1.getObject(1);
            if (rs1 != null ) {
                while (rs1.next()) {
                    sbHeader.append(rs1.getString ("TIPO")).append(
                    rs1.getString ("IDENTIFICACION")).append(
                    rs1.getString ("FECHA_PROCESO")).append(
                    rs1.getString ("HORA_PROCESO")).append(
                    rs1.getString ("NRO_ENVIO")).append(
                    rs1.getString ("NRO_RECIBIDO")).append("\n");

                    nroEnvio = rs1.getString ("NRO_ENVIO");
                    sFechaProcesoEnvio = rs1.getString ("FECHA_PROCESO_ENVIO");
                    sFechaProceso = rs1.getString ("FECHA_PROCESO");
                   
                }
                rs1.close();
            }
            cons1.close();

            String sFileBanco = "DPPPdat_" + nroConvenio + nroEnvio + "_" + sFechaProcesoEnvio + ".txt";
            String sFileLog   = "DPPPdat_" + nroConvenio + nroEnvio + "_" + sFechaProcesoEnvio + ".log"; 

            fos = new FileOutputStream ( sPathMacro + sFileBanco );
            osw = new OutputStreamWriter (fos, "8859_1");
            bw = new BufferedWriter (osw);
            bw.write( sbHeader.toString());            
            
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_ALL_PRELIQUIDACIONES\" (?)}");
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString  (2, "BATCH"); 

            cons.execute();
            rs =  (ResultSet) cons.getObject(1);
            if (rs != null ) {
                while (rs.next()) {
                    cantLeidos += 1;
                    impLeidos = impLeidos + ((rs.getDouble ("IMP_PREMIO_PESOS") / 100) * 100 / 100);
                    
                    String importe = Formatos.formatearCeros( String.valueOf(rs.getDouble ("IMP_PREMIO_PESOS")).replace(".0", ""), 15);
                    
                    StringBuilder sbLine = new StringBuilder ();
                    sbLine.append(rs.getString ("TIPO")).append(rs.getString ("COD_SERVICIO")).append(
                    rs.getString ("COD_DEUDOR")).append(rs.getString ("NUM_COMPROBANTE")).append(rs.getString ("TIPO_DOC")).append(
                    rs.getString ("NUM_DOC")).append(rs.getString ("FECHA_ORIGEN_DEUDA")).append(rs.getString ("FECHA_VIGENCIA_DEUDA")).append(
                    importe).append(rs.getString ("FECHA_VENC1")).append(rs.getString ("IMP_VENC2")).append(
                    rs.getString ("FECHA_VENC2")).append(rs.getString ("IMP_VENC3")).append(rs.getString ("FECHA_VENC3")).append(
                    rs.getString ("NOM_DEUDOR")).append(rs.getString ("IDENT_DEUDA")).append(rs.getString ("AREA")).append(
                    rs.getString ("MONEDA")).append(rs.getString ("CUIT")).append(rs.getString ("LEYENDA1")).append(
                    rs.getString ("LEYENDA2")).append(rs.getString ("LEYENDA3")).append(rs.getString ("LEYENDA4")).append(
                    rs.getString ("LEYENDA5")).append(rs.getString ("LEYENDA6")).append(rs.getString ("LEYENDA7")).append(
                    rs.getString ("LEYENDA8")).append(rs.getString ("LEYENDA9")).append(rs.getString ("LEYENDA10")).append(rs.getString ("FILLER")).append("\n");
                    bw.write( sbLine.toString());
                    bExistePreliq = true;
                }
                rs.close();
            }

System.out.println ("impLeidos" + impLeidos);
System.out.println ("cantLeidos" + cantLeidos);

            StringBuilder sbTotal = new StringBuilder ();
            sbTotal.append("T").append(Formatos.formatearCeros( String.valueOf(cantLeidos).replace(".0", ""), 5)).append(
                    df2.format(impLeidos).replace(".","")).append("\n");
            
            bw.write( sbTotal.toString());
            bw.flush();
            bw.close();
            osw.close();
            fos.close();

            fos = new FileOutputStream ( sPathLog + sFileLog );
            osw = new OutputStreamWriter (fos, "8859_1");
            bw = new BufferedWriter (osw);

            StringBuilder sbLog = new StringBuilder ();
            sbLog.append("PROCESO DE ENVIO DE SALDOS DE PRELIQUIDACIONES AL BANCO MACRO").append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());
            sbLog.append("FECHA DE PROCESO: ").append(sFechaProceso).append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());            
            sbLog.append("CANT. DE PRELIQUIDACIONES LEIDAS: ").append(String.valueOf(cantLeidos - 2).replace(".0", "")).append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());            
            sbLog.append("IMPORTE TOTAL ENVIADO: ").append(df2.format(impLeidos)).append("\n");
            bw.write( sbLog.toString());

            bw.flush();
            bw.close();
            osw.close();
            fos.close();      
            
            if ( bExistePreliq == true ) {
                SFTPSendMyFiles sendMyFiles = new SFTPSendMyFiles();
                sendMyFiles.startFTP(_file, sFileBanco);
            }

        } catch (Exception e ) {
            System.out.println (e.getMessage() );
        } finally {
            try {
            if ( cons != null ) cons.close ();
            if ( rs != null ) rs.close ();
            if ( cons1 != null ) cons1.close ();
            if ( rs1 != null ) rs1.close ();
            } catch (SQLException se) {
                System.out.println ( se.getMessage() );
            }
        }        
    } 
    
    static void EnviarDeudoresPorPremio (Connection dbCon) {
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sPathMacro  ="/opt/tomcat/webapps/benef/files/preliq/macro/"; 
        String sPathLog    ="/opt/tomcat/webapps/benef/files/trans/"; 
        int cantLeidos = 2;
        double impLeidos = 0;
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;
        CallableStatement cons1 = null;
        ResultSet rs1           = null;
        CallableStatement cons  = null;
        ResultSet rs            = null;
        
        try {

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("COD_CONVENIO_MACRO_CLI");
            String nroConvenio = oParam.getDBValor(dbCon);

System.out.println ("convenio Clientes " + nroConvenio);

            String nroEnvio      = "";
            String sFechaProcesoEnvio = "";
            String sFechaProceso = "";
            StringBuilder sbHeader = new StringBuilder ();
            boolean bExistePreliq  = false;
            
            dbCon.setAutoCommit(false);
            cons1 = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_CABECERA\" (?)}");
            cons1.registerOutParameter(1, java.sql.Types.OTHER);
            cons1.setString  (2, "BATCH"); 

            cons1.execute();
            rs1 =  (ResultSet) cons1.getObject(1);
            if (rs1 != null ) {
                while (rs1.next()) {
                    sbHeader.append(rs1.getString ("TIPO")).append(
                    rs1.getString ("IDENTIFICACION")).append(
                    rs1.getString ("FECHA_PROCESO")).append(
                    rs1.getString ("HORA_PROCESO")).append(
                    rs1.getString ("NRO_ENVIO")).append(
                    rs1.getString ("NRO_RECIBIDO")).append("\n");

                    nroEnvio = rs1.getString ("NRO_ENVIO");
                    sFechaProcesoEnvio = rs1.getString ("FECHA_PROCESO_ENVIO");
                    sFechaProceso = rs1.getString ("FECHA_PROCESO");
                   
                }
                rs1.close();
            }
            cons1.close();

            String sFileBanco = "DPPPdat_" + nroConvenio + nroEnvio + "_" + sFechaProcesoEnvio + ".txt";
            String sFileLog   = "DPPPdat_" + nroConvenio + nroEnvio + "_" + sFechaProcesoEnvio + ".log"; 

            fos = new FileOutputStream ( sPathMacro + sFileBanco );
            osw = new OutputStreamWriter (fos, "8859_1");
            bw = new BufferedWriter (osw);
            bw.write( sbHeader.toString());            
            
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BMACRO_GET_ALL_PRELIQUIDACIONES\" (?)}");
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString  (2, "BATCH"); 

            cons.execute();
            rs =  (ResultSet) cons.getObject(1);
            if (rs != null ) {
                while (rs.next()) {
                    cantLeidos += 1;
                    impLeidos = impLeidos + ((rs.getDouble ("IMP_PREMIO_PESOS") / 100) * 100 / 100);
                    
                    String importe = Formatos.formatearCeros( String.valueOf(rs.getDouble ("IMP_PREMIO_PESOS")).replace(".0", ""), 15);
                    
                    StringBuilder sbLine = new StringBuilder ();
                    sbLine.append(rs.getString ("TIPO")).append(rs.getString ("COD_SERVICIO")).append(
                    rs.getString ("COD_DEUDOR")).append(rs.getString ("NUM_COMPROBANTE")).append(rs.getString ("TIPO_DOC")).append(
                    rs.getString ("NUM_DOC")).append(rs.getString ("FECHA_ORIGEN_DEUDA")).append(rs.getString ("FECHA_VIGENCIA_DEUDA")).append(
                    importe).append(rs.getString ("FECHA_VENC1")).append(rs.getString ("IMP_VENC2")).append(
                    rs.getString ("FECHA_VENC2")).append(rs.getString ("IMP_VENC3")).append(rs.getString ("FECHA_VENC3")).append(
                    rs.getString ("NOM_DEUDOR")).append(rs.getString ("IDENT_DEUDA")).append(rs.getString ("AREA")).append(
                    rs.getString ("MONEDA")).append(rs.getString ("CUIT")).append(rs.getString ("LEYENDA1")).append(
                    rs.getString ("LEYENDA2")).append(rs.getString ("LEYENDA3")).append(rs.getString ("LEYENDA4")).append(
                    rs.getString ("LEYENDA5")).append(rs.getString ("LEYENDA6")).append(rs.getString ("LEYENDA7")).append(
                    rs.getString ("LEYENDA8")).append(rs.getString ("LEYENDA9")).append(rs.getString ("LEYENDA10")).append(rs.getString ("FILLER")).append("\n");
                    bw.write( sbLine.toString());
                    bExistePreliq = true;
                }
                rs.close();
            }

System.out.println ("impLeidos" + impLeidos);
System.out.println ("cantLeidos" + cantLeidos);

            StringBuilder sbTotal = new StringBuilder ();
            sbTotal.append("T").append(Formatos.formatearCeros( String.valueOf(cantLeidos).replace(".0", ""), 5)).append(
                    df2.format(impLeidos).replace(".","")).append("\n");
            
            bw.write( sbTotal.toString());
            bw.flush();
            bw.close();
            osw.close();
            fos.close();

            fos = new FileOutputStream ( sPathLog + sFileLog );
            osw = new OutputStreamWriter (fos, "8859_1");
            bw = new BufferedWriter (osw);

            StringBuilder sbLog = new StringBuilder ();
            sbLog.append("PROCESO DE ENVIO DE SALDOS DE PRELIQUIDACIONES AL BANCO MACRO").append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());
            sbLog.append("FECHA DE PROCESO: ").append(sFechaProceso).append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());            
            sbLog.append("CANT. DE PRELIQUIDACIONES LEIDAS: ").append(String.valueOf(cantLeidos - 2).replace(".0", "")).append("\n");
            bw.write( sbLog.toString());
            sbLog.delete(0, sbLog.length());            
            sbLog.append("IMPORTE TOTAL ENVIADO: ").append(df2.format(impLeidos)).append("\n");
            bw.write( sbLog.toString());

            bw.flush();
            bw.close();
            osw.close();
            fos.close();      
            
            if ( bExistePreliq == true ) {
                SFTPSendMyFiles sendMyFiles = new SFTPSendMyFiles();
                sendMyFiles.startFTP(_file, sFileBanco);
            }

        } catch (Exception e ) {
            System.out.println (e.getMessage() );
        } finally {
            try {
            if ( cons != null ) cons.close ();
            if ( rs != null ) rs.close ();
            if ( cons1 != null ) cons1.close ();
            if ( rs1 != null ) rs1.close ();
            } catch (SQLException se) {
                System.out.println ( se.getMessage() );
            }
        }        
    } 
    
}
