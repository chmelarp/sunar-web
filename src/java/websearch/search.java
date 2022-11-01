/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

import java.util.Properties;
import java.sql.*;

/**
 *
 * @author
 */
public class search {

    private Connection conn;
    private String host;
    private String dbName;
    private int port;
    
    public search(){
        conn = null;
        host = "minerva2";
        dbName = null;
        port = 5432;
    }
    
    public boolean connect(){
        
        // find library
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException ex) {
            System.err.println("Error loading driver: " + ex);
            return false;
        }
        
        // connect
        try {   // with SSL

            // set properties
            final Properties properties = new Properties();
            properties.put("user", "trecvid");
           properties.put("password", "f2wipufi");
            properties.put("ssl", "true");
            // don't be paranoid... see http://jdbc.postgresql.org/documentation/83/ssl-client.html#nonvalidating
            properties.put("sslfactory", "org.postgresql.ssl.NonValidatingFactory");
//
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:6116/trecvid", properties);

        } catch (SQLException ex) {
            //Logger.getLogger(TrecvidSearch.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Error loading driver: " + ex);

            try {   // without SSL
                conn = DriverManager.getConnection("jdbc:postgresql://localhost:6116/trecvid", "trecvid", "f2wipufi");
            } catch (SQLException e) {
                //Logger.getLogger(TrecvidSearch.class.getName()).log(Level.SEVERE, null, e);
                System.err.println("Error loading driver: " + e);
                //jLabelConnStatus.setText("... failed.");
                return false;
            }

        }
        try{
            DatabaseMetaData dbMetaData = conn.getMetaData();
            String producName = dbMetaData.getDatabaseProductName();
            System.out.println("Product - search " + producName);
        }
        catch(SQLException e){
            System.err.println("Error getting database metadata: " + e);
        }
        
        
        
        
        return true;
        
    }
    
    public void closeConnection(){
        //if(conn.isValid(port)){
        try{
           conn.close();
        }
        catch(SQLException ex){
            System.err.println("Error closing connection: " + ex);
        }
        //}
    }
    
}
