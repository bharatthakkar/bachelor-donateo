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

import net.codejava.springmodels.Cases;

public class ListNGOcurrentCasesCmd implements Command {

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

				Set set = htblInputParams.entrySet();
				Iterator it = set.iterator();
				Map.Entry entry = (Map.Entry) it.next();

				int ngo_id = (Integer) entry.getValue();

				CallableStatement listNGOCurrentCases = conn
						.prepareCall("{call listNGOCurrentCases(? , ?)}");

				listNGOCurrentCases.setInt("NGO_id", ngo_id);
				listNGOCurrentCases.registerOutParameter(2, Types.VARCHAR); // success

				ResultSet rs = null;
				rs = listNGOCurrentCases.executeQuery();
				ArrayList<Cases> projects = new ArrayList<Cases>();
				System.out.println("output message is: "
						+ listNGOCurrentCases.getString(2));

				if (listNGOCurrentCases.getString("output_msg").equals("")
						|| listNGOCurrentCases.getString("output_msg") == null) { // success

					while (rs.next()) {
						System.out.println("I have results in rs");

						projects.add(new Cases(rs.getInt("project_id"), rs
								.getInt("ngo_id"),
								rs.getString("project_name"), rs
										.getString("description"), rs
										.getDate("deadline"), rs
										.getDate("start_date"), rs
										.getBoolean("done"), rs
										.getBoolean("completed"), rs
										.getBoolean("volunteer"), rs
										.getBoolean("donate_money"), rs
										.getBoolean("donate_object"), rs
										.getInt("collected_amount"), rs
										.getInt("amount"), rs
										.getInt("urgency_id")));
					}

					result.put("listNGOcurrentCases", projects);
					Set entrySet = result.entrySet();
					Iterator itr = entrySet.iterator();
					System.out.println("Hashtable entries : ");
					while (itr.hasNext())
						System.out.println(itr.next());
					return result;
				}
				// failure, nothing to display
				else if (listNGOCurrentCases.getString("output_msg").equals(
						"No cases")) {
					result.put("listNGOcurrentCases",
							"You do not have any current cases.");
					System.out.println("You do not have any current cases.");
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
		ListNGOcurrentCasesCmd list = new ListNGOcurrentCasesCmd();
		Hashtable input = new Hashtable();
		input.put("ngo_id", 1);
		ListNGOcurrentCasesCmd l = new ListNGOcurrentCasesCmd();
		Hashtable out = l.execute(input);
		System.out.println("end of main");
	}

}