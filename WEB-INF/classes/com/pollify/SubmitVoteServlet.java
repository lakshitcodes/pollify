package com.pollify;
import com.pollify.DBCredentials;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.pollify.VoteDAO;


public class SubmitVoteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        String username = (String) session.getAttribute("username");
        if (username == null) {
            // Redirect to login if not logged in
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the poll ID from the request (ID of the active voting period)
        String pollIdStr = request.getParameter("pollId");
        int pollId = Integer.parseInt(pollIdStr);

        // Implement DAO to save vote (using VoteDAO to handle database operations)
        VoteDAO voteDAO = new VoteDAO();
        
        try {
            // Record the vote in the database
            boolean voteInserted = voteDAO.recordVote(username, pollId);
        
            // Check if the vote was successfully recorded
            if (voteInserted) {
                response.sendRedirect("vote.jsp?status=" + URLEncoder.encode("Vote submitted successfully!", "UTF-8"));
            } else {
                response.sendRedirect("vote.jsp?status=" + URLEncoder.encode("Failed to submit vote. Please try again.", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to an error page if an exception occurs
            response.sendRedirect("confirmation.jsp?status=error");
        }
    }
}
