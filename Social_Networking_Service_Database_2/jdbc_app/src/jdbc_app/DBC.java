package jdbc_app;

import java.sql.*;

public class DBC 
{
	Connection _conn;
	
	public DBC() throws Exception 
	{  
		try 
		{
			Class.forName("org.postgresql.Driver");
		}
		catch (java.lang.ClassNotFoundException e) 
		{  
			java.lang.System.err.println("ClassNotFoundException: Postgres JDBC");  
			java.lang.System.err.println(e.getMessage());
			throw new Exception("No JDBC Driver found in Server");
		}
		try 
		{
			_conn =  DriverManager.getConnection("jdbc:postgresql://localhost:5432/SNS","postgres","1111");
     		_conn.setAutoCommit(false);
			_conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
		}
		catch (SQLException E) 
		{
			java.lang.System.out.println("SQLException: " + E.getMessage());
			java.lang.System.out.println("SQLState: " + E.getSQLState());
			java.lang.System.out.println("VendorError: " + E.getErrorCode());
			throw E;
		}
	}
	
	public void close()
	{
		try 
		{
			_conn.close();
		} 
		catch (SQLException E) 
		{
			java.lang.System.out.println("SQLException: " + E.getMessage());
			java.lang.System.out.println("SQLState: " + E.getSQLState());
			java.lang.System.out.println("VendorError: " + E.getErrorCode());
			E.printStackTrace();
		}
	}
	
	public void commit()
	{
		try 
		{
			_conn.commit();
		} 
		catch (SQLException E) 
		{
			java.lang.System.out.println("SQLException: " + E.getMessage());
			java.lang.System.out.println("SQLState: " + E.getSQLState());
			java.lang.System.out.println("VendorError: " + E.getErrorCode());
			E.printStackTrace();
		}
	}
	
	public void rollback()
	{
		try 
		{
			_conn.rollback();
		}
		catch (SQLException E) 
		{
			java.lang.System.out.println("SQLException: " + E.getMessage());
			java.lang.System.out.println("SQLState: " + E.getSQLState());
			java.lang.System.out.println("VendorError: " + E.getErrorCode());
			E.printStackTrace();
		}
	}
	
}