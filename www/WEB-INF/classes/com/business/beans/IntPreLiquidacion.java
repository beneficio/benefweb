package com.business.beans;

import com.business.db.db;
import com.business.util.SurException;
import com.business.util.Email;
import com.business.util.Fecha;
import java.io.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.regex.*;


public class IntPreLiquidacion {
    public static String base = "BENEF";   
    public static String pathDirectoryRoot  = "";
    public static String nameDirectoryBack  = "back";
    public static String nameDirectoryRes  = "res";
     
    //Agregar un error -1001 en preliq NO SE PUEDE RECUPERAR DIRECTORIO
    public static int NO_SE_PUEDE_RECUPERAR_DIRECTORIO = -1100;
    public static int ERROR_ELIMINAR_LINEAS_DE_ARCHIVO = -1200;
    public static int ERROR_PROCESO_PRELIQUIDACION = -1000;

    public IntPreLiquidacion(){

    }

    public static String getBase() {
        return base;
    }

    public static void setBase(String base) {
        IntPreLiquidacion.base = base;
    }

    public static String getPathDirectoryRoot() {
        return pathDirectoryRoot;
    }

    public static void setPathDirectoryRoot(String pathDirectoryRoot) {
        IntPreLiquidacion.pathDirectoryRoot = pathDirectoryRoot;
    }

    public static String lPad( String dato , int cant, char caracter) {
         String strLpad = "";
         for (int i = 0 ; i < (cant - dato.length()) ; i++ ) {
             strLpad = strLpad + caracter  ;
         }
        return strLpad + dato;
    }

