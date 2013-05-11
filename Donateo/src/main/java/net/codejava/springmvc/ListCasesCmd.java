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
import net.codejava.springmodels.Cases;
import net.codejava.springmodels.Projects;


public class ListCasesCmd {
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
			CallableStatement listcases = conn.prepareCall("{call listCases(?)}");
			listcases.registerOutParameter(1, Types.VARCHAR);
			boolean hadResults = listcases.execute();
			Hashtable<String , Object> out = new Hashtable<String , Object>();
			ResultSet rs = null;
			//System.out.println("1");
			String output = "";
			output = listcases.getString("output_msg");
			System.out.println("output " + output);
			ArrayList<Cases> listOfCases = new ArrayList<Cases>();
			if(output != null){ 
				out.put("listAllProjectsError", output);
				System.out.println("output 2 " +output);
				out.put("listAllProjects" , listOfCases);
				return out;
			}
				
				if(hadResults){
					  rs = listcases.getResultSet();
					  while(rs.next()){
						  listOfCases.add(new Cases(rs.getInt("project_id"), rs
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
				 
				  hadResults = listcases.getMoreResults();
				}
					
			out.put("listCases", listOfCases);
			out.put("listCasesError" , "");
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
		ListCasesCmd listmyprojects = new ListCasesCmd();
		Hashtable<String, Object> in = new Hashtable<String, Object>();
		in = listmyprojects.execute(projects);
		System.out.println("main executed");

	}

	

}
