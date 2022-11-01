<%-- 
    Document   : formProcess
    Created on : 11.12.2008, 10:03:10
    Author     : 
--%>

<%@ page import="java.util.*" %>
<%! 
    ResourceBundle bundle =null;
    public void jspInit() {
       bundle = ResourceBundle.getBundle("forms");
      }
%>
<jsp:useBean id="formHandler" class="websearch.SearchFormBean" scope="request">
<jsp:setProperty name="formHandler" property="*"/>
</jsp:useBean>
<% 
   if (formHandler.validate()) {
%>
    <jsp:forward page="<%=bundle.getString(\"process.success\")%>"/>
<%
   }  else {
%>
    <jsp:forward page="<%=bundle.getString(\"process.retry\")%>"/>
<%
   }
%>
