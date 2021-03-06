/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.pitt.is1017.spaceinvaders;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Alison
 */
@WebServlet(name = "ws_readscores", urlPatterns = {"/ws/ws_readscores"})
public class ws_readscores extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {

            String gameID, userID;
            User user;
            ScoreTracker scoreTracker;

            if ((request.getParameter("gameID") != null) && (request.getParameter("userID") != null)) {
                userID = request.getParameter("userID");
                int id = Integer.parseInt(userID);
                user = new User(id);
                gameID = request.getParameter("gameID");
                scoreTracker = new ScoreTracker(user, gameID);

                JSONObject leaders = new JSONObject();

                leaders = scoreTracker.getHighScores();

                //  out.println("parameters accepted successfully");
                //   out.print(leaders.toString());
                out.print(leaders);
            } else {
                out.println("parameters not found");

            }

            /*  
            
            
            
            String sql = "SELECT lastName, firstName, MAX(scoreValue) AS highestScore ";
                   sql+= "FROM users JOIN finalscores ON userID = fk_userID ";
                   sql+= "GROUP BY lastName, firstName ";
                   sql+= "ORDER BY MAX(scoreValue) DESC ";
                   sql+= "LIMIT 5; ";
            

            DbUtilities db = new DbUtilities();

            try {
                ResultSet rs = db.getResultSet(sql);
                JSONArray userList = new JSONArray();

                while (rs.next()) {
                    JSONObject users = new JSONObject();
                    users.put("lastName", rs.getString("lastName"));
                    users.put("firstName", rs.getString("firstName"));
                    users.put("highestScore", rs.getInt("highestScore"));
                    userList.put(users);
                }

                JSONObject leaders = new JSONObject();
                
                
                leaders.put("leaders", userList);

                out.print(leaders.toString());
                
            } catch (SQLException | JSONException ex) {
                Logger.getLogger(ws_readscores.class.getName()).log(Level.SEVERE, null, ex);
                out.print("catch?");

            }
             */
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
