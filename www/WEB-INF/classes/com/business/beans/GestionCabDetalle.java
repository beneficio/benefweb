
//Title Bean Gestion Cabecera Detalle

package com.business.beans;

import java.util.Date;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;
public class GestionCabDetalle{

private  int 		codGestion      =0;
private  int 		fila 		=0;
private  int 		codEstado       =0;
private  String  	desEstado  	="" ;
private  String  	codProdDc 	="" ;
private  int            codProd         =0;
private  int            codOrg          =0;
private int             codRama         =0;
private	int		codSubRama	=0;
private	int  		numPoliza	=0;
private	int		endoso		=0;
private String  	asegurado       ="" ;
private	int 		codMon		= 0;
private String          sSignoMon       = "";
private Date		fechaUltPago	=null;
private	Date		fechaVenc	=null;
private int		numCuota	=  0;
private	int  		totalCuotas	=  0;
private	double          impCuotaMes     = 0;
private  double 	impCuotaVenc    =0;
private  double         impNetoRendir   =0;
private  String         observaciones   = "";
private  String         email		= "";
private int             periodo         = 0;
private String          cuit            = "";
private  int            codError        = 0;
private String          descProductor   = "";
private int             zona            = 0;
private  String         strMensajeError ="";
private int             numTomador      = 0;
private String         color            = null;
private int             estadoDeuda     = 0;
private double         impSaldoEnd      = 0;

private CallableStatement cons          = null;
//-----------------------------------------------------

//-----------------------------------------------------
/*
|| Crea una  nueva instancia de la Cabecera  Detalle de Gestion
*/
public GestionCabDetalle(){
}
/*
||Definicion de los metos  setter.
*/
public void 	setcodGestion       (int    param){this.codGestion      = param;}
public void  	setFila             (int    param){this.fila            = param;}
public void 	setCodEstado        (int    param){this.codEstado       = param;}
public void 	setDesEstado        (String param){this.desEstado       = param;}
public void 	setCodProdDc        (String param){this.codProdDc       = param;}
public void 	setCodProd          (int    param){this.codProd         = param;}
public void 	setCodOrg           (int    param){this.codOrg          = param;}
public void 	setCodRama          (int    param){this.codRama         = param;}
public void 	setCodSubRama       (int    param){this.codSubRama      = param;}
public void 	setNumPoliza        (int    param){this.numPoliza       = param;}
public void 	setEndoso           (int    param){this.endoso          = param;}
public  void 	setAsegurado        (String param){this.asegurado       = param;}
public void 	setCodMon           (int    param){this.codMon          = param;}
public void	setFechaUltPago     (Date   param){this.fechaUltPago    = param;}
public void 	setFechaVenc        (Date   param){this.fechaVenc       = param;}
public void 	setNumCuota         (int    param){this.numCuota        = param;}
public void 	setTotalCuotas      (int    param){this.totalCuotas     = param;}	
public void 	setImpCuotaMes      (double param){this.impCuotaMes     = param;}
public void 	setImpCuotaVenc     (double param){this.impCuotaVenc    = param;}
public void 	setImpNetoRendir    (double param){this.impNetoRendir   = param;}
public  void 	setObservaciones    (String param){this.observaciones   = param;}
public void 	setEmail            (String param){this.email           = param;}	
public  void 	setCodError         (int    param){this.codError        = param;}
public void 	setMensajeError     (String param){this.strMensajeError = param;}
public void 	setsSignoMon       (String param){this.sSignoMon       = param;}
public  void 	setperiodo         (int    param){this.periodo          = param;}
public void 	setCuit            (String param){this.cuit            = param;}
public  void 	setzona            (int    param){this.zona             = param;}
public void 	setdescProductor   (String param){this.descProductor    = param;}
public  void 	setnumTomador      (int    param){this.numTomador       = param;}
public void 	setcolor           (String param){this.color            = param;}
public  void 	setestadoDeuda     (int    param){this.estadoDeuda      = param;}
public  void 	setimpSaldoEnd     (double param){this.impSaldoEnd      = param;}

/*
|| Definicion de los metos getter
*/
public  int         getcodGestion   (){	return  this.codGestion ;}
public  int         getFila         (){	return  this.fila       ;}
public  int         getCodEstado    (){	return 	this.codEstado 	;}
public  String      getDesEstado    (){ return  this.desEstado	;}
public  String      getCodProdDc    (){	return  this.codProdDc	;}
public  int         getCodProd      (){	return  this.codProd 	;}
public  int         getCodOrg	    (){	return  this.codOrg 	;}
public  int         getCodRama      (){	return  this.codRama 	;}
public  int         getCodSubRama   (){ return  this.codSubRama ;}
public  int         getNumPoliza    (){	return  this.numPoliza  ;}
public  int         getEndoso	    (){	return  this.endoso     ;}
public  String      getAsegurado    (){	return  this.asegurado  ;}
public  int         getCodMon	    (){	return  this.codMon     ;}
public  Date        getFechaUltPago (){	return  this.fechaUltPago;}
public  Date        getFechaVenc    (){	return  this.fechaVenc      ;}
public  int         getNumCuota	    (){	return  this.numCuota       ;}
public  int         getTotalCuotas  (){ return  this.totalCuotas    ;}	
public  double      getImpCuotaMes  (){ return  this.impCuotaMes    ;}
public  double      getImpCuotaVenc (){ return  this.impCuotaVenc   ;}
public  double      getImpNetoRendir(){ return  this.impNetoRendir  ;}
public  String      getObservaciones(){ return  this.observaciones  ;}
public  String      getEmail	    (){ return  this.email          ;}	
public  int         getCodError     (){ return  this.codError       ;}
public  String      getMensajeError (){ return  this.strMensajeError;}
public  String      getsSignoMon    (){ return  this.sSignoMon;}
public  int         getperiodo      (){ return  this.periodo       ;}
public  String      getcuit         (){ return  this.cuit;}
public  int         getzona         (){ return  this.zona;}
public  String      getdescProductor (){ return  this.descProductor;}
public  int         getnumTomador   (){ return  this.numTomador;}
public  String      getcolor        (){ return  this.color;}
public  int         getestadoDeuda  (){ return this.estadoDeuda;}
public  double      getimpSaldoEnd  (){ return this.impSaldoEnd;}


public void  setDB ( Connection dbCon) throws SurException {               
        
       try {
            dbCon.setAutoCommit(true);
	    cons = dbCon.prepareCall(db.getSettingCall("CO_SET_DETA_GESTION(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt(2,getcodGestion());
            cons.setInt(3,getFila());
	    cons.setInt(4,getCodEstado());
            cons.setString(5,getDesEstado());
            cons.setString(6,getCodProdDc());
            cons.setInt(7,getCodProd());
            cons.setInt(8,getCodOrg());            
            cons.setInt(9,getCodRama());
            cons.setInt(10,getCodSubRama());
            cons.setInt(11,getNumPoliza());
            cons.setInt(12,getEndoso());
            cons.setString(13,getAsegurado() );
            cons.setInt(14,getCodMon() );
            if (getFechaUltPago() == null ){
                cons.setNull(15, java.sql.Types.DATE);
            } else {
                cons.setDate (15,Fecha.convertFecha(getFechaUltPago())) ;
           }
            if (getFechaVenc() == null) {
                cons.setNull(16, java.sql.Types.DATE);
            } else {
                cons.setDate(16,Fecha.convertFecha(getFechaVenc())) ;
           }
            cons.setInt(17,getNumCuota() );
            cons.setInt(18,getTotalCuotas() ) ;
            cons.setDouble(19,getImpCuotaMes() ) ;
            cons.setDouble(20,getImpCuotaVenc() );
            cons.setDouble(21,getImpNetoRendir()  ) ;
            cons.setString(22,getObservaciones ()  );
            cons.setString(23,getEmail()) ;
            cons.setInt (24,getperiodo()) ;
            cons.setString (25,getcuit());
            cons.setInt    (26, getzona());
            cons.setInt    (27, getnumTomador());
            cons.setString (28,getcolor());
            cons.setInt     (29,getestadoDeuda() ) ;
            cons.setDouble  (30,getimpSaldoEnd()) ;            
            

            cons.execute();  

            this.setCodError(cons.getInt(1));
            
        } catch (SQLException se) {
                setCodError (-1);
                setMensajeError ("GestionCabDetalle [setDB]:" +  se.getMessage());
        }catch (Exception e) {
                setCodError (-1);
                setMensajeError ("GestionCabDetalle [setDB]:" + e.getMessage());
        }finally {
            try {
                if (cons != null) { cons.close (); }
                } catch (SQLException see){
                 throw new SurException (see.getMessage());
                }          
        }   
    }
public void setDBEstadoEnvioProductor ( Connection dbCon)
        throws SurException {
    CallableStatement cons = null;
    try {
    dbCon.setAutoCommit(true);
    cons = dbCon.prepareCall(db.getSettingCall("CO_SET_GESTION_ESTADO_PROD(?,?,?,?,?)"));
    cons.registerOutParameter(1, java.sql.Types.INTEGER);
    cons.setInt   (2, this.getcodGestion() );
    cons.setInt   (3, this.getCodProd());
    cons.setString(4, this.getCodProdDc());
    cons.setInt   (5, this.getCodEstado());
    cons.setString(6, this.getDesEstado());


    cons.execute();
    this.setCodError(cons.getInt(1));

    } catch (SQLException se) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[ setDBEstadoEnvioProductor]: " + se.getMessage());
    } catch (Exception e) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[ setDBEstadoEnvioProductor]: " + e.getMessage());
    } finally {
        try{
            if (cons != null) cons.close ();
        } catch (SQLException see) {
        throw new SurException (see.getMessage());
        }
    }
}

}                

  