package basic_package;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class MainClass{
	@SuppressWarnings("resource")
	public static void main(String[] args)
	{

		Scanner input= new Scanner(System.in);
		Scanner input_int= new Scanner(System.in);
		Scanner input_double = new Scanner(System.in);
		
		System.out.println("WELCOME TO THE DATABASE MANAGER!");
		System.out.println();
				
		System.out.print("Please enter database IP address: ");
		String ip_address= input.nextLine();

		System.out.print("Please enter database name: ");
		String db_name= input.nextLine();

		System.out.print("Please enter username: ");
		String username= input.nextLine();

		System.out.print("Please enter password: ");
		String password= input.nextLine();

		int menu_sel = 1;

		//String ip_address = "localhost:5432";
		//String db_name = "PLH303_project";
		//String username = "postgres";
		//String password = "plh303";
		String hotel_prefix = null;
		String lname_prefix = null;
		int hotel_index = -1;
		int query_sel = -1;
		int client_id = -1;
		int roombookings_index = -1;
		String checkin_update = null;
		String checkout_update = null;
		double rate_update = -1;
		int hotel_id = -1;
		String new_checkin = null;
		String new_checkout = null;
		int rooms_index = -1;
		int room_id = -1;
		
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
					System.out.println("No hotel starting with: \""+hotel_prefix+"\"");
					System.out.println("Do you wish to restart the query?");
					System.out.println("Type '1'/'0' for yes/no:");
					menu_sel = input_int.nextInt();
				}else {

					while (rs.next()) {
						System.out.println( rs.getRow() +". Hotel ID: "+rs.getInt(1) +"  Name: "+rs.getString(2));
					}
					System.out.println();
					System.out.println("Please select one of the hotels above: ");
					hotel_index = input_int.nextInt();

					rs =  st.executeQuery("SELECT \"idHotel\", \"name\" "
							+ "FROM hotel WHERE left(\"name\", "
							+ "LENGTH('"+hotel_prefix+"')) = '"+hotel_prefix+"'"
							+ " ORDER BY \"name\" ASC;");

					for(int i=0; i < hotel_index; i++) {
						rs.next();
					}

					hotel_id = rs.getInt(1);
					
					System.out.println();
					System.out.println("1. Search all hotel clients' details");
					System.out.println("2. Show client's room bookings");
					System.out.println("3. Create a new room booking checking vacancy");
					System.out.println();
					System.out.println("Please select one of the queries above: ");
					query_sel = input_int.nextInt();
					
					switch(query_sel) {
					case 1:
						System.out.println();
						System.out.print("Search client's last name: ");
						lname_prefix = input.nextLine();
						
						rs =  st.executeQuery("SELECT * FROM person_details_prefix('"+hotel_id+"','"+lname_prefix+"');");
						
						System.out.println();
						System.out.printf("%-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s \n",
								"Person ID", "First Name", "Last Name", "Sex", "Date of Birth", "Address", "City", "Country");
						System.out.printf("----------------------------------------------------------------"
								+ "------------------------------------------------------------------------------------------------------------\n");
						while (rs.next()) {
							System.out.printf("%-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s \n",
									rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5),
									rs.getString(6), rs.getString(7), rs.getString(8));
						}
						
						System.out.println();
						System.out.println("Do you wish to restart the query?");
						System.out.println("Type '1'/'0' for yes/no:");
						menu_sel = input_int.nextInt();
						break;
					case 2:
						System.out.println();
						System.out.print("Please enter client's ID: ");
						client_id = input_int.nextInt();
						rs =  st.executeQuery("SELECT * FROM client_roombookings('"+client_id+"', '"+hotel_id+"');");
						
						System.out.println();
						System.out.printf("%-20s %-20s %-20s %-20s %-20s \n",
								"Index", "Room ID", "Checkin", "Checkout", "Rate");
						System.out.printf("-----------------------------------------------------------------------------\n");
						while (rs.next()) {
							System.out.printf("%-20s %-20s %-20s %-20s %-20s \n",
									rs.getRow(), rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4));
						}	
						
						System.out.println();
						System.out.println("Please select one of the room bookings above to update");
						System.out.println("Select '0' to get redirected to the start menu: ");
						roombookings_index = input_int.nextInt();
						
						if(roombookings_index == 0) {
							break;
						}
						
						rs =  st.executeQuery("SELECT * FROM client_roombookings('"+client_id+"', '"+hotel_id+"');");
						for(int i=0; i < roombookings_index; i++) {
							rs.next();
						}
						
						System.out.println();
						System.out.println("Please enter new checkin date (in format yyyy-mm-dd): ");
						checkin_update = input.nextLine();
						
						System.out.println();
						System.out.println("Please enter new checkout date (in format yyyy-mm-dd): ");
						checkout_update = input.nextLine();	
						
						System.out.println();
						System.out.println("Please enter new room rate: ");
						rate_update = input_double.nextDouble();	

						st.executeUpdate("UPDATE roombooking "
								+ "SET checkin = date '"+checkin_update+"', checkout = date '"+checkout_update+"'"
								+", rate = '"+rate_update+"'"
								+ "WHERE checkin = date '"+rs.getString(2)+"' AND \"roomID\" = '"+rs.getString(1)+"' ");
						
						System.out.println();
						System.out.println("Do you wish to restart the query?");
						System.out.println("Type '1'/'0' for yes/no:");
						menu_sel = input_int.nextInt();
						
						break;
					case 3:
						
						System.out.println();
						System.out.println("Please enter a new checkin date (in format yyyy-mm-dd): ");
						new_checkin = input.nextLine();
						
						System.out.println();
						System.out.println("Please enter a new checkout date (in format yyyy-mm-dd): ");
						new_checkout = input.nextLine();	
						
						rs =  st.executeQuery("SELECT * FROM rooms_available('"+new_checkin+"','"+new_checkout+"','"+hotel_id+"');");
						
						System.out.println();
						System.out.printf("%-20s %-20s %-20s %-20s \n",
								"Index", "Room ID", "Number", "Room Type");
						System.out.printf("-----------------------------------------------------------------------------\n");
						while (rs.next()) {
							System.out.printf("%-20s %-20s %-20s %-20s \n",
									rs.getRow(), rs.getInt(1), rs.getString(2), rs.getString(3));
						}
						
						System.out.println();
						System.out.println("Please select one of the rooms above to book: ");
						rooms_index = input_int.nextInt();
						
						rs =  st.executeQuery("SELECT * FROM rooms_available('"+new_checkin+"','"+new_checkout+"','"+hotel_id+"');");
						
						for(int i=0; i < rooms_index; i++) {
							rs.next();
						}
						
						room_id = rs.getInt(1);
						
						System.out.println();
						System.out.println("Please enter the client's ID: ");
						client_id = input_int.nextInt();
						
						st.executeUpdate(
								"INSERT INTO hotelbooking(reservationdate, cancellationdate, \"bookedbyclientID\", payed)"+ 
								"VALUES (NOW()::date, date '"+new_checkin+"' - integer '10','"+client_id+"' , '0');"
						);
						
						st.executeUpdate(
								"INSERT INTO roombooking(\"hotelbookingID\", \"roomID\", \"bookedforpersonID\", checkin, checkout)"+
								"VALUES ((SELECT idhotelbooking FROM hotelbooking ORDER BY idhotelbooking DESC LIMIT 1),"+
								"'"+room_id+"', '"+client_id+"', '"+new_checkin+"', '"+new_checkout+"');"								
						);
						
						System.out.println();
						System.out.println("Do you wish to restart the query?");
						System.out.println("Type '1'/'0' for yes/no:");
						menu_sel = input_int.nextInt();
						
						break;
					default:
						System.out.println();
						System.out.println("Wrong input!");
						System.out.println("Do you wish to restart the query?");
						System.out.println("Type '1'/'0' for yes/no:");
						menu_sel = input_int.nextInt();
						
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