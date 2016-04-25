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
        <link href="css/styles.css" rel="stylesheet" type="text/css"/>
        <!--this is for favicon -->
        <link rel='shortcut icon' href='images/favicon.ico' type='image/x-icon'/>
    </head>

    <body>
        <form id="frmLogin" action="LoginValidator" method="post" style="width:230px;">
            <h1>Alien Invasion <span class="accent"> Login</span></h1>

            <table class="tblLogin">
                <tr>
                    <td>
            <label for="txtEmail">Email: </label>
                    </td>
                    <td>
            <input type="text" id="txtEmail" name="txtEmail" value=""> 
                    </td>
                </tr>
                <tr>
                    <td>
            <label for="txtPassword">Password: </label>
                    </td>
                    <td>
                        <input type="password" id="txtPassword" name="txtPassword" value=""> 
                    </td>
                </tr>
                <tr>
                    <td>
            <input type="submit" id="btnSubmit" name="btnSubmit" value="Login">
                    </td>
                    <td>
            <a href="register.jsp" target="_blank">Register</a>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
