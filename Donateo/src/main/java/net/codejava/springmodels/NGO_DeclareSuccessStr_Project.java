package net.codejava.springmodels;

public class NGO_DeclareSuccessStr_Project {
	private int ngo_id;
	private int project_id;
	private String story;
	public NGO_DeclareSuccessStr_Project(int ngo_id , int project_id , String story){
		this.setNgo_id(ngo_id);
		this.setProject_id(project_id);
		this.setStory(story);
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
	public String getStory() {
		return story;
	}
	public void setStory(String story) {
		this.story = story;
	}
	

}
