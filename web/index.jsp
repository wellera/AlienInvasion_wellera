<%-- 
    Document   : index
    Created on : Mar 3, 2016, 6:31:31 PM
    Author     : Alison
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Login</title>
    </head>
    <%
    %>
    <body>
        <h1>Alien Invasion - Login</h1>
        <form id="frmLogin" action="LoginValidator" method="post">
            <label for="txtEmail">Email: </label><input type="text" id="txtEmail" name="txtEmail" value=""> 
            <br />
            <label for="txtPassword">Password: </label><input type="password" id="txtPassword" name="txtPassword" value=""> 
            <br />
            <input type="submit" id="btnSubmit" name="btnSubmit" value="Login">
            <a href="register.jsp" target="_blank">Register</a>
        </form>
    </body>
</html>
