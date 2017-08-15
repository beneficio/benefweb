/*
 * CotizacionServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
 */

package servlets;  
                  
import java.io.IOException;
import java.util.LinkedList;
import java.util.Enumeration;
import java.sql.Connection;
        
import com.business.beans.Usuario;
import com.business.beans.Cotizacion;
import com.business.beans.CotizadorSumas;
import com.business.beans.Persona;
import com.business.beans.Producto;
import com.business.beans.CotizadorNomina;
import com.business.util.*;
import com.business.db.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Hashtable;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class CotizadorVCServlet extends HttpServlet {
    
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
            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }

            String op =  request.getParameter("opcion");

                if ( op.equals("cotizador") ) {
                    Cotizador (request, response);
                } else if (op.equals ("get_cot") ||op.equals ("getCot")) {
                    getCotizacion (request, response);
                }                
                else if (op.equals("getCotizacion_Xls"))
                {
                    getCotizacion_Xls(request, response);
                }
         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    } 
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */

    protected void getCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
     
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));

            dbCon = db.getConnection();
            Cotizacion oCot = new Cotizacion();
            oCot.setnumCotizacion (numCotizacion);
            oCot.getDB(dbCon);

            request.setAttribute ("cotizacion", oCot);

            doForward (request, response, "/cotizador/vc/cotizaVC_sol1.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void Cotizador (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            String siguiente = request.getParameter ("siguiente");

            dbCon = db.getConnection();
            Cotizacion oCot = new Cotizacion ();
            oCot.setnumCotizacion     (Integer.parseInt (request.getParameter("num_cotizacion")));           

// input solapa 1
            oCot.setuserId(oUser.getusuario());
            if (request.getParameter ("COD_PROD") == null){
               oCot.setcodProd(oUser.getiCodProd());
            }else{
               oCot.setcodProd(Integer.parseInt(request.getParameter ("COD_PROD")));
            }
            oCot.setcodRama           (Integer.parseInt (request.getParameter("COD_RAMA")));
            oCot.setcodSubRama        (Integer.parseInt (request.getParameter("COD_SUB_RAMA")));
            oCot.setcodProducto       (Integer.parseInt (request.getParameter("COD_PRODUCTO")));
            oCot.setcodProvincia      (Integer.parseInt (request.getParameter("COD_PROVINCIA")));
            oCot.setcodVigencia       (Integer.parseInt (request.getParameter("COD_VIGENCIA")));
            oCot.settomadorApe        (request.getParameter ("TOMADOR_APE"));
            oCot.setdescSubRama       ( (request.getParameter ("COD_SUB_RAMA_DESC") != null) ? request.getParameter ("COD_SUB_RAMA_DESC"): "" );

            oCot.setmcaNominaExcel    ( (request.getParameter ("MCA_NOMINA_EXCEL") != null ) ? request.getParameter ("MCA_NOMINA_EXCEL"): "" );

            System.out.println(" oCot.getnumCotizacion() "  + oCot.getnumCotizacion()) ;
            System.out.println(" oCot.getdescSubRama "  +oCot.getdescSubRama() );
            System.out.println(" oCot.getmcaNominaExcel "  +oCot.getmcaNominaExcel() );            

            Producto oProd = new Producto();
            oProd.setCodRama    (oCot.getcodRama());
            oProd.setCodSubRama (oCot.getcodSubRama());
            oProd.setcodProducto(oCot.getcodProducto());
            oProd.getDB(dbCon);
            if (oProd.getiNumError() != 0) {
                throw new SurException(oProd.getsMensError());
            }

// input solapa 2

            if (oProd.getNivelCob().equals("P")) {
                        oCot.setmcaMuerteAccidental( ( request.getParameter ("MUERTE_ACCIDENTAL") == null ||
                                                       request.getParameter ("MUERTE_ACCIDENTAL").equals ("") ? null :
                                                       request.getParameter ("MUERTE_ACCIDENTAL")) );
                        LinkedList lSumas = new LinkedList ();
                        String ParameterNames = "";
                        int cantAseg  = 0;
			for(Enumeration e = request.getParameterNames(); e.hasMoreElements(); ){
				ParameterNames = (String)e.nextElement();
                                if (ParameterNames.startsWith("VIDAS_")) {
                                    String aNombre [] = ParameterNames.split("_",2);
                                    CotizadorSumas cs = new CotizadorSumas();
                                    cs.setnumCotizacion         (oCot.getnumCotizacion());
                                    cs.setcantVidas             (Integer.parseInt (request.getParameter (ParameterNames)));
                                    cantAseg += Integer.parseInt (request.getParameter (ParameterNames));
                                    cs.setedadDesde             (Integer.parseInt (request.getParameter ("EDAD_DESDE_" + aNombre[1] )));
                                    cs.setedadHasta             (Integer.parseInt (request.getParameter ("EDAD_HASTA_" + aNombre[1] )));
                                    cs.setsumaAsegMuerte        (Dbl.StrtoDbl(request.getParameter ("SUMA_MUERTE_" + aNombre[1] )));
                                    cs.setsumaAsegInvalidez     (Dbl.StrtoDbl(request.getParameter ("SUMA_INVALIDEZ_" + aNombre[1] )));
                                    cs.setmaxSumaAsegMuerte     (Dbl.StrtoDbl(request.getParameter ("SUMA_MUERTE_MAX_" + aNombre[1] )));
                                    cs.setmaxSumaAsegInvalidez  (Dbl.StrtoDbl(request.getParameter ("SUMA_INVALIDEZ_MAX_" + aNombre[1] )));
                                    cs.setminSumaAsegMuerte     (Dbl.StrtoDbl(request.getParameter ("SUMA_MUERTE_MIN_" + aNombre[1] )));
                                    cs.setminSumaAsegInvalidez  (Dbl.StrtoDbl(request.getParameter ("SUMA_INVALIDEZ_MIN_" + aNombre[1] )));
                                    cs.settasaInvalidez         (Dbl.StrtoDbl(request.getParameter ("TASA_INVALIDEZ_" + aNombre[1] )));
                                    cs.settasaMuerte            (Dbl.StrtoDbl(request.getParameter ("TASA_MUERTE_" + aNombre[1] )));
                                    lSumas.add(cs);
                                }
			}
                        if (lSumas.size() > 0) {
                            oCot.setlRangosSumas (lSumas);
                            oCot.setcantPersonas(cantAseg);
                        }
            } else {
                System.out.println ("else");
// ACA HAY QUE AGREGAR TODA LA LOGICA PARA TOMAR LOS DATOS DE LA SOLAPA 2 DE CAPITALES NO UNIFORMES
// QUE DEPENDEN DEL TIPO DE NOMINA C1, C2 O C3. HAY QUE CARGAR LA NOMINA 
//                oCot.setcantPersonas      (Integer.parseInt (request.getParameter("CANT_PERSONAS")));
//                oCot.setgastosAdquisicion (Dbl.StrtoDbl(request.getParameter("GASTOS_ADQUISICION")));

                if ( request.getParameter ("tipo_nomina")!=null &&
                     request.getParameter ("CANT_PERSONAS")!=null)
                {
                    String ParameterNames = "";
                    int cantPersonas =  (Integer.parseInt (request.getParameter("CANT_PERSONAS")));
                    String tipoNomina = request.getParameter ("tipo_nomina");                    
                    LinkedList lCotNominas = new LinkedList ();
		    for(Enumeration e = request.getParameterNames(); e.hasMoreElements(); ){
                        ParameterNames = (String)e.nextElement();
                        if (ParameterNames.startsWith("age_"))
                        {
                            lCotNominas.add(buildCotizadorNomina(tipoNomina, ParameterNames , request));
                        }
                    }// for                    
                    oCot.setcantPersonas(0);
                    if (lCotNominas.size() > 0) {
                        oCot.setlNomina(lCotNominas);
                        oCot.setcantPersonas(lCotNominas.size());
                    }
                } //if

            } // else end.

// input solapa 3

            String sUrlDestino = "";
            if (oProd.getNivelCob().equals("P")) {
// POR ACA ENTRA PORQUE EL PRODUCTO ES DE CAPITALES UNIFORMES
                if ( siguiente.equals ("solapa2") ) {
                        if (oCot.getlRangosSumas() == null ) {
                            // LEVANTA LA TABLA DE RANGOS POR EDADES
                            oCot.getDBAllRangosSumas(dbCon);
                        }
                        sUrlDestino =  "/cotizador/vc/cotizaVC_sol2_unif.jsp";
                 } else if ( siguiente.equals ("solapa3") ) {
                            // GRABA LA COTIZACION
                            oCot.setDB(dbCon);
                            if (oCot.getiNumError() != 0) {
// Agregado por PINO 27/03/2015
                                request.setAttribute("mensaje", oCot.getsMensError());
                                request.setAttribute("volver", "-1" );
                                doForward (request, response, "/include/MsjHtmlServidor.jsp");

// Fin de Agregado por PINO 27/03/2015
                            } else {
                                this.cotizar(dbCon, oCot, oUser, request, response); 

                                if (oCot.getiNumError() == 0 ) {
                                    oCot.getDB(dbCon);
                                    if (oCot.getiNumError() != 0) {
                                        throw new SurException( (oCot.getsMensError()));
                                    }
                                    sUrlDestino =  "/cotizador/vc/cotizaVC_sol3.jsp";
                                }
                            }
                        } else {
                            sUrlDestino =  "/cotizador/vc/cotizaVC_sol1.jsp";
                        }
            } else {
                 if ( siguiente.equals ("solapa2") ) {
                     if (oCot.getlNomina() == null) {
                        oCot.getDBNomina(dbCon);
                     }
                        //SUP 2015-04-20 --->
                        if (oCot.getnumCotizacion() == 0 )
                        {
                            oCot.setmcaNominaExcel("");
                        }
                        //SUP 2015-04-20 <---

                     sUrlDestino =  "/cotizador/vc/cotizaVC_sol2_nounif.jsp";
                 } else if ( siguiente.equals ("solapa3") ) {
                            oCot.setDB(dbCon);
                            if (oCot.getiNumError() != 0) {
// Agregado por PINO 27/03/2015
                                request.setAttribute("mensaje", oCot.getsMensError() );
                                request.setAttribute("volver", "-1" );
                                doForward (request, response, "/include/MsjHtmlServidor.jsp");

// Fin de Agregado por PINO 27/03/2015

                            } else {
                                this.cotizar(dbCon, oCot,oUser, request, response);

                                if (oCot.getiNumError() == 0 ) {
                                    oCot.getDB(dbCon);
                                    if (oCot.getiNumError() != 0) {
                                        throw new SurException( (oCot.getsMensError()));
                                    }
                                    sUrlDestino =  "/cotizador/vc/cotizaVC_sol3.jsp";
                                }
                            }                            
                 } else {
                    sUrlDestino =  "/cotizador/vc/cotizaVC_sol1.jsp";
                 }
            }

            if (oCot.getiNumError() == 0) {
                request.setAttribute("cotizacion", oCot);
                request.setAttribute("producto", oProd);

                doForward (request, response, sUrlDestino );
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    private CotizadorNomina buildCotizadorNomina ( String _tipoNomina , 
                                                   String _ParameterNames ,
                                                   HttpServletRequest _request)
    {
        CotizadorNomina _oCotNomina = new CotizadorNomina();
        String _index = _ParameterNames.replace("age_","");        
        if (_tipoNomina.equals("C1"))
        {
            /* Nomina C1: Fecha Nac/Edad, antiguedad, sueldo */
            //System.out.println(" buildCotizadorNomina , Procesa C1" );
            String _valueAge = _request.getParameter ("age_" + _index);
            String _valueAnt = _request.getParameter ("ant_" + _index);
            String _valuePay = _request.getParameter ("pay_" + _index);
            /*
            System.out.println ( " ParameterNames " + _ParameterNames  +
                                 " index "           + _index +
                                 " valueAge "        + _valueAge +
                                 " valueAnt "        + _valueAnt +
                                 " valuePay "        + _valuePay
                                );*/
           _oCotNomina.setedad(Integer.parseInt (_valueAge));
           _oCotNomina.setantiguedad(Integer.parseInt (_valueAnt));
           _oCotNomina.setsueldo(Dbl.StrtoDbl(_valuePay));
        }
        else if (_tipoNomina.equals("C2"))
        {
            //System.out.println("buildCotizadorNomina ,Procesa C2" );
            /* Nomina C2: Fecha Nac/Edad, cantSueldos, sueldo */
            String _valueAge = _request.getParameter ("age_" + _index);
            String _valueAmo = _request.getParameter ("amo_" + _index);
            String _valuePay = _request.getParameter ("pay_" + _index);
            /*
            System.out.println ( " ParameterNames " + _ParameterNames  +
                                 " index "           + _index +
                                 " valueAge "        + _valueAge +
                                 " valueAmo "        + _valueAmo +
                                 " valuePay "        + _valuePay );
             */
            _oCotNomina.setedad(Integer.parseInt (_valueAge));
            _oCotNomina.setcantSueldos(Integer.parseInt (_valueAmo));
            _oCotNomina.setsueldo(Dbl.StrtoDbl(_valuePay));
        }
        else
        {
            //System.out.println("buildCotizadorNomina ,Procesa C3 " );
            /* NOmina C3: Fecha Nac/Edad, SumaAsegMuerte     */
            String _valueAge = _request.getParameter ("age_" + _index);
            String _valuePay = _request.getParameter ("pay_" + _index);
            /*
            System.out.println ( " ParameterNames " + _ParameterNames  +
                                 " index "           + _index +
                                 " valueAge "        + _valueAge +
                                 " valuePay "        + _valuePay
                               ) ;
             */
            _oCotNomina.setedad(Integer.parseInt (_valueAge));
            _oCotNomina.setsumaAsegMuerte (Dbl.StrtoDbl(_valuePay));
        }
        return _oCotNomina;   
    } //End--> buildCotizadorNomina
   

    protected void cotizar (Connection dbCon, Cotizacion oCot, Usuario usu, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        String sMensaje = "";
        String sVolver = "";
        try {
    // setear el control de acceso
                ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                oControl.setearAcceso(dbCon, 36);
    // fin de setear el control de acceso
                oCot.setDBCotizarVC(dbCon, "C");

System.out.println ("despues de setDBCotizarVC " + oCot.getiNumError());

                if (oCot.getiNumError() < 0 ) {
                        sMensaje = "";
                        switch (oCot.getiNumError() ) {
                            case -200:
                                sMensaje = "ESTA FUNCION NO ESTA HECHA PERO ACA VAMOS A DEVOLVER ERORRES DE COTIZACION ";
                                break;
                            default:
                                sMensaje = "";
                        }

                        if ( ! sMensaje.equals("")) {
                            oCot.delDB (dbCon, usu.getusuario() );
                            sVolver  = Param.getAplicacion() + "servlet/CotizadorVCServlet?opcion=cotizador&num_cotizacion=" + oCot.getnumCotizacion() + "&siguiente=solapa2";
                            request.setAttribute("mensaje", sMensaje );
                            request.setAttribute("volver", "-1" );
                            doForward (request, response, "/include/MsjHtmlServidor.jsp");
                        } else {
                            throw new SurException (oCot.getsMensError() );
                        }
                 }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

    protected void sendEmailCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        StringBuilder sMensaje = new StringBuilder();
        String sMsgCuotas = "";
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));
            
            dbCon = db.getConnection();
            Cotizacion oCot = new Cotizacion();
            oCot.setnumCotizacion (numCotizacion); 
            oCot.getDB(dbCon);

            if (oCot.getabm().equals("S")) {
                throw new SurException ("Operación invalida.La cotización es de Testeo, no puede ser enviada.");
            }
            
            oCot.setestadoCotizacion (1); 
            oCot.setusuarioCambiaEstado (oUser.getusuario());
            oCot.setDBCambiarEstadoCotizacion(dbCon);
            
            if (oCot.getiNumError() < 0) {
                throw new SurException ("Operación invalida.La cotización no se puede enviar. Consulte a su representante. Muchas Gracias ");
            }
            
            sMsgCuotas = "En "+ oCot.getcantCuotas()+" cuotas de $"+ Dbl.DbltoStr(oCot.getvalorCuota(),2);
            
            sMensaje.append(oCot.getdescEstadoCotizacion()).append(" DE COTIZACION DE ACCIDENTES PERSONALES\n");
            
            sMensaje.append("-----------------------------------\n\n");
            sMensaje.append("COTIZADO POR : ").append(oCot.getdescUsu()).append("\n");
            sMensaje.append("PRODUCTOR    : ").append(oCot.getdescProd()).append("(").append(oCot.getcodProd()).append(")\n");
            sMensaje.append("OPERACION NRO: ").append(String.valueOf(oCot.getnumCotizacion())).append("\n");
            sMensaje.append("FECHA        : ").append(oCot.getfechaCotizacion()).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Tomador           : ").append(oCot.gettomadorApe()).append("\n");
            sMensaje.append("Descripción Tareas: ").append(oCot.getdescActividad()).append("\n");
            sMensaje.append("Telefono          : ").append((oCot.gettomadorTel () == null ? " " : oCot.gettomadorTel ())).append("\n");
            sMensaje.append("Cond I.V.A        : ").append((oCot.gettomadorDescIva () == null ? " " : oCot.gettomadorDescIva ())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Características del seguro\n");
            sMensaje.append("-------------------------- \n");
            sMensaje.append("Ubicación del riesgo: ").append(oCot.getdescProvincia()).append("\n");
            sMensaje.append("Modalidad           : ").append(oCot.getdescAmbito()).append("\n");
            sMensaje.append("Vigencia            : ").append(oCot.getdescVigencia()).append("\n");
            sMensaje.append("Cantidad de Vidas   : ").append(String.valueOf(oCot.getcantPersonas())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Descripcion de Coberturas\n");
            sMensaje.append("-------------------------\n");
//            sMensaje.append("Muerte por accidente                   $").append(Dbl.DbltoStrPadRight( oCot.getcapitalMuerte(),2, 15)).append("\n");
//            sMensaje.append("Invalidez permanente total y/o parcial $").append(Dbl.DbltoStrPadRight( oCot.getcapitalInvalidez(),2, 15)).append("\n");
//            sMensaje.append("Asistencia medica farmaceutica         $").append(Dbl.DbltoStrPadRight( oCot.getcapitalAsistencia(),2, 15)).append("\n");
            sMensaje.append("Franquicia                             $").append(Dbl.DbltoStrPadRight( oCot.getfranquicia(),2, 15)).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Presupuesto\n");
            sMensaje.append("-----------\n");
            sMensaje.append("Prima pura          $").append( Dbl.DbltoStrPadRight( oCot.getprimaPura(),2, 15)).append( "\n");
            sMensaje.append("Sub-Total           $").append( Dbl.DbltoStrPadRight( oCot.getsubTotal(),2, 15)).append( "\n");
            sMensaje.append("Subtotal            $").append( Dbl.DbltoStrPadRight( oCot.getprimaPura()+ oCot.getrecAdmin() ,2, 15)).append( "\n");
            sMensaje.append(" GDA " ).append( Dbl.DbltoStrPadRight( oCot.getgastosAdquisicion(),2, 6)).append("%        $").append( Dbl.DbltoStrPadRight( oCot.getgda(),2, 15)).append( "\n");
            sMensaje.append("Recargos finan. ").append( Dbl.DbltoStrPadRight( oCot.getporcRecFinan(),2, 6)).append("%  $").append( Dbl.DbltoStrPadRight( oCot.getrecFinan(),2, 15)).append( "\n");
            sMensaje.append(" Derecho de Emision $").append( Dbl.DbltoStrPadRight( oCot.getderEmi(),2, 15)).append( "\n");
            sMensaje.append("Prima Tarifa        $").append( Dbl.DbltoStrPadRight( oCot.getprimaTar(),2, 15)).append( "\n");
            sMensaje.append(" IVA ").append( Dbl.DbltoStrPadRight( oCot.getporcIva(),2, 6)).append("%        $").append( Dbl.DbltoStrPadRight( oCot.getiva(),2, 15)).append( "\n");
            sMensaje.append(" Tasa SSN ").append( Dbl.DbltoStrPadRight( oCot.getporcSsn(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getssn(),2, 15)).append( "\n");
            sMensaje.append(" Serv.Soc ").append( Dbl.DbltoStrPadRight( oCot.getporcSoc(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getsoc(),2, 15)).append( "\n");
            sMensaje.append(" Sellado  ").append( Dbl.DbltoStrPadRight( oCot.getporcSellado(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getsellado(),2, 15)).append( "\n");
            sMensaje.append("Premio              $").append( Dbl.DbltoStrPadRight( oCot.getpremio(),2, 15)).append( "\n");
            sMensaje.append(" \n");
            
            sMensaje.append(sMsgCuotas).append("\n");

            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("Beneficio Web - AVISO de "+ oCot.getdescEstadoCotizacion() +" DE COTIZACION DE A.P. N° " + oCot.getnumCotizacion());
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "COTIZADOR");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
               // oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
             
            request.setAttribute("mensaje", oCot.getMensajeEstado());
            request.setAttribute("volver", Param.getAplicacion() + "servlet/CotizacionServlet?opcion=getAllCotizaciones");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /******************************************************/
    // Nuevo BEGIN

    // /function agregar en --> Fecha
    private int getEdadByFechaNacimiento(java.util.Date dateNacim)
    {
        String nacim = Fecha.toString(dateNacim);
        int d1 = Integer.parseInt(nacim.substring(0, 2));
        int m1 = Integer.parseInt(nacim.substring(3, 5));
        int y1 = Integer.parseInt(nacim.substring(6, 10));

        String fechaActual = Fecha.toString(new java.util.Date ());
        int d2 = Integer.parseInt(fechaActual.substring(0, 2));
        int m2 = Integer.parseInt(fechaActual.substring(3, 5));
        int y2 = Integer.parseInt(fechaActual.substring(6, 10));

        return  (y2 - y1 - 1) + (m2 == m1 ? (d2 >= d1 ? 1 : 0) : m2 >= m1 ? 1 : 0);
    }

    protected void getCotizacion_Xls ( HttpServletRequest request,
                                       HttpServletResponse response)
    throws ServletException, IOException,
           com.jspsmart.upload.SmartUploadException ,    
           java.sql.SQLException ,
           SurException
    {        
        response.setContentType ("text/html");
        // Initialization
       com.jspsmart.upload.SmartUpload mySmartUpload = new com.jspsmart.upload.SmartUpload ();
        // Initialization
        mySmartUpload.initialize (this.getServletConfig (), request, response);
        //mySmartUpload.initialize(pageContext);
        // Only allow txt or htm files
        mySmartUpload.setAllowedFilesList("xls");
        // DeniedFilesList can also be used :
        mySmartUpload.setDeniedFilesList("exe,bat,jsp,bmp,tif");
        // Deny physical path
        mySmartUpload.setForcePhysicalPath(false);
        // Only allow files smaller than 50000 bytes
        mySmartUpload.setMaxFileSize(500000);
        // Upload
        mySmartUpload.upload();
        // Save the files with their original names in a virtual path of the web server
        Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
        com.jspsmart.upload.Request reqJspSmart = mySmartUpload.getRequest();
        String tipoNomina = reqJspSmart.getParameter("tipo_nomina");
        String nameCotizacion = null;
        try
        {
            com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);      
	    if (!myFile.isMissing())
            {        
                nameCotizacion = "/files/cotizaciones/" + oUser.getusuario() + "_" + tipoNomina + "@" + "cotizacion.xls";                
                myFile.saveAs( nameCotizacion , mySmartUpload.SAVE_VIRTUAL);
            }
        }
        catch (Exception e)
        {
            //System.out.println ("Error al enviar el archivo" + e.getMessage());
            throw new SurException("Error al enviar el archivo" + e.getMessage());
        }

        try
        {
            //System.out.println(" tipoNomina " + tipoNomina );
            String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;
            String path = pathReal + nameCotizacion ;
            LinkedList <CotizadorNomina> lNomina = new LinkedList <CotizadorNomina>();
            int lineaExcel = 0;            
            if (path !=null && !path.equals("") )
            {
                LinkedList nameCol    = new LinkedList();
                LinkedList typeCol    = new LinkedList();
                LinkedList hFilaAux   = new LinkedList();
                getTypeAndNameColXls ( nameCol , typeCol , tipoNomina);
                hFilaAux = xls.getInfoByXls(typeCol,nameCol,path,1);
                if (hFilaAux != null && hFilaAux.size() > 0)
                {
                    for ( int i=0 ; i< hFilaAux.size(); i++ )
                    {
                        lineaExcel = i+1;
                        Hashtable has =(Hashtable)hFilaAux.get(i);
                        if ( lineaExcel != 1)
                        {
                            lNomina.add (getCotNomByRowXls ( tipoNomina , has));
                        }
                    } //for
                } // if
            } // if
           
            Cotizacion oCot = getCotizacionByRequestJspSmart(oUser,reqJspSmart);
            Producto oProd = getProductoByRequest(oCot.getcodRama(),oCot.getcodSubRama(),oCot.getcodProducto());
            oCot.setlNomina(lNomina);
            oCot.setmcaNominaExcel("X");
            System.out.println(" ---> NumCotizacion: " + oCot.getnumCotizacion() );
            String sUrlDestino = "/cotizador/vc/cotizaVC_sol2_nounif.jsp";
            if (oCot.getiNumError() == 0)
            {
                request.setAttribute("cotizacion", oCot);
                request.setAttribute("producto", oProd);
                doForward (request, response, sUrlDestino );
            }

        }
        catch (Exception e)
        {
            System.out.println(" Error --> " + e.getMessage());
            throw new SurException (e.getMessage());
        }       
    }


    protected CotizadorNomina getCotNomByRowXls ( String tipoNomina, Hashtable has)
    {
        CotizadorNomina cs = new CotizadorNomina ();

        if (tipoNomina.equals("C1") || tipoNomina.equals("C2") || tipoNomina.equals("C3"))
        {
            String nacim     = ((String)has.get("F_NACIM"))==null?"":((String)has.get("F_NACIM")).trim();
            java.util.Date dateNacim ;
            try
            {
                 dateNacim = Fecha.strToDate(nacim);
                 cs.setedad(getEdadByFechaNacimiento(dateNacim));
                 cs.setfechaNac(dateNacim);
            }
            catch (Exception expDate)
            {
                 //String error = "Error en el formato de fecha informado. Fila nro. = " + lineaExcel ;
                 //System.out.println(" error ---> " + error + " : "+ expDate.getMessage());
            }
        }
        
        if (tipoNomina.equals("C1"))
        {
            String ant     = ((String)has.get("ANT"))==null?"":((String)has.get("ANT")).trim();
            String sueldo  = ((String)has.get("SUELDO"))==null?"":((String)has.get("SUELDO")).trim();

            cs.setantiguedad( Integer.parseInt(ant));
            cs.setsueldo (Dbl.StrtoDbl(sueldo));

        }
        else if (tipoNomina.equals("C2"))
        {
            String cant     = ((String)has.get("CANT"))==null?"":((String)has.get("CANT")).trim();
            String sueldo  = ((String)has.get("SUELDO"))==null?"":((String)has.get("SUELDO")).trim();

            cs.setcantSueldos(Integer.parseInt (cant));
            cs.setsueldo(Dbl.StrtoDbl(sueldo));
        }
        else if (tipoNomina.equals("C3"))
        {
            String suma      = ((String)has.get("SUMA"))==null?"":((String)has.get("SUMA")).trim();
            cs.setsumaAsegMuerte (Dbl.StrtoDbl(suma));
        }
        return cs;
    }
    
    protected void getTypeAndNameColXls (  LinkedList nameCol , LinkedList typeCol , String tipoNomina)   
    {
        if (tipoNomina.equals("C1"))
        {           
            nameCol.add(0,"F_NACIM");
            typeCol.add(0,"TYPE_DATE");

            nameCol.add(1,"ANT");
            typeCol.add(1,"TYPE_NUMERIC");

            nameCol.add(2,"SUELDO");
            typeCol.add(2,"TYPE_NUMERIC");
        }
        else if (tipoNomina.equals("C2"))
        {
            nameCol.add(0,"F_NACIM");
            typeCol.add(0,"TYPE_DATE");

            nameCol.add(1,"CANT");
            typeCol.add(1,"TYPE_NUMERIC");

            nameCol.add(2,"SUELDO");
            typeCol.add(2,"TYPE_NUMERIC");
        }
        else if (tipoNomina.equals("C3"))
        {
            nameCol.add(0,"F_NACIM");
            typeCol.add(0,"TYPE_DATE");

            nameCol.add(1,"SUMA");
            typeCol.add(1,"TYPE_NUMERIC");
        }        
    }

    protected Cotizacion getCotizacionByRequestJspSmart(Usuario oUser , com.jspsmart.upload.Request reqJspSmart)
    {
        Cotizacion oCot = new Cotizacion ();
        oCot.setnumCotizacion(Integer.parseInt (reqJspSmart.getParameter("num_cotizacion")));
        oCot.setuserId(oUser.getusuario());
        if (reqJspSmart.getParameter("COD_PROD") == null)
        {
            oCot.setcodProd(oUser.getiCodProd());
        }
        else
        {
           oCot.setcodProd(Integer.parseInt(reqJspSmart.getParameter("COD_PROD")));
        }
        oCot.setcodRama           (Integer.parseInt (reqJspSmart.getParameter("COD_RAMA")));
        oCot.setcodSubRama        (Integer.parseInt (reqJspSmart.getParameter("COD_SUB_RAMA")));
        oCot.setcodProducto       (Integer.parseInt (reqJspSmart.getParameter("COD_PRODUCTO")));
        oCot.setcodProvincia      (Integer.parseInt (reqJspSmart.getParameter("COD_PROVINCIA")));
        oCot.setcodVigencia       (Integer.parseInt (reqJspSmart.getParameter("COD_VIGENCIA")));
        oCot.settomadorApe        (reqJspSmart.getParameter("TOMADOR_APE"));
        oCot.setdescSubRama       ( (reqJspSmart.getParameter("COD_SUB_RAMA_DESC") != null) ? reqJspSmart.getParameter("COD_SUB_RAMA_DESC"): "" );
        return oCot;
    }

    protected Producto getProductoByRequest(int codRama, int codSubRama, int codProducto)
        throws java.sql.SQLException , SurException {

        Connection dbCon = null;
        Producto oProd = new Producto();
        try
        {
            dbCon = db.getConnection();
            oProd.setCodRama    (codRama);
            oProd.setCodSubRama (codSubRama);
            oProd.setcodProducto(codProducto);
            oProd.getDB(dbCon);
            if (oProd.getiNumError() != 0)
            {
                throw new SurException(oProd.getsMensError());
            }
        }
        catch (Exception e)
        {
            throw new SurException (e.getMessage());
        }
        finally
        {
            db.cerrar(dbCon);
        }
        return oProd;
    }
//Nuevo END
/******************************************************/
/******************************************************/

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
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
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) 
     throws ServletException, IOException {
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
