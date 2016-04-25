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
            var alienCounter = 50;
            var hitRight = false;
            var SHOT_WIDTH = 12;
            var SHOT_HEIGHT = 23;
            var ALIEN_WIDTH = 43;
            var ALIEN_HEIGHT = 29;
            var BOTTOM_LIMIT = 33;
            var score = 0;
            var gameEnded = false;
            var collision = false;
            var TABLE_ROWS = 5;
            var TABLE_COLS = 10;
            var curBulletID = 1;
            var firedBullets = []; // initialize empty array that will hold bullet objects
            var screenWidth = 0;
            var screenHeight = 0;
            var rightRow = TABLE_COLS;
            var leftRow = 1;
            var score = 0;

            var gameID = generateGameID();
            var userID;

            $(document).ready(function () {

                userID = getUrlParameter("userID");

                console.log("user is is: " + userID);

                $tblAliens = $('#tblAliens');
                $alien = $('#alien');
                $ship = $('#ship');
                drawAliens();
                drawShip();
                alienInterval = setInterval(moveAliens, 100);


            });

            $(document).keydown(function (e) {
                if (e.keyCode) {
                    controlShip(e);
                    e.preventDefault(); //prevent the default action
                }
            });


            /*CREATE TABLE COMPENENTS, ALIEN OBJECTS, AND APPEND THEM TO A TABLE*/
            function drawAliens() {
                for (var i = 0; i < TABLE_ROWS; i++) {
                    $tr = $('<tr></tr>');
                    // $tr.attr('class', col + i+1); // give each row a class
                    for (var j = 0; j < TABLE_COLS; j++) {
                        var col = j + 1;
                        $td = $('<td></td>');

                        // give each td its column number as a class (used for the controlCollapse function)
                        $td.attr('class', 'td' + col);

                        $td.attr('width', ALIEN_WIDTH); // prevent table from collapsing
                        $alien = $('<img>');

                        // give each alien a column class (used for the controlCollapse function)
                        $alien.attr('class', 'alien' + col);
                        $alien.attr('src', 'images/alien.gif');
                        $td.append($alien);
                        alienList.push($alien);
                        $tr.append($td);
                    }
                    $tblAliens.append($tr);
                }
            }/*END drawAliens*/

            function drawShip() {
                $ship.css("left", (window.innerWidth / 2 - (16.5)) + "px");
                $ship.css("top", (window.innerHeight - (10 + $ship.height())) + "px");
            }



            /*ASSIGN KEYS TO GAME FUNCTIONS*/
            function controlShip(e) {
                switch (e.which) {
                    case 32: // fire
                        createBullet();
                        break;
                    case 37: // left
                        var pos = $ship.position();
                        var edge = 10;
                        if ($ship.position().left >= edge) {
                            $ship.css('left', (pos.left - 10) + 'px');
                        }
                        break;
                    case 39: // right
                        var pos = $ship.position();
                        var edge = window.innerWidth - 10;
                        if (($ship.position().left + $ship.width()) <= edge) {
                            $ship.css('left', (pos.left + 10) + 'px');
                        }
                        break;
                    default:
                        return; // exit this handler for other keys
                }
            }/*END controlShip*/

            /*COLLAPSE THE OUTER COLUMNS IF THEY ARE EMPTY*/
            function controlCollapse() {
                ///only allow the table to drop its outer rows
                for (i = 1; i <= TABLE_COLS; i++) {
                    var tdAlien = "alien" + i;
                    var tdCell = "td" + i;

                    var a = document.getElementsByClassName(tdAlien).length;

                    if (a <= 0 && i === rightRow) {
                        var cells = document.getElementsByClassName(tdCell);
                        for (x = 0; x < cells.length; x++) {
                            cells[x].style.width = "0px";
                            cells[x].style.padding = "0px";
                        }
                        console.log("drop the far right row");
                        rightRow--;
                    }
                    if (a <= 0 && i === leftRow) {
                        var cells = document.getElementsByClassName(tdCell);
                        for (x = 0; x < cells.length; x++) {
                            cells[x].style.width = "0px";
                            cells[x].style.padding = "0px";
                        }
                        console.log("drop the far left row");
                        leftRow++;
                    }

                }

            }/*END controlCollapse*/


            /*SEND SCORE TO DATABASE VIA WS_SAVESCORE SERVLET*/
            function saveScore(score) {


                var url = "ws/ws_savescore?gameID=" + gameID + "&score=" + score + "&userID=" + userID;
                console.log(url);

                $.post(url, function (data) {

                });

                if (score === 1) {
                    alienCounter--;
                    score += 1;
                }

                if (alienCounter === 0) {
                    gameEnded = true;
                    var result = "You won!";
                    gameOver(result);
                }

                if (score === 0) {
                    score += -1;
                }

            }/*END saveScore*/


            /*CREATE BULLET OBJECTS*/
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
            }/*END createBullet*/


            /*MOVE BULLET UP THE SCREEN AND REMOVE IF IT HITS AN ALIEN OR THE TOP OF THE SCREEN*/
            function moveBullet(bullet) {

                // Get the jQuery bullet object from the DOM
                $firedBullet = $('#bullet_' + bullet.bulletID);

                // (This may only be required for slow computers?..) Test to see if bullets should all be cleared
                if (!gameEnded) {

                    // Get current Y position
                    var posY = $firedBullet.position().top;

                    // Get new position - move by 10 pixels up along Y-axis
                    var newPosY = posY - 10;

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

                        clearInterval(bullet.intervalID);
                        $firedBullet.remove(); // Remove bullet from the DOM
                        firedBullets.shift(); // Remove first element of the bullets array
                        score = 0;
                        saveScore(score);// If bullet hits the top of the screen, it's a miss

                    }
                } else { // If the game is ended, clear the bullet
                    $firedBullet.remove();
                }
            }/*END moveBullet*/


            function moveAliens() {
                var pos = $tblAliens.position();
                var tblPosX = $tblAliens.position().left;
                var tblWidth = $tblAliens.width();
                var winWidth = window.innerWidth;
                var tblBottom = $tblAliens.position().top + $tblAliens.height();

                if (tblBottom >= (window.innerHeight - BOTTOM_LIMIT)) {
                    $(this.$tblAliens).remove();
                    var result = "Game over.";
                    $(this.$firedBullet).remove();
                    gameOver(result);
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

            /*LOOP THROUGH EACH ALIEN IN THE ARRAY TO SEE IF BULLET HAS HIT, IF SO - KILL THE ALIEN*/
            function detectCollision($firedBullet) {

                for (var i = 0; i < alienList.length; i++) {

                    var collisionDetected = false;

                    $alien = alienList[i];

                    if (alienList[i] !== null) {

                        if (intersect($firedBullet, $alien)) {
                            $(this.$firedBullet).remove();
                            $(this.$alien).remove();
                            controlCollapse();
                            alienList[i] = null;
                            collisionDetected = true;
                            score = 1;
                            saveScore(score);
                        }
                    }
                    if (collisionDetected) {
                        return true;
                    }
                }
            }/*END detectCollision*/

            /*CHECK FOR LOCATION INTERSECTION OF THE BULLET AND THE ALIEN*/
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
                    collision = true;
                    return true;
                }
                return false;
            }/*END intersect*/


            /*CALLED WHEN GAME IS OVER, REPORT RESULTS AND HIGH SCORES*/
            function gameOver(result) {
                $(this.$ship).remove();
                var count;
                var leaderList = [];
                var leader;
                var report = result + " Your score is: " + score + ". \n \n \nAll-time high scores: \n \n";
                gameEnded = true;



                var url = "ws/ws_readscores?gameID=" + gameID + "&userID=" + userID;
                $.getJSON(url, function (data) {

                    for (var i = 0; i < data.leaders.length; i++) {

                        leader = data.leaders[i].firstName.toString() + " " + data.leaders[i].lastName.toString() + ": " + data.leaders[i].highestScore.toString() + "\n";
                        leaderList.push(leader);
                        report += leader + "\n";
                        if (i === data.leaders.length-1) {
                            alert(report);

                        }

                    }

                });


            }/*END gameOver*/



            /////????????????????????
            // window.alert($tbl);
            $(window).unload(function () {
                result = "You lost."; ///TEST THIS
                gameOver(result); ///TEST THIS
            });
            ///////???????????????



            /*RETRIEVE PARAMETERS FROM THE URL PASSED VIA LOGINVALIDATOR SERVLET (LOGGING IN) 
             * 
             *http://stackoverflow.com/questions/19491336/get-url-parameter-jquery-or-how-to-get-query-string-values-in-js
             */
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
            }


        </script>

        <!--this is for favicon -->
        <link rel='shortcut icon' href='images/favicon.ico' type='image/x-icon'/>
    </head>

    <body>

        <table id="tblAliens">

        </table>


        <div id="ship"></div> 

     

    </body>
</html>
