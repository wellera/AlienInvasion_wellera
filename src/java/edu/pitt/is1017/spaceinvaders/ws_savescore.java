/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.pitt.is1017.spaceinvaders;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Alison
 */
@WebServlet(name = "ws_savescore", urlPatterns = {"/ws/ws_savescore"})
public class ws_savescore extends HttpServlet {

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
      //  response.setContentType("application/json");
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            String gameID, userID;
            int score;
            User user;
            ScoreTracker scoreTracker;

       out.println(request.getParameter("gameID"));
       out.println(request.getParameter("score"));
       out.println(request.getParameter("userID"));
       out.println("?");

       
       
            if ((request.getParameter("gameID") != null) && (request.getParameter("score") != null) && (request.getParameter("userID") != null)) {
                    userID = request.getParameter("userID");
                    int id = Integer.parseInt(userID);
                    user = new User(id);
                    gameID = request.getParameter("gameID");
                    score = Integer.parseInt(request.getParameter("score"));
                    scoreTracker = new ScoreTracker(user, gameID);
                    scoreTracker.recordScore(score);
        out.println("parameters accepted successfully");
        
            }
else{
        out.println("parameters not found");
    
        }
            
            /*
            String x, y;
           x = request.getParameter("x");
           y = request.getParameter("y");
           
           if(x != null && y !=null){
               String sql = "INSERT INTO positions(x,y) VALUES (" + x + ", " + y + ");";
               out.println(sql);
               DbUtilities db = new DbUtilities();
               db.executeQuery(sql);
               
               out.println("{'message':'success'}");
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
