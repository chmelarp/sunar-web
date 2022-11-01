<%-- 
    Document   : index
    Created on : 8.12.2008, 16:36:55
    Updated on : 23.4.2009
    Author     : Tom Krejcir
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:useBean id="dbacces1" class="websearch.DBAcces" scope="session" />
<jsp:useBean id="weightsForm" class="websearch.WeightsFormBean" scope="session" />
<jsp:useBean id="datasetForm" class="websearch.DatasetFormBean" scope="session" />
<jsp:useBean id="datasetsForm" class="websearch.DatasetsFormBean" scope="session" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/functions.js"></script>
		<!--[if lt IE 7.]><link rel="stylesheet" type="text/css" href="css/ie.css" /><![endif]-->
        <script type="text/javascript">
            function defaultweights() {
                document.getElementById('col_w').value = '1.6';
                document.getElementById('hist_w').value = '1.3';
                document.getElementById('grad_w').value = '1.3';
                document.getElementById('gabor_w').value = '1.0';
                document.getElementById('face_w').value = '2.1';
                document.getElementById('sift_w').value = '1.0';
                document.getElementById('surf_w').value = '1.5';
            }
            function colorweight() {
                document.getElementById('col_w').value = '1.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function histweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '1.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function gradweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '1.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function gaborweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '1.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function faceweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '1.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function colorweight() {
                document.getElementById('col_w').value = '1.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function siftweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '1.0';
                document.getElementById('surf_w').value = '0.0';
            }
            function surfweight() {
                document.getElementById('col_w').value = '0.0';
                document.getElementById('hist_w').value = '0.0';
                document.getElementById('grad_w').value = '0.0';
                document.getElementById('gabor_w').value = '0.0';
                document.getElementById('face_w').value = '0.0';
                document.getElementById('sift_w').value = '0.0';
                document.getElementById('surf_w').value = '1.0';
            }


            function showimage() {
                var video = document.getElementById("video").value;
                var shot = document.getElementById("shot").value;
                if (video > 110)
                    // http://pcsocrates1.fit.vutbr.cz:8080/
                    document.getElementById("queryBox").src = "/trecvid/data/keyframes.devel/TRECVID2007_"+ video +"/shot"+ video +"_"+ shot +".jpg";
                else
                    document.getElementById("queryBox").src = "/trecvid/data/keyframes.devel/TRECVID2007_"+ video +"/shot"+ video +"_"+ shot +"_RKF.jpg";
            }

            function fillshots() {
                var video = document.getElementById("video").value;
                window.location = "?video=" + video + "&shot=1&query_set=query";
            } 
            cssfile();
        </script>
        <title>TRECVid Search 2009</title>
    </head>
    <body>
        <div id="header">
            <div class="css">
                <small>
                    <a onclick="document.cookie='STYLE='+escape('user.css')+';'; document.getElementById('css').href='css/user.css';">user</a> <br />
                    <a onclick="document.cookie='STYLE='+escape('expert.css')+';'; document.getElementById('css').href='css/expert.css';">expert</a>
                </small>
            </div>
            <img class="logo_trecvid" src="trecvid.gif" width="168" height="61" />
            <img class="logo_fit" src="fit.gif" width="85" height="50" />
            <div class="title">TRECVid Search 2009 Demo</div>
        </div>