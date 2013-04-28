package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import net.codejava.springmodels.NGO_Notification;

public class ListNGONotificationsCmd implements Command {

	@Override
	public Hashtable execute(Hashtable htblInputParams) {

		try {

			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = null;

			try {
				Hashtable<String, Object> result = new Hashtable<String, Object>();

				conn = DriverManager
						.getConnection(
								"jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
								"orange", "");
				System.out.println("connection established");

				Set set = htblInputParams.entrySet();
				Iterator it = set.iterator();
				Map.Entry entry = (Map.Entry) it.next();
				int ngo_id = (Integer) entry.getValue();

				CallableStatement listNGONotifications = conn
						.prepareCall("{call listNGONotifications(? , ?)}");
				System.out.println("procedure called");
				listNGONotifications.setInt("NGO_id", ngo_id);
				listNGONotifications.registerOutParameter(2, Types.VARCHAR);

				ResultSet rs = null;
				rs = listNGONotifications.executeQuery();
				ArrayList<NGO_Notification> notifications = new ArrayList<NGO_Notification>();
				System.out.println("success message is: "
						+ listNGONotifications.getString(2));

				if (listNGONotifications.getString("output_msg") == null
						|| listNGONotifications.getString("output_msg").equals(
								"")) { // success

					while (rs.next()) {
						notifications.add(new NGO_Notification(rs
								.getInt("notification_id"), ngo_id, rs
								.getInt("project_id"), rs
								.getString("notification_type"), rs
								.getString("notification_content")));

					}

					result.put("listNGOnotifications", notifications);
					Set entrySet = result.entrySet();
					Iterator itr = entrySet.iterator();
					System.out.println("Hashtable entries : ");
					while (itr.hasNext())
						System.out.println(itr.next());
					return result;
				} else if (listNGONotifications.getString("output_msg").equals(
						"No notifications")) { // failure
					result.put("listNGOnotifications",
							"You currently have no notifications");
					System.out.println("You currently have no notifications.");
					return result;
				}

			} catch (SQLException e) {
				System.out.println("SQLException: " + e.getMessage());
				System.out.println("ErrorCode: " + e.getErrorCode());
				e.printStackTrace();
			}

		}

		catch (ClassNotFoundException e) {

			System.out.println("Class not found exception");
			e.printStackTrace();
		}
		return null;
	}

	public static void main(String[] args) {
		ListNGONotificationsCmd list = new ListNGONotificationsCmd();
		Hashtable input = new Hashtable();
		input.put("ngo_id", 1);
		ListNGONotificationsCmd l = new ListNGONotificationsCmd();
		Hashtable out = l.execute(input);
		System.out.println("end of main");
	}

}