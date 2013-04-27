package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;

import net.codejava.springmodels.Projects;
import snaq.db.ConnectionPool;

public class GetUrgentProjectsCmd implements Command {

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
						.prepareCall("{call getUrgentProjects(?)}");

				cStmt.registerOutParameter("success_msg", Types.LONGVARCHAR);
				cStmt.execute();

				String success_message;
				try {
					// there aren't any recommended projects
					success_message = cStmt.getString("success_msg");
					System.out.println(success_message);
				} catch (Exception e) {
					// there are recommended projects
					System.out.println("it has values");
					ArrayList<Projects> urgent_projects = new ArrayList<Projects>();
					ResultSet rs = cStmt.executeQuery();
					while (rs.next()) {
						System.out.println("there are items");
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
						int urgency_id = rs.getInt("urgency_id");

						// create a project object
						Projects p = new Projects(project_id, ngo_id,
								project_name, description, deadline,
								start_date, done, volunteer, donate_money,
								donate_object, collected_amount, amount,
								urgency_id);

						System.out.println("project name: "
								+ p.getProject_name());
						urgent_projects.add(p);

					}

					htblOutputParams.put("getUrgentProjects", urgent_projects);

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
