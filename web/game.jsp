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

        <script>
            $alien = null;
            $bullet = null;
            $tblAliens = null;
            $ship = null;
            var alienList = [];
            var alienInterval = null;
            //   var bulletInterval = null;
            var hitRight = false;
            var SHOT_WIDTH = 12;
            var SHOT_HEIGHT = 23;
            var ALIEN_WIDTH = 43;
            var ALIEN_HEIGHT = 29;
            var BOTTOM_LIMIT = 33;
            var score = 0;

            var collision = false;

            ///new variables///
            var curBulletID = 1;
            var firedBullets = []; // initialize empty array that will hold bullet objects
            var screenWidth = 0;
            var screenHeight = 0;

            var gameID = generateGameID();
            var userID;

            $(document).ready(function () {

                userID = getUrlParameter("userID");

                console.log("gameID: " + gameID + "... user id: " + userID);



                $tblAliens = $('#tblAliens');
                $alien = $('#alien');
                $ship = $('#ship');
                drawAliens();
                drawShip();
                alienInterval = setInterval(moveAliens, 100);

                /*
                 for (var i=0; i<alienList.length; i++){
                 console.log(alienList[i].position());
                 }
                 */

                $(document).keydown(function (e) {
                    if (e.keyCode) {
                        controlShip(e);
                        e.preventDefault(); //prevent the default action
                    }
                    /*
                     if (e.keyCode === 32) {
                     drawBullet();
                     e.preventDefault(); //prevent the default action)
                     //bulletInterval = setInterval(moveBullet, 100);
                     }
                     if (e.keyCode === 37 || 39) {
                     moveShip(e);
                     e.preventDefault(); //prevent the default action (scroll / move caret)
                     }
                     */

                });
            });
            function drawAliens() {
                for (var i = 0; i < 5; i++) {
                    $tr = $('<tr></tr>');
                    for (var j = 0; j < 10; j++) {
                        $td = $('<td></td>');
                        $td.attr('width', ALIEN_WIDTH); // prevent table from collapsing
                        $alien = $('<img>');
                        $alien.attr('src', 'images/alien.gif');
                        $td.append($alien);
                        alienList.push($alien);
                        $tr.append($td);

                        //  console.log($alien);

                    }
                    $tblAliens.append($tr);
                }
            }

            function drawShip() {
                $ship.css("left", (window.innerWidth / 2 - (16.5)) + "px");
                $ship.css("top", (window.innerHeight - (10 + $ship.height())) + "px");
            }




            function controlShip(e) {
                switch (e.which) {
                    case 32: // fire
                        createBullet();
                        break;
                    case 37: // left
                        var pos = $ship.position();
                        $ship.css('left', (pos.left - 10) + 'px');
                        break;
                    case 39: // right
                        var pos = $ship.position();
                        $ship.css('left', (pos.left + 10) + 'px');
                        break;
                    default:
                        return; // exit this handler for other keys
                }
                /*OLD
                 switch (e.which) {
                 case 37: //left
                 var pos = $ship.position();
                 $ship.css('left', (pos.left - 30) + "px");
                 break;
                 case 39: //right
                 var pos = $ship.position();
                 $ship.css('left', (pos.left + 30) + "px");
                 break;
                 case 32:
                 drawBullet();
                 break;
                 default:
                 return; //exit this handler for other keys
                 }OLD END*/
            }

            /*
             function saveAlienPosition(pos) {
             var url = "ws_savescore?x=" + pos.left + "&y=" + pos.top;
             // console.log(url);
             
             //var url = "ws/ws_savescore";
             //var coords = {
             //  "x" : pos.left,
             //  "y" : pos.top
             //};
             $.post(url, function (data) {
             console.log(data + "test alien position");
             });
             }
             */


            function saveScore(score) {

                var url = "ws/ws_savescore?gameID=" + gameID + "&score=" + score + "&userID=" + userID;
                // console.log(url);

                //var url = "ws/ws_savescore";
                    console.log("attempting to save to database, test... the url is: " + url);


                $.post(url, function (data) {

                });
            }


            /* old bullet code
             function drawBullet() {
             $bullet = $('<img>');
             $bullet.attr('src', 'images/shot.gif');
             $bullet.attr('id', bulletIdSeed);
             bulletIdSeed++;
             $bullet.css({
             "z-index": -1,
             "position": "absolute",
             "left": (($ship.offset().left) + ($ship.width() / 2) - (SHOT_WIDTH / 2)) + "px",
             "top": $ship.offset().top + "px"
             });
             console.log($bullet);
             $('body').append($bullet);
             bulletClip.push($bullet);
             if (timer != null) {
             clearInterval(timer);
             }
             timer = setInterval(moveBullet, bulletClip.length * 100);
             }
             */

            /*old bullet code
             function moveBullet() {
             console.log("Array length: " + bulletClip.length);
             for (var i = 0; i < bulletClip.length; i++) {
             $bullet = bulletClip[i];
             var pos = $bullet.position();
             $bullet.css("top", (pos.top - 10) + "px");
             
             // detectCollision($bullet);
             
             if (pos.top <= 0) {
             $(this.$bullet).remove();
             bulletClip.shift();
             // clearInterval(bulletInterval);
             clearInterval(timer);
             timer = setInterval(moveBullet, bulletClip.length * 100);
             return;
             }
             
             }
             clearInterval(timer);
             timer = setInterval(moveBullet, bulletClip.length * 100);
             
             
             }*/



            //moveBullet end

            ////////////////////////new bullet code start/////////////////////

            function createBullet() {
                // Create image object
                $bulletObj = $('<img>');

                // Set attributes for the image object
                $bulletObj.attr({
                    "id": "bullet_" + curBulletID,
                    "src": "images/shot.gif"
                });

                var initBulletX = $ship.position().left + $ship.width() / 2 - SHOT_WIDTH / 2;
                var initBulletY = $ship.position().top - SHOT_HEIGHT;

                // Set CSS position for the image object
                $bulletObj.css({
                    "position": "absolute",
                    "width": SHOT_WIDTH + "px",
                    "height": SHOT_HEIGHT + "px",
                    "top": initBulletY + "px",
                    "left": initBulletX + "px"
                });

                $('body').append($bulletObj);
                /*
                 * Create bullet object as a JSON object.  Look carefully at the properties.
                 * intervalID property will store timer interval ID
                 * bulletObj property stores the actual jQuery image object representing
                 * an individual bullet
                 */
                var bullet = {
                    "bulletID": curBulletID,
                    "intervalID": 0,
                    "bulletObj": $bulletObj
                };

                // Increment global variable
                curBulletID++;

                // Save bullet into a global array
                firedBullets.push(bullet);

                /*
                 * This is a major difference from what we did in class.
                 * Note that setInterval can take more than two arguments
                 * Each argument after the time interval is an argument that gets
                 * passed to the moveBullet function.  
                 * See documentation: 
                 * https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setInterval
                 */
                bullet.intervalID = setInterval(moveBullet, 100, bullet);
            }


            function moveBullet(bullet) {
                // Get the jQuery bullet object from the DOM
                $firedBullet = $('#bullet_' + bullet.bulletID);

                //console.log($firedBullet);

                // Get current Y position
                var posY = $firedBullet.position().top;

                // Get new position - move by 10 pixels up along Y-axis
                var newPosY = posY - 10;

                //console.log($firedBullet);

                //detect collision
                detectCollision($firedBullet);

                if (collision) {
                    clearInterval(bullet.intervalID);
                    $firedBullet.remove(); // Remove bullet from the DOM
                    firedBullets.shift(); // Remove first element of the bullets array
                    collision = false;
                    return;
                }


                // Once the bullet is 5px away from the top, remove it
                if (newPosY > 5) {
                   // console.log("where's my bullet?");
                    $firedBullet.css("top", newPosY + "px");
                } else {
                    /* 
                     * Clear interval - it's easy because the interval is 
                     * now a property of the bullet JSON object
                     */
                    saveScore(0);
                    console.log("save score + 0 called here....")        

                    clearInterval(bullet.intervalID);
                    $firedBullet.remove(); // Remove bullet from the DOM
                    firedBullets.shift(); // Remove first element of the bullets array
                }

            }




            ////////////////////////new bullet code end//////////////////////

            function moveAliens() {
                var pos = $tblAliens.position();
                var tblPosX = $tblAliens.position().left;
                var tblWidth = $tblAliens.width();
                var winWidth = window.innerWidth;
                var tblBottom = $tblAliens.position().top + $tblAliens.height();

                /////LOSE...end game here
                if (tblBottom >= (window.innerHeight - BOTTOM_LIMIT)) {
                    //  exit();
                    console.log("you lose. link this test to gameOver");
                }

                if (hitRight === false) {
                    $tblAliens.css("left", (pos.left + 10) + "px");
                    tblPosX = $tblAliens.position().left;
                    tblWidth = $tblAliens.width();
                    winWidth = window.innerWidth;
                    if (tblPosX >= (winWidth - (tblWidth + 10))) {
                        hitRight = true;
                        $tblAliens.css("top", (pos.top + 10) + "px");
                    }
                }
                if (hitRight === true) {
                    $tblAliens.css("left", (pos.left - 10) + "px");
                    tblPosX = $tblAliens.position().left;
                    tblWidth = $tblAliens.width();
                    winWidth = window.innerWidth;
                    if (tblPosX <= 10) {
                        hitRight = false;
                        $tblAliens.css("top", (pos.top + 10) + "px");
                    }
                }

            }

            //detect collisions?
            function detectCollision($firedBullet) {

                for (var i = 0; i < alienList.length; i++) {

                    var collisionDetected = false;

                    $alien = alienList[i];

                    if (alienList[i] !== null) {

                        if (intersect($firedBullet, $alien)) {

                            $(this.$alien).remove();
                            alienList[i] = null;
                            collisionDetected = true;
                            console.log("collision detected...");


                            saveScore(1);
                            console.log("save score + 1 called here....")        
                        }
                    }

                    if (collisionDetected) {
                        return true;
                    }
                }
            }// end detectCollision

            function intersect($firedBullet, $alien) {

                var alien = {
                    left: $alien.position().left,
                    top: $alien.position().top,
                    right: $alien.position().left + ALIEN_WIDTH,
                    bottom: $alien.position().top + ALIEN_HEIGHT
                };

                var bullet = {
                    left: $firedBullet.position().left,
                    top: $firedBullet.position().top,
                    right: $firedBullet.position().left + SHOT_WIDTH,
                    bottom: $firedBullet.position().top + SHOT_HEIGHT
                };

                if (((bullet.top < alien.bottom) && (bullet.left < alien.right) && !(bullet.right < alien.left)) || ((bullet.top < alien.bottom) && (bullet.right > alien.left) && !(bullet.left > alien.right))) {
                    //  $($bullet).remove();///NOT WORKING
                    //  $($alien).remove();

                    collision = true;

                    // console.log(alienList.length);
                    return true;
                }

                return false;

            }//end intersect function

            //http://stackoverflow.com/questions/19491336/get-url-parameter-jquery-or-how-to-get-query-string-values-in-js
            // function getUrlParameter(sParam) {
            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                        sURLVariables = sPageURL.split('&'),
                        sParameterName,
                        i;

                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');

                    if (sParameterName[0] === sParam) {
                        return sParameterName[1] === undefined ? true : sParameterName[1];
                    }
                }
            };

            //https://jsfiddle.net/briguy37/2MVFd/
            function generateGameID() {
                var d = new Date().getTime();
                var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                    var r = (d + Math.random() * 16) % 16 | 0;
                    d = Math.floor(d / 16);
                    return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
                });
                return uuid.toString();
            };            


        </script>

        <!--this is for favicon -->
        <link rel='shortcut icon' href='images/favicon.ico' type='image/x-icon'/>
    </head>

    <body>

        <table id="tblAliens">

        </table>

        <!--  <img src="assets/images/ship.gif" id="ship" alt=""/> /-->

        <div id="ship"></div> 

    </body>
</html>
