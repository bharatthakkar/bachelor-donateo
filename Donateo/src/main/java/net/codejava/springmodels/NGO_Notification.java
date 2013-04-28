package net.codejava.springmodels;

public class NGO_Notification {

	private int notification_id;
	private int ngo_id;
	private int project_id;
	private int project_name;
	private String notification_type;
	private String notification_content;
	

	public NGO_Notification(int notification_id, int ngo_id, int project_id,
			String notification_type, String notification_content) {
		this.notification_id = notification_id;
		this.ngo_id = ngo_id;
		this.project_id = project_id;
		this.notification_type = notification_type;
		this.notification_content = notification_content;

	}

	public int getNotification_id() {
		return notification_id;
	}

	public void setNotification_id(int notification_id) {
		this.notification_id = notification_id;
	}

	public int getNgo_id() {
		return ngo_id;
	}

	public void setNgo_id(int ngo_id) {
		this.ngo_id = ngo_id;
	}

	public int getProject_id() {
		return project_id;
	}

	public void setProject_id(int project_id) {
		this.project_id = project_id;
	}

	public String getNotification_type() {
		return notification_type;
	}

	public void setNotification_type(String notification_type) {
		this.notification_type = notification_type;
	}

	public String getNotification_content() {
		return notification_content;
	}

	public void setNotification_content(String notification_content) {
		this.notification_content = notification_content;
	}

	public int getProject_name() {
		return project_name;
	}

	public void setProject_name(int project_name) {
		this.project_name = project_name;
	}

}
