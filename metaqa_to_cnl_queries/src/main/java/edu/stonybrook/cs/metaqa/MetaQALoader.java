package main.java.edu.stonybrook.cs.metaqa;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class MetaQALoader {
	
	private File file;
	FileReader fileReader;
	BufferedReader bufferedReader;
	boolean hasNextLine = true;
	String line = null;
	
	public MetaQALoader(String fileName) {
		try {
			file = new File(fileName);
			fileReader = new FileReader(file);
			bufferedReader = new BufferedReader(fileReader);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// Return the next line of question answer pair every time 
	// the loader gets called.
	public String Next() {
		if (!hasNextLine) {
			return null;
		}	
		try {
			line = bufferedReader.readLine();
			if (line == null) {
				hasNextLine = false;
				bufferedReader.close();
				return null;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String[] sentence = line.split("\t");
		return PreprocessSymbols(sentence[0]);
	}
	
	// This function pre-processes the symbols in the queries.
	// 1. named entity rewrite: [ABC XYZ] -> ABC-XYZ
	// 2. append '?' to the end of query.
	// 3. replace \' and \. in [XYZ] with space.
	private String PreprocessSymbols(String line) {
		line = line + "?";
		line = line.replace("fall under?", "falls under?");
		return line;
	}
}
