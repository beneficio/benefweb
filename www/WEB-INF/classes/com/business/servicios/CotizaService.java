/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.servicios;

import com.business.beans.ActividadCategoria;
import java.lang.reflect.Modifier;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;  
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;

import com.business.beans.Producto;
import com.business.beans.Cotizacion;
import com.business.beans.Vigencia;
import com.business.beans.ConsultaMaestros;
import com.business.beans.Tablas;
import com.business.beans.OpcionAjuste;
import com.business.beans.CoberturaDetalle;
import com.business.util.*;
import com.business.db.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;


/**      
 * REST Web Service
 *
 * @author Rolando Elisii
 */

@Path("cotizaService")
public class CotizaService {

    /** Creates a new instance of CotizaVC */
    public CotizaService () {
    }

    /**
     * Retrieves representation of an instance of com.business.servicios.CotizaVC
     * @return an instance of java.lang.String
     */
    @GET
    @Produces("application/xml")
    public String getXml() {
        //TODO return proper representation object
        throw new UnsupportedOperationException();
    }

    /**
     * PUT method for updating or creating an instance of CotizaVC
     * @param content representation for the resource
     * @return an HTTP response with content of the updated or created resource.
     */

    	@GET
	@Path("/productos")
	@Produces(MediaType.APPLICATION_JSON)
	public String productos (
                        @QueryParam("cod_rama") int iCodRama,
			@QueryParam("cod_prod") int iCodProd,
                        @QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("usuario") String sUser) throws SurException {


        try {

            LinkedList lProd = null;
            Tablas  oTabla   = new Tablas ();
            lProd = oTabla.getProductos(iCodRama, iCodSubRama, iCodProd, sUser, "C"); // productos para el cotizador

            if (lProd.size() == 0) {
                lProd.add( new Producto  (0, "No existen productos para la subrama"));
            } 

                Gson gson = new GsonBuilder()
                .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
                .create();
                return gson.toJson(lProd);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            }
	}

