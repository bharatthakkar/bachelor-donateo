package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

import javax.servlet.http.HttpSession;

import net.codejava.springmodels.Projects;

public class FilterByTypeAndCategoryCmd {
	public static Hashtable execute(Hashtable table) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			try {
				conn = DriverManager
						.getConnection(
								"jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
								"orange", "");

				Set set = table.entrySet();
				Iterator it = set.iterator();
				int category_id = 0;
				String p_type = "";
				while (it.hasNext()) {
					Map.Entry entry = (Map.Entry) it.next();
					if (entry.getKey().equals("category_id")) {
						category_id = (Integer) entry.getValue();
					} else if (entry.getKey().equals("p_type")) {
						p_type = (String) entry.getValue();
					}
				}

				CallableStatement filter = conn
						.prepareCall("{call getProjectsByTypeCategory(? , ? , ?)}");
				System.out.println("procedure called");
				filter.registerOutParameter(3, Types.VARCHAR);
				filter.setInt("cat_id", category_id);
				filter.setString("p_type", p_type);
				boolean hadResults = filter.execute();
				System.out.println("procedure executed");
				Hashtable<String, Object> out = new Hashtable<String, Object>();
				ResultSet rs = null;
				// System.out.println("1");
				String success_msg = "";
				success_msg = filter.getString(3);
				ArrayList<Projects> projects = new ArrayList<Projects>();
				if (success_msg != null) {
					if (success_msg.equals("This category does not exist")) {
						out.put("FilterByTypeAndCategoryError", success_msg);
						out.put("FilterByTypeAndCategory", projects);
						System.out.println(success_msg);
						return out;
					} else if (success_msg.equals("No projects of this type")) {
						out.put("FilterByTypeAndCategoryError", success_msg);
						out.put("FilterByTypeAndCategory", projects);
						System.out.println(success_msg);
						return out;
					} else if (success_msg
							.equals("No projects of this category")) {
						out.put("FilterByTypeAndCategoryError", success_msg);
						out.put("FilterByTypeAndCategory", projects);
						System.out.println(success_msg);
						return out;
					}
				}

				if (hadResults) {
					rs = filter.getResultSet();
					while (rs.next()) {
						projects.add(new Projects(rs.getInt("project_id"), rs
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
						System.out.println(rs.getInt("project_id"));
						System.out.println(rs.getString("project_name"));
					}
					hadResults = filter.getMoreResults();
				}
				out.put("FilterByTypeAndCategory", projects);
				out.put("FilterByTypeAndCategoryError", "");
				return out;
				// System.out.println("2");

				/*
				 * else{ while(rs.next()){ int x = rs.getInt(0); String y =
				 * rs.getString(2); System.out.println(x);
				 * System.out.println(y); out.put(x, y);
				 * 
				 * } }
				 */
				// System.out.println("3");

			}

			catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("went heree**************");
		}

		return table;
	}

	public static void main(String[] args) {
		Hashtable<String, Object> in = new Hashtable<String, Object>();
		in.put("category_id", 1);
		in.put("p_type", "Campaign");
		FilterByTypeAndCategoryCmd f = new FilterByTypeAndCategoryCmd();
		Hashtable<String, Object> out = new Hashtable<String, Object>();
		out = f.execute(in);
	}

	private static String getString(String string) {
		// TODO Auto-generated method stub
		return null;
	}
}
