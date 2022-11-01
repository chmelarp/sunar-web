/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

/**
 *
 * @author 
 */
public class DatasetFormBean {
    private String DatasetDevel;
    private String DatasetTest;
    
    public DatasetFormBean() {
        DatasetDevel = "/data/keyframes.devel";
        DatasetTest = "/data/keyframes.imag.fr";
    }
    
    public String getDatasetDevel() {
        return DatasetDevel;
    }
    
    public String getDatasetTest() {
        return DatasetTest;
    }

}
