package net.codejava.springmodels;

import java.util.ArrayList;
import java.util.Date;

public  class  Projects {

	private int project_id;
	private int ngo_id;
	private String project_name;
	private String description;
	private String location;
	private Date deadline;
	private Date start_date;
	private boolean done;
	private boolean completed;
	private boolean volunteer;
	private boolean donate_money;
	private boolean donate_object;
	private int collected_amount;
	private int amount;
	private int urgency_id; // --> id corresponds to the value of severity.
							// ranges from 1 to 2
//	private ArrayList<String> objects;
//	private ArrayList<String> categories;

	public Projects(int project_id, int ngo_id, String project_name,
			String description, Date deadline, Date start_date, boolean done,
			boolean volunteer, boolean donate_money, boolean donate_object,
			int collected_amount, int amount, int urgency_id) {

		this.project_id = project_id;
		this.ngo_id = ngo_id;
		this.project_name = project_name;
		this.description = description;
		this.deadline = deadline;
		this.start_date = start_date;
		this.done = done;
		this.volunteer = volunteer;
		this.donate_money = donate_money;
		this.donate_object = donate_object;
		this.collected_amount = collected_amount;
		this.amount = amount;
		this.urgency_id = urgency_id;
		
//		this.objects = objects;
//		this.categories = categories;
		
	}

	public int getProject_id() {
		return project_id;
	}

	public void setProject_id(int project_id) {
		this.project_id = project_id;
	}

	public int getUrgency_id() {
		return urgency_id;
	}

	public void setUrgency_id(int urgency_id) {
		this.urgency_id = urgency_id;
	}

	public int getNgo_id() {
		return ngo_id;
	}

	public void setNgo_id(int ngo_id) {
		this.ngo_id = ngo_id;
	}

	public String getProject_name() {
		return project_name;
	}

	public void setProject_name(String project_name) {
		this.project_name = project_name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Date getDeadline() {
		return deadline;
	}

	public void setDeadline(Date deadline) {
		this.deadline = deadline;
	}

	public boolean isDone() {
		return done;
	}

	public void setDone(boolean done) {
		this.done = done;
	}

	public Date getStart_date() {
		return start_date;
	}

	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}

	public boolean isVolunteer() {
		return volunteer;
	}

	public void setVolunteer(boolean volunteer) {
		this.volunteer = volunteer;
	}

	public boolean isDonate_money() {
		return donate_money;
	}

	public void setDonate_money(boolean donate_money) {
		this.donate_money = donate_money;
	}

	public boolean isDonate_object() {
		return donate_object;
	}

	public void setDonate_object(boolean donate_object) {
		this.donate_object = donate_object;
	}

	public int getCollected_amount() {
		return collected_amount;
	}

	public void setCollected_amount(int collected_amount) {
		this.collected_amount = collected_amount;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public boolean isCompleted() {
		return completed;
	}

	public void setCompleted(boolean completed) {
		this.completed = completed;
	}

	

}