    public static int processPreLiquidacion (Connection dbCon,  int codProd, String userid) throws SurException {
        int lote = 0;
        String pathDirectoryBack = pathDirectoryRoot + "/" +nameDirectoryBack ;
        String pathDirectoryRes  = pathDirectoryRoot + "/" + nameDirectoryRes ;
        
        File preliqFile     = null;
        File backPreliqFile = null;
        File resPreliqFile  = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        try {

            lote = IntPreLiquidacion.getDBLote(dbCon,IntPreLiquidacion.base);
            // ------------------------
            //Validacion de directorios
            // ------------------------
            boolean fileOk = true;
            preliqFile = new File(pathDirectoryRoot);
            if(!preliqFile.exists()){                
                IntPreLiquidacion.setDBError(dbCon,base, lote,0,NO_SE_PUEDE_RECUPERAR_DIRECTORIO,codProd,"El directorio: "+pathDirectoryRoot+" no se puede recuperar");
                fileOk = false;
            } else {
                backPreliqFile = new File(pathDirectoryBack);
                if( !backPreliqFile.exists() && !backPreliqFile.isDirectory() ){
                    IntPreLiquidacion.setDBError(dbCon,base, lote,0,NO_SE_PUEDE_RECUPERAR_DIRECTORIO,codProd,"El directorio de Backup : "+pathDirectoryBack + " no existe o no es un directorio");
                    fileOk = false;
                } else {
                    resPreliqFile = new File(pathDirectoryRes);
                    if(!resPreliqFile.exists() && !resPreliqFile.isDirectory() ){
                        IntPreLiquidacion.setDBError(dbCon,base, lote,0,NO_SE_PUEDE_RECUPERAR_DIRECTORIO,codProd,"El directorio de Resultado : "+pathDirectoryRes + " no existe o no es un directorio");
                        fileOk = false;
                    }else {
                        fileOk = true;
                    }
                }
            }
            
            if (fileOk) {
                //Arma tabla Hash para obtener mayor liquidacion.
                Hashtable preLiquidacionesHas = IntPreLiquidacion.getPreLiqHashtable(preliqFile,codProd);
                Enumeration e = preLiquidacionesHas.keys();
                Object obj;
                // Recorre la tabla Hash con una liquidacion por productor.
                while (e.hasMoreElements()) {
                   obj = e.nextElement();                
                   int codProdHash = ((Integer)obj).intValue();
                   int preLiqHash  = ((Integer)preLiquidacionesHas.get(obj)).intValue();                   
                   String nameFilePreLiq = IntPreLiquidacion.getFormatPreLiq(codProdHash, preLiqHash);
                   String pathFilePreLiq = pathDirectoryRoot +"/"+nameFilePreLiq;

                   try {
                        File inFile = new File(pathFilePreLiq);
                        if (!inFile.isFile()) {
                            throw new SurException  ("No se pudo recuperar el archivo " + pathFilePreLiq);
                        }
//System.out.println (" source " + dirSource.getPath()) ;
//System.out.println (" infile " + inFile.getName()) ;

                       IntPreLiquidacion.removeLineFromFile(pathFilePreLiq);
//System.out.println( " lote : " + lote + " preLiq : "  +preLiqHash + "codProd" + codProdHash);
                       int codReturnProcess = processDBPreliq (dbCon , base , lote, preLiqHash , codProdHash, userid, new Date (inFile.lastModified()));
//System.out.println( "Cod.return " + codReturnProcess);
                       if (codReturnProcess !=0 ) {
                           IntPreLiquidacion.setDBError( dbCon,base,lote,preLiqHash,codReturnProcess,codProdHash,"");
                           IntPreLiquidacion.enviarMensajes (dbCon, lote);
                       }
                       if (codReturnProcess == -300 || // -300 ya existe liquidacion mas actualizada para el productor
                           codReturnProcess == -500 || // SE REEMPLAZO PERO NO SE ENVIO
                           codReturnProcess == -600 || // SE REEMPLAZO Y SE ENVIO
                           codReturnProcess == 0    ) { // ok
                            
                            //Borrar en archivo back uno igual

                            File dirSource = new File(pathDirectoryBack);

//System.out.println(" dirSource " + dirSource.getName());

                            inFile.renameTo(new File(dirSource, inFile.getName()));

                            if (codReturnProcess == -600 ) {
                                //Se cerror OK la liquidacion
                                    dbCon.setAutoCommit(false);
                                    cons = dbCon.prepareCall(db.getSettingCall("CO_GET_FILE_CIERRE_PRELIQ(?,?)"));
                                    cons.registerOutParameter(1, java.sql.Types.OTHER);
                                    cons.setInt(2, preLiqHash);
                                    cons.setInt(3, codProdHash);
                                    cons.execute();

                                    String nameFileRes = "pre" +  lPad ( String.valueOf(preLiqHash), 8, '0')+".res";
                                    String fileRes = pathDirectoryRes +  "/" + nameFileRes;

                                    FileOutputStream fos = new FileOutputStream (fileRes);
                                    OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
                                    BufferedWriter bw = new BufferedWriter (osw);

                                    rs = (ResultSet) cons.getObject(1);
                                    if (rs != null) {
                                        while (rs.next()) {
                                            bw.write(rs.getString ("TEXTO"));
                                        }
                                        rs.close();
                                    }
                                    bw.flush();
                                    bw.close();
                                    osw.close();
                                    fos.close();
                            }
                       }

                   } catch (SurException se) {                     
                      //System.out.println( " errorprocess .......... " + se.getMessage());
                      try {
                          String error = (se.getMessage().length()>100)?se.getMessage().substring(0,99):se.getMessage();
                          IntPreLiquidacion.setDBError( dbCon,base,lote,preLiqHash,ERROR_PROCESO_PRELIQUIDACION,codProdHash,error);
                      } catch (Exception exp) {
                          //System.out.println( " Error grabar error "  + exp.getMessage());
                          exp.printStackTrace();
                          throw new SurException (exp.getMessage());
                      }
                   }
                }                
            }            
            return lote;

        } catch (Exception e )  {
            e.printStackTrace();
            throw new SurException ("[IntPreLiquidacion]{processPreLiquidacion} " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
                if (rs != null) { rs.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
       }

    private static void enviarMensajes (Connection dbCon, int lote) throws SurException {
        StringBuilder sMensaje = new StringBuilder();
        try {
            LinkedList lErrores = getDBErrorByLote (dbCon, lote);

            sMensaje.append("Detalle de inconsistencias producidas al procesar la carga masiva de preliquidaciones o cuando el productor ingresa a operar el módulo.\n");

            int numPreliqAnt = 0;
            StringBuilder datosProd = new StringBuilder();
            for (int i=0; i< lErrores.size();i++) {
                ErrorPreliq oErr = (ErrorPreliq) lErrores.get(i);
                if (numPreliqAnt != oErr.getNumPreliq()) {
                    Usuario oProd = new Usuario ();
                    oProd.setiCodProd(oErr.getCodProd());
                    oProd.getDBProductor(dbCon);
                    datosProd.delete(0, datosProd.length());
                    datosProd.append("Productor: " ).append(oProd.getRazonSoc()).append(" (").append(oProd.getiCodProd()).append(") - ");
                    datosProd.append(oProd.getEmail() != null ? oProd.getEmail() : " ");
                    datosProd.append(" - Tel.: ").append(oProd.getTel1()).append(" - Oficina: ").append(oProd.getdescOficina()).append("\n");
                }

                sMensaje.append("Preliquidación N° ");
                sMensaje.append(oErr.getNumPreliq()).append("\n");
                sMensaje.append(datosProd.toString()).append("\n");
                sMensaje.append(oErr.getDescError()).append("\n");
                if (numPreliqAnt != oErr.getNumPreliq()) {
                    sMensaje.append("------------------------------------\n\n");
                    numPreliqAnt = oErr.getNumPreliq();
                }
            }

            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a relisii@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("PRELIQUIDACION WEB - INCONSISTENCIAS ");
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "PRELIQUIDACION_WEB");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
               // oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }


        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } 
    }

    /*
     * Elimina el cabecera y caracter especial.
     */
    private static void removeLineFromFile(String file)  throws SurException {

        try {            
            File inFile = new File(file);
            if (!inFile.isFile()) {            
               throw new SurException  ("No se pudo recuperar el archivo " + file);                
            }
            File     tempFile = new File(inFile.getAbsolutePath() + ".tmp");
            BufferedReader br = new BufferedReader(new FileReader(file));
            PrintWriter    pw = new PrintWriter(new FileWriter(tempFile));
            String line = null;
            
            while ((line = br.readLine()) != null) {                             
                char firstChar = line.charAt(0);
                if ( firstChar != 'O' && firstChar != '' ) {
                    pw.println(line);
                    pw.flush();
                }
            }
            pw.close();
            br.close();

            // Borrar archivo original
            if (!inFile.delete()) {
                // System.out.println("No se puede borrar el archivo");
                throw new SurException  ("No se pudo borrar el archivo original : " + inFile.getName());
            }

            //Renombra el archivo tmp con el nombre del archivo original.            
            if (!tempFile.renameTo(inFile)) {
                //System.out.println("No se puede renombrar el archivo");
                throw new SurException  ("No se pudo renombrar el archivo temporal : " + tempFile.getName());
            }
            

        } catch (FileNotFoundException fnfex) {
            fnfex.printStackTrace();
            throw new SurException  (fnfex.getMessage());
        } catch (IOException ioex) {
            ioex.printStackTrace();
            throw new SurException  (ioex.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException  (e.getMessage());
        }
    }


    /*
     * Obtener Formato de preliquidacion
     */
    private static String getFormatPreLiq(int _codProd , int _numPreliq ) {
        StringBuilder stb = new StringBuilder("PRE");
        return stb.append(String.format("%08d", _numPreliq)).append(".").append(String.format("%05d", _codProd)).toString()  ;
    }

    private static String getFormatPreLiq2 (int _codProd , int _numPreliq ) {
        StringBuilder stb = new StringBuilder("pre");
        return stb.append(String.format("%08d", _numPreliq)).append(".").append(String.format("%05d", _codProd)).toString()  ;
    }

    /*
     * Armar Hash con las preliquidaciones
     */
    private static Hashtable getPreLiqHashtable(File _preliqFile,int _copProd) {
        Hashtable<Integer, Integer> preliqHash = new Hashtable<Integer, Integer>();
        String[] listFile = _preliqFile.list();
        for(int i=0; i<listFile.length; i++){
            String nameFile = listFile[i];
            File iFile = new File(_preliqFile +"/"+ nameFile);
            if (!iFile.isDirectory()) {
                String erPreLiq = "^PRE\\d[0-9]{7}.\\d[0-9]{4}$";
                String erPreLiq2 = "^pre\\d[0-9]{7}.\\d[0-9]{4}$";
                Pattern pattPreLiq = Pattern.compile(erPreLiq);
                Pattern pattPreLiq2 = Pattern.compile(erPreLiq2);
                Matcher matcherPreLiq = pattPreLiq.matcher(nameFile);
                Matcher matcherPreLiq2 = pattPreLiq2.matcher(nameFile);
                if (matcherPreLiq.matches() || matcherPreLiq2.matches() ){
                    int numPreLiq  = Integer.parseInt(nameFile.substring(3,11));
                    int numCodProd = Integer.parseInt(nameFile.substring(12,17));                    
                    if (  ( _copProd == 99999 ) || ( _copProd != 99999 && _copProd == numCodProd ) ) {
                        Integer numPreLiqHas = preliqHash.get(Integer.valueOf(numCodProd));
                        if (numPreLiqHas != null) {                                                        
                            if ( numPreLiqHas < numPreLiq) {
                                //System.out.println("     [SI] Graba en Hash el valor :" + numPreLiq + " --> "+numPreLiqHas+"(Hash Liq.) < " +numPreLiq+"(New Liq.)" );
                                //Grabar en Tabla de Hash la liquidacion obtenida < liquidacion del hash.-
                                preliqHash.put(numCodProd,numPreLiq);
                            }
                        } else {                            
                            preliqHash.put(numCodProd,numPreLiq);
                        }
                    }
                } 
            }
        }
        return preliqHash;
    }

    
    /*
     * Obtener Lote de Preliquidacion     
     */
    public static int getDBLote ( Connection dbCon)  throws SurException {
        return IntPreLiquidacion.getDBLote ( dbCon , "" );
    }

    public static int getDBLote ( Connection dbCon , String _BASE) throws SurException {        
        ResultSet rs = null;
        CallableStatement cons = null;
        int lote  = 0;        
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("INT_NUM_LOTE_PRELIQ()"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.execute();            
            return cons.getInt(1);
            
       } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());

        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }catch (Exception e) {
                throw new SurException (e.getMessage());
            }
            
        } 
        
    } //

