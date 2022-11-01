/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

/**
 *
 * @author
 */
public class DatasetsFormBean implements getDevel {
    
    private String concepts;
    private String devel;
    private String test;
    private String stoplist;
    private String queries;
    
    public DatasetsFormBean(){
        concepts = "812";
        devel = "821";
        test = "821";
        stoplist = "1";
        queries = "821";
    }
    
    public String getConcepts(){
        return concepts;
    }
    
    public String getDevel(){
        return devel;
    }
    
    public String getTest(){
        return test;
    }
    
    public String getStoplist(){
        return stoplist;
    }
    
    public String getQueries(){
        return queries;
    }

}
