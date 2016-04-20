<%-- 
    Document   : test
    Created on : Apr 14, 2016, 5:17:12 PM
    Author     : Alison
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>testing page</title>
        <link href="css/styles.css" rel="stylesheet" type="text/css"/>
        <script src="js/jquery-2.2.3.min.js" type="text/javascript"></script>
        <script>
            
            
            $(document).ready(function () {
                console.log("document loaded");
                $.getJSON('ws/ws_readscores', function (data) {
                    $tbl = $('#tblUsers');
                    for (var i = 0; i < data.leaders.length; i++) {
                        $tr = $('<tr></tr>');
                        $td = $('<td></td>');
                        $td.html(data.leaders[i].lastName);
                        $tr.append($td);

                        $td = $('<td></td>');
                        $td.html(data.leaders[i].firstName);
                        $tr.append($td);

                        $td = $('<td></td>');
                        $td.html(data.leaders[i].highestScore);
                        $tr.append($td);

                        $tbl.append($tr);
                    }

                });
            });
            
            
        </script>
    </head>
    <body>
        <h1>testing page</h1>


        <table id="tblUsers">
            <th>Last Name</th>
            <th>First Name</th>
            <th>High Score</th>
        </table>



    </body>
</html>
