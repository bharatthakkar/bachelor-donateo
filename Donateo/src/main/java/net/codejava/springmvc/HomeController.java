package net.codejava.springmvc;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.logging.FileHandler;

import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import net.codejava.springmodels.Admins;
import net.codejava.springmodels.NGO;
import net.codejava.springmodels.User;
import net.codejava.springxml.registerRequest.UserXML;
import net.codejava.springxml.registerResponse.Message;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import snaq.db.ConnectionPool;

import com.mysql.jdbc.Driver;

/**
 * Handles requests for the application home page.
 */
@SessionAttributes({ "user", "registration_message", "login_message",
		"controller_table", "listMyFollowingProjects",
		"project_creation_message", "messageForMAI" })
@Controller
public class HomeController {
	ConnectionPool pool;

	public HomeController() {
		Class c;
		try {
			c = Class.forName("com.mysql.jdbc.Driver");
			Driver driver = (Driver) c.newInstance();
			DriverManager.registerDriver(driver);

			String url = "jdbc:mysql://localhost:3306/DonationCrowdfundingProject";
			// Note, timeout is specified in milliseconds.
			this.pool = new ConnectionPool("local", 5, 10, 30, 180000, url,
					"orange", "");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	private static final Logger logger = LoggerFactory
			.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String Home(HttpSession session, Locale locale, Model model) {
		logger.info("Wlcome home habebe", locale);

		Date date = new Date();
		DateFormat d = DateFormat.getDateTimeInstance(DateFormat.LONG,
				DateFormat.LONG, locale);
		String formatteddate = d.format(date);
		// String greetings = "Greetings, Spring MVC!";
		model.addAttribute("serverTime", formatteddate);
		Hashtable<String, Object> controller_table = new Hashtable<String, Object>();
		session.setAttribute("controller_table", controller_table);
		

		// User user = new User(1, "Sherine", "ddssd", "sdsdsds", "sddsdsds",
		// "dsdssdsd");
		// model.addAttribute("user", user);
		// session.setAttribute("user", user);
		// System.out.println(((User)session.getAttribute("user")).getId());
		// ListNGOvolunteerCasesCmd list = new ListNGOvolunteerCasesCmd();
		// Hashtable t = new Hashtable();
		// t.put("ngo_id", 1);
		// list.execute(t);

		return "Login";
	}

	// **************************************SHERINE*******************************************************************************
	@RequestMapping(value = "/Register", method = RequestMethod.POST)
	public String register(HttpSession session, Model model,
			@RequestParam("name") String name,
			@RequestParam("email") String email,
			@RequestParam("password") String password,
			@RequestParam("phone") String phone,
			@RequestParam("phoneI") String phoneI,
			@RequestParam("phoneII") String phoneII,
			@RequestParam("address") String address) {

		String phone_number = phone + phoneI + phoneII;

		Hashtable<String, String> user_parameters = new Hashtable<String, String>();
		user_parameters.put("name", name);
		user_parameters.put("email", email);
		user_parameters.put("password", password);
		user_parameters.put("address", address);
		user_parameters.put("phone", phone_number);

		// User user = new User(1, name, email, password, phone_number,
		// address);
		// model.addAttribute("user", user);
		// return "User_Profile";

		RegisterCmd registerCmd = new RegisterCmd();
		System.out.println(name + "***************");
		Hashtable htblOutputParams = registerCmd.execute(user_parameters);
		if (htblOutputParams == null) {
			System.out.println("anaa hennaaaaa regi cont");
			return "home";
		}

		if (((String) htblOutputParams.get("success_message"))
				.equals("YOU HAVE SUCCESSFULLY REGISTERED")) {
			int id = ((Integer) htblOutputParams.get("user_id")).intValue();
			User user = new User(id, name, email, password, phone_number,
					address);
			// model.addAttribute("user", user);
			session.setAttribute("user", user);
			// call login to create the session
			Hashtable login_user = new Hashtable();
			login_user.put("email", email);
			login_user.put("password", password);
			LoginCmd loginCmd = new LoginCmd();
			loginCmd.execute(login_user);
			return "User_Profile";
		} else if (((String) htblOutputParams.get("success_message"))
				.equals("EMAIL OR PASSWORD ALREADY EXISTS")) {
			model.addAttribute("registration_message",
					"EMAIL OR PASSWORD ALREADY EXISTS");
			return "Register";

		} else if (((String) htblOutputParams.get("success_message"))
				.equals("USER NAME ALREADY EXISTS")) {
			model.addAttribute("registration_message",
					"USER NAME ALREADY EXISTS");
			return "Register";
		}
		// session.setAttribute("user", user);
		return "home";

	}

	@RequestMapping(value = "/Login", method = RequestMethod.POST)
	public String login(HttpSession session, Model model,
			@RequestParam("email") String email,
			@RequestParam("password") String password) {

		Hashtable user_parameters = new Hashtable();
		user_parameters.put("email", email);
		user_parameters.put("password", password);
		user_parameters.put("pool", this.pool);

		// System.out.println(email + "      " + password);

		LoginCmd loginCmd = new LoginCmd();
		Hashtable htblOutputParams = loginCmd.execute(user_parameters);

		if (htblOutputParams.get("success_message") != null
				&& ((String) htblOutputParams.get("success_message"))
						.equals("YOU HAVE NOT REGISTERED YET")) {
			model.addAttribute("login_message", "YOU HAVE NOT REGISTERED YET");
			return "Login";
		} else if (((String) htblOutputParams.get("login_message"))
				.equals("EMAIL OR PASSWORD IS WRONG")) {
			model.addAttribute("login_message", "EMAIL OR PASSWORD IS WRONG");
			return "Login";
		} else if (((String) htblOutputParams.get("login_message"))
				.equals("LOGGED IN")) {
			// account exists and user has successfully logged in

			// check on type to know which object to create
			if (((String) htblOutputParams.get("type")).equals("user")) {
				int user_id = ((Integer) htblOutputParams.get("id")).intValue();
				String user_name = (String) htblOutputParams.get("name");
				String user_email = (String) htblOutputParams.get("email");
				String user_password = (String) htblOutputParams
						.get("password");
				String user_phone = (String) htblOutputParams.get("phone");
				String user_address = (String) htblOutputParams.get("address");

				User user = new User(user_id, user_name, user_email,
						user_password, user_phone, user_address);
				session.setAttribute("user", user);
				// osama
				listFollowingProjects(session);
				// model.addAttribute("user", user);
				return "User_Profile";
			} else if (((String) htblOutputParams.get("type")).equals("ngo")) {
				int admin_id = ((Integer) htblOutputParams.get("admin_id"))
						.intValue();
				int ngo_id = ((Integer) htblOutputParams.get("ngo_id"))
						.intValue();
				String ngo_email = (String) htblOutputParams.get("ngo_email");
				String ngo_password = (String) htblOutputParams.get("password");
				String ngo_name = (String) htblOutputParams.get("ngo_name");
				String photo = (String) htblOutputParams.get("photo");
				String description = (String) htblOutputParams
						.get("description");
				String website_link = (String) htblOutputParams
						.get("websute_link");
				String phone = (String) htblOutputParams.get("phone");

				NGO ngo = new NGO(admin_id, ngo_id, ngo_email, ngo_password,
						ngo_name, photo, description, website_link, phone);
				session.setAttribute("user", ngo);
				// model.addAttribute("user", ngo);
				// return "NGO_Profile";
				return "newProject";
			} else {
				// the user is admin

				int admin_id = ((Integer) htblOutputParams.get("admin_id"))
						.intValue();
				String admin_email = (String) htblOutputParams
						.get("admin_email");
				String admin_password = (String) htblOutputParams
						.get("password");

				Admins admin = new Admins(admin_id, admin_email, admin_password);
				session.setAttribute("user", admin);
				// model.addAttribute("user", admin);
				return "Admin_Profile";
			}

		}

		return "";
	}

	@RequestMapping(value = "/Logout", method = RequestMethod.GET)
	public String logout(HttpSession session, Model model) {
		// session.removeAttribute("user");
		// session.invalidate();
		Hashtable htblInputParams = new Hashtable();
		Object o = session.getAttribute("user");
		if (o != null) {
			if (o instanceof User) {
				User current_user = (User) o;
				htblInputParams.put("id", new Integer(current_user.getId()));
				htblInputParams.put("type", "user");
			} else if (o instanceof NGO) {
				NGO current_user = (NGO) o;
				htblInputParams
						.put("id", new Integer(current_user.getNgo_id()));
				htblInputParams.put("type", "ngo");
			} else if (o instanceof Admins) {
				Admins current_user = (Admins) o;
				htblInputParams.put("id",
						new Integer(current_user.getAdmin_id()));
				htblInputParams.put("type", "admin");
			}
		}
		session.setAttribute("user", null);

		LogoutCmd logoutCmd = new LogoutCmd();
		logoutCmd.execute(htblInputParams);
		// model.addAttribute("user", null);

		return "Login";
	}

	@RequestMapping(value = "/getRecommededProjects", method = RequestMethod.GET)
	public String getRecommendedProjects(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);
		GetRecommendedProjectsCmd get_recommended = new GetRecommendedProjectsCmd();
		Hashtable getRecommendedProjects = get_recommended
				.execute(htblInputParams);
		ArrayList getRecommendedProjectsArray = (ArrayList) getRecommendedProjects
				.get("getRecommendedProjects");

		this.pool.release();

		session.setAttribute("controller_table", ((Hashtable) session
				.getAttribute("contoller_table")).put("getRecommendedProjects",
				getRecommendedProjectsArray));
		return "User_Profile";
	}

	@RequestMapping(value = "/getUrgentProjects", method = RequestMethod.GET)
	public String getUrgentProjects(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);
		GetUrgentProjectsCmd get_urgent = new GetUrgentProjectsCmd();
		Hashtable getUrgentProjectsCmd = get_urgent.execute(htblInputParams);
		ArrayList getUrgentProjectsArray = (ArrayList) getUrgentProjectsCmd
				.get("getUrgentProjects");

		this.pool.release();
		session.setAttribute("controller_table", ((Hashtable) session
				.getAttribute("contoller_table")).put("getUrgentProjects",
				getUrgentProjectsArray));
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyCurrentCases", method = RequestMethod.GET)
	public String listMyCurrentCases(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			ListMyCurrentCasesCmd user_current_cases = new ListMyCurrentCasesCmd();
			Hashtable currentCases = user_current_cases
					.execute(htblInputParams);
			ArrayList ListMyCurrentCasesArray = (ArrayList) currentCases
					.get("listMyCurrentCases");
			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put("listMyCurrentCases",
					ListMyCurrentCasesArray));
			// put array in session
		}
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyFinishedCases", method = RequestMethod.GET)
	public String listMyFinishedCases(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			ListMyFinishedCasesCmd user_finished_cases = new ListMyFinishedCasesCmd();
			Hashtable finishedCases = user_finished_cases
					.execute(htblInputParams);
			ArrayList ListMyFinishedCasesArray = (ArrayList) finishedCases
					.get("listMyFinishedCases");

			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listMyFinishedCases", ListMyFinishedCasesArray));
			// put array in session
		}
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyCurrentCrowdfundings", method = RequestMethod.GET)
	public String listMyCurrentCrowdfundings(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			ListMyCurrentCrowdfundingsCmd user_current_crowdfundings = new ListMyCurrentCrowdfundingsCmd();
			Hashtable currentcf = user_current_crowdfundings
					.execute(htblInputParams);
			ArrayList listMyCurrentCrowdfundingsArray = (ArrayList) currentcf
					.get("ListMyCurrentCrowdfundings");

			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"ListMyCurrentCrowdfundings",
					listMyCurrentCrowdfundingsArray));

			// put array in session
		}
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyFinishedCrowdfundings", method = RequestMethod.GET)
	public String listMyFinishedCrowdfundings(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			ListMyFinishedCrowdfundingsCmd user_finished_crowdfundings = new ListMyFinishedCrowdfundingsCmd();
			Hashtable finishedcf = user_finished_crowdfundings
					.execute(htblInputParams);
			ArrayList finishedcfArray = (ArrayList) finishedcf
					.get("ListMyFinishedCrowdfundings");

			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"ListMyFinishedCrowdfundings", finishedcfArray));

			// put array in session
		}
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyCurrentCampaigns", method = RequestMethod.GET)
	public String listMyCurrentCampaigns(HttpSession session) {

		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			// htblInputParams.put("user_id", new Integer(1));
			ListMyCurrentCampaignsCmd user_current_campaigns = new ListMyCurrentCampaignsCmd();
			Hashtable currentCampaigns = user_current_campaigns
					.execute(htblInputParams);
			ArrayList currentCampaignsArray = (ArrayList) currentCampaigns
					.get("listMyCurrentCampaigns");

			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listMyCurrentCampaigns", currentCampaignsArray));

			// put array in session
		}
		return "User_Profile";
	}

	@RequestMapping(value = "/listMyFinishedCampaigns", method = RequestMethod.GET)
	public String listMyFinishedCampaigns(HttpSession session) {
		Hashtable htblInputParams = new Hashtable();
		htblInputParams.put("pool", this.pool);

		Object o = session.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			htblInputParams.put("user_id", new Integer(user.getId()));
			// htblInputParams.put("user_id",new Integer(1));
			ListMyFinishedCampaignsCmd user_finished_campaigns = new ListMyFinishedCampaignsCmd();
			Hashtable finishedCampaigns = user_finished_campaigns
					.execute(htblInputParams);
			ArrayList finishedCampaignsArray = (ArrayList) finishedCampaigns
					.get("listMyFinishedCampaigns");

			this.pool.release();
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listMyFinishedCampaigns", finishedCampaignsArray));

		}
		return "User_Profile";
	}
	
	//************XML***********
	
	@RequestMapping(value = "/xRegister")
	public String xRegister(HttpSession session, Model model,
	@RequestParam("user") String xml) {
	// create a JAXBContext capable of handling classes generated into
	// the itemListAPI package
		 try {
			 
				//File request = new File("/Users/sherinehanna/Documents/workspace-orange/Donateo/registerRequest.xml");
			 	//FileUtils.writeStringToFile(new File ("registerRequest.xml"), xml);
				
				//
		        FileWriter fileWriter = null;
		        File request = null;
		        try {
		            //String content = "Hello! Java-Buddy :)";
		            request = new File("registerRequest2.xml");
		            fileWriter = new FileWriter(request);
		            fileWriter.write(xml);
		            fileWriter.close();
		        } catch (IOException ex) {
		        	System.out.println("here");
		            //Logger.getLogger(WriteStringToFile.class.getName()).log(Level.SEVERE, null, ex);
		        } finally {
		            try {
		                fileWriter.close();
		            } catch (IOException ex) {
		            	System.out.println("here2");
		                //Logger.getLogger(WriteStringToFile.class.getName()).log(Level.SEVERE, null, ex);
		            }
		        }
		        
		    
			 //
				JAXBContext jaxbContext = JAXBContext.newInstance(UserXML.class);
		 
				Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
				System.out.println(xml);
				UserXML user_xml = (UserXML) jaxbUnmarshaller.unmarshal(request);
				System.out.println(user_xml.getFirstName());
				
			 	String first_name =  user_xml.getFirstName();
				String last_name = user_xml.getLastName();
				String email = user_xml.getEmail();
				String password = user_xml.getPassword();
				String phone = user_xml.getPhone();
				String address = user_xml.getAddress();
				
				// call command

				Hashtable user_parameters = new Hashtable();
				user_parameters.put("name", first_name);
				user_parameters.put("email", email);
				user_parameters.put("password", password);
				user_parameters.put("address", address);
				user_parameters.put("phone", phone);
				
				RegisterCmd registerCmd = new RegisterCmd();
				Hashtable htblOutputParams = registerCmd.execute(user_parameters);
				
				//creating the output xml
				Message message = new Message();
				String success_message = (String)htblOutputParams.get("success_message");
				if (success_message.equals("YOU HAVE SUCCESSFULLY REGISTERED")) {
					message.setBasicMessage((String)htblOutputParams.get("success_message"));
					message.setFnMessage(first_name);
					message.setEmlMessage(email);
					message.setPswdMessage(password);
					message.setPhnMessage(phone);
					message.setAdrsMessage(address);
				}
				else {
					//the user haven't registered
					message.setBasicMessage((String)htblOutputParams.get("success_message"));
					message.setFnMessage("");
					message.setEmlMessage("");
					message.setPswdMessage("");
					message.setPhnMessage("");
					message.setAdrsMessage("");
				}
				
				
				File response = new File("/Users/sherinehanna/Documents/workspace-orange/Donateo/registerResponse.xml");
				JAXBContext jaxbContext2 = JAXBContext.newInstance(Message.class);
				Marshaller jaxbMarshaller = jaxbContext2.createMarshaller();
		 
				// output pretty printed
				jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
		 
				jaxbMarshaller.marshal(message, response);
				jaxbMarshaller.marshal(message, System.out);
				
				request.delete();
		 
			  } catch (JAXBException e) {
				e.printStackTrace();
			  }
		 

			
	return "home";
	}
	//********END XML***********

	// *************************************OSAMA*************************************************************************************
	@RequestMapping(value = "/User_Profile#following", method = RequestMethod.GET)
	public void listFollowingProjects(HttpSession s) {
		Object o = s.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			Hashtable listMyFollowingProjects = new Hashtable();
			listMyFollowedProjectsCmd followedProjects = new listMyFollowedProjectsCmd();
			Hashtable<String, Integer> in = new Hashtable<String, Integer>();
			in.put("user_id", new Integer(user.getId()));
			Hashtable out = listMyFollowedProjectsCmd.execute(in);
			ArrayList array = (ArrayList) out.get("listMyFollowedProjects");
//			s.setAttribute("controller_table", ((Hashtable) s
//					.getAttribute("contoller_table")).put(
//					"listMyFollowedProjects", array));
			Hashtable temp_table = (Hashtable) s.getAttribute("contoller_table");
			temp_table.put("listMyFollowedProjects", array);
			s.setAttribute("controller_table", temp_table);
			s.setAttribute("listMyFollowingProjects", out);
			s.setAttribute("messageForMAI", "HAI MAI");
		}

	}

	// listCampaigns
	@RequestMapping(value = "/homePage#campaigns", method = RequestMethod.GET)
	public void listCampaigns(HttpSession s) {

		ListCampaignsCmd campaigns = new ListCampaignsCmd();
		Hashtable in = new Hashtable();
		Hashtable out = ListCampaignsCmd.execute(in);
		ArrayList array = (ArrayList) out.get("listCampaigns");
		s.setAttribute("controller_table", ((Hashtable) s
				.getAttribute("contoller_table")).put("listCampaigns", array));
	}

	// listSuccessStories
	@RequestMapping(value = "/homePage#successStories", method = RequestMethod.GET)
	public void listSuccessStories(HttpSession s) {

		listMyFollowedProjectsCmd followedProjects = new listMyFollowedProjectsCmd();
		Hashtable in = new Hashtable();
		Hashtable out = listMyFollowedProjectsCmd.execute(in);
		ArrayList array = (ArrayList) out.get("listCampaigns");
		s.setAttribute("controller_table", ((Hashtable) s
				.getAttribute("contoller_table")).put("listCampaigns", array));

	}

	// followproject
	@RequestMapping(value = "/profilePage#follow", method = RequestMethod.GET)
	public void followProject(HttpSession s,
			@RequestParam("project_id") String project_id) {

		Object o = s.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			FollowProjectCmd follow = new FollowProjectCmd();
			Hashtable in = new Hashtable();
			in.put("ngo_id", new Integer(user.getId()));
			in.put("project_id", Integer.parseInt(project_id));
			Hashtable out = follow.execute(in);
			ArrayList array = (ArrayList) out.get("followProject");
			s.setAttribute("controller_table", ((Hashtable) s
					.getAttribute("contoller_table")).put("followProject",
					array));

		}
	}

	// unfollowproject
	@RequestMapping(value = "/profilePage#unfollow", method = RequestMethod.GET)
	public void unfollowProject(HttpSession s,
			@RequestParam("project_id") String project_id) {

		Object o = s.getAttribute("user");
		if (o instanceof User) {
			User user = (User) o;
			UnfollowProjectCmd unfollow = new UnfollowProjectCmd();
			Hashtable in = new Hashtable();
			in.put("ngo_id", new Integer(user.getId()));
			in.put("project_id", Integer.parseInt(project_id));
			Hashtable out = unfollow.execute(in);
			ArrayList array = (ArrayList) out.get("unfollowProject");
			s.setAttribute("controller_table", ((Hashtable) s
					.getAttribute("contoller_table")).put("unfollowProject",
					array));

		}
	}

	@RequestMapping(value = "/projectFiltering", method = RequestMethod.GET)
	public void unfollowProject(HttpSession s) {

		FilterByTypeAndCategoryCmd filter = new FilterByTypeAndCategoryCmd();
		Hashtable in = new Hashtable();
		Hashtable out = listMyFollowedProjectsCmd.execute(in);
		ArrayList array = (ArrayList) out.get("FilterByTypeAndCategory");
		s.setAttribute("controller_table", ((Hashtable) s
				.getAttribute("contoller_table")).put(
				"FilterByTypeAndCategory", array));

	}

	// **************************************MIRNA************************************************************************************

	@RequestMapping(value = "/newProject", method = RequestMethod.POST)
	public String newProject(
			HttpSession session,
			@RequestParam("name") String name,
			@RequestParam("description") String description,
			@RequestParam("location") String location,
			@RequestParam("severity") String urgency_id,
			@RequestParam("type") String campaignOrProject,
			@RequestParam(value = "isDonation", required = false) String isDonation,
			@RequestParam(value = "isVolunteer", required = false) String isVolunteer,
			@RequestParam(value = "isObject", required = false) String isObject,
			@RequestParam(value = "health", required = false) String c_health,
			@RequestParam(value = "education", required = false) String c_education,
			@RequestParam(value = "orphans", required = false) String c_orphans,
			@RequestParam(value = "development", required = false) String c_development,
			@RequestParam(value = "slums", required = false) String c_slums,
			@RequestParam(value = "economy", required = false) String c_economy,
			@RequestParam(value = "deadline", required = false) String deadline,
			@RequestParam(value = "from", required = false) String from,
			@RequestParam(value = "to", required = false) String to,
			@RequestParam(value = "fund", required = false) String amount,
			@RequestParam(value = "object_name1", required = false) String name1,
			@RequestParam(value = "object_name2", required = false) String name2,
			@RequestParam(value = "object_name3", required = false) String name3,
			@RequestParam(value = "object_name4", required = false) String name4,
			@RequestParam(value = "object_name5", required = false) String name5,
			@RequestParam(value = "object_amount1", required = false) String value1,
			@RequestParam(value = "object_amount2", required = false) String value2,
			@RequestParam(value = "object_amount3", required = false) String value3,
			@RequestParam(value = "object_amount4", required = false) String value4,
			@RequestParam(value = "object_amount5", required = false) String value5) {

		Hashtable<String, Object> project_data = new Hashtable<String, Object>();
		ArrayList<String> categories = new ArrayList<String>();
		ArrayList<String> objects = new ArrayList<String>();
		Object o = session.getAttribute("user");
		if (o instanceof NGO) {
			NGO ngo = (NGO) o;

			project_data.put("ngo_id", ngo.getNgo_id() + "");
			project_data.put("urgency_id", urgency_id);
			project_data.put("name", name);
			project_data.put("description", description);
			project_data.put("location", location);
			// categories
			if (c_health != null)
				categories.add(c_health);
			if (c_education != null)
				categories.add(c_education);
			if (c_orphans != null)
				categories.add(c_orphans);
			if (c_development != null)
				categories.add(c_development);
			if (c_economy != null)
				categories.add(c_economy);
			project_data.put("categories", categories);
			// types
			if (isVolunteer != null)
				project_data.put("isVolunteer", isVolunteer);
			if (isDonation != null) {
				project_data.put("isMoney", isDonation);
				project_data.put("amount", amount);
			}
			if (isObject != null) {

				objects.add(name1);
				objects.add(value1);
				if (!name2.equals("") && !value2.equals("")) {
					objects.add(name2);
					objects.add(value2);
				}
				if (!name3.equals("") && !value3.equals("")) {
					objects.add(name3);
					objects.add(value3);
				}
				if (!name4.equals("") && !value4.equals("")) {
					objects.add(name4);
					objects.add(value4);
				}
				if (!name5.equals("") && !value5.equals("")) {
					objects.add(name5);
					objects.add(value5);
				}

				project_data.put("isObject", isObject);
				project_data.put("objects", objects);
				System.out.println("ARRAY OBJECTS IN CONTROLLER " + objects);
				System.out.println("size = " + objects.size());
			}

			Hashtable errorOrSuccess = new Hashtable<String, String>();

			if (campaignOrProject.equals("charity")) { // charity = case
				project_data.put("deadline", deadline);
				CreateCaseCmd createCaseCmd = new CreateCaseCmd();
				errorOrSuccess = createCaseCmd.execute(project_data);

			} else if (campaignOrProject.equals("campaign")) {
				project_data.put("from", from);
				project_data.put("to", to);
				CreateCampaignCmd createCampaignCmd = new CreateCampaignCmd();
				errorOrSuccess = createCampaignCmd.execute(project_data);
			}
			Set set = errorOrSuccess.entrySet();
			Iterator it = set.iterator();
			Map.Entry entry = (Map.Entry) it.next();
			System.out.println(entry.getKey() + " : " + entry.getValue());
			session.setAttribute("project_creation_message", entry.getValue());
			if (entry.getKey().equals("success_message"))
				return "projectData"; // project page
			else
				return "newProject"; // redirect to same page
		}
		return "projectData";
	}

	@RequestMapping(value = "/NGO_Profile#onGoingCases", method = RequestMethod.GET)
	public void listNGOOnGoingCases(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOonGoingCasesCmd onGoingCasesCmd = new ListNGOonGoingCasesCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = onGoingCasesCmd.execute(input);
			ArrayList array = (ArrayList) result.get("listNGOOnGoingCases");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOOnGoingCases", array));
		}
	}

	@RequestMapping(value = "/NGO_Profile#currentCases", method = RequestMethod.GET)
	public void listNGOCurrentCases(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOcurrentCasesCmd currentCasesCmd = new ListNGOcurrentCasesCmd();

			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = currentCasesCmd.execute(input);
			ArrayList array = (ArrayList) result.get("listNGOcurrentCases");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOcurrentCases", array));
			// s.setAttribute("messageForMAI", "HAI MAI");

		}
	}

	// ListNGOcurrentCampaigns
	@RequestMapping(value = "/NGO_Profile#currentCampaigns", method = RequestMethod.GET)
	public void listNGOCurrentCampaigns(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOcurrentCampaignsCmd listNGOCurrentCampaigns = new ListNGOcurrentCampaignsCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listNGOCurrentCampaigns.execute(input);
			ArrayList array = (ArrayList) result.get("listNGOCurrentCampaigns");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOCurrentCampaigns", array));

		}
	}

	// ListNGOonGoingCampaigns
	@RequestMapping(value = "/NGO_Profile#ongoingCases", method = RequestMethod.GET)
	public void listNGOonGoingCampaigns(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOonGoingCampaignsCmd listOnGoingCampaigns = new ListNGOonGoingCampaignsCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listOnGoingCampaigns.execute(input);
			ArrayList array = (ArrayList) result.get("listOnGoingCampaigns");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listOnGoingCampaigns", array));

		}
	}

	// ListNGOcurrentCFcases
	@RequestMapping(value = "/NGO_Profile#currentCF", method = RequestMethod.GET)
	public void listNGOcurrentCF(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOcurrentCFcasesCmd listNGOCurrentCfcases = new ListNGOcurrentCFcasesCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listNGOCurrentCfcases.execute(input);
			ArrayList array = (ArrayList) result.get("listNGOcurrentCfcases");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOcurrentCfcases", array));

		}
	}

	// ListNGOonGoingCrowdFundings
	@RequestMapping(value = "/NGO_Profile#ongoingCF", method = RequestMethod.GET)
	public void listNGOonGoingCF(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGOonGoingCrowdFundingsCmd listNGOonGoingCF = new ListNGOonGoingCrowdFundingsCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listNGOonGoingCF.execute(input);
			ArrayList array = (ArrayList) result
					.get("listNGOonGoingCrowdFundings");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOonGoingCrowdFundings", array));

		}
	}

	// ListNGOnotifications
	@RequestMapping(value = "/notifications", method = RequestMethod.GET)
	public void listNotifications(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListNGONotificationsCmd listNotifications = new ListNGONotificationsCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listNotifications.execute(input);
			ArrayList array = (ArrayList) result.get("listNGOnotifications");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listNGOnotifications", array));

		} else if (user instanceof User) {
			// CALL USERNOTIFICATIONS
		}
	}

	// ListSuggestedProjects
	@RequestMapping(value = "/ngoProfile#suggestions", method = RequestMethod.GET)
	public void listSuggestedProjects(HttpSession session)

	{
		Object user = session.getAttribute("user");
		if (user instanceof NGO) {
			NGO ngo = (NGO) user;
			ListSuggestedProjectsCmd listSuggestedProjects = new ListSuggestedProjectsCmd();
			Hashtable input = new Hashtable();
			input.put("ngo_id", ngo.getNgo_id());

			Hashtable result = listSuggestedProjects.execute(input);
			ArrayList array = (ArrayList) result.get("listSuggestedProjects");
			session.setAttribute("controller_table", ((Hashtable) session
					.getAttribute("contoller_table")).put(
					"listSuggestedProjects", array));

		}
	}
}
