/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

import java.util.*;


/**
 *
 * @author 
 */
public class SearchFormBean {
    private String user;
    private String password;
    private String conn;
    private String status;
    private Hashtable errors;
    
    public boolean validate() {
        boolean allOk = true;
        
        if (user.equals("")) {
            errors.put("firstName","Please enter your first name");
            user="";
            allOk=false;
        }
        
        if (password.equals("")) {
            errors.put("firstName","Please enter your first name");
            password="";
            allOk=false;
        }
        
        if (conn.equals("")) {
            errors.put("firstName","Please enter your first name");
            user="";
            allOk=false;
        }

        
        return allOk;
    }

}
