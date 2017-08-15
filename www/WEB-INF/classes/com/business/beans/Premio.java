/*
 * Premio.java
 *
 * Created on 27 de marzo de 2006, 09:31
 */

package com.business.beans;

import com.business.util.*;
import java.util.Date;
import java.util.LinkedList;
import java.text.SimpleDateFormat;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.Fecha;
import com.business.interfaces.InterReport;

public class Premio {

    private int codRama        = 0;
    private int numPoliza      = 0;
    private int endoso         = 0;
    private double impBonif    = 0;
    private double impDerEmi   = 0;
    private double impIVA      = 0;
    private double impImpInternos = 0;
    private double impPrima    = 0;
    private double impRecAdm   = 0;
    private double impRecFin   = 0;
    private double impSellados = 0;
    
    private double porcBonif   = 0;
    private double porcImpInternos = 0;
    private double porcRecAdm  = 0;
    private double porcRecFin  = 0;
    private double porcSellados= 0;
    private double porcIVA     = 0;
    private double porcIngBrutos= 0;
    private double mpremio      = 0;
    private double mprimaAnu    = 0;
    private double msumaAseg    = 0;
    private double impIngBrutos= 0;
    private double impOtrosImpuestos = 0;
    
    private double porcComisionPrimaProd = 0;
    private double porcComisionPremioProd = 0;
    private double porcComisionPrimaOrg   = 0;
    private double porcComisionPremioOrg  = 0;
    
    private String sCodFormaPago  = null;
    private String sDescFormaPago = null;
    
    private String sMensError = new String ();
    private int  iNumError = 0;

//****************************************************************************+
/** * Get/Set Methods
*/
    public void setcodRama      (int param) { this.codRama = param; }
    public void setnumPoliza    (int param) { this.numPoliza = param; }
    public void setendoso       (int param) { this.endoso = param; }

    public int getcodRama       () { return codRama; }
    public int getnumPoliza     () { return  this.numPoliza; }
    public int getendoso        () { return  this.endoso; }    
    
    public double getimpBonif() {
        return impBonif;
    }

    public void setimpBonif(double impBonif) {
        this.impBonif = impBonif;
    }

    public double getimpDerEmi() {
        return impDerEmi;
    }

    public void setimpDerEmi(double  impDerEmi) {
        this.impDerEmi = impDerEmi;
    }


    public double getimpIVA() {
        return impIVA;
    }

    public void setimpIVA(double  impIVA) {
        this.impIVA = impIVA;
    }

    public double getporcIVA() {
        return porcIVA;
    }

    public void setporcIVA(double  porcIVA) {
        this.porcIVA = porcIVA;
    }
    
    public double getimpImpInternos() {
        return impImpInternos;
    }

    public void setimpImpInternos(double  impImp) {
        this.impImpInternos = impImp;
    }

    public double getimpOtrosImpuestos() {
        return impOtrosImpuestos;
    }

    public void setimpOtrosImpuestos(double  impOtrosImpuestos) {
        this.impOtrosImpuestos = impOtrosImpuestos;
    }

    public double getimpPrima() {
        return impPrima;
    }

    public void setimpPrima(double  impPrima) {
        this.impPrima = impPrima;
    }


    public double getimpRecAdm() {
        return impRecAdm;
    }

    public void setimpRecAdm(double  impRecAdm) {
        this.impRecAdm = impRecAdm;
    }

    public double getimpRecFin() {
        return impRecFin;
    }

    public void setimpRecFin(double  impRecFin) {
        this.impRecFin = impRecFin;
    }

    public double getimpSellados() {
        return impSellados;
    }

    public void setimpSellados(double  impSellados) {
        this.impSellados = impSellados;
    }

    public double getporcImpInternos() {
        return porcImpInternos;
    }

    public void setporcImpInternos(double  impImp) {
        this.porcImpInternos = impImp;
    }

    public double getporcSellados() {
        return porcSellados;
    }

    public void setporcSellados(double  porcSellados) {
        this.porcSellados = porcSellados;
    }
    
    public double getporcBonif() {
        return porcBonif;
    }

    public void setporcBonif(double  porcBonif) {
        this.porcBonif = porcBonif;
    }

    public double getporcRecAdm() {
        return porcRecAdm;
    }

    public void setporcRecAdm(double  porcRecAdm) {
        this.porcRecAdm = porcRecAdm;
    }

    public double getporcRecFin() {
        return porcRecFin;
    }

    public void setporcRecFin(double  porcRecFin) {
        this.porcRecFin = porcRecFin;
    }

    public double getMpremio() {
        return mpremio;
    }

    public void setMpremio(double  mpremio) {
        this.mpremio = mpremio;
    }


    public double getMprimaAnu() {
        return mprimaAnu;
    }

    public void setMprimaAnu(double  mprimaAnu) {
        this.mprimaAnu = mprimaAnu;
    }

    public double getMsumaAseg() {
        return msumaAseg;
    }

    public void setMsumaAseg(double  msumaAseg) {
        this.msumaAseg = msumaAseg;
    }

    public double getimpIngBrutos() {
        return impIngBrutos;
    }

    public void setimpIngBrutos(double  pimpIngBrutos) {
        this.impIngBrutos = pimpIngBrutos;
    }

    public double getporcIngBrutos() {
        return porcIngBrutos;
    }

    public void setporcIngBrutos(double  pporcIngBrutos) {
        this.porcIngBrutos = pporcIngBrutos;
    }

    public void setporcComisionPrimaProd (double param) { this.porcComisionPrimaProd  = param; }
    public void setporcComisionPremioProd(double param) { this.porcComisionPremioProd  = param; }
    public void setporcComisionPrimaOrg  (double param) { this.porcComisionPrimaOrg  = param; }
    public void setporcComisionPremioOrg (double param) { this.porcComisionPremioOrg  = param; }
    public double getporcComisionPrimaProd () { return  this.porcComisionPrimaProd  ; }
    public double getporcComisionPremioProd() { return  this.porcComisionPremioProd  ; }
    public double getporcComisionPrimaOrg  () { return  this.porcComisionPrimaOrg  ; }
    public double getporcComisionPremioOrg () { return  this.porcComisionPremioOrg  ; }
    public String getsDescFormaPago () { return this.sDescFormaPago;}

    public void setsDescFormaPago (String param) {this.sDescFormaPago = param; }
 
}

