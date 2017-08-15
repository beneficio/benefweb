/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
     
package com.business.beans;
  
import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;
import java.io.*;


public class LoteEmision {
    
    private int codRama          = 0;
    private int numPoliza        = 0;
    private int numPolizaAnt     = 0;
    private int numPropuesta     = 0;
    private String numDocTom     = "";
    private Date fechaEmision    = null;
    private int estadoProp       = 0;
    private String descEstadoLote = "";
    private int codEstado        = 0;
    private String observacion   = ""; 
    private String userId        = "";
    private Date fechaTrabajo    = null;
    private int numLote          = 0;
    private String titulo        = "";
    private int minNumPoliza        = 0;
    private int minNumPolizaAnt     = 0;
    private int minNumPropuesta     = 0;
    private String minNumDocTom     = "";
    private int cantRegistros       = 0;
    private int cantErrores         = 0;
    private String tipoLote        = "R";
    private LinkedList lPropuestas = null;
    private int cantProcesados     = 0;
 
    private String sMensError      = new String();
    private int  iNumError         = 0;
    private String sPathAbsoluto   = "";
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public LoteEmision () {
    }

    public void setfechaEmision     (Date param) { this.fechaEmision = param; }
    public void setcodRama          (int param) { this.codRama = param; }
    public void setestadoProp       (int param) { this.estadoProp = param; }
    public void setnumPoliza        (int param) { this.numPoliza  = param; }
    public void setnumPolizaAnt     (int param) { this.numPolizaAnt  = param; }
    public void setnumPropuesta     (int param) { this.numPropuesta  = param; }
    public void setnumDocTom        (String param) { this.numDocTom = param; }
    public void setcodEstado        (int param) { this.codEstado  = param; }
    public void setobservacion      (String param) { this.observacion      = param; }
    public void setminNumPoliza        (int param) { this.minNumPoliza  = param; }
    public void setminNumPolizaAnt     (int param) { this.minNumPolizaAnt  = param; }
    public void setminNumPropuesta     (int param) { this.minNumPropuesta  = param; }
    public void setminNumDocTom        (String param) { this.minNumDocTom = param; }
    public void setuserId           (String param) { this.userId = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    public void setAllPropuestas    (LinkedList param) {this.lPropuestas = param;}
    public void setnumLote          (int param ){ numLote       = param; }
    public void settitulo           (String param){ titulo      = param; }
    public void setcantRegistros    (int param ){ cantRegistros = param; }
    public void setdescEstadoLote   (String param) { this.descEstadoLote = param; }
    public void settipoLote         (String param) { this.tipoLote  = param; }
    public void setcantErrores      (int param ){ cantErrores = param; }
    public void setcantProcesados   (int param ){ cantProcesados = param; }
    public void setsPathAbsoluto    (String param) { this.sPathAbsoluto  = param; }

    public Date getfechaEmision     () { return  this.fechaEmision;}
    public int getcodRama           () { return  this.codRama;}
    public int getnumPoliza         () { return this.numPoliza;}    
    public int getnumPolizaAnt      () { return this.numPolizaAnt;}    
    public int getnumPropuesta      () { return this.numPropuesta;}
    public String getnumDocTom      () { return this.numDocTom; }
    public int getcodEstado         () { return this.codEstado;}
    public String getobservacion    () { return this.observacion;}
    public int getestadoProp        () { return this.estadoProp ; }
    public String getuserId         () { return this.userId;}
    public Date getfechaTrabajo     () { return  this.fechaTrabajo;}
    public LinkedList getAllPropuestas () {return lPropuestas;}
    public int    getnumLote       () {return this.numLote; }
    public String gettitulo  () {return this.titulo; }
    public int getminNumPoliza         () { return this.minNumPoliza;}
    public int getminNumPolizaAnt      () { return this.minNumPolizaAnt;}
    public int getminNumPropuesta      () { return this.minNumPropuesta;}
    public String getminNumDocTom      () { return this.minNumDocTom; }
    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    public int getcantRegistros  () { return this.cantRegistros;}
    public String getdescEstadoLote      () { return this.descEstadoLote; }
    public String gettipoLote    () { return this.tipoLote; }
    public int getcantErrores  () { return this.cantErrores;}
    public int getcantProcesados  () { return this.cantProcesados;}
    public String getsPathAbsoluto() { return this.sPathAbsoluto; }

    public LoteEmision getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_GET_LOTE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumLote());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setnumLote         (rs.getInt ("NUM_LOTE"));
                    this.setfechaTrabajo    (rs.getDate ("FECHA_TRABAJO"));
                    this.setcodEstado       (rs.getInt ("ESTADO"));
                    this.setobservacion     (rs.getString ("OBSERVACIONES"));
                    this.settitulo          (rs.getString ("TITULO"));
                    this.setuserId          (rs.getString ("USERID"));
                    this.setcantRegistros   (rs.getInt ("CANT_REGISTROS"));
                    this.setcantErrores     (rs.getInt ("CANT_ERRORES"));
                    this.setcantProcesados  (rs.getInt ("CANT_PROCESADOS"));
                    this.settipoLote        (rs.getString ("TIPO_LOTE"));
                    this.setdescEstadoLote  (rs.getString ("DESC_ESTADO"));
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE EL LOTE");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LoteEmision setDBEmitir ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {

