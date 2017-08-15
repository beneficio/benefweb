/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
        
package servlets; 
import com.business.beans.Usuario;
import com.business.beans.IntPreLiquidacion;
import com.business.beans.Preliq;
import com.business.beans.PreliqDet;
import com.business.beans.Persona;
import com.business.db.db;
import com.business.db.phpDC;
import com.business.util.Parametro;


import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.io.OutputStreamWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URLConnection;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.business.util.*;

public class PreliquidacionServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
//            if( ! request.isRequestedSessionIdValid() ) {
//                doForward(request, response, "/sessionCancel,jsp");
//            }

            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }
            String op =  request.getParameter("opcion");
            if (op.equals("getAllPreliq")) {
                getAllPreliq (request, response);
            } else if (op.equals("procesarPreLiq")) {
                procesarPreLiq (request, response);
            } else if (op.equals("grabarCuotasPreliq") || op.equals("cambiarOrden")) {
                grabarCuotasPreliq (request, response);
            } else if (op.equals("getPreliquidacion")) {
                getPreliquidacion (request, response);
            } else if (op.equals("cerrarPreLiquidacion")) {
                cerrarPreliquidacion (request, response);
            } else if (op.equals("getPreliqPDF")) {
                getPreliqPDF (request, response);
            } else if (op.equals("cambiarEstado")) {
                cambiarEstado (request, response);
            } else if (op.equals("anularCobro")) {
                anularCobro (request, response);
            }  else if (op.equals("enviarMensaje")) {
                enviarMensaje (request, response);
            }

        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void getPreliqPDF (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        Report oReport = new Report();
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int iNumPreliq = (request.getParameter("co_numPreliq") == null || 
                              request.getParameter("co_numPreliq").equals ("") ? 0 :
                              Integer.parseInt (request.getParameter("co_numPreliq")));
            String sOrden  =request.getParameter ("co_orden");
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);

            Preliq preliq = new Preliq();
            preliq.setNumPreliq(iNumPreliq );

            preliq.getDB(dbCon);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }

            preliq.getDBPreliqDet(dbCon, sOrden);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }

            oReport.setOrientacion("portrait");//// portrait = horizontal, landscape = vertical
            oReport.setTitulo       ("PRELIQUIACION");
            oReport.addlObj         ("subtitulo" , "PRELIQUIACION");
            oReport.setUsuario      ("user.getusuario()");
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("NOM001");
            oReport.setReportName   (getServletContext ().getRealPath("/preliq/report/preliquidaciones.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));

            oReport.addlObj("NUM_DOC", preliq.getnumDoc());
            oReport.addlObj("NUM_PRELIQ", String.valueOf(iNumPreliq));
            oReport.addlObj("COD_PROD", String.valueOf(preliq.getCodProd()));
            oReport.addlObj("COD_ORG", String.valueOf(preliq.getCodOrg()));
            oReport.addlObj("COD_PROD_DESC", preliq.getCodProdDesc());
            oReport.addlObj("DESC_ESTADO",preliq.getsDescEstado() + (preliq.getCodEstado() == 3 ?
           ( " por " + preliq.getNumPreliqReem() ) :
            ( preliq.getCodEstado() == 1 ? 
                ( " el " + 
                (preliq.getFechaEnvioBenef() == null ? Fecha.showFechaForm(preliq.getFechaEnvioProd()) :
                                                       Fecha.showFechaForm(preliq.getFechaEnvioBenef())
                ) + " (" + 
    (preliq.getUseridEnvioBenef() == null ? preliq.getUseridEnvioProd():preliq.getUseridEnvioBenef()
                ) + ")"
              ) : " " ) ) );

            oReport.addIniTabla("TABLA_PRELIQUIDACIONES");

            double dPrima      = 0;
            double dPremioMon  = 0;
            double dPremioPeso = 0;
            double dPremioNeto = 0;

            if (preliq.getLPreliDet() != null ) {
                String sStyle[] = {"ItemCob","ItemCobL", "ItemCob",
                                   "ItemCobL","ItemCob", "ItemCob"/*,"ItemCobR"*/,"ItemCobR",
                                   "ItemCobR","ItemCob","ItemCob"};
                for (int i = 0; i< preliq.getLPreliDet().size();i++) {
                    PreliqDet oPreliqDet = (PreliqDet) preliq.getLPreliDet().get(i);
                    String op        = (oPreliqDet.getOperacion() == null ? " " : oPreliqDet.getOperacion());
                    String codRama   = String.valueOf(oPreliqDet.getCodRama());
                    String PolEnd    = String.valueOf(oPreliqDet.getNumPoliza())
                                     +"/"+String.valueOf(oPreliqDet.getEndoso())  ;
                    String Cu        = String.valueOf(oPreliqDet.getNumCuota());
                    String Asegurado = (oPreliqDet.getAsegurado() == null ? " " : oPreliqDet.getAsegurado());
                    String fechaRec  = (oPreliqDet.getFechaRec() == null ? " " : Fecha.showFechaForm(oPreliqDet.getFechaRec())) ;
                    String fechaAseg = (oPreliqDet.getFechaAseg() == null ? " " : Fecha.showFechaForm(oPreliqDet.getFechaAseg())) ;
//                    String prima      = String.valueOf(oPreliqDet.getImpPrima());
                    String premioMon  = String.valueOf(oPreliqDet.getImpPremio());
                    String premioPeso = String.valueOf(oPreliqDet.getImpPremioPesos());
                    String premioNeto = String.valueOf(oPreliqDet.getImpPremioNeto());
                    String estado =  (oPreliqDet.getMcaCobro()!=null && oPreliqDet.getMcaCobro().equals("*")? "COBRADA":"  ");
                    String sFechaCob = (oPreliqDet.getFechaCobro() == null ? " " : Fecha.showFechaForm(oPreliqDet.getFechaCobro()));

                    if (estado.equals("COBRADA")) {
                        dPrima      = dPrima      + oPreliqDet.getImpPrima();
                        dPremioMon  = dPremioMon  + oPreliqDet.getImpPremio();
                        dPremioPeso = dPremioPeso + oPreliqDet.getImpPremioPesos();
                        dPremioNeto = dPremioNeto + oPreliqDet.getImpPremioNeto();
                    }

                    String sElem [] ={  codRama, PolEnd , Cu,
                                        Asegurado, fechaAseg, fechaRec/*, prima*/, premioMon ,
                                        premioPeso, estado, sFechaCob };
                    oReport.addElementsTabla(sElem, sStyle);
                }
            }
            oReport.addFinTabla();           

            oReport.addIniTabla("TABLA_TOTALES");
            String sStyleTT[] = {"ItemCobL", "ItemCobL"};
/*
            String titulo ="PRIMA COBRADA:";
            String monto =Dbl.DbltoStr(dPrima,2) + "     (Moneda original)";
            String sElemTT1 [] ={titulo, monto };
            oReport.addElementsTabla(sElemTT1, sStyleTT);
*/
            String titulo = "PREMIO COBRADO:";
            String monto  = "$ " + Dbl.DbltoStr(dPremioPeso,2);
            String sElemTT2 [] ={titulo, monto };
            oReport.addElementsTabla(sElemTT2, sStyleTT);

            titulo = "PREMIO NETO:";
            monto  = "$ " + Dbl.DbltoStr(dPremioNeto,2)+ "     (Moneda original)";
            String sElemTT3 [] ={titulo, monto };
            oReport.addElementsTabla(sElemTT3, sStyleTT);

            oReport.addFinTabla();

            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");
        } catch (Exception se) {
            throw new SurException (se.getMessage());   
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void cerrarPreliquidacion  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        boolean bOk;
        try {            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iNumPreliq  = oDicc.getInt (request, "co_numPreliq");
            int iCodProd    = oDicc.getInt (request, "co_CodProd");
            
            dbCon = db.getConnection();

            bOk = this.procesarCuotas (dbCon, iNumPreliq, oUser, request, response);

            if (bOk) {
                String pathRoot = this.getServletConfig().getServletContext().getRealPath("/files/preliq/res");
                File pathRootDirectory =new File(pathRoot);
                if( !pathRootDirectory.exists() && !pathRootDirectory.isDirectory() ){
                    throw new SurException( "No existe el Directorio : "  + pathRoot);
                }

                
                Preliq preliq = new Preliq();
                preliq.setNumPreliq(iNumPreliq);
                preliq.setCodProd(iCodProd);
                preliq.setUserid(oUser.getusuario());

                preliq.setDBCerrarPreliq (dbCon); // Cerrar Liquidacion.

                if ( preliq.getiNumError() != 0 ) {
                    request.setAttribute("mensaje", preliq.getsMensError());
                    if (preliq.getiNumError() == -100) {
                       request.setAttribute("volver", "-1");
                       doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    } else {
                        request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    }
                } else {
                    //Se cerror OK la liquidacion
                    dbCon.setAutoCommit(false);
                    cons = dbCon.prepareCall(db.getSettingCall("CO_GET_FILE_CIERRE_PRELIQ(?,?)"));
                    cons.registerOutParameter(1, java.sql.Types.OTHER);
                    cons.setInt(2, iNumPreliq);
                    cons.setInt(3, iCodProd);
                    cons.execute();

                    // setear el control de acceso
                    ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                    oControl.setearAcceso(dbCon, 30);

                    String nameFilePreliq = "pre" + lPad( String.valueOf(iNumPreliq),8,'0')+".res"; // + lPad( String.valueOf(iCodProd),5,'0');
                    String fileRes = pathRoot +  "/" + nameFilePreliq;

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


                    response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                    response.setHeader("Location", Param.getAplicacion() + "preliq/printPreview.jsp?opcion=getPreliqPDF&co_numPreliq=" + iNumPreliq + "&co_cierrePreliq=si&cod_prod=" + iCodProd);
                }
            }

   //         } //Control valores negativos


        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
                if (rs != null) { rs.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            db.cerrar(dbCon);
        }
            /**/


    }

    private String lPad( String dato , int cant, char caracter) {
         String strLpad = "";
         for (int i = 0 ; i < (cant - dato.length()) ; i++ ) {
             strLpad = strLpad + caracter  ;
         }
        return strLpad + dato;
    }

    protected void anularCobro  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        try {

            dbCon = db.getConnection();
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int iNumPreliq  = Integer.parseInt (request.getParameter("co_numPreliq"));
            int iNumFila    = Integer.parseInt (request.getParameter("co_numFila"));
            String sOrden   = request.getParameter ("co_orden");

            PreliqDet preliqdet = new PreliqDet ();
            preliqdet.setNumPreliq(iNumPreliq);
            preliqdet.setNumFila(iNumFila);
            preliqdet.setUseridCobro(oUser.getusuario());
            
            preliqdet.setDBMcaCobro(dbCon);
            if (preliqdet.getiNumError() < 0) {
                throw new SurException( preliqdet.getsMensError());
            }

            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_CONTROL_NC (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setInt   (2, iNumPreliq);
            cons.setString(3, oUser.getusuario());
            cons.execute();
            String res =cons.getString(1);

            if (!res.equals("")) {
                request.setAttribute("mensaje", "La suma de todas las cuotas tildadas de la/s póliza/s " + res + " es NEGATIVA. \n Por favor chequear porque se destildaron los créditos " );
                request.setAttribute("volver", Param.getAplicacion() + "servlet/PreliquidacionServlet?opcion=getPreliquidacion&co_numPreliq="+iNumPreliq+"&co_pri=N");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else{
                Preliq preliq = new Preliq();
                preliq.setNumPreliq(iNumPreliq );
                preliq.getDB(dbCon);
                if (preliq.getiNumError() < 0) {
                    throw new SurException( preliq.getsMensError());
                }
                preliq.getDBPreliqDet(dbCon, sOrden);
                if (preliq.getiNumError() < 0) {
                    throw new SurException( preliq.getsMensError());
                }
                request.setAttribute("preliq", preliq);
                request.setAttribute("lPreliqDet", preliq.getLPreliDet());
                doForward(request, response, "/preliq/getPreliquidacion.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                see.printStackTrace();
                throw new SurException(see.getMessage());
            }
            db.cerrar(dbCon);
        }
    }


    protected boolean  procesarCuotas  (Connection dbCon, int iNumPreliq, Usuario oUser, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        CallableStatement cons = null;
        boolean bOk = true;
        try {
            Enumeration paramNames = request.getParameterNames();
            LinkedList lPreliDet = getLpreliqDetModifCuota(paramNames , oUser.getusuario());

            int iNumFilaError = 0;
            for (int i=0 ; i < lPreliDet.size() ;i++) {
                PreliqDet preliqdet = (PreliqDet)lPreliDet.get(i);

                preliqdet.setDBMcaCobro(dbCon);
                if (preliqdet.getiNumError() < 0) {

                    if (preliqdet.getiNumError() == -200) {
                        bOk = false;
                        iNumFilaError = preliqdet.getNumFila();
                        break;
                    } else {
                        throw new SurException( preliqdet.getsMensError());
                    }
                }
            }

            if ( ! bOk) {
                request.setAttribute("mensaje", "La poliza  de la fila seleccionada N° " + iNumFilaError + " SE ENCUENTRA ANULADA." );
                request.setAttribute("volver", Param.getAplicacion() + "servlet/PreliquidacionServlet?opcion=getPreliquidacion&co_numPreliq="+iNumPreliq+"&co_pri=N");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall(db.getSettingCall("CO_GET_CONTROL_NC (?,?)"));
                cons.registerOutParameter(1, java.sql.Types.VARCHAR);
                cons.setInt   (2, iNumPreliq);
                cons.setString(3, oUser.getusuario());
                cons.execute();

                String res =cons.getString(1);

                if (!res.equals("")) {
                    bOk = false;
                    request.setAttribute("mensaje","La suma de todas las cuotas tildadas de la/s póliza/s " + res + " es NEGATIVA. \n Por favor chequear porque se destildaron los créditos " );
                    request.setAttribute("volver", Param.getAplicacion() + "servlet/PreliquidacionServlet?opcion=getPreliquidacion&co_numPreliq="+iNumPreliq+"&co_pri=N");
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
                }

            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
        return bOk;
    }

    protected void grabarCuotasPreliq  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        boolean bOk;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iNumPreliq  = oDicc.getInt (request, "co_numPreliq");
            String sOrden   = oDicc.getString (request, "co_orden", "POLIZA");
            //
            dbCon = db.getConnection();
            bOk = this.procesarCuotas  (dbCon, iNumPreliq, oUser, request, response);

            if (bOk) {
                Preliq preliq = new Preliq();
                preliq.setNumPreliq(iNumPreliq );
                preliq.getDB(dbCon);
                if (preliq.getiNumError() < 0) {
                    throw new SurException( preliq.getsMensError());
                }
                preliq.getDBPreliqDet(dbCon, sOrden);
                if (preliq.getiNumError() < 0) {
                    throw new SurException( preliq.getsMensError());
                }
                request.setAttribute("preliq", preliq);
                request.setAttribute("lPreliqDet", preliq.getLPreliDet());                
                doForward(request, response, "/preliq/getPreliquidacion.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void getPreliquidacion  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            dbCon = db.getConnection();
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iNumPreliq  = oDicc.getInt (request, "co_numPreliq");
            String sOrden   = oDicc.getString (request, "co_orden", "POLIZA");

            Preliq preliq = new Preliq();
            preliq.setNumPreliq(iNumPreliq );
            preliq.getDB(dbCon);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }
            preliq.getDBPreliqDet(dbCon, sOrden);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }
            request.setAttribute("preliq", preliq);
            request.setAttribute("lPreliqDet", preliq.getLPreliDet());           
            doForward(request, response, "/preliq/getPreliquidacion.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void cambiarEstado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            dbCon = db.getConnection();
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int iNumPreliq  = Integer.valueOf(request.getParameter ("co_numPreliq"));
            String sOrden   = request.getParameter ("co_orden");

            Preliq preliq = new Preliq();
            preliq.setNumPreliq(iNumPreliq );
            preliq.setUserid(oUser.getusuario());
            preliq.setCodEstado(0);
            
            preliq.setDBCambioEstado (dbCon);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }

            preliq.getDB(dbCon);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }

            preliq.getDBPreliqDet(dbCon, sOrden);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }
            request.setAttribute("preliq", preliq);
            request.setAttribute("lPreliqDet", preliq.getLPreliDet());
            doForward(request, response, "/preliq/getPreliquidacion.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    private LinkedList getLpreliqDetModifCuota(Enumeration lParamNames ,String usuario) throws SurException{
        LinkedList lPreliqDet = new LinkedList();
        try {
            String CUOTA_SEL = "^CBX_PRELIQ_\\d[0-9]*_FILA_\\d[0-9]*$";
            String CUOTA_BD  = "^CUOTA_PRELIQ_\\d[0-9]*_FILA_\\d[0-9]*$";
            Pattern patt_CUOTA_SEL = Pattern.compile(CUOTA_SEL);
            Pattern patt_CUOTA_BD  = Pattern.compile(CUOTA_BD);
            String sep_Inicial_CUOTA_SEL = "CBX_PRELIQ_";
            String sep_Inicial_CUOTA_BD  = "CUOTA_PRELIQ_";
            Hashtable cuotaSelHT = new Hashtable();
            Hashtable cuotabdHT  = new Hashtable();
            while(lParamNames.hasMoreElements())
            {
                String dato = (String)lParamNames.nextElement();
                Matcher matcher_CUOTA_SEL = patt_CUOTA_SEL.matcher(dato);
                StringBuffer datoStb = null;
                if (matcher_CUOTA_SEL.matches()) {
                    datoStb = new StringBuffer(dato);
                    datoStb.delete(0, sep_Inicial_CUOTA_SEL.length());
                    cuotaSelHT.put(datoStb.toString().trim(),datoStb.toString().trim());
                } else {
                    Matcher matcher_CUOTA_BD = patt_CUOTA_BD.matcher(dato);
                    if (matcher_CUOTA_BD.matches()) {
                        datoStb = new StringBuffer(dato);
                        datoStb.delete(0, sep_Inicial_CUOTA_BD.length());
                        cuotabdHT.put(datoStb.toString().trim(),datoStb.toString().trim());
                    }
                }
            } //while enumeration

            Enumeration eCuotaSel = cuotaSelHT.keys();
            Object objCuotaSel;            
            while (eCuotaSel.hasMoreElements()) {
                objCuotaSel = eCuotaSel.nextElement();
                boolean existsInCuotaBD = cuotabdHT.containsKey(objCuotaSel);
                if(!existsInCuotaBD){
                    PreliqDet pd = getPreliqDetByParameter ((String)objCuotaSel) ;
                    pd.setMcaCobro("*");
                    pd.setUseridCobro(usuario);
                    lPreliqDet.add(pd);
                }
            }
            Enumeration eCuotaBD = cuotabdHT.keys();
            Object objCuotaBD;
            while (eCuotaBD.hasMoreElements()) {
                objCuotaBD = eCuotaBD.nextElement();
                boolean existsInCuotaSel = cuotaSelHT.containsKey(objCuotaBD);
                if (!existsInCuotaSel) {
                    PreliqDet pd = getPreliqDetByParameter ((String)objCuotaBD) ;
                    pd.setMcaCobro("");
                    pd.setUseridCobro(usuario);
                    lPreliqDet.add(pd);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException(e.getMessage());
        }
        return lPreliqDet;
    }

    private PreliqDet getPreliqDetByParameter (String dato) {
        String sepFILA = "_FILA_";
        StringBuffer datoStb = new StringBuffer(dato);
        PreliqDet pd = new PreliqDet();
        pd.setNumPreliq(Integer.parseInt((datoStb.substring(0, datoStb.indexOf(sepFILA)).toString())));
        pd.setNumFila(Integer.parseInt((datoStb.substring(datoStb.indexOf(sepFILA)  + sepFILA.length() , datoStb.length()).toString())));
        return pd;
    }
  

    /**/
    protected void procesarPreLiq  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        String sCommand = "";
        try {            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iCodProd  = oDicc.getInt (request, "preliq_cod_prod");

            IntPreLiquidacion.setBase("BENEF");
            String pathRoot = this.getServletConfig().getServletContext().getRealPath("/files/preliq") ; //DESA.
                    //"D:/Usuarios/SUP/proyecto/beneficios/benef/www/files/preliq"; //LOCAL
            IntPreLiquidacion.setPathDirectoryRoot(pathRoot);

// cambiar el permiso al archivo que vamos a leer
            if (iCodProd == 99999 ) {
                sCommand = "chmod 666 " +  pathRoot + "/PRE*.*";
            }else {
                sCommand =  "chmod 666 " +  pathRoot + "/PRE*." + String.valueOf(iCodProd);
            }
            String osName = System.getProperty("os.name" );

            if ( ! osName.contains("Windows")) {
                String[] command1 = {"sh", sCommand};
                Process proc = Runtime.getRuntime().exec (command1);
/*                BufferedReader stdInput = new BufferedReader(new InputStreamReader (proc.getInputStream()));

                BufferedReader stdError = new BufferedReader(new InputStreamReader (proc.getErrorStream()));

                // read the output from the command
                String s = null;
                while ((s = stdInput.readLine()) != null) {
                    System.out.println(s);
                }

                // read any errors from the attempted command
                while ((s = stdError.readLine()) != null) {
                    System.out.println(s);
                }
 * /
 */

            }


            dbCon = db.getConnection();

// ANULAR EL MODULO DE PRELIQUIDACIONES ON LINE SI NO LO ESTA

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_PRELIQ_ONLINE");
            if (  oParam.getDBValor(dbCon).equals("S") ) {
                oParam.setsCodigo("ESTADO_PRELIQ_ONLINE");
                oParam.setsValor("N");
                oParam.setsUserid(oUser.getusuario());
                oParam.setDB(dbCon);
            }

            int lote  = IntPreLiquidacion.processPreLiquidacion(dbCon , iCodProd, oUser.getusuario());

            LinkedList lError = IntPreLiquidacion.getDBErrorByLote(dbCon,IntPreLiquidacion.base,lote);

            IntPreLiquidacion.insertarLote(dbCon, lote, oUser.getusuario());

            IntPreLiquidacion.anulacionMasivaPreliq(dbCon, lote);

// VOLVER A HABILITAR EL MODULO DE PRELIQUIDACIONES ON LINE
  //          oParam.setsValor("S");
  //          oParam.setsUserid(oUser.getusuario());
  //          oParam.setDB(dbCon);

            request.setAttribute("lote", lote);
            request.setAttribute("lError", lError);
            request.setAttribute("estadoproceso", "estadoproceso");
            doForward(request, response, "/preliq/procesarPreLiq.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

   
    /**/
    protected void getAllPreliq  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPreliq = null;
        boolean bExistePreliq = false;
        LinkedList lError = new LinkedList();
        String sCodProdDC = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iCodProd        = Integer.parseInt (request.getParameter("cod_prod") == null ? "-1" :
                                                    request.getParameter("cod_prod"));

            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000) {
                iCodProd = oUser.getiCodProd();
            }

            if (iCodProd != -1) {
                dbCon = db.getConnection();
                IntPreLiquidacion.setBase(db.getBase());
                String pathRoot = this.getServletConfig().getServletContext().getRealPath("/files/preliq") ;

                IntPreLiquidacion.setPathDirectoryRoot(pathRoot);

                String sCommand =  "chmod 666 " +  pathRoot + "/PRE*." + Formatos.lpad(String.valueOf(iCodProd),"0",5);

                String osName = System.getProperty("os.name" );

                if ( ! osName.contains("Windows")) {
                    String[] command1 = {"sh", sCommand};
                    Process proc = Runtime.getRuntime().exec (command1);
                    proc.waitFor();
/*
                    BufferedReader stdInput = new BufferedReader(new InputStreamReader (proc.getInputStream()));

                    BufferedReader stdError = new BufferedReader(new InputStreamReader (proc.getErrorStream()));

                    // read the output from the command
                    System.out.println("ESTA ES LA SALIDA DEL COMANDO:\n");
                    String s = null;
                    while ((s = stdInput.readLine()) != null) {
                        System.out.println(s);
                    }

                    // read any errors from the attempted command
                    System.out.println("ESTA ES LA SALIDA DE ERROR DEL COMANDO:\n");
                    while ((s = stdError.readLine()) != null) {
                        System.out.println(s);
                    }
*/
                }

                int lote  = IntPreLiquidacion.processPreLiquidacion(dbCon , iCodProd, oUser.getusuario());

                //System.out.println ("Listar Errores  " );
                lError = IntPreLiquidacion.getDBErrorByLote(dbCon,IntPreLiquidacion.base, lote);

                Preliq oUltPre = new Preliq();
                oUltPre.setCodProd(iCodProd);
                oUltPre.getDBUltimaPreliq(dbCon);

                if (oUltPre.getiNumError() < 0 && oUltPre.getiNumError() != -100) {
                    throw new SurException( oUltPre.getsMensError());
                }

                if (oUltPre.getCodEstado() == 7 || // vencida 
                    oUltPre.getCodEstado() == 0 || // en carga
                    oUltPre.getCodEstado() == 5) { // procesada

                    sCodProdDC = VerificoVencimientos (dbCon, iCodProd, oUser, oUltPre);

                    if (sCodProdDC != null && ! sCodProdDC.equals("0")) {
// vuelvo a obtener la nueva preliquidacion que acabo de generar en VerificoVencimientos
                        if ( ! osName.contains("Windows")) {
                            String[] command1 = {"sh", sCommand};
                            Process proc = Runtime.getRuntime().exec (command1);
                            proc.waitFor();
                        }

                        lote  = IntPreLiquidacion.processPreLiquidacion(dbCon , iCodProd, oUser.getusuario());

                        lError = IntPreLiquidacion.getDBErrorByLote(dbCon,IntPreLiquidacion.base, lote);
                    }
                }

                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("CO_GET_ALL_PRELIQUIDACIONES (?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt     (2, iCodProd );
                cons.setString  (3, oUser.getusuario());
                cons.execute();
                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    lPreliq = new LinkedList();
                    while (rs.next()) {
                        bExistePreliq = true;
                        Preliq oPre = new Preliq();
                        oPre.setsDescEstado      (rs.getString ("DESC_ESTADO"));
                        oPre.setNumPreliq       (rs.getInt("NUM_PRELIQ"));
                        oPre.setFechaTrabajo    (rs.getDate("FECHA_TRABAJO"));
                        oPre.setUserid          (rs.getString("USERID"));
                        oPre.setCodEstado       (rs.getInt ("COD_ESTADO"));
                        oPre.setCodProdDc       (rs.getString ("COD_PROD_DC"));
                        oPre.setCodProd         (rs.getInt("COD_PROD"));
                        oPre.setCodOrg          (rs.getInt("COD_ORG"));
                        oPre.setCodZona         (rs.getInt("COD_ZONA"));
                        oPre.setFechaEnvioProd  (rs.getDate("FECHA_ENVIO_PROD"));
                        oPre.setHoraEnvioProd   (rs.getString("HORA_ENVIO_PROD"));
                        oPre.setUseridEnvioProd (rs.getString ("USERID_ENVIO_PROD"));
                        oPre.setFechaEnvioBenef (rs.getDate("FECHA_ENVIO_BENEF"));
                        oPre.setHoraEnvioBenef  (rs.getString("HORA_ENVIO_BENEF"));
                        oPre.setUseridEnvioBenef(rs.getString ("USERID_ENVIO_BENEF"));
                        oPre.setNumLotePreliq   (rs.getInt("NUM_LOTE_PRELIQ"));
                        lPreliq.add(oPre);
                    }
                    rs.close ();
                }
                if (! bExistePreliq ) {
                    lPreliq = null;
                }
                cons.close();
            }

           // fin de setear el control de acceso

            request.setAttribute("preliquidaciones", lPreliq);
            request.setAttribute("errores", lError );
            doForward(request, response, "/preliq/getAllPreliq.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected String VerificoVencimientos (Connection dbCon, int iCodProd, Usuario oUser, Preliq oUltPre)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        String sCodProdDC = "0"; 
        try {
                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("CO_PRELIQ_VERIFICO_VENCIMIENTOS (?, ?, ?)"));
                cons.registerOutParameter(1, java.sql.Types.VARCHAR);
                cons.setInt   (2, iCodProd );
                cons.setInt   (3, oUltPre.getNumPreliq());
                if (oUltPre.getFechaTrabajo() == null ) {
                    cons.setNull (4, java.sql.Types.DATE);
                } else {
                    cons.setDate (4, Fecha.convertFecha(oUltPre.getFechaTrabajo()) );
                }
                cons.execute();

                sCodProdDC = cons.getString(1);

                cons.close();
                
                if ( ! sCodProdDC.equals ("0") ) {
                    try {

                        phpDC.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));

                        if (Param.getRealPath () == null) {
                            Param.realPath (phpDC.getRealPath());
                        }

                       db.realPath (phpDC.getRealPath());

                       String patron = "yyyyMMdd";
                       SimpleDateFormat formato = new SimpleDateFormat(patron);
                       Calendar hoy = Calendar.getInstance();
                       hoy.add(Calendar.DATE, 60);

                       StringBuilder sb = new StringBuilder();
                       sb.append("PROGRAMA=").append( phpDC.getPrograma(dbCon, "PHP_NUEVA_PRELIQ"));
                       sb.append("\r\nPRODUC=").append( sCodProdDC);
                       sb.append("\r\nCOMNET=B\r\nQUENET=\r\nFECVTO=").append(formato.format(hoy.getTime()));
                       sb.append("\r\n");
                       
                       String sMensaje    = null;
                       try {
                           URLConnection urlConnection = phpDC.getConnection( sb.toString());

                           BufferedReader inStream =  phpDC.sendRequest(urlConnection);

                           StringBuilder buffer = new StringBuilder();
                           String linea;
                           while((linea = inStream.readLine() ) != null) {
                                buffer.append(linea);
                                System.out.println (linea);
                           }

                            if (buffer == null || ! buffer.toString().endsWith("PRELIQUIDACION GENERADA")) {
                                sMensaje = "Salida incorrecta:" + (buffer == null ? "nula" : buffer.toString() );
                            }
                        } catch (Exception ioe) {
                            sMensaje = ioe.getMessage();
                        }
                       if ( sMensaje != null ) {
                            Email oEmail = new Email ();

                            oEmail.setSubject("ERROR EN PRELIQUIDACION ON LINE - COD.PROD " + sCodProdDC);
                            oEmail.setContent( sMensaje );
                            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR_INTERFACE");

                            for (int i=0; i < lDest.size();i++) {
                                Persona oPers = (Persona) lDest.get(i);
                                oEmail.setDestination(oPers.getEmail());
                                oEmail.sendMessageBatch();
                            }
                       }

                    } catch (Exception e) {
                        throw new SurException( e.getMessage());
                    }

                }

           // fin de setear el control de acceso

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return sCodProdDC;
        }
    }

    protected void enviarMensaje  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iNumPreliq  = oDicc.getInt (request, "co_numPreliq");
            String sOrden   = oDicc.getString (request, "co_orden", "POLIZA");
            StringBuilder sMensaje = new StringBuilder();

            sMensaje.append ("Preliquidación N° ");
            sMensaje.append (iNumPreliq).append("\n\n");
            sMensaje.append ("Productor: " ).append(oUser.getRazonSoc()).append(" (").append(oUser.getsCodProdDC()).append(").\n");
            sMensaje.append ("Remitente: ").append(request.getParameter("remitente")).append("\n\n");
            sMensaje.append ("Comentarios: ").append(request.getParameter("DESCRIPCION")).append("\n\n");

            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a relisii@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            StringBuilder sSubject = new StringBuilder();
            sSubject.append("PRELIQUIDACION WEB - SOLICITUD DE MODIFICACION PRELIQ. N ").append(iNumPreliq);

            oEmail.setSubject(sSubject.toString());
            oEmail.setContent(sMensaje.toString());

            dbCon = db.getConnection();
            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "PRELIQ_RECLAMO");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
            //        oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
            
            Preliq preliq = new Preliq();
            preliq.setNumPreliq(iNumPreliq );
            preliq.getDB(dbCon);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }
            preliq.getDBPreliqDet(dbCon, sOrden);
            if (preliq.getiNumError() < 0) {
                throw new SurException( preliq.getsMensError());
            }

            request.setAttribute("preliq", preliq);
            request.setAttribute("lPreliqDet", preliq.getLPreliDet());
            doForward(request, response, "/preliq/getPreliquidacion.jsp?mensaje=ok");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }

    public void doForward(HttpServletRequest request, HttpServletResponse response,
            String nextPage) throws  ServletException, IOException {
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

    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) throws ServletException, IOException {
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
