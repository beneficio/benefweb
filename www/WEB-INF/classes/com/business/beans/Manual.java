package com.business.beans;
import java.util.Date;
/**
 *
 * @author Rolando Elisii
 */
public class Manual {

   private String titulo ;
    private int    codManual;
    private int    orden;
    private int    tipoUsuario;
    private int    numEndoso;
    private String categoria;
    private Date   fechaPublicacion;
    private String   mensaje;
    private String link;
    private String mcaBaja;
    private String seccionTit;
    private String seccionMens;
    private int   codSeccion = 0;
    private String tipoDoc;


    /** Creates a new instance of Certificado */
    public Manual () {
    }

    public String gettitulo      (){return this.titulo;}
    public int    getcodManual   (){return this.codManual;}
    public int    getorden       (){return this.orden;}
    public int    gettipoUsuario (){return this.tipoUsuario;}
    public int    getNumEndoso   (){return this.numEndoso;}
    public String getcategoria   (){return this.categoria; }
    public Date   getfechaPublicacion (){ return this.fechaPublicacion;  }
    public String   getmensaje   (){return this.mensaje;  }
    public String getlink        (){return this.link;  }
    public String getmcaBaja     (){ return this.mcaBaja;}
    public int    getcodSeccion  (){return this.codSeccion;}
    public String getseccionTit  (){return this.seccionTit;  }
    public String getseccionMens (){ return this.seccionMens;}
    public String gettipoDoc     (){ return this.tipoDoc;}

    public void settitulo      (String param ) {this.titulo= param ;}
    public void setcodManual   (int param ) {this.codManual= param ;}
    public void setorden       (int param ) {this.orden= param ;}
    public void settipoUsuario (int param ) {this.tipoUsuario= param ;}
    public void setNumEndoso   (int param ) {this.numEndoso= param ;}
    public void setcategoria   (String param ) {this.categoria= param ; }
    public void setfechaPublicacion ( Date param) {this.fechaPublicacion= param ;  }
    public void setmensaje     (String param) {this.mensaje= param ;  }
    public void setlink        (String param ) {this.link= param ;  }
    public void setmcaBaja     (String param) {this.mcaBaja = param; }
    public void setseccionTit  (String param ) {this.seccionTit= param ;  }
    public void setseccionMens (String param) {this.seccionMens = param; }
    public void setcodSeccion  (int param ) {this.codSeccion = param ;}
    public void settipoDoc     (String param ) {this.tipoDoc = param ;}
}

