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

import net.codejava.springmodels.NGO_DeclareSuccessStr_Project;


public class ListSuccessStoriesCmd implements Command {

	@Override
	public Hashtable execute(Hashtable table) {

		try {

			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = null;

			try {
				Hashtable<String, Object> out = new Hashtable<String, Object>();

				conn = DriverManager
						.getConnection(
								"jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
								"orange", "");
				System.out.println("connection established");

				/*Set set = table.entrySet();
				Iterator it = set.iterator();
				Map.Entry entry = (Map.Entry) it.next();

				 int ngo_id = (Integer) entry.getValue();*/

				CallableStatement lss = conn.prepareCall("{call listSuccessStories(?)}");
				System.out.println("procedure called");
				System.out.println("procedure executed");
				lss.registerOutParameter(1, Types.VARCHAR);

				ResultSet rs = null;
				rs = lss.executeQuery();
				ArrayList<NGO_DeclareSuccessStr_Project> listOfSuccessStories = new ArrayList<NGO_DeclareSuccessStr_Project>();
				System.out.println("success message is: "
						+ lss.getString("output_msg"));

				if ( lss.getString("output_msg") == null) { 

					while (rs.next()) {
						System.out.println(rs.getInt("ngo_id"));
						System.out.println(rs.getInt("project_id"));
						System.out.println(rs.getString("story"));
						listOfSuccessStories.add(new NGO_DeclareSuccessStr_Project(rs.getInt("ngo_id"),
								rs.getInt("project_id"), rs.getString("story")));					
								}

					out.put("listSuccessStories", listOfSuccessStories);
					/*Set entrySet = result.entrySet();
					Iterator itr = entrySet.iterator();
					System.out.println("Hashtable entries : ");
					while (itr.hasNext())
						System.out.println(itr.next());
					return result;*/
				} else if (lss.getString("output_msg")
						.equals("No success stories")) { // failure
					out.put("error_msg", lss.getString("output_msg"));
					System.out.println("There are no suggested projects.");
					return out;
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
		ListSuccessStoriesCmd list = new ListSuccessStoriesCmd();
		Hashtable table = new Hashtable();
		Hashtable out = list.execute(table);
		System.out.println("end of main");
	}

}