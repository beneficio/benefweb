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

import com.business.beans.CtaCteFac;
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
 * @author relisii
 */

@Path("opService")
public class OrdenPagoService {

    /** Creates a new instance of CotizaVC */
    public OrdenPagoService () {
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
	@Path("/existeComprobante")
	@Produces(MediaType.APPLICATION_JSON)
	public String existeComprobante (
                        @QueryParam("num_comprob1") String numComprob1,
			@QueryParam("num_comprob2") String numComprob2,
                        @QueryParam("cuit") String sCuit,
                        @QueryParam("usuario") String sUser) throws SurException {
        Connection dbCon = null;

        try { 
            dbCon = db.getConnection();

            CtaCteFac occ = new CtaCteFac();
            occ.setnumComprob1 (numComprob1);   
            occ.setnumComprob2 (numComprob2);
            occ.getDBExisteComprobante(dbCon, sCuit, sUser);

            if (occ.getiNumError() < 0 && occ.getiNumError() != -100 ) { 
                throw new SurException(occ.getsMensError());
            }

           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(occ);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            } finally {
                db.cerrar(dbCon);
            }
        }

    	@GET
	@Path("/existeFactura")
	@Produces(MediaType.APPLICATION_JSON)
	public String existeFactura (
                        @QueryParam("num_comprob1") String numComprob1,
			@QueryParam("num_comprob2") String numComprob2,
                        @QueryParam("cuit") String sCuit,
                        @QueryParam("usuario") String sUser) throws SurException {
        Connection dbCon = null;

        try { 
            
System.out.println ("en ordenPagoService");
System.out.println (numComprob1);
System.out.println (numComprob2);
System.out.println (sCuit);
System.out.println (sUser);

            dbCon = db.getConnection();

            CtaCteFac occ = new CtaCteFac();
            occ.setnumComprob1 (numComprob1);   
            occ.setnumComprob2 (numComprob2);
            occ.getDBExisteFactura (dbCon, sCuit, sUser);

            if (occ.getiNumError() < 0 && occ.getiNumError() != -100 ) { 
                throw new SurException(occ.getsMensError());
            }

           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(occ);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            } finally {
                db.cerrar(dbCon);
            }
        }

}
