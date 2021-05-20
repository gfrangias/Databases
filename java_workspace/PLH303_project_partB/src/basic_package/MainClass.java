package basic_package;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class MainClass{
	public static void main(String[] args)
	{

		Scanner input= new Scanner(System.in);
		Scanner input_int= new Scanner(System.in);

		System.out.println("WELCOME TO THE DATABASE MANAGER!");
		/*		
		System.out.print("Please enter database IP address: ");
		String ip_address= input.nextLine();

		System.out.print("Please enter database name: ");
		String db_name= input.nextLine();

		System.out.print("Please enter username: ");
		String username= input.nextLine();

		System.out.print("Please enter password: ");
		String password= input.nextLine();*/

		int menu_sel = 1;

		String ip_address = "localhost:5432";
		String db_name = "PLH303_project";
		String username = "postgres";
		String password = "plh303";
		String hotel_prefix = null;
		int hotel_index = -1;
		int query_sel = -1;

		while(menu_sel == 1) {
			try {
				Database db= new Database(ip_address, db_name, username, password);
				Statement st = db._conn.createStatement();

				System.out.print("Search hotel name: ");
				hotel_prefix = input.nextLine();

				ResultSet rs =  st.executeQuery("SELECT \"idHotel\", \"name\" "
						+ "FROM hotel WHERE left(\"name\", "
						+ "LENGTH('"+hotel_prefix+"')) = '"+hotel_prefix+"'"
						+ "ORDER BY \"name\" ASC");

				if (!rs.isBeforeFirst()) {
					System.out.println("No hotel with prefix: \""+hotel_prefix+"\"");
					System.out.println("Do you wish to restart the query?");
					System.out.println("Type '1'/'0' for yes/no:");
					menu_sel = input_int.nextInt();
				}else {

					while (rs.next()) {
						System.out.println( rs.getRow() +". Hotel ID: "+rs.getInt(1) +"  Name: "+rs.getString(2));
					}
					System.out.println("Please select one of the hotels above: ");
					hotel_index = input_int.nextInt();

					rs =  st.executeQuery("SELECT \"idHotel\", \"name\" "
							+ "FROM hotel WHERE left(\"name\", "
							+ "LENGTH('"+hotel_prefix+"')) = '"+hotel_prefix+"'"
									+ " ORDER BY \"name\" ASC;");

					for(int i=0; i < hotel_index; i++) {
						rs.next();
					}

					System.out.println("Please select one of the queries above: ");
					query_sel = input_int.nextInt();

					switch(query_sel) {
					case 1:
						
						break;
					case 2:
						break;
					case 3:
						break;
					default:
						break;
					}


				}
				rs.close();
				st.close();
			}catch (Exception ex) {  ex.printStackTrace();
			}
		}
	}

}