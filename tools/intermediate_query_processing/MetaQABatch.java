package main.java.edu.stonybrook.cs.batch;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MetaQABatch {

	private String AnonymizeSingletonVar(String rule) {
		rule = rule.substring(0, rule.length() - 1);
		HashMap<String, ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
		HashMap<String, Integer> filmIDMap = new HashMap<String, Integer>();
		
		Pattern pattern = Pattern.compile("movie\\('(Film|Actor|Writer|Director)',(.+?),'(Actor|Writer|Genre|Director|Release Year|Language)',(.+?)\\)");
		Matcher matcher = pattern.matcher(rule);
		while (matcher.find())
		{
		    String predicate = matcher.group(0);
		    
		    predicate = predicate.substring(6, predicate.length()-1);
		    String[] ele = new String[4];
		    ele[0] = matcher.group(1);
		    if (ele[0].equals("Film")) {
		    	String temp = matcher.group(2);
		    	temp = temp.substring(1);
		    	temp = temp.substring(0, temp.length()-1);
		    	int index = temp.lastIndexOf(",");
		    	String k = temp.substring(index + 1);
		    	String v = temp.substring(0, index);
		    	
		    	if (filmIDMap.containsKey(k)) {
		    		filmIDMap.put(k, filmIDMap.get(k) + 1);
		    	} else {
		    		filmIDMap.put(k, 1);
		    	}
		    	ele[1] = v;
		    } else {
		    	ele[1] = matcher.group(2);
		    }
		    ele[2] = matcher.group(3);
		    ele[3] = matcher.group(4);
		    
		    if (!map.containsKey(ele[0])) {
		    	ArrayList<String> temp = new ArrayList<String>();
		    	temp.add(ele[1]);
		    	map.put(ele[0], temp);
		    } else {
		    	ArrayList<String> temp = map.get(ele[0]);
		    	boolean contain = false;
		    	for (String s : temp) {
		    		if (s.equals(ele[1])) {
		    			contain = true;
		    			break;
		    		}
		    	}
		    	if (!contain) {
		    		temp.add(ele[1]);
		    	}
		    }
		    if (!map.containsKey(ele[2])) {
		    	ArrayList<String> temp = new ArrayList<String>();
		    	temp.add(ele[3]);
		    	map.put(ele[2], temp);
		    } else {
		    	ArrayList<String> temp = map.get(ele[2]);
		    	boolean contain = false;
		    	for (String s : temp) {
		    		if (s.equals(ele[3])) {
		    			contain = true;
		    			break;
		    		}
		    	}
		    	if (!contain) {
		    		temp.add(ele[3]);
		    	}
		    }	    
		}
		String result = "";		
		rule = rule + result + ".";
		
		for(String filmID : filmIDMap.keySet()) {
			if (filmIDMap.get(filmID) == 1 && !rule.contains(filmID + " \\=")
					&& !rule.contains("\\= " + filmID)) {
				rule = rule.replace("," + filmID + ")", ",_)");
			}
		}
		
		return rule;
	}
	
	private void composeQuery(int id, String rule) {
		String outputFile = "path/to/metaqa_query_without_singleton_var";
		if (id == 1) {
			try (BufferedWriter bw 
					= new BufferedWriter(new FileWriter(outputFile))) {			
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		try (BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile, true))) {
			bw.write(AnonymizeSingletonVar(rule) + "\n");	
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	private void batchProcessing() {
		try (BufferedReader br = new BufferedReader(new FileReader("path/to/metaqa_query_with_singleton_var"))) {
			String sentence;
			long startTime = System.currentTimeMillis();
			int id = 0;
			while ((sentence = br.readLine()) != null) {
				id++;				
				composeQuery(id, sentence);
			}
			long stopTime = System.currentTimeMillis();
			long elapsedTime = stopTime - startTime;
			System.out.println("Total time (s): " + elapsedTime/1000);
		} catch (IOException x) {
			System.err.println(x);
			x.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		MetaQABatch batch = new MetaQABatch();
		batch.batchProcessing();
	}

}
