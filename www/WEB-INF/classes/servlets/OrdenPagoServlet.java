/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
       
package servlets;
import com.business.beans.OrdenPago;
import com.business.beans.OrdenPagoDet;
import com.business.beans.Usuario;
import com.business.beans.CtaCteFac;
import com.business.beans.CtaCteHis;
import com.business.beans.Persona;
import com.business.db.db;
import com.business.db.phpDC;
import com.business.util.ControlDeUso;
import com.business.util.Dbl;
import com.business.util.Email;
import com.business.util.Proceso;
import com.business.util.SurException;
import com.business.util.Param;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedList;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;
import java.util.Random;
import java.text.DecimalFormat;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import com.jspsmart.upload.*;
import java.io.BufferedReader;
import java.net.URLConnection;
import java.sql.CallableStatement;
import java.sql.ResultSet;

               
public class OrdenPagoServlet extends HttpServlet {
private ServletConfig config;   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    final public void init(ServletConfig config)
      throws ServletException{
        super.init(config);
        this.config = config;
    }    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        try {

            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }
            
            if (request.getContentType() != null && 
                    request.getContentType().toLowerCase().contains("multipart/form-data") == true ) {
                uploadOP (request, response);
            } else {             
                String op =  request.getParameter("opcion");
                if  (op.equals("selectCtaCte")) {
                    selectCtaCte (request, response);            
                } else if  (op.equals("addCuitAfip")) {
                    updateCuitNominaAfip (request, response);            
                } else if  (op.equals("getFactura")) {
                    getFactura (request, response);            
                } else if  (op.equals("getAllOrdenPago")) {
                    getAllOrdenPago(request, response);            
                }else if  (op.equals("deleteFactura")) {
                    deleteFactura(request, response);            
                }
            }
            
        } catch (SurException se) {            
            goToJSPError(request,response, se);
        } catch (Exception e) {            
            goToJSPError(request,response, e);
        }
    }    

    protected void selectCtaCte  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        Proceso oProc = new Proceso ();
        boolean bFirst = true;
        OrdenPago op = new OrdenPago ();
        LinkedList <OrdenPagoDet> lDet = new LinkedList ();
        int numItem  = 1;
        double totalNeto = 0;
        double totalIva  = 0;
        double totalBruto = 0;
        try {
            Usuario usu = (Usuario) request.getSession().getAttribute("user");
            
            int numSecuOp = Integer.parseInt(request.getParameter ("num_secu_op"));
            int codProd   = Integer.parseInt (request.getParameter ("cod_prod" ));
            String cuitValido = request.getParameter ("cuit_valido");
            
            dbCon = db.getConnection();
            
            Usuario oProd = new Usuario();
            oProd.setiCodProd(codProd);
            oProd.getDBProductor(dbCon);
            oProd.setcuitValido(cuitValido != null && cuitValido.equals("S") ? true : false);

            CtaCteFac oUltFactCC = new CtaCteFac();
            oUltFactCC.setCodProdDc(oProd.getsCodProdDC());
            oUltFactCC.getDBUltimaFactura(dbCon);             
            
            op.setCodOrg(oProd.getorganizador());
            op.setCodProd(oProd.getiCodProd());
            op.setbeneficiario(oUltFactCC.getiNumError() == -100 ? oProd.getRazonSoc() : oUltFactCC.getbeneficiario());
            op.setcuit(oProd.getCuit());    
            op.setnumSecuOp(numSecuOp);
            
            int minAnioMes = 999999;
            int maxAnioMes = 0;
            
            for (Enumeration<String> paramNames = request.getParameterNames(); paramNames.hasMoreElements();) {
                 String param = paramNames.nextElement();
                 String valor = request.getParameter(param );
                 
                 if (param.startsWith("numsecuop") && valor.equals("S")) { // cambiar por S
                    String aValor [] = param.split("_");
                    
                    OrdenPagoDet opDet = new OrdenPagoDet ();

                    opDet.setanioMes(Integer.parseInt (aValor[1]));
                    opDet.setcodProdDC (aValor[2]);
                    opDet.setnumItem   (numItem);
                    opDet.setnumSecuOp (numSecuOp);
                    opDet.setimpNeto(Dbl.StrtoDbl(request.getParameter ("impneto_" + aValor[1]+ "_"+aValor[2] )));
                    if ( oProd.getCodCondIVA() == 1 ) {
                        opDet.setimpIva( opDet.getimpNeto() * 0.21 );
                    } else {
                        opDet.setimpIva( 0);
                    }
                    
                    opDet.setitem("Comisiones devengadas Cod.Prod." + opDet.getcodProdDC() );
                    totalNeto += opDet.getimpNeto();
                    totalIva  += opDet.getimpIva();
           //         if ( oProd.getiCodProd() >= 80000 )  verificar si por la condicion ante la afip
           //          tiene que facturar con o sin iva. 
                    
                    totalBruto +=  opDet.getimpNeto() + opDet.getimpIva();
                    numItem += 1;
                    lDet.add(opDet);
                    op.setcodProdDc(opDet.getcodProdDC());
                    if (opDet.getanioMes() < minAnioMes ) minAnioMes = opDet.getanioMes();
                    if (opDet.getanioMes() > maxAnioMes ) maxAnioMes = opDet.getanioMes();
                }
            }
            LinkedList <CtaCteHis> lCtaCte = new LinkedList ();
            if ( usu.getiCodTipoUsuario() == 0) {
                lCtaCte = op.getDBCtaCteHis(dbCon, minAnioMes, maxAnioMes);
                if (op.getiNumError() < 0) {
                    throw new SurException(op.getsMensError());
                }
            }
            op.setimpNeto(totalNeto);
            op.setimpIvaCierre(totalIva);
            op.setimpFactura(totalBruto);
            op.settipoOrden("OO");

            if (oProd.getCodCondIVA() == 1)
               op.settipoFactura("FA");
            else 
               op.settipoFactura("FC");
            
/*            if (oUltFactCC.getiNumError() == -100 ) {
                 if (oProd.getCodCondIVA() == 1)
                    op.settipoFactura("FA");
                 else 
                    op.settipoFactura("FC");
            } else {  
               op.settipoFactura(oUltFactCC.gettipoComprob());
            }
  */           
            if ( oUltFactCC.getiNumError() == 0 )                   
                op.setnumSuc(Integer.parseInt (oUltFactCC.getnumComprob1()));
            else 
                op.setnumSuc(1);
            
            if (oUltFactCC.getiNumError() == 0 && 
                    ! oUltFactCC.getnumComprob2().equals("0000000"))                   
                op.setnumFactura(Integer.parseInt (oUltFactCC.getnumComprob2()));
            else 
                op.setnumFactura(0);            
                
            request.setAttribute("productor", oProd);
            request.setAttribute("orden_pago", op);
            request.setAttribute("orden_pago_det", lDet);
            request.setAttribute("ult_fact_ctacte", oUltFactCC);
            request.setAttribute("ctactehis", lCtaCte);
            request.setAttribute("volver", "ctactefa"); 
            
            doForward(request, response, "/ordenPago/formOrdenPago.jsp");
   
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }        
    }

    protected void getFactura (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        OrdenPago op = new OrdenPago ();
        LinkedList <CtaCteHis> lCtaCte = new LinkedList ();  
        try {
            Usuario usu = (Usuario) request.getSession().getAttribute("user");            
            int numSecuOp = Integer.parseInt(request.getParameter ("num_secu_op"));
            
            dbCon = db.getConnection();
            
            op.setnumSecuOp(numSecuOp);

            op.getDB(dbCon);
            
            if ( op.getiNumError() < 0 ) {
                throw new SurException (op.getsMensError());
            }
            
            if ( usu.getiCodTipoUsuario() == 0 ) { // no es procesada
                lCtaCte = op.getDBCtaCteHis(dbCon,0, 0);
                if ( op.getiNumError() < 0 ) {
                    throw new SurException (op.getsMensError());
                }
            }
            
            Usuario oProd = new Usuario();
            oProd.setiCodProd( op.getCodProd() == 0 ? op.getCodOrg() : op.getCodProd() );
            oProd.getDBProductor(dbCon);
            oProd.getDBValidarCuit(dbCon);
            
                            
            request.setAttribute("productor", oProd);
            request.setAttribute("orden_pago", op);
            request.setAttribute("orden_pago_det", op.getDetalle());
            request.setAttribute("ctactehis", lCtaCte); 
            request.setAttribute("volver", request.getParameter ("volver") == null ? "ctactefa" :request.getParameter ("volver") ); 
            
            doForward(request, response, "/ordenPago/formOrdenPago.jsp");
   
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }        
    }

    protected void getAllOrdenPago (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList <OrdenPago> lOrden = new LinkedList ();
        CallableStatement cons  = null;
        ResultSet rs = null;
        try {
            Usuario usu = (Usuario) request.getSession().getAttribute("user");

            dbCon = db.getConnection();
            
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("OP_GET_ALL_ORDEN_PAGO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString  (2, usu.getusuario());

            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    OrdenPago op = new OrdenPago();
                    op.settipoOrden     (rs.getString ("TIPO_ORDEN" ));
                    op.setnumOrden      (rs.getInt ("NUM_ORDEN" ));
                    op.settipoFactura   (rs.getString ("TIPO_FACTURA" ));
                    op.setnumSuc        (rs.getInt ("NUM_SUC" ));
                    op.setnumFactura    (rs.getInt ("NUM_FACTURA" ));
                    op.setmcaFacturaFisica(rs.getString ("MCA_FACTURA_FISICA" ));
                    op.setCodProd       (rs.getInt ("COD_PROD" ));
                    op.setcuit          (rs.getString ("CUIT" ));
                    op.setimpNeto       (rs.getDouble("IMP_NETO" ));
                    op.setimpIva        (rs.getDouble("IMP_IVA" ));
                    op.setimpOrdenPago  (rs.getDouble("IMP_ORDEN_PAGO" ));
                    op.setimpFactura    (rs.getDouble("IMP_FACTURA" ));
                    op.setuserId        (rs.getString ("USERID" ));
                    op.setfechaTrabajo  (rs.getDate("FECHA_TRABAJO" ));
                    //rs.getString ("HORA_TRABAJO" ));
                    op.setcodEstado     (rs.getInt ("COD_ESTADO" ));
                    op.setcodErrorOP    (rs.getInt ("COD_ERROR" ));
                    op.setimpIvaCierre  (rs.getDouble("IMP_IVA_CIERRE" ));
                    op.setnomArchivoFactura(rs.getString ("NOM_ARCHIVO_FACTURA" ));
                    op.setuserIdAutoriza(rs.getString ("USERID_AUTORIZA" ));
                    op.setnumSecuOp     (rs.getInt ("NUM_SECU_OP"));
                    op.setbeneficiario  (rs.getString ("BENEFICIARIO"));
                    op.setfechaFactura  (rs.getDate("FECHA_FACTURA"));
                    op.setdescErrorOP   (rs.getString ("DESC_ERROR"));
                    op.setproductor     (rs.getString ("PRODUCTOR"));
                    op.setdescEstado    (rs.getString ("DESC_ESTADO"));
                    op.setcodProdDc     (rs.getString ("COD_PROD_DC"));
                    op.setfechaEmision  (rs.getDate ("FECHA_EMISION"));
                    
                    lOrden.add(op);
                }
                rs.close ();
            }
            cons.close();
                            
            request.setAttribute("ordenes", lOrden);
            
            doForward(request, response, "/ordenPago/formAllOrdenPago.jsp");
   
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            db.cerrar(dbCon);
        }        
    }
    
    protected void uploadOP  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException, SQLException, SmartUploadException {
        Connection dbCon = null;
        OrdenPago op = new OrdenPago ();
        SmartUpload mySmartUpload = new SmartUpload();        
        String sMensaje = "";
        String sVolver = "";
        LinkedList <OrdenPagoDet> lDet = new LinkedList ();

        try {
            
        Usuario usu = (Usuario) request.getSession().getAttribute("user");
        
        // Initialization
        mySmartUpload.initialize(this.getServletConfig(), request, response); 
        // Only allow txt or htm files
        mySmartUpload.setAllowedFilesList("pdf,jpg,jpge,bmp,jpeg,PDF,JPG,JPGE,JPEG,BMP");

        // DeniedFilesList can also be used :
        mySmartUpload.setDeniedFilesList("exe,bat,jsp,tif");

        // Deny physical path
        mySmartUpload.setForcePhysicalPath(false);

        // Only allow files smaller than 50000 bytes
        // 5 MB
        mySmartUpload.setMaxFileSize(5242880);
    
        // Upload	
        try {  
            mySmartUpload.upload();

        } catch (java.lang.SecurityException se) {
            if (se.getMessage().startsWith("The extension of the file is not allowed to be uploaded")) {
                sMensaje =  "ARCHIVO NO PERMITIDO, LAS EXTENSIONES PERMITIDAS SON  pdf, jpg, jpeg, bmp";
            } else if ( se.getMessage().startsWith("Size exceeded for this file")) {
                sMensaje = "ARCHIVO DEMASIADO GRANDE, NO DEBERIA SUPERAR LOS 5 MegaBytes";
            } else {
                sMensaje = se.getMessage();
            }
            
            request.setAttribute("mensaje", sMensaje );
            request.setAttribute("volver", "-1" );
            doForward (request, response, "/include/MsjHtmlServidor.jsp");            
        }
        // Save the files with their original names in a virtual path of the web server
        //Request requestSmart = mySmartUpload.getRequest();
        
        String volver =  mySmartUpload.getRequest().getParameter ("volver");
        int numSecuOp = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_secu_op"));
        String tipoOrden = mySmartUpload.getRequest().getParameter ("tipo_orden");
        String codProdDC = mySmartUpload.getRequest().getParameter ("cod_prod_dc");
        int codProd      = Integer.parseInt (mySmartUpload.getRequest().getParameter ("cod_prod"));
        String beneficiario = mySmartUpload.getRequest().getParameter ("beneficiario");
        String cuit = mySmartUpload.getRequest().getParameter ("cuit_benef");

        String tipoFactura = mySmartUpload.getRequest().getParameter ("tipo_factura");
        int numSuc = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_suc"));
        int numFact = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_factura"));

        double impNeto = Double.parseDouble (mySmartUpload.getRequest().getParameter ("total_neto"));
        double impIva  = Double.parseDouble (mySmartUpload.getRequest().getParameter ("total_iva"));
        double impIvaCierre  = Double.parseDouble (mySmartUpload.getRequest().getParameter ("total_iva_cierre"));
        double impBruto= Double.parseDouble (mySmartUpload.getRequest().getParameter ("total_factura"));
        double impOrdenPago = Double.parseDouble (mySmartUpload.getRequest().getParameter ("total_op"));

        String oldstring = mySmartUpload.getRequest().getParameter ("fecha_factura");
        
        java.util.Date fecha = null;
        try {
            fecha = new SimpleDateFormat("yyyy-MM-dd").parse(oldstring);
        
        } catch ( Exception e ) {
            fecha = new SimpleDateFormat("dd/MM/yyyy").parse(oldstring);
        }

        String mcaFacturaFisica  = ( mySmartUpload.getRequest().getParameter ("factura_electronica").equals ("S") ? null : "X");
        String userIdAutoriza    = null;
        if ( usu.getiCodTipoUsuario() == 0 ) {
            userIdAutoriza =  usu.getusuario();
        }
         
        String cuitValido = mySmartUpload.getRequest().getParameter ("cuit_valido");
        
        op.setbeneficiario(beneficiario);
        
        if (cuitValido.equals("N") && usu.getiCodTipoUsuario() == 1) { 
            op.setcodEstado(5);// error
            op.setcodErrorOP(-300); // CUIT INVALIDO
            op.setdescErrorOP("Cuit Invalido");
        } else {
            op.setcodEstado(1);// enviado
        }
        op.setcuit(cuit);
        op.setfechaFactura(fecha);
        op.setimpFactura(impBruto);
        op.setimpIva(impIva);
        op.setimpIvaCierre(impIvaCierre);
        op.setimpNeto(impNeto);
        op.setimpOrdenPago(impOrdenPago);
        op.setmcaFacturaFisica(mcaFacturaFisica);
        op.setnumFactura(numFact);
        op.setnumSecuOp(numSecuOp);
        op.setnumSuc(numSuc);
        op.settipoFactura(tipoFactura);
        op.settipoOrden(tipoOrden);
        op.setuserId(usu.getusuario());
        op.setuserIdAutoriza(userIdAutoriza);
        op.setCodProd(codProd);
        op.setcodProdDc(codProdDC);
        
        Random r;
        r=new Random();
        r.setSeed(new java.util.Date().getTime());
        String sFile = codProdDC + "@" + r.nextInt(10000) + ".";

        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);

        if (!myFile.isMissing()) {

        // Save it only if this file exists
            sFile = sFile + myFile.getFileExt();
            String nameFile = "/files/factura/" + sFile;
            // Save the files with its original names in a virtual path of the web server       
            myFile.saveAs (nameFile , mySmartUpload.SAVE_VIRTUAL);
            // myFile.saveAs("/upload/" + myFile.getFileName(), mySmartUpload.SAVE_PHYSICAL);
            op.setnomArchivoFactura(sFile);
        } else {
            op.setnomArchivoFactura(mySmartUpload.getRequest().getParameter ("nom_archivo"));
        }
        // count = mySmartUpload.save("/files/nominas", mySmartUpload.SAVE_VIRTUAL);


        dbCon = db.getConnection();
        op.setDB(dbCon);
        
        if (op.getiNumError() < 0 ) {
            throw new SurException(op.getsMensError());
        }
        
        int cantItems = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("cant_item"));
        
        for (int i=1;i<=cantItems; i++) { 
            OrdenPagoDet opDet = new OrdenPagoDet ();
            opDet.setanioMes(Integer.parseInt (mySmartUpload.getRequest().getParameter ("aniomes_" + i)));
            opDet.setcodProdDC (mySmartUpload.getRequest().getParameter ("codproddc_" + i));
            opDet.setnumItem   (i);
            opDet.setnumSecuOp (op.getNumSecuOp());
            opDet.setimpNeto (Dbl.StrtoDbl(mySmartUpload.getRequest().getParameter ("impneto_" + i )));
            opDet.setitem ("Comisiones Prod." + opDet.getcodProdDC() + " - " + opDet.getanioMes() );
            opDet.setDB(dbCon);
            lDet.add(opDet);
        }
        
        if ( usu.getiCodTipoUsuario() == 0 ) {
            this.emitirOrdenPago(dbCon, op, lDet, usu);
            if (op.getiNumError() == 0 ) { 
                if ( op.getnumOrden() > 0 ) {
                    sMensaje = "La factura fue emitida exitosamente !! Orden de Pago # " + op.getnumOrden();
                } else {
                    sMensaje = "La orden de pago no pude ser emitida debido al siguiente error: " + op.getsMensError();
                }
            } else { 
                sMensaje = "Hubo un error en la emision de la Orden Pago: " + op.getsMensError();
            }
        } else {
            sMensaje = "La Factura fue enviada exitosamente pendiente de autorizaci&oacute;n. <br><br>Transacci&oacute;n # " + op.getNumSecuOp();
        }

