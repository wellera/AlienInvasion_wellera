package edu.pitt.is1017.spaceinvaders;

/**
 * The User Object contains all information required to identify a
 * user in the database, create a new user, and/or update user info.
 * 
 * @author Alison Weller
 */

import java.sql.ResultSet;
import javax.swing.JOptionPane;

public class User{
	
	private int userID;
	private String lastName;
	private String firstName;
	private String email;
	private String password;
	private boolean loggedIn = false;

	public User(int userID){
		try{
			DbUtilities db = new DbUtilities();
			String sql = "SELECT * FROM users WHERE userID = " + userID + "; ";
			ResultSet rs = db.getResultSet(sql);
			if(rs.next()){
				this.userID = userID;
				this.lastName = rs.getString("lastName");
				this.firstName = rs.getString("firstName");
				this.email = rs.getString("email");
				this.password = rs.getString("password");
				setLoggedIn(true);
			}
			else{
				JOptionPane.showMessageDialog(null, "User not found.");
			}
			db.closeDbConnection(); // Close connection ///IS THIS IN THE RIGHT SPOT??
		}
		catch(Exception ex){
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database. Please try again.");
		}
	}
	
	//for an existing user logging into the system...
	public User(String email, String password){
		try{
			DbUtilities db = new DbUtilities();
			String sql = "SELECT * FROM users WHERE email = '" + email + "' AND password = MD5('" + password + "');";
			ResultSet rs = db.getResultSet(sql);
			if(rs.next()){
				this.userID = rs.getInt("userID");
				this.lastName = rs.getString("lastName");
				this.firstName = rs.getString("firstName");
				this.email = rs.getString("email");
				this.password = rs.getString("password");
				setLoggedIn(true);
				//System.out.println(rs);//FOR TESTING
			}
			else{
                                setLoggedIn(false);
				//JOptionPane.showMessageDialog(null, "Login failed. Please check your email and password and try again.");
			}
			db.closeDbConnection(); // Close connection 
		}
		catch(Exception ex){
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database. Please try again.");
		}
		
		if (isLoggedIn()){
			//JOptionPane.showMessageDialog(null, "Login successful! Welcome.");//no longer needed; launch game instead
			Thread t = new Thread("gameLaunchThread"){
				public void run(){
					//Game game = new Game(getUserID());
					//game.gameLoop();
				}
			};
			t.start();
			
		}
	}
	
	public User(String lastName, String firstName, String email, String password){
		this.lastName=lastName;
		this.firstName=firstName;
		this.email=email;
		this.password=password;
		setLoggedIn(true); // log in when creating new account?
		try{
			DbUtilities db = new DbUtilities();
			String sql = "INSERT INTO users (lastName,firstName,email,password) ";
			sql = sql + "VALUES('" + lastName + "', '" + firstName + "', '" + email + "', MD5('" + password + "'));";
			db.executeQuery(sql);
			db.closeDbConnection(); // Close connection ///IS THIS IN THE RIGHT SPOT??
		}
		catch(Exception ex){
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database. Please try again.");
		}
	}
	
	public void saveUserInfo(){
		try{
			DbUtilities db = new DbUtilities();
			String sql = "UPDATE users SET lastName='" + this.lastName + "', firstName='" + this.firstName + "',  "
					+ "email='" + this.email + "', password=MD5('" + this.password + "') "
							+ "WHERE userID = " + this.userID + "; ";//UPDATED CODE; TEST THIS//
			db.executeQuery(sql);
			db.closeDbConnection(); // Close connection ///IS THIS IN THE RIGHT SPOT??
		}
		catch(Exception ex){
			JOptionPane.showMessageDialog(null, "There was an error connecting to the database. Please try again.");
		}
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isLoggedIn() {
		return loggedIn;
	}

	public void setLoggedIn(boolean loggedIn) {
		this.loggedIn = loggedIn;
	}

	public int getUserID() {
		return userID;
	}


	
	
}
