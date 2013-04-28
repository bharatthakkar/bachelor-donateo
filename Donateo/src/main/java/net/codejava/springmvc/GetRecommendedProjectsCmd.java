package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;

import net.codejava.springmodels.Campaign;
import net.codejava.springmodels.Cases;
import net.codejava.springmodels.Crowdfundings;
import net.codejava.springmodels.Projects;

import snaq.db.ConnectionPool;

public class GetRecommendedProjectsCmd implements Command {

	@Override
	public Hashtable execute(Hashtable htblInputParams) {
		ConnectionPool pool = (ConnectionPool)htblInputParams.get("pool");
		
		Hashtable htblOutputParams = new Hashtable();
		
		htblOutputParams.put("pool", pool);
		
		Connection con = null;
		long timeout = 10000; // 3 second timeout
		try {
			con = pool.getConnection(timeout);
			
			if (con != null) {
				// ...use the connection...
				CallableStatement cStmt = con.prepareCall("{call getRecommendedProjects(?)}");

				cStmt.registerOutParameter("success_msg", Types.LONGVARCHAR);
				cStmt.execute();

				String success_message;
				try {
					//there aren't any recommended projects
					success_message = cStmt.getString("success_msg");
					System.out.println(success_message);
				} catch (Exception e) {
					//there are recommended projects
					System.out.println("it has values");
					ArrayList<Projects> recommended_projects = new ArrayList<Projects>();
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
							
//							int num_attending_members;
//							try {
//								num_attending_members = rs.getInt("num_attending_members");
//								System.out.println("always can enter");
//							} catch (Exception e2) {
//								System.out.println("always can enter*");
//								// TODO: handle exception
//								num_attending_members = -1;
//							}
//							
//							boolean verified = false;
//							boolean isCrowdfunding;
//							try {
//								verified = rs.getBoolean("verified");
//								isCrowdfunding = true;
//								System.out.println("came here");
//							} catch (Exception e2) {
//								// TODO: handle exception
//								isCrowdfunding = false;
//								System.out.println("came here too");
//							}
							
							//create a project object
							Projects p = new Projects(project_id, ngo_id, project_name, description, deadline, start_date, done,completed,  volunteer, donate_money, donate_object, collected_amount, amount, urgency_id);
//							if (num_attending_members == -1) {
//								//this is not a campaign
//								if (isCrowdfunding) {
//									//this is crowd funding
//									p = new Crowdfundings(project_id, ngo_id, project_name, description, deadline, start_date, done, completed, volunteer, donate_money, donate_object, collected_amount, amount, urgency_id, verified);
//									System.out.println("This is crowd funding");
//								}
//								else if (!isCrowdfunding){
//									//it is not a crowd funding project, its a case
//									p = new Cases(project_id, ngo_id, project_name, description, deadline, start_date, done, completed, volunteer, donate_money, donate_object, collected_amount, amount, urgency_id);
//									System.out.println("This is a case");
//								}
//							}
//							else {
//								p = new Campaign(project_id, ngo_id, project_name, description, deadline, start_date, done, completed, volunteer, donate_money, donate_object, collected_amount, amount, urgency_id, num_attending_members);
//								System.out.println("This is a campaign");
//							}
							
							System.out.println("project name: " + p.getProject_name());
							recommended_projects.add(p);

						}

					
					htblOutputParams.put("getRecommendedProjects", recommended_projects);
					
					
				}

				
				cStmt.close();

				//conn.close();
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
				//pool.release();
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
