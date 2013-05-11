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
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import net.codejava.springmodels.Campaign;
import net.codejava.springmodels.Crowdfundings;
import net.codejava.springmodels.Projects;


public class ListCfProjectsCmd {
	public static Hashtable execute(Hashtable table) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			try {
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
						"orange", "");
			
			/*Set set = table.entrySet();
			Iterator it = set.iterator();
			int user_id;
			Map.Entry entry = (Map.Entry) it.next();
			user_id =  (Integer)entry.getValue();*/
			CallableStatement listcfprojects = conn.prepareCall("{call listCfProjects(?)}");
			listcfprojects.registerOutParameter(1, Types.VARCHAR);
			boolean hadResults = listcfprojects.execute();
			Hashtable<String , Object> out = new Hashtable<String , Object>();
			ResultSet rs = null;
			//System.out.println("1");
			String output = "";
			output = listcfprojects.getString("output_msg");
			System.out.println("output " + output);
			ArrayList<Crowdfundings> listOfCf = new ArrayList<Crowdfundings>();
			if(output != null){ 
				out.put("listCfProjectsError", output);
				System.out.println("output 2 " +output);
				out.put("listAllProjects" , listOfCf);
				return out;
			}
				
				if(hadResults){
					  rs = listcfprojects.getResultSet();
					  while(rs.next()){
						  listOfCf.add(new Crowdfundings(rs.getInt("project_id"), rs
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
											.getInt("urgency_id"), rs
											.getBoolean("verified")));
						  System.out.println(rs.getInt("project_id"));
						  System.out.println(rs.getString("project_name"));
					  }
				 
				  hadResults = listcfprojects.getMoreResults();
				}
					
			out.put("listCfProjects", listOfCf);
			out.put("listCfProjectsError" , "");
			return out;
			//System.out.println("2");
			
			/*else{
				while(rs.next()){
					int x = rs.getInt(0);
					String y = rs.getString(2);
					System.out.println(x);
					System.out.println(y);
					out.put(x, y);
					
				}
			}*/
			//System.out.println("3");
			
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
		Hashtable projects = new Hashtable();
		ListCfProjectsCmd listmyprojects = new ListCfProjectsCmd();
		Hashtable<String, Object> in = new Hashtable<String, Object>();
		in = listmyprojects.execute(projects);
		System.out.println("main executed");

	}

	

}