// setear el control de acceso
        ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
        oControl.setearAcceso(dbCon, 41 );
// fin de setear el control de acceso 
        
        if (volver.equals ("ctactefa") || usu.getiCodTipoUsuario() == 1 ) {
            sVolver = Param.getAplicacion() + "servlet/CtaCteServlet?opcion=getCtaCteFac&cod_prod=" + op.getCodProd();
        } else {
            sVolver = Param.getAplicacion() + "servlet/OrdenPagoServlet?opcion=getAllOrdenPago";
        }
        request.setAttribute("mensaje", sMensaje );
        request.setAttribute("volver", sVolver );
        doForward (request, response, "/include/MsjHtmlServidor.jsp");
   
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }        
    }

    protected void  emitirOrdenPago (Connection dbCon, OrdenPago oP, LinkedList lDet, Usuario usu )
    throws IOException, SurException {
        URLConnection urlConnection = null;
        BufferedReader inStream = null;
        BufferedReader inStreamError = null;
        int vRetorno = 0;
        boolean bProcesarRetorno = true;
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sCodProdDC = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        DecimalFormat dblFormat = new DecimalFormat("00000000.00");        
        try {
            if ( System.getProperty("os.name" ).contains("Windows") ) {
                _file = getServletConfig().getServletContext().getRealPath("/benef/propiedades/");
                _file = _file + "config.xml";
            }

            if (phpDC.getRealPath() == null) {
                phpDC.realPath (_file);
            }
            
            String[] lDetalle = {"","","",""}; 

            int maxAnioMes = 0;
            int minAnioMes = 999999;
            if (lDet.size() > 4 ) { 
                for (int i=0;i< lDet.size();i++) { 
                    OrdenPagoDet op = (OrdenPagoDet) lDet.get(i);
                    sCodProdDC = op.getcodProdDC();
                    if (op.getanioMes() > maxAnioMes ) maxAnioMes = op.getanioMes();
                    if (op.getanioMes() < minAnioMes ) minAnioMes = op.getanioMes();
                }
                lDetalle [0] = "Comisiones Prod. " + sCodProdDC;
                lDetalle [1] = "Periodos e/" + minAnioMes + " y " + maxAnioMes; 
            } else { 
                for (int i=0;i< lDet.size();i++) { 
                    OrdenPagoDet op = (OrdenPagoDet) lDet.get(i);
                    sCodProdDC = op.getcodProdDC();
                    if (op.getanioMes() > maxAnioMes ) maxAnioMes = op.getanioMes();
                    if (op.getanioMes() < minAnioMes ) minAnioMes = op.getanioMes();
                    lDetalle [i] = op.getitem();
                }
            }

// graba los conceptos utilizados para emitir la orden de pago
            oP.setDBConceptos(dbCon, sCodProdDC, minAnioMes, maxAnioMes);
            if (oP.getiNumError() < 0) {
                throw new SurException(oP.getsMensError());
            }
            
// emitir la orden de pago en DC
            
            StringBuilder sb = new StringBuilder ();     
            sb.append("PROGRAMA=").append( phpDC.getPrograma(dbCon, "PHP_EMITE_OP")).append("\n");
            sb.append("TIPCOM=").append(oP.gettipoOrden()).append("\n");// XX   TIPO DE ORDEN  OO    OP     OT    OS    OA
            sb.append("NUMPRO=").append(sCodProdDC).append("\n");// 9(10)                 PROVEEDOR , PRODUCTOR,
            sb.append("SUCFAC=").append(String.format("%04d",oP.getnumSuc())).append("\n");//  9999   SUCURSAL  DE LA FACTURA
            sb.append("NUMFAC=").append(String.format("%08d",oP.getnumFactura())).append("\n");// 99999999        NUMERO  DE FACTURA
            sb.append("FECFAC=").append(sdf.format (oP.getfechaFactura())).append("\n");//  9(08)  FECHA EMISION DE LA FACTURA  AAAAMMDD
            sb.append("FECPAG=").append(sdf.format (oP.getfechaFactura())).append("\n");// 9(08)   FECHA ESTIMADA DE PAGO DE LA FACTURA   AAAAMMDD
            sb.append("CODEGR=").append("0046").append("\n");//9999     CODIGO DE EGRESO    DETERMINA LA IMP.CONTABLE DEL GASTO
            sb.append("COMBRU=").append(dblFormat.format(oP.getimpNeto()).replace(".", ",")).append("\n");//9(10),99 SOLO PARA PRODUTORES   COMISION BRUTA  SOBRE LA QUE SE CALCULA EL I.V.A.
            sb.append("COMNET=").append(dblFormat.format(oP.getimpOrdenPago() ).replace(".", ",")).append("\n");//9(10),99 SOLO PRODUCTORES   COMISION NETA
            sb.append("IMPIVA=").append(dblFormat.format(oP.getimpIva()).replace(".", ",")).append("\n");//9(10),99 IMPORTE DEL I.V.A.
            sb.append("NETGRA=").append(dblFormat.format(oP.getimpOrdenPago()).replace(".", ",")).append("\n");//9(10),99 NETO GRAVADO DE LA ORDEN  PARA TODAS LAS QUE NO SON OO
            sb.append("NETNOG=").append("00000000,00").append("\n");//9(10),99 NETO NO GRAVADO
            sb.append("CONTAB=").append(oP.gettipoOrden().equals("OO") ? "S" : "N").append("\n");// X       FORMA DE CONTABILIZACION   â€œSâ€   PARA PRODUCTORES â€œNâ€  PARA EL RESTO
            sb.append("DESUNO=").append(String.format("%1$-45s",lDetalle [0])).append("\n");//X(45)    DESCRIPCION DE LA ORDEN
            sb.append("DESDOS=").append(String.format("%1$-45s",lDetalle [1])).append("\n");//X(45)    DESCRIPCION
            sb.append("DESTRE=").append(String.format("%1$-45s",lDetalle [2])).append("\n");//X(45)    DESCRIPCION
            sb.append("DESCUA=").append(String.format("%1$-45s",lDetalle [3])).append("\n");//X(45)    DESCRIPCION
            sb.append("BENEFI=").append(String.format("%1$-45s",oP.getbeneficiario())).append("\n");//X(45)    BENEFICIARIO DE LA ORDEN
            sb.append("SECION=").append("00").append("\n");// 99      SECCION DEL SINIESTRO
            sb.append("NUMSIN=").append("00000000").append("\n");//9(08)    NUMERO DE SINIESTRO
            sb.append("SUBSIN=").append("00").append("\n");//99       SUBSINIESTRO
            sb.append("HECGEN=").append("00").append("\n");//99       HECHO GENERADOR
            sb.append("CONPAG=").append("00").append("\n");//99       CONCEPTO DE PAGO     TABLA DEL SISTEMA
            sb.append("TIPGAS=").append(" ").append("\n");//X        I =  INDEMNIZACION   G = GASTOS
            sb.append("TIPFAC=").append(oP.gettipoFactura()).append("\n");//XX FA, FC, FM o RE
            sb.append("NUMWEB=").append(String.format("%08d",oP.getNumSecuOp())).append("\n");//  9999   SUCURSAL  DE LA FACTURA
            
//System.out.println (sb.toString());            
            
            try {

                String linea;
                String estado = "";
                StringBuilder error = new StringBuilder();
                String numOrden = "";
                String sFechaEmision = "";
                String sImpPago = "";
                StringBuilder salida = new StringBuilder();
                urlConnection = phpDC.getConnection(sb.toString());

                inStream =  phpDC.sendRequest(urlConnection);
                
                inStreamError = inStream;
                
                while((linea = inStream.readLine() ) != null) {                    
                    String [] aParam = linea.split("=");
                    if (aParam [0].equals ("ESTADO")) estado = aParam[1];
                    if ( estado != null && estado.contains("OK")) { 
                        if (aParam [0].equals ("NUMORD")) numOrden = aParam[1];
                        if (aParam [0].equals ("FECEMI")) sFechaEmision = aParam[1];
                        if (aParam [0].equals ("IMPPAG")) sImpPago = aParam[1];
                    }
                    
                    salida.append(linea);
                }

                if ( salida.toString().equals ("") ) {
                        oP.setcodEstado(5);
                        oP.setdescErrorOP(salida.toString());
                        enviarMail(dbCon, oP, usu);
                } else {                    
                    if ( estado.contains("OK") ) {                        
                        oP.setnumOrden(Integer.parseInt (numOrden));
                        oP.setfechaEmision(new SimpleDateFormat("yyyyMMdd").parse(sFechaEmision) );
                        oP.setcodEstado(3); // PROCESADA
                    } else {
                        while((linea = inStream.readLine() ) != null) {                    
//                            System.out.println (linea);
                            String [] aParam = linea.split("=");
                            if (aParam [0].equals ("ERR001") || aParam [0].equals ("ERR002") ||
                                aParam [0].equals ("ERR003") || aParam [0].equals ("ERR004")) error.append(aParam[1]);
                        }
                        
                        oP.setcodEstado(5);
                        oP.setdescErrorOP(error.toString());
                    }     
                }
                oP.setDB(dbCon);                

            } catch (Exception ioe) {
                enviarMail (dbCon, oP, usu);
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

   protected void  enviarMail (Connection dbCon, OrdenPago oP, Usuario usu )
    throws IOException, SurException {
        try {
            Email oEmail = new Email ();

            oEmail.setSubject("ERROR EN FACTURA WEB ON LINE - NUM.SECU.OP Nº " + oP.getNumSecuOp());
            oEmail.setContent(oP.getdescErrorOP());
            LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR_INTERFACE");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                oEmail.sendMessageBatch();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
    
    protected void  updateCuitNominaAfip  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons2  = null;
        try {

            int codProd   = Integer.parseInt (request.getParameter ("cod_prod" ));
            
            String cuit   = request.getParameter ("cuit");

            Usuario usu = (Usuario) request.getSession().getAttribute("user");
            String operacion = request.getParameter ("operacion");

            String volver = request.getParameter ("volver") == null ? "ctactefa" : request.getParameter ("volver");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(true);
            cons2 = dbCon.prepareCall(db.getSettingCall("AFIP_UPDATE_CUIT_NOMINA (?, ?, ?)"));
            cons2.registerOutParameter(1, java.sql.Types.INTEGER);
            cons2.setString   (2, cuit );
            cons2.setString   (3, usu.getusuario());
            cons2.setString   (4, operacion);

            cons2.execute();
            int retorno2 = cons2.getInt(1);
            
            request.setAttribute("mensaje", "CUIT dado de " + operacion + " de  la nomina exitosamente !!");
            
            if (volver.equals("ctactefa")) { 
                request.setAttribute("volver", Param.getAplicacion() + "servlet/CtaCteServlet?opcion=getCtaCteFac&cod_prod=" + codProd ); 
            } else { 
                request.setAttribute("volver", Param.getAplicacion() + "servlet/OrdenPagoServlet?opcion=getAllOrdenPago");
            }    
            doForward (request, response, "/include/MsjHtmlServidor.jsp");  
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try { 
                if (cons2 != null ) cons2.close ();
            } catch (SQLException se) {
                throw new SurException(se.getMessage());
            }
            db.cerrar(dbCon);
        }        
    }

    protected void  deleteFactura (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        String sMensaje = "";
        try {

            int numSecuOp   = Integer.parseInt (request.getParameter ("num_secu_op" ));
    
            Usuario usu = (Usuario) request.getSession().getAttribute("user");
    
            dbCon = db.getConnection();
            
            OrdenPago op = new OrdenPago();
            op.setnumSecuOp(numSecuOp);
            op.setuserId (usu.getusuario());
            op.deleteDB(dbCon);

            if (op.getiNumError() < 0) 
                sMensaje = op.getsMensError();
            else 
                sMensaje = "ORDEN DE PAGO ANULADA CON EXITO";
            
            request.setAttribute("mensaje", sMensaje);
            request.setAttribute("volver", Param.getAplicacion() + "servlet/OrdenPagoServlet?opcion=getAllOrdenPago");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");  
            
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