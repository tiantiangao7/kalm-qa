package main.java.edu.stonybrook.cs.metaqa;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class MetaQASerializer {
	File fout;
	FileOutputStream fos;
	BufferedWriter bw;
	
	public MetaQASerializer(String fileName) {
		try {
			fout = new File(fileName);
			fos = new FileOutputStream(fout);
			bw = new BufferedWriter(new OutputStreamWriter(fos));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}	
	}
	
	public void SerializeToFile(String query) {
		try {
			bw.write("?-sentence_to_metaqa_query('" +  query + "').\n");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void Close() {
		try {
			bw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
