/*
 * DbBean.java
 *
 * Created on 13 de mayo de 2002, 11:11
 */

package com.business.db;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

        

/**
 *
 * @author  lpablo
 */
public class DbBean  implements Serializable{   
    
    private Connection conn = null;
    private String  _BASE = "BENEF";
    //private static Connection conn = null;
    
    //private String url = "jdbc:mysql://localhost/jukebox?user=root";
    
    /** Creates a new instance of DbBean */
    public DbBean() {
        conn = null;
        
    }
    
    public void finalize()
    throws Throwable {
        try {
            if (conn != null) conn.close();
        } catch (java.sql.SQLException se) {}
    }

    public void cerrar ()
    throws Throwable {
        try {
            if (conn != null) conn.close();
        } catch (java.sql.SQLException se) {}
    }
    
    public Connection getConnection() {
 
        try {
            if (conn == null) {
                //    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
                //    conn = DriverManager.getConnection(url);
                //}
                
                // Obtain our environment naming context.
       //         Context initCtx = new InitialContext();
                
                // Look up our data source.
      //          DataSource ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/postgres");
                
                // Allocate and use a connection from the pool.
        //        conn = ds.getConnection();
                
/*                Jdbc3PoolingDataSource source = new Jdbc3PoolingDataSource();
                source.setDataSourceName("A Data Source");
                source.setServerName("localhost");
                source.setDatabaseName("test");
                source.setUser("testuser");
                source.setPassword("testpassword");
                source.setMaxConnections(10);
                new InitialContext().rebind("DataSource", source);
*/
                return null;
            }            
    //    } catch (NamingException e) {
      //      e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
   public String  getSettingCall (String storeProcedure ) {
       String stDevuelto = "{ ? = call \"" + _BASE + "\".\"";
           String proc  = storeProcedure.substring(0,storeProcedure.indexOf("(")).trim();
           String param = storeProcedure.substring(storeProcedure.indexOf("(")); 
          
           stDevuelto = stDevuelto + proc + "\"" + param + " }";
           
           return stDevuelto;
   }

}
