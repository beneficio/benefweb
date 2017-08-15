package com.business.menu;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import org.w3c.dom.*;
import com.business.db.*;
import com.business.util.SurException;


public class JDBCMenuBuilder implements MenuBuilder
{
    private int coord=0;
    private String driver;
    private String url;
    private String username;
    private String password;
    private int aplicacion = 1;
    private String userLogon;
    private ArrayList topMenus = new ArrayList();

    public JDBCMenuBuilder(String driver, String url, String username, String password, int aplicacion, String userLogon)
    {
           this.driver = driver;
           this.url = url;
           this.username = username;
           this.password = password;
           this.userLogon = userLogon;
           this.aplicacion = aplicacion;
    }

    public JDBCMenuBuilder(String driver, String url, String username, String password)
    {
           this.driver = driver;
           this.url = url;
           this.username = username;
           this.password = password;
    }

    public String renderMenu() throws MenuException
    {
        Connection dbCon = null;
        String str       = null;
         try {
            dbCon = db.getConnection();
          
            str = buildTopMenu (dbCon);

         } catch (MenuException ex) {
            throw new MenuException("Unable to get root menu from the database", ex);
         } finally {
             try {
                db.cerrar(dbCon);
             } catch (SurException se) {
                 throw new MenuException("Unable to get root menu from the database", se);
             }
            return str;            
         }
    }

    private String buildTopMenu (Connection dbCon) 
      throws MenuException {
     
        ResultSet rs          = null;
        CallableStatement  cs = null;
        StringBuffer sb       = null;
        try{
            dbCon.setAutoCommit(false);             
            cs     = dbCon.prepareCall(db.getSettingCall("MU_GET_MENU_PRINCIPAL(?,?)"));             
            cs.registerOutParameter(1, java.sql.Types.OTHER);
            cs.setInt    (2, this.aplicacion); 
            cs.setString (3, this.userLogon);

            cs.execute();

            rs = (ResultSet) cs.getObject (1); 
            while(rs.next()){
                 CompositeMenu aTopMenu = new CompositeMenu(rs.getString("MENUID"), rs.getString("MENUNAME"), rs.getString("URL"));
                 topMenus.add(aTopMenu);
            }
            rs.close();
            cs.close();
            
        sb = new StringBuffer();
        int j=1;
        for (int i=0;i<topMenus.size();i++)
        {
         CompositeMenu menu = (CompositeMenu)topMenus.get(i);
         menu.setLevelCoord(Integer.toString(j));
         j++;
         buildMenu(dbCon, menu.getMenuId(), menu);
         sb.append(menu.render());
            
        }
        }catch(Exception ex) {
            throw new MenuException("Unable to get root menu from the database", ex);
        } finally {
            try {
                if (rs != null ) rs.close();                
                if (cs != null ) cs.close();
            } catch (SQLException se) {
                throw new MenuException("Unable to get root menu from the database", se);
            }
            return sb.toString();
        }
    }

    private boolean isLeaf(Connection dbCon, String menuId)throws MenuException, SurException
    {
/*<<<<<<< JDBCMenuBuilder.java
        CallableStatement cs = null;
=======
 **/
        CallableStatement  cs = null;
        boolean isLeaf = false;
        try{
            dbCon.setAutoCommit(false);                         
            cs     = dbCon.prepareCall(db.getSettingCall("MU_GET_MENU_COUNT (?,?,?)"));
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            cs.setInt    (2, this.aplicacion); 
            cs.setString (3, this.userLogon);
            cs.setString (4,  menuId.trim());
           
            cs.execute();
            
            int i = cs.getInt(1);
            
            if (i < 1)
               isLeaf = true;
            cs.close();
 
        }catch(Exception ex){  
            throw new MenuException("Unable to get data from the database", ex);
        } finally {
            try {
                if (cs != null) cs.close();
            } catch (SQLException se) {
                 throw new MenuException("Unable to get data from the database", se);
            }
            return isLeaf;
        }  

    }

    private void buildMenu(Connection dbCon, String menuId, CompositeMenu comSrc) throws MenuException, SurException
    {
        ResultSet rs   = null;
        CallableStatement  cs = null;
        
        try{
            dbCon.setAutoCommit(false);                                     
            cs = dbCon.prepareCall(db.getSettingCall("MU_GET_MENU (?,?,?)"));
            cs.registerOutParameter(1, java.sql.Types.OTHER);
            cs.setInt    (2, this.aplicacion); 
            cs.setString (3, this.userLogon);
            cs.setString (4,  menuId.trim());
           
            cs.execute();

            rs = (ResultSet) cs.getObject (1);                 
            while(rs.next()){
                 String childMenuId = rs.getString("MENUID");
                 String menuName = rs.getString("MENUNAME");
                 String href = rs.getString("URL");
                 String parentId = rs.getString("PARENTMENUID");

                 if (isLeaf(dbCon, childMenuId)) //simple menu
                 {
                        SimpleMenu sm = new SimpleMenu(childMenuId , menuName, href);
                        comSrc.add(sm);
                 }
                 else
                 {
                    CompositeMenu aParentMenu = new CompositeMenu(childMenuId, menuName);
                    comSrc.add(aParentMenu);
                    buildMenu(dbCon, childMenuId, aParentMenu);
                 }
            }
            rs.close();
            cs.close();

        }catch(Exception ex){
                throw new MenuException("Unable to get data from the database", ex);
        } finally {
            try {
            if (rs != null) rs.close ();
            if (cs != null) cs.close ();            
            } catch (SQLException se) {
                throw new MenuException("Unable to get data from the database", se);                
            }
        }  
    }

    public static void main(String argv[]) throws Exception
    {
        JDBCMenuBuilder builder = new JDBCMenuBuilder("oracle.jdbc.driver.OracleDriver", "jdbc:oracle:thin:@fxs04ntdev:1521:fccd", "fxapp2", "fxapp2");
        builder.renderMenu();
    }
}
