package net.codejava.springmvc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

import net.codejava.springmodels.NGO_DeclareSuccessStr_Project;

public class FollowProjectCmd {
	public Hashtable execute(Hashtable table){
		try {

			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = null;

			try {
				Hashtable<String, String> out = new Hashtable<String, String>();

				conn = DriverManager
						.getConnection(
								"jdbc:mysql://localhost:3306/DonationCrowdfundingProject",
								"orange", "");
				System.out.println("connection established");

				Set set = table.entrySet();
				Iterator it = set.iterator();
				int user_id = 0;
				int project_id = 0;
				while(it.hasNext()){
					Map.Entry entry = (Map.Entry) it.next();
					if(entry.getKey().equals("user_id")){
						user_id = (Integer)entry.getValue();
					}
					else if(entry.getKey().equals("project_id")){
						project_id = (Integer) entry.getValue();
					}
				}

				CallableStatement fp = conn.prepareCall("{call FollowProject(? , ? , ?)}");
				System.out.println("procedure called");
				System.out.println("procedure executed");
				fp.registerOutParameter(3, Types.VARCHAR);
				fp.setInt(1, user_id);
				fp.setInt(2, project_id);
				fp.executeQuery();
				String success_msg = fp.getString("success_msg");
				System.out.println("success message is: "
						+ success_msg);

				if ( success_msg.equals("This user is not registered")) { 
					out.put("followproject", success_msg);
					System.out.println(success_msg);
					/*Set entrySet = result.entrySet();
					Iterator itr = entrySet.iterator();
					System.out.println("Hashtable entries : ");
					while (itr.hasNext())
						System.out.println(itr.next());
					return result;*/
				} else if (success_msg.equals("This project does not exist")) { // failure
					out.put("followproject", success_msg);
					System.out.println("This project does not exist");
				}
				else if (success_msg.equals("You have successfully followed this project")){
					out.put("followproject", success_msg);
					System.out.println(success_msg);
				}
				return out;

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
	public static void main (String[] args){
		FollowProjectCmd fp = new FollowProjectCmd();
		Hashtable<String , Integer> in = new Hashtable<String , Integer>();
		in.put("user_id", 1);
		in.put("project_id", 1);
		Hashtable<String , String> out = new Hashtable<String , String>();
		out = fp.execute(in);
	}

}


