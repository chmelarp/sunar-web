<%@ page import="websearch.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="./sources/header.jsp" %>
<jsp:useBean id="paginator" class="websearch.PaginatorBean" scope="session" />

<%
if(!dbacces1.isConnection()) dbacces1.connect();
if(!dbacces1.isConnection()){
    out.print("<br /><div class=\"box\">Error. Connection problem: Database server not found.</div>");
}
else {
    String query = "";
    int video = 0;
    int shot = 0;
    ResultSet rs = null;
        //vynulovat ofset paginatoru
    paginator.setOffset(0);

    if(request.getParameter("search") != null) {
        video = Integer.parseInt(request.getParameter("video"));
        shot = Integer.parseInt(request.getParameter("shot"));

        weightsForm.setColor(Double.parseDouble(request.getParameter("col_w")));
        weightsForm.setHist(Double.parseDouble(request.getParameter("hist_w")));
        weightsForm.setGrad(Double.parseDouble(request.getParameter("grad_w")));
        weightsForm.setGabor(Double.parseDouble(request.getParameter("gabor_w")));
        weightsForm.setFace(Double.parseDouble(request.getParameter("face_w")));
        weightsForm.setSift(Double.parseDouble(request.getParameter("sift_w")));
        weightsForm.setSurf(Double.parseDouble(request.getParameter("surf_w")));
        
        query = dbacces1.searchQuery(821, video, shot,
                Integer.parseInt(request.getParameter("metricG")), Integer.parseInt(request.getParameter("metricL")), weightsForm);

            // pomocny vypis SELECTu
        //out.print("<br /><div id=\"resultsHead\" style=\"text-align: left;\">" + query + "</div>");
            //dbacces1.setQuery(query);
            if (dbacces1.selectFromDB() != null) {
                rs = dbacces1.selectFromDB();
                try {
                    int count = 0;
                    while(rs.next()) count++;
                    rs.first();
                    paginator.setQuerySize(count);
                }
                catch (SQLException e) {
                    out.println( "Error getting the FetchSize: " + e.getMessage());
                }
            }
            else
                rs = null;
    }
    else if(request.getParameter("textSearch") != null){
        paginator.setOffset(0);
        if((request.getParameter("query") != null) && (request.getParameter("query").compareTo("") != 0)) {
            query = dbacces1.textQuerySearch(request.getParameter("query"), datasetsForm.getTest());
            //out.print("<br /><div class=\"box\">"+query+"</div>");   // vypis dotazu
            rs = dbacces1.selectFromDB();
            try {
                int count = 0;
                while(rs.next()) count++;
                rs.first();
                paginator.setQuerySize(count);
            }
            catch (SQLException e) {
                out.println( "Error getting the FetchSize: " + e.getMessage());
            }
        }
    }
    else if(request.getParameter("transform") != null) {
        query = dbacces1.TimeToShot(request.getParameter("src"), request.getParameter("start"), request.getParameter("stop"));
        //out.print(query);
        rs = dbacces1.selectFromDB();
        try {
            int count = 0;
            while(rs.next()) count++;
            rs.first();
            paginator.setQuerySize(count);
        }
        catch (SQLException e) {
            out.println( "Error getting the FetchSize: " + e.getMessage());
        }

        video = rs.getInt("video");
        shot = rs.getInt("shot");
    }
    else {
        // nacteni nahodnych 100 shotu
        query = dbacces1.Selection();
        //dbacces1.setQuery(query);
        rs = dbacces1.selectFromDB();
        try {
            int count = 0;
            while(rs.next()) count++;
            rs.first();
            paginator.setQuerySize(count);
        }
        catch (SQLException e) {
            out.println( "Error getting the FetchSize: " + e.getMessage());
        }
    }
    if(request.getParameter("query_set") != null) {
        video = Integer.parseInt(request.getParameter("video"));
        shot = Integer.parseInt(request.getParameter("shot"));
    }

    if(request.getParameter("offset") != null) {
        paginator.setOffset(Integer.parseInt(request.getParameter("offset")));
    }
%>

    <!-- start paginator -->
    <div class="upperPaginator">
        <%
            if ((request.getParameter("search") != null) || (request.getParameter("textSearch") != null) || (request.getParameter("transform") != null))
                out.print("<span style=\"float: left;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=\"index.jsp\">Clear Query</a></span>");

            String href = "";
            if (request.getParameter("search") != null) {
                href += "video="+ request.getParameter("video").toString() +"&shot=" + request.getParameter("shot").toString();
                href += "&metricG=" + request.getParameter("metricG").toString();
                href += "&metricL=" + request.getParameter("metricL").toString();
                href += "&col_w=" + request.getParameter("col_w").toString() + "&hist_w=" + request.getParameter("hist_w").toString();
                href += "&grad_w=" + request.getParameter("grad_w").toString() + "&gabor_w=" + request.getParameter("gabor_w").toString();
                href += "&face_w=" + request.getParameter("face_w").toString();
                href += "&sift_w=" + request.getParameter("sift_w").toString() + "&surf_w=" + request.getParameter("surf_w").toString();
                href += "&search=Search";
            }
            else if (request.getParameter("textSearch") != null)
                href += "query=" + request.getParameter("query") + "&textSearch=Search";

            if(paginator.getOffset() > 0) {
                out.println( "<a href=\"?" + href + "&offset=" + paginator.begin() +"\"><<</a>&nbsp;&nbsp;<a href=\"?" + href + "&offset=" + paginator.prew() +"\"><&nbsp;prev</a>" );
            }
            else
                out.println( "<span class=\"dead\"><<&nbsp;&nbsp;<&nbsp;prev</span>" );
        %>
        &nbsp;&nbsp; <strong><%= paginator.getOffset() %></strong> ... <strong><% if((paginator.getOffset() + paginator.getCount()) < paginator.getQuerySize()) out.println(paginator.getOffset() + paginator.getCount()); else out.println(paginator.getQuerySize());  %></strong>&nbsp; from <strong><%= paginator.getQuerySize() %></strong> &nbsp;&nbsp;
        <%
            if(paginator.getOffset() < (paginator.getQuerySize() - paginator.getCount()))
                out.println( "<a href=\"?" + href + "&offset=" + paginator.next() +"\">next&nbsp;></a>&nbsp;&nbsp;<a href=\"?" + href + "&offset=" + paginator.end() +"\">>></a>" );
            else
                out.println( "<span class=\"dead\">next&nbsp;>&nbsp;&nbsp;>></span>" );
        %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
    <!-- end paginator -->

    <!-- start page -->
        <div id="main">
            <div id="flexiLeftPanel" class="sidebar">
                <div class="box_title">Image Query</div>
                <div class="t_box">
                <%
                String img_query = "image.jpg";
                if (request.getParameter("video") != null) {
                    if(Integer.parseInt(request.getParameter("video")) > 110)
                        img_query = /*"http://pcsocrates1.fit.vutbr.cz:8080/" +*/ datasetForm.getDatasetDevel() + "/TRECVID2007_" + request.getParameter("video").toString() + "/shot" + request.getParameter("video").toString() + "_" + request.getParameter("shot").toString() + ".jpg";
                    else
                        img_query = /*"http://pcsocrates1.fit.vutbr.cz:8080/" +*/ datasetForm.getDatasetDevel() + "/TRECVID2007_" + request.getParameter("video").toString() + "/shot" + request.getParameter("video").toString() + "_" + request.getParameter("shot").toString() + "_RKF.jpg";
                }

                out.print("<img src=\""+ img_query +"\" id=\"queryBox\" width=\"200\" height=\"164\" />");
                %>
                    <form action="index.jsp" method="post">
                        <table class="formTable" border="0">
                            <tr>
                                <td>
                                    Video:
                                    <select style="width: 5em;" id="video" name="video" onchange="showimage(); fillshots();" onkeydown="showimage();fillshots();" onkeyup="showimage();fillshots();" >
                                        <%
                                        int num = dbacces1.numberOfVideos("hlf_search.tv_keyframes", 821);
                                        int vid = 1;

                                        for(int i = 1; i <= num; i++) {
                                            if ((request.getParameter("video") != null) && (video == i)) {
                                                out.println("<option value=\""+ i +"\" selected>"+ i +"</option>");
                                                vid = i;
                                            }
                                            else
                                                out.println("<option value=\""+ i +"\">"+ i +"</option>");
                                        }
                                        %>
                                    </select>
                                </td>
                                <td>
                                    Shot:
                                    <select style="width: 5em;" id="shot" name="shot" onchange="showimage();" onkeydown="showimage();" onkeyup="showimage();">
                                        <%
                                        num = dbacces1.numberOfShots("hlf_search.tv_keyframes", 821, vid);
                                        
                                        for(int i = 1; i <= num; i++) {
                                            if ((request.getParameter("shot") != null) && (shot == i))
                                                out.println("<option value=\""+ i +"\" selected>"+ i +"</option>");
                                            else
                                                out.println("<option value=\""+ i +"\">"+ i +"</option>");
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                               <td colspan="2" class="searchCell">
                                   <input type="submit" name="search" value="Search" style="font: 11px Verdana, sans-serif;"/>
                               </td>
                            </tr>
                        </table>
                        <table id="expert">
                            <tr>
                                <td colspan="2" class="box_title">Distance and Weights</td>
                            </tr>
                            <tr>
                                <td colspan="2"><strong>Global features</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="searchCell">
                                    <select style="width: 15em;" name="metricG" >
                                        <option value="1">Euclidean distance</option>
                                        <option value="2">Chebyshev distance</option>
                                        <option value="3">Mahalanobis distance</option>
                                    </select>
                                </td>
                           </tr>
                            <tr>
                                <td>
                                    Color: <input type="text" size="5" name="col_w" id="col_w" value="<% out.print(weightsForm.getColor()); %>" class="textInput"/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;Hist: <input type="text" size="8" name="hist_w" id="hist_w" value="<% out.print(weightsForm.getHist()); %>" class="textInput"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Grad: <input type="text" size="8" grad="grad_w" name="grad_w" id="grad_w" value="<% out.print(weightsForm.getGrad()); %>" class="textInput"/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;Gabor: <input type="text" size="5" name="gabor_w" id="gabor_w" value="<% out.print(weightsForm.getGabor()); %>" class="textInput"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Face: <input type="text" size="5" name="face_w" id="face_w" value="<% out.print(weightsForm.getFace()); %>" class="textInput"/>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="2"><strong>Local features</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="searchCell">
                                    <select style="width: 12em;" name="metricL" >
                                        <option value="1">Cosine + TF-IDF</option>
                                        <option value="2">Binary</option>
                                    </select>
                                </td>
                           </tr>
                            <tr>
                                <td>
                                    MSER/SIFT: <input type="text" size="5" name="sift_w" id="sift_w" value="<% out.print(weightsForm.getSift()); %>" class="textInput"/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;SURF: <input type="text" size="5" name="surf_w" id="surf_w" value="<% out.print(weightsForm.getSurf()); %>" class="textInput"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <strong><a onclick="defaultweights();">DEFAULT Weights</a></strong>
                                </td>
                            </tr>
                            <!-- <tr>
                                <td style="border:1px inset;">
                                    <strong><a onclick="colorweight();">COLOR</a></strong>
                                </td>
                                <td style="border:1px inset;">
                                    <strong><a onclick="histweight();">HIST</a></strong>
                                </td>
                            </tr>
                            <tr>
                                <td style="border:1px inset;">
                                    <strong><a onclick="gradweight();">GRAD</a></strong>
                                </td>
                                <td style="border:1px inset;">
                                    <strong><a onclick="gaborweight();">GABOR</a></strong>
                                </td>
                            </tr>
                            <tr>
                                <td style="border:1px inset;">
                                    <strong><a onclick="faceweight();">FACE</a></strong>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="border:1px inset;">
                                    <strong><a onclick="siftweight();">SIFT</a></strong>
                                </td>
                                <td style="border:1px inset;">
                                    <strong><a onclick="surfweight();">SURF</a></strong>
                                </td>
                            </tr> -->
                        </table>
                    </form>
                </div>

                <div class="box_title">Text Query</div>
                <div class="t_box">
                    <form action="index.jsp" method="post">
                        <table border="0" style="margin: auto; vertical-align: middle;">
                            <tr>
                                <td class="searchCell">
                                    <%
                                    String txtQuery;
                                    if (request.getParameter("query") != null)
                                        txtQuery = request.getParameter("query");
                                    else
                                        txtQuery = "";
                                    %>
                                    Querry: <input type="text" size="20" class="textInput" value="<% out.print(txtQuery); %>" name="query"/>
                                </td>
                                <td class="searchCell">
                                    <select style="width: 4em;" name="language" >
                                        <option value="en">en</option>
                                        <!-- <option value="nl">nl</option> -->
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="searchCell">
                                    <input type="submit" name="textSearch" value="Search" style="font: 10px Verdana, sans-serif;"/>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>

                <div id="expert" class="box_title">Video Query</div>
                <div id="expert" class="t_box">
                    <form action="index.jsp" method="post">
                        <table border="0" style="margin: auto; vertical-align: middle;">
                            <tr>
                                <td>Video (src): </td>
                                <td class="searchCell">
                                    <input type="text" size="20" class="textInput" name="src"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Start time: </td>
                                <td class="searchCell">
                                    <input type="text" size="20" class="textInput" name="start"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Stop time: </td>
                                <td class="searchCell">
                                    <input type="text" size="20" class="textInput" name="stop"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="searchCell">
                                    <input type="submit" name="transform" value="Transform" style="font: 10px Verdana, sans-serif;"/>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>

            <div id="flexiContent">
             
<%
    if (rs == null) {
        out.print("<div class=\"box\">"+ query +"</div>");
        out.print("<div class=\"box\">All weights must be NUMERIC values and at least one weight must be nonzero value.</div>");
    }
    else if( (rs = dbacces1.selectFromDB()) == null ) {
        out.print("<div class=\"box\">Specify shot or text querry and click Search.</div>");
    }
    else {    // if (false)
        //out.print("<div class=\"box\"><a href=\"index.jsp?clear=true\">clear query</a></div>");
        //out.print("<div class=\"box\"><a href=\"index.jsp\">Clear query</a></div>");
%>
                
                <table border="0" id="resultsTable">
<%
    for(int i = 0; i < paginator.getOffset(); i++) rs.next();
    String img;
    String onclick = "";
    int count = 0;
    
    while(count < paginator.getCount()){
        out.println("<tr>");
        for(int i = 0; i < 4; i++){
            if(rs.next()){
                if(rs.getInt("video") > 110)
                    img = /*"http://pcsocrates1.fit.vutbr.cz:8080/" +*/ datasetForm.getDatasetDevel() + "/TRECVID2007_" + rs.getInt("video") + "/shot" + rs.getInt("video") + "_" + rs.getInt("shot") + ".jpg";
                else
                    img = /*"http://pcsocrates1.fit.vutbr.cz:8080/" +*/ datasetForm.getDatasetDevel() + "/TRECVID2007_" + rs.getInt("video") + "/shot" + rs.getInt("video") + "_" + rs.getInt("shot") + "_RKF.jpg";

                out.println("<td>");

                if(request.getParameter("search") != null) {
                    onclick = "document.getElementById('distance').value = '" + dbacces1.formatResult(rs.getDouble("dist")) + "';";

                    if (weightsForm.getColor() > 0)
                        onclick += "document.getElementById('col_distance').value = '" + dbacces1.formatResult(rs.getDouble("color_distance")) + "'; ";
                    if (weightsForm.getHist() > 0)
                        onclick += "document.getElementById('hist_distance').value = '" + dbacces1.formatResult(rs.getDouble("hist_distance")) + "'; ";
                    if (weightsForm.getGrad() > 0)
                        onclick += "document.getElementById('grad_distance').value = '" + dbacces1.formatResult(rs.getDouble("grad_distance")) + "'; ";
                    if (weightsForm.getGabor() > 0)
                        onclick += "document.getElementById('gabor_distance').value = '" + dbacces1.formatResult(rs.getDouble("gabor_distance")) + "'; ";
                    if (weightsForm.getFace() > 0)
                        onclick += "document.getElementById('face_distance').value = '" + dbacces1.formatResult(rs.getDouble("face_distance")) + "'; ";
                    if (weightsForm.getSift() > 0)
                        onclick += "document.getElementById('sift_distance').value = '" + dbacces1.formatResult(rs.getDouble("siftser_rating")) + "'; ";
                    if (weightsForm.getSurf() > 0)
                        onclick += "document.getElementById('surf_distance').value = '" + dbacces1.formatResult(rs.getDouble("surf_rating")) + "'; ";
                }

                out.println("<small>Shot "+ rs.getInt("video") +"/"+ rs.getInt("shot") +"</small><br />");   // id=\"expert\"
                out.println("<img src=\"" + img + "\" alt='obr' width='100' height='82' border='0'" +
                        "onClick=\"document.getElementById('imageBox').src = '" + img + "';" +
                        "document.getElementById('res_video').value = '" + rs.getInt("video") + "';" +
                        "document.getElementById('res_shot').value = '" + rs.getInt("shot") + "'; " +
                        //"document.getElementById('description').value = '" + dbacces1.Description(821, rs.getInt("video"), rs.getInt("shot"), "en") + "'; " +
                        onclick +
                        "\"/>");
                if (request.getParameter("search") != null) {
                    out.println("<br /><small><a href=\"index.jsp?video=" + rs.getInt("video") + "&shot=" + rs.getInt("shot") + "&metricG=" + request.getParameter("metricG").toString() + "&col_w=" + request.getParameter("col_w").toString() + "&hist_w=" + request.getParameter("hist_w").toString() + "&grad_w=" + request.getParameter("grad_w").toString() + "&gabor_w=" + request.getParameter("gabor_w").toString() + "&face_w=" + request.getParameter("face_w").toString() + "&metricL=" + request.getParameter("metricL").toString() + "&sift_w=" + request.getParameter("sift_w").toString() + "&surf_w=" + request.getParameter("surf_w").toString() + "&search=Search\">Find similar</a></small>");
                }
                else {
                    out.println("<br /><small><a href=\"index.jsp?video=" + rs.getInt("video") + "&shot=" + rs.getInt("shot") + "&metricG=1&col_w=" + weightsForm.getColor() + "&hist_w=" + weightsForm.getHist() + "&grad_w="+ weightsForm.getGrad() +"&gabor_w="+ weightsForm.getGabor() +"&face_w="+ weightsForm.getFace() +"&metricL=1&sift_w="+ weightsForm.getSift() +"&surf_w="+ weightsForm.getSurf() +"&search=Search\">Find similar</a></small>");
                }
                out.println("</td>");
            }
            count++;
        }
        out.println("</tr>");
        dbacces1.setResult(null);
    }
    rs.close();
%>
                </table>

                <br />
                <!-- Paginator zacatek-->
                <div>
                    <%
                    href = "";
                    if (request.getParameter("search") != null) {
                        href += "video="+ request.getParameter("video").toString() +"&shot=" + request.getParameter("shot").toString();
                        href += "&metricG=" + request.getParameter("metricG").toString();
                        href += "&metricL=" + request.getParameter("metricL").toString();
                        href += "&col_w=" + request.getParameter("col_w").toString() + "&hist_w=" + request.getParameter("hist_w").toString();
                        href += "&grad_w=" + request.getParameter("grad_w").toString() + "&gabor_w=" + request.getParameter("gabor_w").toString();
                        href += "&face_w=" + request.getParameter("face_w").toString();
                        href += "&sift_w=" + request.getParameter("sift_w").toString() + "&surf_w=" + request.getParameter("surf_w").toString();
                        href += "&search=Search";
                    }
                    if (request.getParameter("textSearch") != null)
                        href += "query=search&textSearch=Search";

                    if(paginator.getOffset() > 0) 
                        out.println( "<a href=\"?" + href + "&offset=" + paginator.begin() +"\"><<</a>&nbsp;&nbsp;<a href=\"?" + href + "&offset=" + paginator.prew() +"\"><&nbsp;prev</a>" );
                    else
                        out.println( "<span class=\"dead\"><<&nbsp;&nbsp;<&nbsp;prev</span>" );
                    %>
                    &nbsp; <strong><%= paginator.getOffset() %></strong> ...
                    <strong><% if((paginator.getOffset() + paginator.getCount()) < paginator.getQuerySize()) out.println(paginator.getOffset() + paginator.getCount()); else out.println(paginator.getQuerySize());  %></strong> &nbsp;
                    <%
                    if(paginator.getOffset() < (paginator.getQuerySize() - paginator.getCount())) 
                        out.println( "<a href=\"?" + href + "&offset=" + paginator.next() +"\">next&nbsp;></a>&nbsp;&nbsp;<a href=\"?" + href + "&offset=" + paginator.end() +"\">>></a>" );
                    else
                        out.println( "<span class=\"dead\">next&nbsp;>&nbsp;&nbsp;>></span>" );
                    %>
                </div>
                <!-- Paginator konec-->
<%
         }
%>
            <br />
            </div>
            <!-- end content -->
            <!-- start rightbar -->
            <div id="flexiRightPanel" class="sidebar">
                <div class="box_title">Result</div>
                <div class="t_box">

                    <img src="result.jpg" id="imageBox" width="200" height="164"/>
                    <form action="index.jsp" method="post">
                        <table class="formTable" border="0">
                            <tr>
                                <td>
                                    Video: <input type="text" size="5" id="res_video" name="video" readonly class="textInput"/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;Shot: <input type="text" size="5" id="res_shot" name="shot" readonly class="textInput"/>
                                </td>
                            </tr>
                            <!--<tr>
                                <td colspan="2">
                                    <textarea id="description" rows="3" cols="30" class="textInput" readonly>
                                    </textarea>
                                </td>
                            </tr> -->
                            <tr>
                                <td colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="searchCell">
                                    <input type="submit" name="query_set" value="Set as Query" style="font: 10px Verdana, sans-serif;"/>
                                </td>
                            </tr>
                        </table>
                        <table id="expert">
                            <tr>
                                <td colspan="2" class="box_title">Distances</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Distance: <input type="text" size="10" id="distance" class="textInput" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><strong>Global features</strong></td>
                            </tr>
                            <tr>
                                <td>
                                    Color: <input type="text" size="5" id="col_distance" value="" class="textInput" readonly/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Hist: <input type="text" size="5" id="hist_distance" value="" class="textInput" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Grad: <input type="text" size="5" id="grad_distance" value="" class="textInput" readonly/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;Gabor: <input type="text" size="5" id="gabor_distance" value="" class="textInput" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Face: <input type="text" size="5" id="face_distance" value="" class="textInput" readonly/>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="2"><strong>Local features</strong></td>
                            </tr>
                            <tr>
                                <td>
                                    MSER/SIFT: <input type="text" size="5" id="sift_distance" value="" class="textInput" readonly/>
                                </td>
                                <td>
                                    &nbsp;&nbsp;SURF: <input type="text" size="5" id="surf_distance" value="" class="textInput" readonly/>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
             </div>
             <!-- end rightbar -->
                <%
                //String temp = dbacces1.Description(821, 35, 1, "en");
                //out.print(temp);
                %>
        <%  rs.close();}  %>
        </div>
        <!-- end page -->

<%@ include file="./sources/footer.jsp" %>