    public static void anulacionMasivaPreliq ( Connection dbCon , int numLote ) throws SurException {
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_ANULACION_MASIVA_PRELIQ(?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, numLote );
            cons.execute();

       } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }catch (Exception e) {
                throw new SurException (e.getMessage());
            }
        }
    } //

    public static void insertarLote ( Connection dbCon , int numLote, String userId ) throws SurException {
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_SET_LOTE_PRELIQ (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, numLote );
            cons.setString (3, userId);
            cons.execute();

       } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }catch (Exception e) {
                throw new SurException (e.getMessage());
            }
        }
    } //

    public static LinkedList getDBErrorByLote ( Connection dbCon,int numLotePreliq)  throws SurException {
        return IntPreLiquidacion.getDBErrorByLote ( dbCon , "" ,numLotePreliq);
    }

    public static LinkedList getDBErrorByLote ( Connection dbCon ,  String _BASE , int numLotePreliq ) throws SurException {
        LinkedList lError = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("INT_GET_ERROR_PRELIQ_BY_LOTE(?)"));
             cons.registerOutParameter(1, java.sql.Types.OTHER);
             cons.setInt (2, numLotePreliq);
             cons.execute();
             rs = (ResultSet) cons.getObject(1);
             if (rs != null) {
                 while (rs.next()) {
                    ErrorPreliq oError = new ErrorPreliq();
                    oError.setNumLotePreliq(rs.getInt("NUM_LOTE_PRELIQ"));
                    oError.setNumPreliq(rs.getInt("NUM_PRELIQ"));
                    oError.setCodError(rs.getInt("COD_ERROR"));
                    oError.setCodProd(rs.getInt("COD_PROD"));
                    oError.setDescError(rs.getString("DESC_ERROR"));
                    lError.add(oError);
                }
                rs.close();
            }

        }  catch (SQLException se) {
            se.printStackTrace();
            throw new SurException (se.getMessage());
        } catch (Exception e) {
                e.printStackTrace();
                throw new SurException (e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                see.printStackTrace();
                throw new SurException (see.getMessage());
            }
            return lError;
        }
    }

    /*
     * Grabar Error de preLiquidacion
     */
    public static int setDBError ( Connection dbCon,
                                   int numLotePreliq, 
                                   int numPreliq ,
                                   int codError,
                                   int codProd,
                                   String descError
                                  )  throws SurException {
        return IntPreLiquidacion.setDBError ( dbCon , "" ,numLotePreliq,numPreliq,codError,codProd,descError);
    }

    public static int setDBError ( Connection dbCon ,  String _BASE ,
                                   int numLotePreliq, 
                                   int numPreliq ,
                                   int codError,
                                   int codProd,
                                   String descError
                                 ) throws SurException {
        CallableStatement cons  = null;
        try {
            dbCon.setAutoCommit(true);
             cons = dbCon.prepareCall(db.getSettingCall("INT_SET_ERROR_PRELIQ(?, ? ,? ,? ,?,?)"));
             cons.registerOutParameter(1, java.sql.Types.INTEGER);
             cons.setInt    (2, numLotePreliq);
             cons.setInt    (3, numPreliq);
             cons.setInt    (4, codError);
             cons.setInt    (5, codProd);
             cons.setString (6, descError);
             cons.setString (7, " ");

             cons.execute();
             return cons.getInt (1);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                se.printStackTrace();
                throw new SurException (se.getMessage());
            }
        }
    } //


    
    /*
     * Procesar Liquidacion     
     */
    public static int processDBPreliq ( Connection dbCon,
                                        int numLotePreliq,
                                        int numPreliq ,
                                        int codProd,
                                        String userid,
                                        Date lastModif
                                  )  throws SurException {
        return IntPreLiquidacion.processDBPreliq ( dbCon , "" , numLotePreliq, numPreliq, codProd, userid, lastModif);
    }

    public static int processDBPreliq ( Connection dbCon ,
                                        String _BASE ,
                                        int numLotePreliq,
                                        int numPreliq ,
                                        int codProd,
                                        String userid,
                                        Date lastModif
                                 ) throws SurException {
        CallableStatement cons  = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("INT_PRELIQUIDACION(?, ? ,? ,? ,?,?)"));
             cons.registerOutParameter(1, java.sql.Types.INTEGER);
             cons.setInt    (2, numLotePreliq);
             cons.setString (3, "");
             cons.setInt    (4, numPreliq);
             cons.setInt    (5, codProd);
             cons.setString (6, userid);
             cons.setDate   (7, Fecha.convertFecha(lastModif) );
             cons.execute();
             return cons.getInt (1);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    } //
}


