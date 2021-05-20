package basic_package;
import java.sql.*;

public class Database {

	Connection _conn;
	String ip_address, db_name, username, password;
	
	public Database(String ip_address, String db_name, String username, String password) throws Exception{
		this.ip_address = ip_address;
		this.db_name = db_name;
		this.username = username;
		this.password = password;
		
		// Connect to driver
		try {
			Class.forName("org.postgresql.Driver");
		}catch (java.lang.ClassNotFoundException e) {
			java.lang.System.err.print("ClassNotFoundException: Postgres JDBC");
			java.lang.System.err.println(e.getMessage());
			throw new Exception("No JDBC Driver found in Server");
		}

		try {
			_conn = 
		DriverManager.getConnection("jdbc:postgresql://"+ this.ip_address+ "/"+ this.db_name
				,this.username,this.password);
		}
			catch (SQLException E) {
				java.lang.System.out.println("SQLException: " + E.getMessage());
				java.lang.System.out.println("SQLState:     " + E.getSQLState());
				java.lang.System.out.println("VendorError:  " + E.getErrorCode());
				throw E;
			}
		}
}
