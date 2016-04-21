package edu.pitt.is1017.spaceinvaders;

/**
 * A ScoreTracker Object is initialized at the beginning of each round of a game.
 * It reports play-by-play score information to the database.
 * 
 * @author Alison Weller
 */

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.swing.JOptionPane;

public class ScoreTracker{
	private User user;
	private int currentScore;
	private int highestScore;
	private String gameID;

        
        
        
        
        
        ///THIS IS MY NEW SCORETRACKER THAT ACCEPTS GAMEID AS A PARAMETER
        public ScoreTracker(String gameID){
            this.gameID = gameID;
            int userID = getUserID(gameID);
            
            
            User webUser = new User(userID);
            
            this.user = webUser;
            
            ScoreTracker webTracker = new ScoreTracker(webUser, gameID);
            

	}
	
	public ScoreTracker(User user, String gameID){
		this.user=user;
                this.gameID = gameID;
                
		setCurrentScore(0);
		
		//Retrieve the value of the highest score for any game that the user has ever played 
		try{
			DbUtilities db = new DbUtilities();
			String maxScore = "SELECT MAX(scoreValue) as scoreValue FROM finalscores WHERE fk_userID = " + user.getUserID() + "; ";
			db.getResultSet(maxScore);
			ResultSet rs = db.getResultSet(maxScore);
			
			if(rs.next()){
				setHighestScore(rs.getInt("scoreValue"));
				//System.out.println("highest score is: " + getHighestScore());////FOR TESTING///
			}
			else{
				highestScore=0;
			}
			db.closeDbConnection(); // Close connection
		
		}
		catch(SQLException se){
	      //Handle errors for JDBC
	      se.printStackTrace();
	    }
		catch(Exception e){
	      e.printStackTrace();
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database (getting max score).");
		}

	}
	
	public void recordScore(int point){
		setCurrentScore(getCurrentScore() + point);
		boolean scoreType = false;
		String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());
		if (point > 0){
			scoreType=true;
		}

		//Insert currentScore into runningscores table
		try{
			DbUtilities db = new DbUtilities();
			String sql = "INSERT INTO runningscores (gameID, scoreType, scoreValue, fk_userID, dateTimeEntered) VALUES "
					+ "('" + gameID + "', " + scoreType + ", " + getCurrentScore() + ", '" + user.getUserID() + "', '" + timeStamp + "'); ";						
			db.executeQuery(sql);
			db.closeDbConnection(); // Close connection (each time???)
		}
		catch(Exception ex){
			ex.printStackTrace();
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database(inserting running score).");
		}
		//System.out.println("this is the current score: " + getCurrentScore()); /// THIS IS FOR TESTING
	}
	
	public void recordFinalScore(){
		String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());
		try{
			DbUtilities db = new DbUtilities();
			//insert final score to the database
			String sql = "INSERT INTO finalscores (gameID, scoreValue, fk_userID, dateTimeEntered) VALUES ('" + gameID + "', '" + getCurrentScore() + "', '" + user.getUserID() + "', '" + timeStamp + "'); ";
			db.executeQuery(sql);
			
			//retrieve your high score from the database and report
			sql = "SELECT MAX(scoreValue) as scoreValue FROM finalscores WHERE fk_userID = " + user.getUserID() + "; ";
			String myHighScore;
			ResultSet myMax = db.getResultSet(sql);
			if(myMax.next()){
				myHighScore = myMax.getString("scoreValue");
			}
			else{
				myHighScore = "0";
			}
			
			//retrieve highest score of any player from the database and report
			//sql = "SELECT lastName, firstName, MAX(scoreValue) as scoreValue FROM finalscores JOIN users ON fk_userID = userID GROUP BY lastName, firstName; ";
			sql = "SELECT firstName, lastName, MAX(scoreValue) as scoreValue FROM finalscores JOIN users ON fk_userID = userID ORDER BY firstName, lastName, scoreValue; ";
			ResultSet rs = db.getResultSet(sql);
			String first, last, highScore;
			//if the result set successfully returns information, create a message dialogue
			if(rs.next()){
				first = rs.getString("firstName");
				last = rs.getString("lastName");
				highScore = rs.getString("scoreValue");
				String highScores = "Your current score: " + currentScore + " \nYour high score: " + myHighScore + "\n" +
						 "All-time high score: " + first + " " + last + ": " + highScore;
				JOptionPane.showMessageDialog(null, highScores);
			}
			
			db.closeDbConnection(); // Close connection
		}
		catch(Exception ex){
			ex.printStackTrace();
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database(recording final score).");
		}
		
	}
        
        
        public int getUserID(String gameID){
		//this.user=user;
		int userID =0;
                
		//Get the user associated with the current game
		try{
			DbUtilities db = new DbUtilities();
			String currentUser = "SELECT fk_userID FROM runningscores WHERE gameID = " + gameID + " LIMIT 1; ";
                        
                        db.getResultSet(currentUser);
			ResultSet rs = db.getResultSet(currentUser);
			
			if(rs.next()){
                                userID = rs.getInt("currentUser");
                                
			}
                  
			db.closeDbConnection(); // Close connection
		
		}
		catch(SQLException se){
	      //Handle errors for JDBC
	      se.printStackTrace();
	    }
		catch(Exception e){
	      e.printStackTrace();
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database (retrieving current game).");
		}
                
            return userID;
	}

	public int getCurrentScore() {
		return currentScore;
	}
	public void setCurrentScore(int currentScore) {
		this.currentScore = currentScore;
	}
	public int getHighestScore() {
		return highestScore;
	}
	public void setHighestScore(int highestScore) {
		this.highestScore = highestScore;
	}

}