           this.getDB(dbCon);
            if (this.getiNumError() < 0) {
                throw new SurException(this.getsMensError());
           }
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_PROCESAR_LOTE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumLote());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setnumLote(rs.getInt ("NUM_LOTE"));
                    this.setfechaTrabajo(rs.getDate ("FECHA_TRABAJO"));
                    this.setcodEstado(rs.getInt ("ESTADO"));
                    this.setobservacion(rs.getString ("OBSERVACIONES"));
                    this.settitulo(rs.getString ("TITULO"));
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE EL LOTE");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LoteEmision setDB ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_SET_LOTE (?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt     (2, this.getnumLote());
            cons.setInt     (3, this.getcodEstado());
            cons.setString  (4, this.getobservacion());
            cons.setString  (5, this.gettitulo());
            cons.setString  (6, this.getuserId());
            cons.setInt     (7, this.getcantRegistros());
            cons.setInt     (8, this.getcantErrores());
            cons.setString  (9, this.gettipoLote());
            cons.setInt     (10, this.getcantProcesados());
            cons.execute();

            this.setnumLote(cons.getInt (1));

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error LoteEmision [setDB]:" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error LoteEmision [setDB]:" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LoteEmision setDBValidarEmision ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_VALIDAR_EMISION (?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt     (2, this.getnumLote());
            cons.execute();

            this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LoteEmision setDBRenovar ( Connection dbCon) throws SurException {
        CallableStatement cons  = null;
        FileWriter fw = null;
        BufferedWriter bw = null;
        PrintWriter  salida = null;
        FileReader fr = null;
        BufferedReader br = null;
        int cantLeidos   = 0;
        int cantErrores  = 0;

        try {  

           String  _fileRenovar = "";
           String  _fileLog     = "";

           String osName = System.getProperty("os.name" );
           if ( osName.contains("Windows")) {
                _fileRenovar =  this.getsPathAbsoluto() + "\\renovar_" + this.getnumLote() + ".csv";
                _fileLog     =  this.getsPathAbsoluto() + "\\renovar_log_"+ this.getnumLote() + ".csv";
           } else {
                _fileRenovar =  this.getsPathAbsoluto() + "/renovar_" + this.getnumLote() + ".csv";
                _fileLog     =  this.getsPathAbsoluto() + "/renovar_log_"+ this.getnumLote() + ".csv";
           }

           String  separador    = ";";

           fw = new FileWriter( _fileLog );
           bw = new BufferedWriter(fw);
           salida = new PrintWriter(bw);
           File fRenovar = new File(_fileRenovar );
           if(!fRenovar.isFile()){
               this.setcodEstado(3);
               this.setDB(dbCon);

               throw new SurException("NO SE ENCONTRO EL ARCHIVO renovar.csv");
            }
            fr = new FileReader (fRenovar);
            br = new BufferedReader(fr);

         // Lectura del fichero
            this.setcodEstado(1);
            String linea;
            int nLinea = 0;
            while((linea=br.readLine())!=null) {
                nLinea = nLinea + 1;
                String [] datos = linea.split (";") ;
                String sError = "OK";
                boolean bError =false;
                if (! datos[0].equals ("10") &&
                    ! datos[0].equals ("18") &&
                    ! datos[0].equals ("21") &&
                    ! datos[0].equals ("22") &&
                    ! datos[0].equals ("23") &&
                    ! datos[0].equals ("25")  ) {
                    if (nLinea == 1) {
                         salida.println (linea + separador + "NUM_PROPUESTA_ACTUAL" +
                                 separador + "PREMIO_ACTUAL" + separador +
                                 "FACT_ACTUAL" + separador + "CANT_CUOTAS_ACTUAL"+ separador + "CANT_VIDAS_ACTUAL" + separador + "ESTADO");
                        continue;
                    } else {
                        bError = true;
                        sError =  "LA PRIMERA COLUMNA NO ES UNA RAMA VALIDA";
                    }
                }
                int iNumPropuesta = 0;
                double premioActual = 0;
                int factActual = 0;
                int cantCuotasActual = 0;
                int cantVidasActual  = 0;

                int iCodRama    = Integer.parseInt (datos[0]);
                int iPolizaAnt  = Integer.parseInt (datos[1]);
                int iCantVidas  = Integer.parseInt (datos[2]);

                LoteEmisionDetalle oDetalle = new LoteEmisionDetalle();
                oDetalle.setnumLote ( this.getnumLote());
                oDetalle.setnumPolizaAnt(iPolizaAnt);
                oDetalle.setcodRama(iCodRama);

                cantLeidos = cantLeidos + 1;
                int iEstadoPropuesta = 1;
                try {
                    dbCon.setAutoCommit(true);
                    cons = dbCon.prepareCall(db.getSettingCall("REN_SET_RENOVACION  (?,?,?,?,?,?)"));
                    cons.registerOutParameter(1, java.sql.Types.INTEGER);
                    cons.setInt (2, iCodRama);
                    cons.setInt (3, iPolizaAnt);
                    cons.setInt (4, iCantVidas);
                    cons.setInt (5, 0);
                    cons.setString (6, "BA");
                    cons.setString (7, this.getuserId());

                    cons.execute();
                    iNumPropuesta = cons.getInt(1);

                    cons.close();

                } catch (SQLException se){
                    bError = true;
                    sError =  se.getMessage();
                    iEstadoPropuesta = -1;
                }

                if (!bError) {
                    if (iNumPropuesta > 0) {
                        // enviar propuesta
                        Propuesta oProp = new Propuesta ();
                        oProp.setNumPropuesta( iNumPropuesta);

                        oProp.getDB(dbCon);
                        premioActual = oProp.getImpPremio();
                        factActual = oProp.getCodFacturacion();
                        cantCuotasActual = oProp.getCantCuotas();
                        cantVidasActual  = oProp.getCantVidas();
/*
                        oProp.setUserid      ("BATCH");
                        oProp.setCodEstado   ( 1 );

                        oProp.setDBEstado(dbCon);

                        if (oProp.getCodError() < 0) {
                            sError = ConsultaMaestros.getdescError(dbCon, oProp.getCodError(), "PROPUESTA");
                            if (sError == null || sError.equals ("")) {
                                sError = oProp.getDescError();
                            }
                            bError = true;
                            iEstadoPropuesta = 3;
                        }
 *
 */
                    } else {
                        iEstadoPropuesta = -1;
                        bError = true;
                        sError = ConsultaMaestros.getdescError(dbCon, iNumPropuesta, "RENOVACIONES");
                    }
                }

                 salida.println (linea + separador + iNumPropuesta + separador + premioActual + separador +
                         factActual + separador + cantCuotasActual + separador + cantVidasActual + separador + sError);

                oDetalle.setestadoProp      (iEstadoPropuesta);
                oDetalle.setobservacion     (sError);
                oDetalle.setnumPropuesta    (iNumPropuesta);
                oDetalle.setDB  (dbCon);

                if (oDetalle.getiNumError() < 0 ) {
                    throw new SurException(oDetalle.getsMensError());
                }
                if (oDetalle.getestadoProp() == -1 ) {
                    cantErrores = cantErrores + 1;
                }
            }

            this.setcantErrores(cantErrores);
            this.setcantProcesados(cantLeidos);
            if ( cantErrores > 0 ) {
                this.setcodEstado(3);
            }
            this.setDB(dbCon);

            fr.close();
        // Renombramos el archivo de entrada.
        fRenovar.renameTo ( new File (_fileRenovar + ".OK"));

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            if (salida != null) salida.close();
            try {
                if (bw != null) bw.close();
                if (fw != null) fw.close();
            } catch (IOException io) {
                throw new SurException(io.getMessage());
            }
            return this;
        }
    }

    public LinkedList getDBAllDetalle ( Connection dbCon) throws SurException {
        LinkedList lDet = new LinkedList();
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_GET_ALL_DETALLE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumLote());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    LoteEmisionDetalle oLote = new LoteEmisionDetalle ();
                    oLote.setnumLote      (rs.getInt ("NUM_LOTE"));
                    oLote.setcodRama      (rs.getInt ("COD_RAMA"));
                    oLote.setnumPolizaAnt (rs.getInt ("POLIZA_ANTERIOR"));
                    oLote.setnumPropuesta (rs.getInt ("NUM_PROPUESTA"));
                    oLote.setfechaTrabajo (rs.getDate("FECHA_TRABAJO"));
                    oLote.setobservacion  (rs.getString ("OBSERVACIONES"));
                    oLote.setnumPoliza    (rs.getInt ("NUM_POLIZA"));
                    oLote.setnumDocTom    (rs.getString ("NUM_DOC_TOM"));
                    oLote.setestadoProp   (rs.getInt ("ESTADO"));
                    oLote.setdescEstadoPropuesta(rs.getString ("DESC_ESTADO"));
                    lDet.add(oLote);
                }
                rs.close();
            }

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error LoteEmision [getDBAllDetalle]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error LoteEmision [getDBAllDetalle]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lDet;
        }
    }

    public int setDBEnviarLote ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        int cantErrores = 0;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_GET_ALL_DETALLE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumLote());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    if ( rs.getInt ("NUM_PROPUESTA") > 0 && rs.getInt ("ESTADO") == 0) {
                        LoteEmisionDetalle oLote = new LoteEmisionDetalle ();
                        oLote.setnumLote      (rs.getInt ("NUM_LOTE"));
                        oLote.setcodRama      (rs.getInt ("COD_RAMA"));
                        oLote.setnumPolizaAnt (rs.getInt ("POLIZA_ANTERIOR"));
                        oLote.setnumPropuesta (rs.getInt ("NUM_PROPUESTA"));
                        oLote.setestadoProp(1);

                        // enviar propuesta
                        Propuesta oProp = new Propuesta ();
                        oProp.setNumPropuesta( oLote.getnumPropuesta());

                        oProp.getDB(dbCon);

                        oProp.setUserid      ("BATCH");
                        oProp.setCodEstado   ( 1 );

                        oProp.setDBEstado(dbCon);

                        if (oProp.getCodError() < 0) {
                            oLote.setobservacion(ConsultaMaestros.getdescError(dbCon, oProp.getCodError(), "PROPUESTA"));
                            if ( oLote.getobservacion() == null || oLote.getobservacion().equals ("")) {
                                oLote.setobservacion(oProp.getDescError());
                            }
                            oLote.setestadoProp(-2);
                            cantErrores = cantErrores + 1;
                        }
                        oLote.setDB(dbCon);
                        if (oLote.getiNumError() < 0) {
                            throw new SurException (oLote.getsMensError());
                        }
                    }

                }
                rs.close();
            }


        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error LoteEmision [getDBAllDetalle]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error LoteEmision [getDBAllDetalle]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return cantErrores;
        }
    }

    public LoteEmision setActualizarLog ( Connection dbCon) throws SurException {
        CallableStatement cons  = null;
        FileWriter fw = null;
        BufferedWriter bw = null;
        PrintWriter  salida = null;
        FileReader fr = null;
        BufferedReader br = null;

        try {

           String  _fileRenovar = "";
           String  _fileLog     = "";

           String osName = System.getProperty("os.name" );
           if ( osName.contains("Windows")) {
                _fileRenovar =  this.getsPathAbsoluto() + "\\renovar_" + this.getnumLote() + ".csv.OK";
                _fileLog     =  this.getsPathAbsoluto() + "\\renovar_log_"+ this.getnumLote() + ".csv";
           } else {
                _fileRenovar =  this.getsPathAbsoluto() + "/renovar_" + this.getnumLote() + ".csv.OK";
                _fileLog     =  this.getsPathAbsoluto() + "/renovar_log_"+ this.getnumLote() + ".csv";
           }


           String  separador    = ";";

           fw = new FileWriter( _fileLog );
           bw = new BufferedWriter(fw);
           salida = new PrintWriter(bw);
           File fRenovar = new File(_fileRenovar );
           if(!fRenovar.isFile()){
               this.setcodEstado(3);
               this.setDB(dbCon);

               throw new SurException("NO SE ENCONTRO EL ARCHIVO renovar.csv");
            }
            fr = new FileReader (fRenovar);
            br = new BufferedReader(fr);

         // Lectura del fichero
            String linea;
            int nLinea = 0;
            while((linea=br.readLine())!=null) {
                nLinea = nLinea + 1;
                String [] datos = linea.split (";") ;
                if (! datos[0].equals ("10") &&
                    ! datos[0].equals ("18") &&
                    ! datos[0].equals ("21") &&
                    ! datos[0].equals ("22") &&
                    ! datos[0].equals ("23") &&
                    ! datos[0].equals ("25")  ) {
                    if (nLinea == 1) {
                         salida.println (linea + separador + "NUM_PROPUESTA_ACTUAL" +
                                 separador + "PREMIO_ACTUAL" + separador +
                                 "FACT_ACTUAL" + separador + "CANT_CUOTAS_ACTUAL"+ separador + "CANT_VIDAS_ACTUAL" + separador + "ESTADO");
                        continue;
                    }
                }

                double premioActual = 0;
                int factActual = 0;
                int cantCuotasActual = 0;
                int cantVidasActual  = 0;

                int iCodRama    = Integer.parseInt (datos[0]);
                int iPolizaAnt  = Integer.parseInt (datos[1]);

                LoteEmisionDetalle oDetalle = new LoteEmisionDetalle();
                oDetalle.setnumLote ( this.getnumLote());
                oDetalle.setnumPolizaAnt(iPolizaAnt);
                oDetalle.setcodRama(iCodRama);
                oDetalle.getDB(dbCon);

                if (oDetalle.getnumPropuesta() > 0) {
                    Propuesta oProp = new Propuesta ();
                    oProp.setNumPropuesta( oDetalle.getnumPropuesta ());

                    oProp.getDB(dbCon);
                    premioActual = oProp.getImpPremio();
                    factActual = oProp.getCodFacturacion();
                    cantCuotasActual = oProp.getCantCuotas();
                    cantVidasActual  = oProp.getCantVidas();

                }

                 salida.println (linea + separador + oDetalle.getnumPropuesta() + separador + premioActual + separador +
                         factActual + separador + cantCuotasActual + separador + cantVidasActual + separador + oDetalle.getobservacion());


            }

            fr.close();

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            if (salida != null) salida.close();
            try {
                if (bw != null) bw.close();
                if (fw != null) fw.close();
            } catch (IOException io) {
                throw new SurException(io.getMessage());
            }
            return this;
        }
    }

/*
    public Poliza getDB ( Connection dbCon) throws SurException {
        Date oTime = new Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(oTime);
        ResultSet rs = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_POLIZA (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setnumPoliza           (rs.getInt("NUM_POLIZA"));
                    this.setobservacion            (rs.getString ("RAMA"));
                    this.setestadoProp             (rs.getInt ("COD_PROD"));
                    this.setcodEstado          (rs.getInt ("NUM_TOMADOR"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION_POL"));
                    this.setestadoProp           (rs.getInt ("CANT_VIDAS"));
                    this.setnumPropuesta        (rs.getInt ("NUM_PROPUESTA"));
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE LA POLIZA");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    
*/

}


