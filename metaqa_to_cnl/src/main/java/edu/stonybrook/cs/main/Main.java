package main.java.edu.stonybrook.cs.main;

import main.java.edu.stonybrook.cs.metaqa.MetaQALoader;
import main.java.edu.stonybrook.cs.metaqa.MetaQASerializer;
import main.java.edu.stonybrook.cs.queryprocessing.QueryProcessing;
import main.java.edu.stonybrook.cs.queryprocessing.ThreeHopQueryProcessing;

public class Main {
	public static void main(String[] args) {
		
		MetaQALoader loader = new MetaQALoader("filepath-to-metaqa-test/training-data");
		MetaQASerializer serializer = new MetaQASerializer("filepath-to-prolog-queries-in-cnl-sentences");
		String query;
		QueryProcessing queryProcessing = new QueryProcessing();
		long startTime = System.currentTimeMillis();
		int count = 0;
		
		while ((query = loader.Next()) != null) {
			serializer.SerializeToFile(queryProcessing.RewriteToCNL(query));
			count++;
			if (count%10000 == 0) {
				System.out.println(count);
			}
		}
		
		serializer.Close();
		long stopTime = System.currentTimeMillis();
		long elapsedTime = stopTime - startTime;
		System.out.println("Total time: " + elapsedTime/1000);	
	}

}
