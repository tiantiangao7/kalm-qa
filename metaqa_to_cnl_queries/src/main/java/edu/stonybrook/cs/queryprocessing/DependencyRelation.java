package main.java.edu.stonybrook.cs.queryprocessing;
// This class represents the dependency relations
// returned by Stanford Parser.
public class DependencyRelation {
	private String RelName;
	private int HeadIndex;
	private int DepIndex;
	
	public DependencyRelation(String RelName, int HeadIndex, int DepIndex) {
		this.RelName = RelName;
		this.HeadIndex = HeadIndex;
		this.DepIndex = DepIndex;
	}
	
	public String GetRelName() {
		return RelName;
	}
	
	public int GetHeadIndex() {
		return HeadIndex;
	}
	
	public int GetDepIndex() {
		return DepIndex;
	}
}
