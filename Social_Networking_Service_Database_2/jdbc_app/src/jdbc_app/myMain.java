package jdbc_app;

import java.sql.*;
import java.util.Scanner;

public class myMain 
{
	public static void main(String[] args) 
	{
		Scanner sc = new Scanner(System.in);
		int option, n;
		String email = null;
		boolean connected = false;
		DBC db = null;
		
		printMenu();
		System.out.print("Please choose an option to proceed : ");
		
		do
		{
			option = sc.nextInt();
			if(option < 1 || option > 8)
			{
				System.out.print("Please give valid input.");
				printMenu();
				System.out.print("Please choose an option to proceed : ");
			}
		}while(option < 1 || option > 8);
		
		do
		{			
			if(option == 1)
			{
				if(connected == false)
				{
					try
					{
						System.out.print("Connecting to Database...");
						db = new DBC();
						connected = true;
						System.out.print("Connected.\n");
					}
					catch (Exception ex) 
					{  
						System.out.print("Connection failed.");
						ex.printStackTrace();
					}
				}
				else
				{
					System.out.println("Database already connected.");
				}
			}
			else if(option == 2 && connected == true)
			{
				System.out.print("Please insert user e-mail to commence transaction.\nEmail : ");
				email = sc.next();	
			}
			else if(option == 3 && connected == true && email != null)
			{
				try
				{
					System.out.print("Aborting transaction. Rolling back changes.");
					db.rollback();
				}
				catch (Exception ex) 
				{  
					System.out.print("Abortion failed.");
					ex.printStackTrace();
				}				
			}
			else if(option == 4 && connected == true && email != null)
			{
				try
				{
					System.out.print("Commiting transaction. Validating changes.");
					db.commit();
				}
				catch (Exception ex) 
				{  
					System.out.print("Validation failed.");
					ex.printStackTrace();
				}				
			}
			else if(option == 5 && connected == true && email != null) //find professional network
			{
				System.out.print("Give n to find n-th level connection : ");
				sc.nextLine();
				do
				{
					n = sc.nextInt();
					if(n<0)
					{
						System.out.println("Please insert a positive integer.");
						System.out.print("Give n to find n-th level connection : ");
						
					}
				}while(n<0);
				
				System.out.print("\nPlease select a user from the list below to find his professional network.\n");
				
				try 
				{
					PreparedStatement pst = db._conn.prepareStatement("select email from member where email <> ?");
					pst.setString(1, email);
					ResultSet rs1 = pst.executeQuery();
					System.out.println("e-mail");
					while(rs1.next()) 
					{
						System.out.println(rs1.getString(1));
					}
					rs1.close();
					
					System.out.print("Input user's email : ");
					String user = sc.next();
					sc.nextLine();
					
					pst = db._conn.prepareStatement("select * from JDBC_func(?,?)");
					pst.setInt(1,n);
					pst.setString(2,user);
					ResultSet rs2 = pst.executeQuery();
					System.out.println("\nProfessional Network till level n = "+n+" of "+user+" is :\n");
					while(rs2.next()) 
					{
						System.out.println(rs2.getString(1));                       
					}
					rs2.close();
					pst.close();
				}
				catch (Exception ex) 
				{  
					ex.printStackTrace();
				}
			}
			else if(option == 6 && connected == true && email != null) //insert comment
			{
				System.out.print("Please select an article from the list below to comment.\n");
				
				try 
				{
					PreparedStatement pst = db._conn.prepareStatement("select * from article");
					ResultSet rs = pst.executeQuery();
					System.out.println("ArticleID	Title	CategoryID	theText  Date Posted   e-mail");
					while(rs.next()) 
					{
						System.out.println(rs.getInt(1)+" || "+rs.getString(2)+" || "+rs.getInt(3)+" || "+rs.getString(4)+" || "+rs.getDate(5)+" || "+rs.getString(6));                       
					}
					rs.close();
					
					System.out.print("Input article ID : ");
					int aID = sc.nextInt();
					sc.nextLine();
					System.out.print("Now input your comment: ");
					String cmt = sc.nextLine();
					
					pst = db._conn.prepareStatement("insert into article_comment(\"commentID\", \"theComment\", \"datePosted\", \"articleID\", email)"
							+ "values((select max(\"commentID\" + 1) from article_comment),?,current_date,?,?)");
					pst.setString(1,cmt);
					pst.setInt(2,aID);
					pst.setString(3,email);
					pst.executeUpdate();
					pst.close();
				}
				catch (Exception ex) 
				{  
					ex.printStackTrace();
				}
			}
			else if(option == 7 && connected == true && email != null) //send message
			{
				System.out.print("Please select a user from the list below to send a message to.\n");
				
				try 
				{
					PreparedStatement pst = db._conn.prepareStatement("select email from member where email <> ?");
					pst.setString(1, email);
					ResultSet rs = pst.executeQuery();
					System.out.println("e-mail");
					while(rs.next()) 
					{
						System.out.println(rs.getString(1));                       
					}
					rs.close();
					
					System.out.print("Input user's email : ");
					String msg_usr = sc.next();
					sc.nextLine();
					System.out.print("Now input the message's subject : ");
					String msg_subj = sc.nextLine();
					System.out.print("Now input the message you want to send : ");
					String msg = sc.nextLine();
					
					pst = db._conn.prepareStatement("insert into msg(\"msgID\", \"theSubject\", \"theText\", sender_email, receiver_email, \"dateSent\")"
							+ "values((select max(\"msgID\" + 1) from msg),?,?,?,?,current_date)");
					pst.setString(1,msg_subj);
					pst.setString(2,msg);
					pst.setString(3,email);
					pst.setString(4,msg_usr);
					pst.executeUpdate();
					pst.close();
				}
				catch (Exception ex) 
				{  
					ex.printStackTrace();
				}
			}
			else if(option == 8 && connected == true)
			{
				sc.close();
				db.close();
			}
			else
			{
				if(connected == false && option != 8)
				{
					System.out.print("\nYou must connect to the database first before running any other option.\n");
				}
				else if(email == null && option != 8)
				{
					System.out.print("\nYou must insert an e-mail first before selecting anything else.");
				}
			}
			
			if(option != 8)
			{
				printMenu();
				System.out.print("Please choose an option to proceed : ");
				
				do
				{
					option = sc.nextInt();
					if(option < 1 || option > 8)
					{
						System.out.print("Please give valid input.");
						printMenu();
						System.out.print("Please choose an option to proceed : ");
					}
				}while(option < 1 || option > 8);
			}			
		}while(option != 8);
		
		if(connected == true)
		{
			System.out.println("\nDatabase disconnected.");
		}

		System.out.println("Application Terminated.");
		
		return;
	}
	
	public static void printMenu()
	{
		System.out.println("\n\n************ DBC - Menu ************");
		System.out.println("1. Connect to Database.");
		System.out.println("2. Select user.");
		System.out.println("3. Abort Transaction.");
		System.out.println("4. Commit Transaction.");
		System.out.println("5. Find n-th level professional network.");
		System.out.println("6. Comment an article.");
		System.out.println("7. Send a message to another user.");
		System.out.println("8. Exit.\n\n");
	}
}