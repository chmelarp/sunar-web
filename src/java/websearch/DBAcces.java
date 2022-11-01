/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package websearch;

import java.sql.*;
import java.text.*;
import java.util.Properties;


public class DBAcces implements java.io.Serializable{
    private Connection connection;
    private Statement statement;
    private String query;
    private ResultSet result;
    private String link;
    private String user;
    private String pass;
    
    public DBAcces(){
        connection = null;
        statement = null;
        query = null;
        result = null;
        //link = "jdbc:postgresql://pcsocrates1.fit.vutbr.cz:6116/trecvid";
        link = "jdbc:postgresql://localhost/trecvid";
        user = "trecvid";
        pass = "f2wipufi";
    }
    
    public boolean connect(){
        // find library
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException ex) {
            System.err.println("Error loading driver1: " + ex);
            return false;
        }
        
        // connect
        try {   // with SSL

            // set properties
            final Properties properties = new Properties();
            properties.put("user", user);
            properties.put("password", pass);
            // properties.put("ssl", "true");
            // don't be paranoid... see http://jdbc.postgresql.org/documentation/83/ssl-client.html#nonvalidating
            // properties.put("sslfactory", "org.postgresql.ssl.NonValidatingFactory");
            connection = DriverManager.getConnection(link, properties);  //"jdbc:postgresql://localhost:6116/trecvid"
            
            statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
            //statement = connection.createStatement();

        } catch (SQLException ex) {
            //Logger.getLogger(TrecvidSearch.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Error loading driver2: " + ex);

            try {   // without SSL
                connection = DriverManager.getConnection(link, user, pass);  //"jdbc:postgresql://localhost:6116/trecvid"
            } catch (SQLException e) {
                //Logger.getLogger(TrecvidSearch.class.getName()).log(Level.SEVERE, null, e);
                System.err.println("Error loading driver3: " + e);
                //jLabelConnStatus.setText("... failed.");
                return false;
            }
        }
        try{
            DatabaseMetaData dbMetaData = connection.getMetaData();
            String producName = dbMetaData.getDatabaseProductName();
            System.out.println("Product555 " + producName);
        }
        catch(SQLException e){
            System.err.println("Error getting database metadata: " + e);
        }
        
