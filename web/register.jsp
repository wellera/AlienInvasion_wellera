<%-- 
    Document   : registration
    Created on : Mar 22, 2016, 12:21:23 PM
    Author     : Alison
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Register</title>
        <!--this is for favicon -->
        <link rel='shortcut icon' href='images/favicon.ico' type='image/x-icon'/>
    </head>
    <body>
        <h1>Alien Invasion - Register</h1>
        <form id="frmLogin" action="Registration" method="post">
            <table>
                <tr>
                    <td>
            <label for="txtFirstName">First Name: </label>
                    </td>
                    <td>
            <input type="text" id="txtFirstName" name="txtFirstName" value=""> 
                    </td>
                </tr>    
                <tr>
                    <td>
            <label for="txtLastName">Last Name: </label>
                    </td>
                    <td>
            <input type="text" id="txtLastName" name="txtLastName" value=""> 
                    </td>
                </tr>
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
            <label for="txtConfirmPassword">Confirm Password: </label>
                    </td>
                    <td>
                <input type="password" id="txtConfirmPassword" name="txtConfirmPassword" value=""> 
                    </td>
                </tr>
                <tr>
                    <td>
            <input type="submit" id="btnRegister" name="btnRegister" value="Register">
                    </td>
                    <td>
            <a href="index.jsp">
                <button>Cancel</button>
            </a>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
