package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class CreateCampaignCmd implements Command {

	@Override
	public Hashtable execute(Hashtable htblInputParams) {
		Hashtable<String, String> result = new Hashtable<String, String>();
		try {

			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = null;

			try {
				conn = DriverManager
						.getConnection(
								"jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
								"root", "");

				Set set = htblInputParams.entrySet();
				Iterator it = set.iterator();

				String name = "", location = "", description = "", endDate = "", startDate = "";
				boolean isObject = false, isVolunteer = false, isMoney = false;
				int amount = 0, urgency_id = -1, ngo_id = -1, project_id = -1;
				int category_id = -1;

				ArrayList<String> categories = new ArrayList<String>();
				ArrayList<String> objects = new ArrayList<String>();

				while (it.hasNext()) {
					Map.Entry entry = (Map.Entry) it.next();
					System.out.println(entry.getKey() + " : "
							+ entry.getValue());

					if (entry.getKey().equals("ngo_id")) 
						ngo_id = Integer.parseInt((String) entry.getValue());
					 else if (entry.getKey().equals("isObject")) 
						isObject = true;
					 else if (entry.getKey().equals("isVolunteer"))
						isVolunteer = true;
					 else if (entry.getKey().equals("isMoney")) 
						isMoney = true;
					 else if (entry.getKey().equals("name")) 
						name = (String) entry.getValue();
					 else if (entry.getKey().equals("location")) 
						location = (String) entry.getValue();
					 else if (entry.getKey().equals("description")) 
						description = (String) entry.getValue();
					 else if (entry.getKey().equals("amount")) 
						amount = Integer.parseInt((String) entry.getValue());
					 else if (entry.getKey().equals("urgency_id")) 
						urgency_id = Integer.parseInt((String) entry.getValue());
					 else if (entry.getKey().equals("categories"))
						categories = (ArrayList<String>) entry.getValue();
					else if (entry.getKey().equals("objects")) 
						objects = (ArrayList<String>) entry.getValue();
					 else if (entry.getKey().equals("from")) {
						startDate = (String) entry.getValue();
					} else if (entry.getKey().equals("to")) {
						endDate = (String) entry.getValue();
					}
				}
				CallableStatement createCampaign = conn
						.prepareCall("{call createCampaign(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");

				createCampaign.setInt("urg_id", urgency_id);
				createCampaign.setString("p_name", name);
				createCampaign.setInt("NGO_id", ngo_id);
				createCampaign.setString("p_description", description);
				createCampaign.setString("p_location", location);
				createCampaign.setBoolean("isVolunteer", isVolunteer);
				createCampaign.setBoolean("isMoney", isMoney);
				createCampaign.setBoolean("isObject", isObject);
				createCampaign.setInt("p_amount", amount);
				createCampaign.setTimestamp("p_deadline", new Timestamp(2014,
						10, 2, 0, 0, 0, 0));
				createCampaign.setTimestamp("p_start_date", new Timestamp(2018,
						10, 2, 0, 0, 0, 0));

				// createCampaign.setTimestamp("p_deadline", deadline);
				// createCampaign.setTimestamp("p_deadline", deadline);

				createCampaign.registerOutParameter("p_id", Types.INTEGER);
				createCampaign
						.registerOutParameter("output_msg", Types.VARCHAR);
				createCampaign.execute();

				if (createCampaign.getString("output_msg").equals("")
						|| createCampaign.getString("output_msg") == null) { // success
					project_id = createCampaign.getInt("p_id");

					// ADDING CATEGORIES!
					CallableStatement getCategoryID = conn
							.prepareCall("{call getCategoryID(?, ?)}");
					CallableStatement addCategory = conn
							.prepareCall("{call addCategoryToProject(?, ?)}");

					for (int i = 0; i < categories.size(); i++) {
						// 2- get the id of category

						getCategoryID.setString("categoryName",
								categories.get(i));
						getCategoryID.registerOutParameter(2, Types.VARCHAR);
						getCategoryID.execute();
						if (getCategoryID.getString("success_msg").equals(
								"This Category does not exist")) {
							result.put("error_message",
									"Something went wrong, please refresh and retry.");
							return result;
						} else { // returned cat_id in form of string
							category_id = Integer.parseInt(getCategoryID
									.getString("success_msg"));
						}
						// 3- add it to project (addcategorytoproject)
						
						addCategory.setInt("p_id", project_id);
						addCategory.setInt("c_id", category_id);
						addCategory.execute();

					}

					// ADDING OBJECTS!
					CallableStatement addObjectToProject = conn
							.prepareCall("{call addObjectToProject(?, ?, ?, ?)}");
					for (int i = 0; i < objects.size(); i += 2) {

						addObjectToProject.setInt("pID", project_id);
						addObjectToProject.setString("objName", objects.get(i));
						addObjectToProject.setInt("objQuantity",
								Integer.parseInt(objects.get(i + 1)));
						addObjectToProject.registerOutParameter(4,
								Types.VARCHAR);
						addObjectToProject.execute();

					}
					System.out.println("campaign created");
				} else if (createCampaign.getString("output_msg").equals(
						"Project name exist")) {
					result.put("error_message",
							"Project name already exists! Please choose another name.");
					System.out
							.println("Project name already exists! Please choose another name");
				}

			} catch (SQLException e) {
				System.out.println("SQLException: " + e.getMessage());
				System.out.println("ErrorCode: " + e.getErrorCode());
				e.printStackTrace();

			}
		} catch (ClassNotFoundException e) {

			// TODO Auto-generated catch block
			System.out.println("Class not found exception");
			e.printStackTrace();
		}

		return result;
	}

}
