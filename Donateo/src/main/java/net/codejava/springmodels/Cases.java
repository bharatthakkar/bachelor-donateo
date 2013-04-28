package net.codejava.springmodels;

import java.util.ArrayList;
import java.util.Date;

public class Cases extends Projects {
	public Cases(int project_id, int ngo_id, String project_name,
			String description, Date deadline, Date start_date, boolean done, boolean completed,
			boolean volunteer, boolean donate_money, boolean donate_object,
			int collected_amount, int amount, int urgency_id) {
				super();
				//super(project_id, ngo_id, project_name, description, deadline, start_date, done, volunteer, donate_money, donate_object, collected_amount, amount, urgency_id);
				super.setProject_id(project_id);
				super.setNgo_id(ngo_id);
				super.setProject_name(project_name);
				super.setDescription(description);
				super.setDeadline(deadline);
				super.setStart_date(start_date);
				super.setDone(done);
				super.setCompleted(completed);
				super.setVolunteer(volunteer);
				super.setDonate_money(donate_money);
				super.setDonate_object(donate_object);
				super.setCollected_amount(collected_amount);
				super.setAmount(amount);
				super.setUrgency_id(urgency_id);
				
		// TODO Auto-generated constructor stub
	}

}
