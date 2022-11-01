/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

/**
 *
 * @author
 */
public class PaginatorBean {
    
    private int count;  //pocet zaznamu na strance
    private int offset;
    private int querySize;
    
    public PaginatorBean(){
        count = 32;
        offset = 0;
        querySize = 0;
    }
    
    public int getCount(){
        return count;
    }
    
    public int getOffset(){
        return offset;
    }
    
    public int getQuerySize(){
        return querySize;
    }
    
    public int begin(){
        return 0;
    }
    
    public int prew(){
        return offset - count;
    }
    
    public int next(){
        return offset + count;
    }

    public int end(){
        return ( querySize / count ) * count;
    }
    
    public void setOffset(int value){
        if(value < querySize && value >= 0){
            offset = value;
        }
    }
    
    public void setCount(int value){
        count = value;
    }
    
    public void setQuerySize(int value){
        querySize = value;
    }

}
