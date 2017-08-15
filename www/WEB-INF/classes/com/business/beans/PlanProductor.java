/*
 *
 *
 *
 */   
  
package com.business.beans;
  
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;

public class PlanProductor {

    private int codPlan        = 0;
    private int codProd        = 0;
    private String descProd    = "";
    private double comisionMax = 0;
    private Date fechaTrabajo  = null;
    private String userId      = "";
    private String sMensError  = new String();
    private int  iNumError     = 0;

    // private CallableStatement cons = null;


    public PlanProductor() {
    }

    public int getcodPlan         () { return  this.codPlan;}
    public void setcodPlan        (int param) { this.codPlan = param; }

    public int getcodProd         () { return  this.codProd;}
    public void setcodProd        (int param) { this.codProd = param; }

    public String getdescProd  () { return this.descProd;}
    public void setdescProd    (String param) { this.descProd = param; }

    public Date getfechaTrabajo   () { return  this.fechaTrabajo;}
    public void setfechaTrabajo   (Date param) { this.fechaTrabajo = param; }

    public void setuserId         (String param) { this.userId = param; }
    public String getuserId       () { return this.userId;}

    public void   setcomisionMax      (double param) { this.comisionMax = param; }
    public double getcomisionMax      ()             { return this.comisionMax;  }


    public String getsMensError  () {
        return this.sMensError ;
    }
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }

    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }

}

