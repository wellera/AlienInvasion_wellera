<%-- 
    Document   : game
    Created on : Mar 22, 2016, 12:17:40 PM
    Author     : Alison
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Play</title>
        <link href="css/styles.css" rel="stylesheet" type="text/css"/>

        <script src="js/jquery-2.2.3.min.js"></script>

        <!-- this is a test -->
        <script>
            $alien = null;
            $bullet = null;
            $tblAliens = null;
            $ship = null;
            
            var alienList = [];
            var alienInterval = null;
            var bulletInterval = null;
            var hitRight = false;
            
            $(document).ready(function () {
                
                $tblAliens = $('#tblAliens');
                $alien = $('#alien');
                $ship = $('#ship');
                $bullet = $('#bullet');
                
                drawAliens();
                drawShip();
                
                alienInterval = setInterval(moveAliens, 100);
                /*
                 for (var i=0; i<alienList.length; i++){
                 console.log(alienList[i].position());
                 }
                 */

                $(document).keydown(function (e) {
                    if (e.keyCode == 32) {
                        bulletInterval = setInterval(moveBullet, 100);
                    }
                });


                $(document).keydown(function (e) {
                    moveShip(e);
                    e.preventDefault(); //prevent the default action (scroll / move caret)
                });
            });

            function drawAliens() {
                for (var i = 0; i < 5; i++) {
                    $tr = $('<tr></tr>');
                    for (var j = 0; j < 10; j++) {
                        $td = $('<td></td>');
                        $alien = $('<img>');
                        $alien.attr('src', 'images/alien.gif');
                        $td.append($alien);
                        alienList.push($alien);
                        $tr.append($td);
                    }
                    $tblAliens.append($tr);
                }
            }
            
            function drawShip(){
                $ship.css("left", (window.innerWidth/2-(16.5)) + "px");
                $ship.css("top", (window.innerHeight - (10 + 23)) + "px");
            }

            
             function moveShip(e) {
             switch (e.which) {
             case 37: //left
             var pos = $ship.position();
             $ship.css('left', (pos.left - 30) + "px");
             break;
             
             case 38: //up
             break;
             
             case 39: //right
             var pos = $ship.position();
             $ship.css('left', (pos.left + 30) + "px");
             break;
             
             case 40: //down
             break;
             
             default:
             return; //exit this handler for other keys
             }
            // saveAlienPosition($alien.position());
             }
             
             
            function saveAlienPosition(pos) {
                var url = "ws_savescore?x=" + pos.left + "&y=" + pos.top;
                // console.log(url);

                //var url = "ws/ws_savescore";
                //var coords = {
                //  "x" : pos.left,
                //  "y" : pos.top
                //};
                $.post(url, function (data) {
                    console.log(data);
                });
            }

            function moveBullet() {
                var pos = $bullet.position();
                $bullet.css("top", (pos.top - 10) + "px");
                if (pos.top < 20) {
                    clearInterval(bulletInterval);
                }
                //   console.log(pos);
            }

            function moveAliens() {
                var pos = $tblAliens.position();
                var tblPosX = $tblAliens.offset().left;
                var tblWidth = $tblAliens.width();
                var winWidth = window.innerWidth;

                /*
                 console.log(pos);
                 console.log(tblPosX);
                 console.log(tblWidth);
                 console.log(winWidth);
                 */

                if (hitRight === false) {
                    $tblAliens.css("left", (pos.left + 10) + "px");
                    tblPosX = $tblAliens.offset().left;
                    tblWidth = $tblAliens.width();
                    winWidth = window.innerWidth;
                    if (tblPosX >= (winWidth - (tblWidth + 10))) {
                        hitRight = true;
                        $tblAliens.css("top", (pos.top + 10) + "px");

                    }
                }
                if (hitRight === true) {
                    $tblAliens.css("left", (pos.left - 10) + "px");
                    tblPosX = $tblAliens.offset().left;
                    tblWidth = $tblAliens.width();
                    winWidth = window.innerWidth;
                    if (tblPosX <= 10) {
                        hitRight = false;
                        $tblAliens.css("top", (pos.top + 10) + "px");
                    }
                }




            }

        </script>

        <!--this is for favicon -->
        <link rel='shortcut icon' href='images/favicon.ico' type='image/x-icon'/>
    </head>

    <body>

        <table id="tblAliens">

        </table>


        <div id="bullet"></div>

        <div id="ship"></div>
         
    </body>
</html>
