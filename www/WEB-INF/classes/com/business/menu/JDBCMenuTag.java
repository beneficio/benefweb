package com.business.menu;

public class JDBCMenuTag extends MenuTag
{
    private String driverName;
    private String conurl;
    private String username;
    private String password;
    private int aplicacion;
    private String userLogon; 
    
    public JDBCMenuTag(){
    }

    public String getDriverName(){
            return driverName;
    }

    public void setDriverName(String driverName){
            this.driverName = driverName;
    }

    public String getDriverUrl(){
            return conurl;
    }

    public void setDriverUrl(String url){
            this.conurl = url;
    }

    public String getUserName(){
            return username;
    }

    public void setUserName(String username){
            this.username = username;
    }

    public String getPassword(){
            return password;
    }

    public void setPassword(String password){
            this.password = password;
    }

    public String getUserLogon (){
            return userLogon;
    }

    public void setUserLogon (String userLogon){
            this.userLogon = userLogon;
    }

    public int getAplicacion (){
            return aplicacion;
    }

    public void setAplicacion (int aplicacion){
            this.aplicacion = aplicacion;
    }
    
    protected String getMenu() throws MenuException{
        
            MenuBuilder builder = new JDBCMenuBuilder(driverName, conurl, username, password, aplicacion, userLogon);
            return builder.renderMenu();
    }

}