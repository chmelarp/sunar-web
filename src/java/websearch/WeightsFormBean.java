/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

/**
 *
 * @author
 */
public class WeightsFormBean {
    private Double color;
    private Double hist;
    private Double grad;
    private Double gabor;
    private Double face;

    private Double sift;
    private Double surf;

    public WeightsFormBean(){
        color = 1.6;
        hist = 1.3;
        grad = 1.3;
        gabor = 1.0;
        face = 2.1;

        sift = 1.0;
        surf = 1.5;
    }


    public Double getColor() {
        return color;
    }
    public void setColor(Double weight){
        color = weight;
    }

    public Double getHist(){
        return hist;
    }
    public void setHist(Double weight){
        hist = weight;
    }

    public Double getGrad(){
        return grad;
    }
    public void setGrad(Double weight){
        grad = weight;
    }

    public Double getGabor(){
        return gabor;
    }
    public void setGabor(Double weight){
        gabor = weight;
    }

    public Double getFace(){
        return face;
    }
    public void setFace(Double weight){
        face = weight;
    }

    public Double getSift(){
        return sift;
    }
    public void setSift(Double weight){
        sift = weight;
    }

    public Double getSurf(){
        return surf;
    }
    public void setSurf(Double weight){
        surf = weight;
    }
}