	@GET
	@Path("/vigencias")
	@Produces(MediaType.APPLICATION_JSON)
	public String Vigencias (
                        @QueryParam("cod_rama") int iCodRama,
			@QueryParam("cod_prod") int iCodProd,
                        @QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("cod_producto") int iCodProducto) throws SurException {

       Connection dbCon = null;
        try {

                dbCon = db.getConnection();
                LinkedList lVig = ConsultaMaestros.getAllVigencias(dbCon, iCodRama, iCodSubRama, iCodProducto, 0);

                if ( lVig.size() == 0) {
                    lVig.add ( new Vigencia ( 0, "No existe vigencia para el producto "));
                } 

           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(lVig);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }

	@GET
	@Path("/recotizarVC")
	@Produces(MediaType.APPLICATION_JSON)
	public String RecotizarVC (
                        @QueryParam("num_cotizacion") int numCotiz,
			@QueryParam("premio") double premio,
                        @QueryParam("premio_orig") double premioOrig,
                        @QueryParam("prima") double prima,
                        @QueryParam("prima_orig") double primaOrig,
                        @QueryParam("comision") double comision,
                        @QueryParam("comision_orig") double comisionOrig ) throws SurException {

       Connection dbCon = null;
        try {
           dbCon = db.getConnection();

           String recotiza = null;
           if (premio == 0 && comision == 0)
               recotiza = "R";
           else if ( premio != premioOrig)
               recotiza = "RP";
           else if (comision != comisionOrig)
               recotiza = "RC";

           Cotizacion oCot = new Cotizacion();
           oCot.setnumCotizacion(numCotiz);
           oCot.setpremio       ( premio );
           oCot.setgastosAdquisicion( comision );
           oCot.setDBCotizarVC (dbCon, recotiza);

           int iErrorCotizacion = oCot.getiNumError();
           oCot.getDB           (dbCon);

           oCot.setiNumError(iErrorCotizacion);
           if (oCot.getiNumError() > 0 ) {
               switch (oCot.getiNumError() ) {
                   case 200: oCot.setsMensError("EL MAXIMO DE COMISION POSIBLE ES " + oCot.getgastosAdquisicion());
                   break;
                   case 300: oCot.setsMensError("HA LLEGADO EL TOPE MAXIMO DEL PREMIO");
                   break;
                   case 500: oCot.setsMensError("HA LLEGADO EL TOPE MINIMO DEL PREMIO");
                   break;
                   case 600: oCot.setsMensError("OPERACIONES DIRECTA NO PUEDE MANIPULAR PREMIO NI COMISION ");
                   break;
                   default: oCot.setsMensError("PREMIO MINIMO. EL PREMIO NO PUEDE SER MENOR AL CALCULADO CON COMISION 0%");
               }
           }

           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(oCot);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }

	@GET    
	@Path("/recotizarAP")
	@Produces(MediaType.APPLICATION_JSON)
	public String RecotizarAp (
                        @QueryParam("num_cotizacion") int numCotiz,
			@QueryParam("premio") double premio,
                        @QueryParam("premio_orig") double premioOrig,
                        @QueryParam("prima") double prima,
                        @QueryParam("prima_orig") double primaOrig,
                        @QueryParam("comision") double comision,
                        @QueryParam("comision_orig") double comisionOrig ) throws SurException {

       Connection dbCon = null;
        try {
           dbCon = db.getConnection();

           String recotiza = null;
           if (premio == 0 && comision == 0)
               recotiza = "R";
           else if ( premio != premioOrig)
               recotiza = "RP";
           else if (comision != comisionOrig)
               recotiza = "RC";

           Cotizacion oCot = new Cotizacion();
           oCot.setnumCotizacion(numCotiz);
           oCot.setpremio       ( premio );
           oCot.setgastosAdquisicion( comision );
           oCot.setDBCotizarAp (dbCon, recotiza);

           int iErrorCotizacion = oCot.getiNumError();
           oCot.getDB           (dbCon);
           
           oCot.setiNumError(iErrorCotizacion);
           if (oCot.getiNumError() > 0 ) {
               switch (oCot.getiNumError() ) {
                   case 200: oCot.setsMensError("EL MAXIMO DE COMISION POSIBLE ES " + oCot.getgastosAdquisicion());
                   break;
                   case 300: oCot.setsMensError("HA LLEGADO EL TOPE MAXIMO DEL PREMIO");
                   break;
                   case 500: oCot.setsMensError("HA LLEGADO EL TOPE MINIMO DEL PREMIO");
                   break;
                   case 600: oCot.setsMensError("OPERACIONES DIRECTA NO PUEDE MANIPULAR PREMIO NI COMISION ");
                   break;
                   default: oCot.setsMensError("PREMIO MINIMO. EL PREMIO NO PUEDE SER MENOR AL CALCULADO CON COMISION 0%");
               }
           }
                
           oCot.getDBFinanciacion(dbCon);

           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(oCot);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }

        // utilizado en la sopala 1  del Cotizador AP
    	@GET
	@Path("/opciones")
	@Produces(MediaType.APPLICATION_JSON)
	public String opciones (
                        @QueryParam("cod_rama") int iCodRama,
			@QueryParam("cod_prod") int iCodProd,
                        @QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("usuario") String sUser,
                        @QueryParam("cod_ambito") int iCodAmbito) throws SurException {


        try {

            Tablas  oTabla   = new Tablas ();
            LinkedList lOpciones = oTabla.getOpcionesAjuste (iCodRama, iCodSubRama, iCodProd, sUser, iCodAmbito);
            if (lOpciones.size () == 0) {
                OpcionAjuste oOpcion = new OpcionAjuste();
                oOpcion.setcodOpcion(-1);
                if (iCodProd == 0 && sUser.equals ("PROD"))  {
                    oOpcion.setdescripcion("Debe seleccionar un productor");
                }  else {
                    oOpcion.setdescripcion("No existen opcionales");
                }
            }

            Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();
            return gson.toJson(lOpciones);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            }
	}

        // utilizado en la sopala 1  del Cotizador AP
        // EN DESUSO !!!!!
    	@GET
	@Path("/actividades")
	@Produces(MediaType.APPLICATION_JSON)
	public String actividades (
                        @QueryParam("cod_rama")     int iCodRama,
			@QueryParam("cod_prod")     int iCodProd,
                        @QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("cod_producto") int iCodProducto,
                        @QueryParam("cod_rubro")    int iCodRubro) throws SurException {


        try {
            Tablas  oTabla   = new Tablas ();
            LinkedList lAct = oTabla.getActividades(iCodRama, iCodSubRama, iCodProducto, iCodRubro);

            if (lAct.size () == 0) {
                ActividadCategoria ac = new ActividadCategoria();
                ac.setcodActividad(0);
                ac.setiCodRubro(iCodRubro);
                ac.setdescripcion("No existen actividades");
            }

            Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();
            return gson.toJson(lAct);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            }
	}

        // utilizado en la sopala 1  del Cotizador AP
        // EN DESUSO !!!!!
    	@GET
	@Path("/get_sumas_ap")
	@Produces(MediaType.APPLICATION_JSON)
	public String get_sumas_ap (
                        @QueryParam("cod_rama")     int iCodRama,
			@QueryParam("cod_prod")     int iCodProd,
                        @QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("cod_producto") int iCodProducto,
                        @QueryParam("cod_actividad") int iCodActividad) throws SurException {

        Connection dbCon = null;
        CallableStatement proc = null;
        ResultSet rs = null;
        LinkedList lSumas = new LinkedList();
        try {

            try  {
                dbCon = db.getConnection();
                dbCon.setAutoCommit(false);
                proc = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_MAX_SUMAS_ASEGURADAS ( ?, ?, ?,?,?)"));
                proc.registerOutParameter(1, java.sql.Types.OTHER);
                proc.setInt(2, iCodRama );
                proc.setInt(3, iCodSubRama);
                proc.setInt(4, iCodActividad );
                proc.setInt(5, iCodProd);
                proc.setInt(6, iCodProducto);

                proc.execute();

                rs = (ResultSet) proc.getObject(1);
                if (rs != null) {
                    while (rs.next ()) {
                        CoberturaDetalle cd = new CoberturaDetalle ();

                        cd.setcodCob     (rs.getInt ("COD_COBERTURA") );
                        cd.setsumaMaxima (rs.getDouble("MAX_SUMA_ASEGURADA"));
                        cd.setsumaMinima (rs.getDouble("MIN_SUMA_ASEGURADA"));
                        lSumas.add(cd);
                    }
                }
            } catch (SQLException se ) {
                throw new SurException( (se.getMessage()));
            } finally {
                try {
                    if (rs != null ) rs.close(); 
                    if (proc != null) proc.close(); 
                } catch (SQLException sse) {
                    throw new SurException(sse.getMessage());
                }
                db.cerrar(dbCon);                
            }

            if (lSumas.size () == 0) {
                CoberturaDetalle cd = new CoberturaDetalle();
                cd.setcodCob(0 );
                cd.setsumaMaxima (0);
                cd.setsumaMinima(0);
                lSumas.add(cd);
            }

            Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();
            return gson.toJson(lSumas);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            }
	}

}
