package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;

import net.codejava.springmodels.Cases;
import net.codejava.springmodels.Crowdfundings;
import snaq.db.ConnectionPool;

public class ListMyCurrentCrowdfundingsCmd implements Command {

	@Override
	public Hashtable execute(Hashtable htblInputParams) {
		
		ConnectionPool pool = (ConnectionPool) htblInputParams.get("pool");

		Hashtable htblOutputParams = new Hashtable();

		htblOutputParams.put("pool", pool);

		Connection con = null;
		long timeout = 10000; // 3 second timeout
		try {
			con = pool.getConnection(timeout);

			if (con != null) {
				// ...use the connection...
				CallableStatement cStmt = con
						.prepareCall("{call listMyCurCrowdFundingProjects(?,?)}");
				
				int user_id = ((Integer)htblInputParams.get("user_id")).intValue();
				cStmt.setInt("id", user_id);
				cStmt.registerOutParameter("success_msg", Types.LONGVARCHAR);
				cStmt.execute();

				String success_message;
				try {
					// there aren't any recommended projects
					success_message = cStmt.getString("success_msg");
					htblOutputParams.put("success_msg", success_message);
					System.out.println(success_message);
				} catch (Exception e) {
					
					ArrayList<Crowdfundings> user_current_crowdfundings = new ArrayList<Crowdfundings>();
					ResultSet rs = cStmt.executeQuery();
					while (rs.next()) {
						int project_id = rs.getInt("project_id");
						int ngo_id = rs.getInt("ngo_id");
						String project_name = rs.getString("project_name");
						String description = rs.getString("description");
						String location = rs.getString("location");
						Date deadline = rs.getDate("deadline");
						Date start_date = rs.getDate("start_date");
						boolean done = rs.getBoolean("done");
						boolean completed = rs.getBoolean("completed");
						boolean volunteer = rs.getBoolean("volunteer");
						boolean donate_money = rs.getBoolean("donate_money");
						boolean donate_object = rs.getBoolean("donate_object");
						int collected_amount = rs.getInt("collected_amount");
						int amount = rs.getInt("amount");
						//int urgency_id = rs.getInt("urgency_id");

						// create a project object
						Crowdfundings c = new Crowdfundings(project_id, ngo_id, project_name, description, deadline, start_date, done, completed, volunteer, donate_money, donate_object, collected_amount, collected_amount,1,true);

						System.out.println("project name: "
								+ c.getProject_name());
						user_current_crowdfundings.add(c);

					}

					htblOutputParams.put("listMyCurrentCrowdfundings", user_current_crowdfundings);

				}

				cStmt.close();

				// conn.close();
				return htblOutputParams;

			} else {
				// ...do something else (timeout occurred)...
				System.out.println("The connection is null");
			}
		} catch (SQLException ex) {
			System.out.println("error in getting connection");
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		} finally {
			try {
				// pool.release();
				con.close();
			} catch (SQLException ex) {
				System.out.println("SQLException: " + ex.getMessage());
				System.out.println("SQLState: " + ex.getSQLState());
				System.out.println("VendorError: " + ex.getErrorCode());
			}
		}

		return null;
	}

}