        return true;
    }

    public int numberOfVideos(String table, int dataset) {
        int videos = 0;
        
        try {
            result = statement.executeQuery("SELECT video FROM " + table + " WHERE dataset="+ dataset +" ORDER BY video DESC LIMIT 1");
            result.next();
            videos = result.getInt("video");
        }
        catch(SQLException e) {
            System.out.println( "Error : " + e.getMessage());
        }

        return videos;
    }

    public int numberOfShots(String table, int dataset, int video) {
        int shots = 0;

        try {
            result = statement.executeQuery("SELECT shot FROM " + table + " WHERE dataset="+ dataset +" AND video="+ video +" ORDER BY shot DESC LIMIT 1");
            result.next();
            shots = result.getInt("shot");
        }
        catch(SQLException e) {
            System.out.println( "Error : " + e.getMessage());
        }

        return shots;
    }

    public String Selection(){
        query = "SELECT dataset, video, shot" +
                " FROM hlf_search.tv_keyframes " +
                " WHERE dataset=821" +
                " ORDER BY RANDOM() LIMIT 100";
        return query;
    }

    public String Description(int dataset, int video, int shot, String language) {
        String description = "Test: ";

        try {
            result = statement.executeQuery("SELECT text FROM hlf_search.tv_speech WHERE dataset="+ dataset +" AND language='"+ language +"' AND video="+ video +" AND shot="+ shot +"");
            
            while (result.next()) {
                description += result.getString("text") + " <br /> ";
            }
        }
        catch(SQLException e) {
            System.out.println( "Error : " + e.getMessage());
        }

        return description;
    }

    public String searchQuery(int dataset, int video, int shot,
            int metricG, int metricL, WeightsFormBean weightsForm) {
        String basic = "";
        String att = "";
        String dist = "";
        String from = "";
        String where = "";

        if ((weightsForm.getSift() > 0) || (weightsForm.getSurf() > 0)) {
            basic = "lf.dataset AS dataset, lf.video AS video, lf.shot AS shot,";
        }
        if ((weightsForm.getColor() > 0) || (weightsForm.getHist() > 0) || (weightsForm.getGrad() > 0) || (weightsForm.getGabor() > 0) || (weightsForm.getFace() > 0)) {
            basic = "kf.dataset AS dataset, kf.video AS video, kf.shot AS shot,";
        }

        // nastaveni klauzule SELECT
        if (weightsForm.getColor() > 0)
            switch (metricG) {
                case 1:
                    att += weightsForm.getColor() + " * sqrt(distance_square_int4(qr.color, kf.color)) / 150 AS color_distance,\n";
                    dist += weightsForm.getColor() + " * sqrt(distance_square_int4(qr.color, kf.color)) / 150 + \n";
                    break;
                case 2:
                    att += weightsForm.getColor() + " * (distance_chessboard_int4(qr.color, kf.color)) / 70 AS color_distance,\n";
                    dist += weightsForm.getColor() + " * (distance_chessboard_int4(qr.color, kf.color)) / 70 + \n";
                    break;
                case 3:
                    att += weightsForm.getColor() + " * sqrt(distance_mahalanobis_int4(qr.color, kf.color, stdev.color_stdev)) / 80 AS color_distance,\n";
                    dist += weightsForm.getColor() + " * sqrt(distance_mahalanobis_int4(qr.color, kf.color, stdev.color_stdev)) / 80 + \n";
                    break;
            }
        if (weightsForm.getHist() > 0)
            switch (metricG) {
                case 1:
                    att += weightsForm.getHist() + " * sqrt(distance_square_int4(qr.hist, kf.hist)) / 2500000 AS hist_distance,\n";
                    dist += weightsForm.getHist() + " * sqrt(distance_square_int4(qr.hist, kf.hist)) / 2500000 + \n";
                    break;
                case 2:
                    att += weightsForm.getHist() + " * (distance_chessboard_int4(qr.hist, kf.hist)) / 1000000 AS hist_distance,\n";
                    dist += weightsForm.getHist() + " * (distance_chessboard_int4(qr.hist, kf.hist)) / 1000000 + \n";
                    break;
                case 3:
                    att += weightsForm.getHist() + " * sqrt(distance_mahalanobis_int4(qr.hist,  kf.hist, stdev.hist_stdev)) / 300 AS hist_distance ,\n";
                    dist += weightsForm.getHist() + " * sqrt(distance_mahalanobis_int4(qr.hist,  kf.hist, stdev.hist_stdev)) / 300 + \n";
                    break;
            }
        if (weightsForm.getGrad() > 0)
            switch (metricG) {
                case 1:
                    att += weightsForm.getGrad() + " * sqrt(distance_square_int4(qr.grad, kf.grad)) / 6000000 AS grad_distance,\n";
                    dist += weightsForm.getGrad() + " * sqrt(distance_square_int4(qr.grad, kf.grad)) / 6000000 + \n";
                    break;
                case 2:
                    att += weightsForm.getGrad() + " * (distance_chessboard_int4(qr.grad, kf.grad)) / 2200000 AS grad_distance,\n";
                    dist += weightsForm.getGrad() + " * (distance_chessboard_int4(qr.grad, kf.grad)) / 2200000 + \n";
                    break;
                case 3:
                    att += weightsForm.getGrad() + " * sqrt(distance_mahalanobis_int4(qr.grad,  kf.grad, stdev.grad_stdev)) / 25 AS grad_distance, \n";
                    dist += weightsForm.getGrad() + " * sqrt(distance_mahalanobis_int4(qr.grad,  kf.grad, stdev.grad_stdev)) / 25 + \n";
                    break;
            }
        if (weightsForm.getGabor() > 0)
            switch (metricG) {
                case 1:
                    att += weightsForm.getGabor() + " * sqrt(distance_square_int4(qr.gabor, kf.gabor)) / 55 AS gabor_distance,\n";
                    dist += weightsForm.getGabor() + " * sqrt(distance_square_int4(qr.gabor, kf.gabor)) / 55 + \n";
                    break;
                case 2:
                    att += weightsForm.getGabor() + " * (distance_chessboard_int4(qr.gabor, kf.gabor)) / 25 AS gabor_distance,\n";
                    dist += weightsForm.getGabor() + " * (distance_chessboard_int4(qr.gabor, kf.gabor)) / 25 + \n";
                    break;
                case 3:
                    att += weightsForm.getGabor() + " * sqrt(distance_mahalanobis_int4(qr.gabor, kf.gabor, stdev.gabor_stdev)) / 9 AS gabor_distance,\n";
                    dist += weightsForm.getGabor() + " * sqrt(distance_mahalanobis_int4(qr.gabor, kf.gabor, stdev.gabor_stdev)) / 9 + \n";
                    break;
            }
        if (weightsForm.getFace() > 0)
            switch (metricG) {
                case 1:
                    att += weightsForm.getFace() + " * sqrt(distance_square_int4(qr.face, kf.face)) AS face_distance,\n";
                    dist += weightsForm.getFace() + " * sqrt(distance_square_int4(qr.face, kf.face)) + \n";
                    break;
                case 2:
                    att += weightsForm.getFace() + " * (distance_chessboard_int4(qr.face, kf.face)) AS face_distance,\n";
                    dist += weightsForm.getFace() + " * (distance_chessboard_int4(qr.face, kf.face)) + \n";
                    break;
                case 3:
                    att += weightsForm.getFace() + " * sqrt(distance_mahalanobis_int4(qr.face,  kf.face, stdev.face_stdev)) AS face_distance, \n";
                    dist += weightsForm.getFace() + " * sqrt(distance_mahalanobis_int4(qr.face,  kf.face, stdev.face_stdev)) + \n";
                    break;
            }
        if (weightsForm.getSift() > 0)
            switch (metricL) {
                case 1:
                    att += weightsForm.getSift() + " * (1 - rating_cosine(qrl.siftsers, qrl.siftser_weights, lf.siftsers, lf.siftser_weights)) / 0.95 AS siftser_rating,\n ";
                    dist += weightsForm.getSift() + " * (1 - rating_cosine(qrl.siftsers, qrl.siftser_weights, lf.siftsers, lf.siftser_weights)) / 0.95 + \n ";
                    break;
                case 2:
                    att += weightsForm.getSift() + " * (300 - rating_boolean_int4(qrl.siftsers, lf.siftsers)) / 300 AS siftser_rating,\n ";
                    dist += weightsForm.getSift() + " * (300 - rating_boolean_int4(qrl.siftsers, lf.siftsers)) / 300 + \n ";
                    break;
            }
        if (weightsForm.getSurf() > 0)
            switch (metricL) {
                case 1:
                    att += weightsForm.getSurf() + " * (1 - rating_cosine(qrl.surfs, qrl.surf_weights, lf.surfs, lf.surf_weights)) / 0.97 AS surf_rating,\n ";
                    dist += weightsForm.getSurf() + " * (1 - rating_cosine(qrl.surfs, qrl.surf_weights, lf.surfs, lf.surf_weights)) / 0.97 + \n ";
                    break;
                case 2:
                    att += weightsForm.getSurf() + " * (300 - rating_boolean_int4(qrl.surfs, lf.surfs)) / 300 AS surf_rating,\n ";
                    dist += weightsForm.getSurf() + " * (300 - rating_boolean_int4(qrl.surfs, lf.surfs)) / 300  + \n ";
                    break;
            }
        dist += "0 \n";

        // nastaveni klauzule FROM a WHERE
        if ((weightsForm.getColor() > 0) || (weightsForm.getHist() > 0) || (weightsForm.getGrad() > 0) || (weightsForm.getGabor() > 0) || (weightsForm.getFace() > 0)) {
            from = "hlf_search.tv_keyframes AS kf, " +
                "     ( SELECT * FROM hlf_search.tv_keyframes_aggr WHERE id=1) AS stdev, \n" +
                "     (   SELECT * FROM hlf_search.tv_keyframes \n" +
                "         WHERE dataset=821 AND  video=" + video + " AND shot=" + shot + " AND id=1" +
                "     ) AS qr \n";
            where = "kf.dataset=821";
        }
        if ( ((weightsForm.getColor() > 0) || (weightsForm.getHist() > 0) || (weightsForm.getGrad() > 0) || (weightsForm.getGabor() > 0) || (weightsForm.getFace() > 0)) && ((weightsForm.getSift() > 0) || (weightsForm.getSurf() > 0))) {
            from += ", ";
            where += " AND kf.dataset=lf.dataset AND kf.video=lf.video AND kf.shot=lf.shot AND ";
        }
	
        if ((weightsForm.getSift() > 0) || (weightsForm.getSurf() > 0)) {
            from += "hlf_search.tv_localfeatures AS lf ," +
                "     (   SELECT * FROM hlf_search.tv_localfeatures \n" +
                "         WHERE dataset=821 AND  video=" + video + " AND shot=" + shot + " AND keyframe=1 \n" +
                "     ) AS qrl ";
            where += "lf.dataset=821 AND qrl.siftsers IS NOT NULL AND qrl.siftser_weights IS NOT NULL AND lf.siftsers IS NOT NULL AND lf.siftser_weights IS NOT NULL AND qrl.surfs IS NOT NULL AND qrl.surf_weights IS NOT NULL AND lf.surfs IS NOT NULL AND lf.surf_weights IS NOT NULL";
        }


        query = "SELECT " + basic + "\n" +
                "" + att + "\n" +
                " ( " + dist + ") AS dist \n" +
                " FROM " + from + "\n" +
                " WHERE " + where + "\n" +
                " ORDER BY dist ASC \n" +
                " LIMIT 100";

        return query;
    }
    
    public String textQuerySearch(String textQuery, String dataset){
        String lang = "en";
        query = "SELECT dataset, video, shot, text, ts_rank(textsearch_" + lang + ", query,16) * 1644.93 AS rank " +
                " FROM hlf_search.tv_speech, to_tsquery('english', '" + textQuery + "') query " +
                " WHERE dataset="+ dataset +" AND query @@ textsearch_" + lang +
                " ORDER BY rank DESC LIMIT 1000";
        return query;
    }

    public String TimeToShot(String vName, String vStart, String vStop){
        long midFrame = ((new MediaTime(vStart).getFrames()) + ((new MediaTime(vStop).getFrames()))) / 2;
        System.out.print("Querying " + vName + "@" + midFrame + "... ");

        // dotaz na shot - najdi keyframe nejblize stredu te dotazovane oblasti
        query = "SELECT k.video, k.shot, k.id, ABS(" + midFrame + "-k.frame) as dist " +
                " FROM hlf_search.tv_keyframes as k JOIN hlf_search.tv_videa as v ON (k.video = v.id)" +
                " WHERE v.name like '" + vName + "' AND  k.dataset=821 AND v.dataset=821" +
                " ORDER BY (dist) LIMIT 1";

        return query;
    }
    
    public void setQuery(String Q){
        query = Q;
    }
    
    public ResultSet selectFromDB() throws SQLException {
        ResultSet temp = null;
       
        if(query != null) {
            try {
                temp = statement.executeQuery(query);
            }
            catch(SQLException e) {
                System.out.println( "Error : " + e.getMessage());
            }
        }
        return temp;
    }
    
    public boolean isConnection(){
        if(connection == null) return false;
        else return true;
    }
    
    public ResultSet getResult(){
        return result;
    }
    
    public String printResult(DatasetFormBean datasetForm){
        String out = "ppdpdpdp";
        try{
            while(result.next()){
               out.concat("<tr>");
               for(int i = 0; i < 4; i++){
                   out.concat("<td>");
                   //out.concat(++o + " video: " + result.getInt("video") + "<br />shot: " + result.getInt("video"));
                   out.concat("<br /><img src=\"" + datasetForm.getDatasetDevel() + "/TRECVID2007_" + result.getInt("video") + "/shot" + result.getInt("video") + "_" + result.getInt("shot") + "_RKF.jpg" + "\" alt='obr'/>");   
                   out.concat("</td>");
               }
               out.concat("</tr>");
               return out;
            }
        }
        catch(SQLException e) {
            System.out.println( "Error writting the result set: " + e.getMessage());
        }
        return out;
    }
    
    public void setResult(ResultSet value){
        result = value;
    }
    
    public void disconnect(){
        try{
            if(connection != null)
                connection.close();
            if(result != null)
                result.close();
        }
        catch(SQLException e) {
            System.out.println( "Error closing the db connection: " + e.getMessage());
        }
        connection = null;
        result = null;
    }

    public String formatResult(double res){
        DecimalFormat dec = new DecimalFormat("#.####");
        return dec.format(res);
    }
}
