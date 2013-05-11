package net.codejava.springmvc;

import java.lang.reflect.Array;
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

import com.thoughtworks.xstream.XStream;

import net.codejava.springmodels.ListOfProjects;
import net.codejava.springmodels.Projects;

public class listMyFollowedProjectsCmd {
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
				int user_id = 0;
				int counter = 0;
				while(it.hasNext()){
					Map.Entry entry = (Map.Entry) it.next();
					if(entry.getKey().equals("user_id")){
						user_id = (Integer)entry.getValue();
					}
					else if(entry.getKey().equals("counter")){
						counter = (Integer) entry.getValue();
					}
				}				
				CallableStatement listfollowedprojects = conn
						.prepareCall("{call listFollowedProjects(? , ?)}");
				listfollowedprojects.registerOutParameter(2, Types.VARCHAR);
				listfollowedprojects.setInt("id", user_id);
				boolean hadResults = listfollowedprojects.execute();
				System.out.println("procedure executed");
				Hashtable<String, Object> out = new Hashtable<String, Object>();
				ResultSet rs = null;
				ArrayList<Projects> followed = new ArrayList<Projects>();
				// System.out.println("1");
				String output = "";
				output = listfollowedprojects.getString(2);
				ListOfProjects list = new ListOfProjects();
				if (output != null) {

					
					out.put("listMyFollowedProjects", "<error>"+output+"</error>");
					System.out.println(output);
					return out;
				}

				if (hadResults) {
					rs = listfollowedprojects.getResultSet();
					while (rs.next()) {
						followed.add(new Projects(rs.getInt("project_id"), rs
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
						//System.out.println(rs.getInt("project_id"));
						//System.out.println(rs.getString("project_name"));
					}
					hadResults = listfollowedprojects.getMoreResults();
				}
				int size = followed.size();
				int upperlimit = (counter*5) - 1;
				int lowerlimit = upperlimit-4;
				if(lowerlimit>size){
					out.put("listMyFollowedProjects", "<error>There are no more projects</error>");
					System.out.println("There are no more projects");
					return out;
				}
				if((upperlimit+1)>size){
					for(int i = lowerlimit; i<size; i++){
						list.addProject(followed.get(i));
					}
				}
				else{
					for(int i = lowerlimit;i<=upperlimit; i++){
						list.addProject(followed.get(i));
					}
				}
				XStream xstream = new XStream();
		        xstream.alias("listOfProjects", ListOfProjects.class);
		        xstream.alias("project", Projects.class);
		        String s = xstream.toXML(list);
		        System.out.println(s);
				out.put("listMyFollowedProjects", s);
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
		Hashtable listMyFollowingProjects = new Hashtable();
		int user_id = 1;
		int counter = 2;
		listMyFollowedProjectsCmd listmyprojects = new listMyFollowedProjectsCmd();
		Hashtable<String, Integer> in = new Hashtable<String, Integer>();
		in.put("user_id", user_id);
		in.put("counter", counter);
		listMyFollowingProjects = listmyprojects.execute(in);

	}

	private static String getString(String string) {
		// TODO Auto-generated method stub
		return null;
	}
}
