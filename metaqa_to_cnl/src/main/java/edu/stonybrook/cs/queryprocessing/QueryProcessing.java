package main.java.edu.stonybrook.cs.queryprocessing;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import edu.stanford.nlp.process.Morphology;


public class QueryProcessing {	
	private Morphology morpha = new Morphology();
	private QueryParser parser = new QueryParser();
	private String NamedEntity = null;
	private String SameKeyWord = "same";
		
	public QueryProcessing() {
	}
	
	// A list of transformation rules that converts an NL MetaQA sentence
	// to Attempto Controlled English sentence.
	public String RewriteToCNL(String text) {
		String originalText = text;
		text = RewriteNE(text);
		text = RewriteWhenReleaseSentence(text);
		text = RewriteWithHardCodedRules2(text);
		
		parser.Annotate(text);
		if (HasPAPhrase()) {
			text = RewritePAPhrase();
			parser.Annotate(text);
		}
		
		if (HasWHPhrase()) {
			text = RewriteWHPhrase();
			parser.Annotate(text);
		}
		
		if (HasAppositivePhrase()) {
			text = RewriteAppositivePhrase();
			parser.Annotate(text);
		}
		
		if (HasACLRel()) {
			text = RewriteACLRelIntoClause();
			parser.Annotate(text);
		}
		
		text = RewriteACLRelFromRule();
		parser.Annotate(text);
		
		text = AddMissingArticles();
		parser.Annotate(text);
		
		text = GetNormalizedCNL();
		parser.Annotate(text);
		
		if (parser.HasCompoundWords()) {
			text = RewriteCompoundWords();
			parser.Annotate(text);
		}
		
		text = RewriteWithHardCodedRules1(text);
		text = RecoverNE(text);
		text = RewriteWhenReleaseSentencePostProcessing(text);
		text = RewriteWithHardCodedRules2(text);		
		text = RewriteSentenceWithSameKeyWord(originalText, text);
		
		return text;
	}
	
	private String RewriteWithHardCodedRules2(String text) {
		try (BufferedReader br = new BufferedReader(new FileReader("trans_rules/hard_coded_rules_2.txt"))) {
			String sentence = null;
			while ((sentence = br.readLine()) != null) {
				String[] temp = sentence.split("\\t");
				if (temp.length == 2) {
					text = text.replace(temp[0], temp[1]);
				} else {
					text = text.replace(temp[0], "");
				}
			}
		} catch (IOException x) {		
		}
		return text;
	}
	
	private String RewriteWithHardCodedRules1(String text) {
		try (BufferedReader br = new BufferedReader(new FileReader("trans_rules/hard_coded_rules_1.txt"))) {
			String sentence = null;
			while ((sentence = br.readLine()) != null) {
				String[] temp = sentence.split("\\t");
				if (temp.length == 2) {
					text = text.replace(temp[0], temp[1]);
				} else {
					text = text.replace(temp[0], "");
				}
			}
		} catch (IOException x) {		
		}
		return text;
	}
	
	// Replace a named entity with XYZ to make the processing more generalized.
	// The XYZ-entity will be replace with the original one at the end of the processing.
	private String RewriteNE(String text) {
		int start = text.indexOf("[");
		int end = text.indexOf("]");
		NamedEntity = text.substring(start + 1, end);
		NamedEntity = NamedEntity.replace("'", "\\'");
		text = text.substring(0, start) + "XYZ" + text.substring(end + 1);
		return text;
	}
	
	private String RecoverNE(String text) {
		text = text.replace("XYZ", "\"" + NamedEntity + "\"");
		return text;
	}
	
	// Hard-coded rule to rewrite the sentences
	// when did the film release? -> when is the film released?
	// For the sentence when did the film release, 
	// StanfordParser recognizes 'release' as an NN, which is wrong.
	private String RewriteWhenReleaseSentence(String text) {
		if (text.startsWith("When did")
				&& text.endsWith(" release?"))
		{
			text = text.replace("When did", "When is");
			text = text.replace(" release?", " released?");
			return text;
		} else if (text.startsWith("When does")
				&& text.endsWith(" release?"))
		{
			text = text.replace("When does", "When is");
			text = text.replace(" release?", " released?");
			return text;
		} else if (text.startsWith("when did")
				&& text.endsWith(" release?"))
		{
			text = text.replace("when did", "When is");
			text = text.replace(" release?", " released?");
			return text;
		} else if (text.startsWith("when does")
				&& text.endsWith(" release?"))
		{
			text = text.replace("when does", "When is");
			text = text.replace(" release?", " released?");
			return text;
		} 
		else {
			return text;
		}
	}
	
	// Hard-coded rule to rewrite sentence 
	// when does the movie release whose actor ... -> when does the movie whose actor... release?
	// The former sentence is not grammatically correct. 
	// However, this type of sentences occur in MetaQA dataset.
	private String RewriteWhenReleaseSentencePostProcessing(String text) {
		String prefix1 = "when does the movie releases ";
		String prefix2 = "when does the film releases ";
		if (text.toLowerCase().startsWith(prefix1)
				)
		{
			String suffix = text.substring(prefix1.length(), text.length() - 1);
			text = "When does the movie " + suffix + " release?";
			return text;
		} else if (text.toLowerCase().startsWith(prefix2)
				)
		{
			String suffix = text.substring(prefix2.length(), text.length() - 1);
			text = "When does the film " + suffix + " release?";
			return text;
		} else if (text.endsWith("\" that is released?")) {
			text = text.replace("\" that is released?", "\" released?");
			return text;
		}
		else {
			return text;
		}
	}
	
	private boolean HasPAPhrase() {
		ArrayList<String> pos = parser.GetPOS();
		int size = pos.size();
		for (int i = 0; i < size; i ++) {
			if (i + 2 < size && (pos.get(i).equals("NNP") || pos.get(i).equals("JJ"))
					&& pos.get(i + 1).equals("VBD")
					&& pos.get(i + 2).equals("NNS")) {
				return true;
			}
		}
		return false;
	}
	
	// Add missing articles before a noun.
	private String AddMissingArticles() {
		ArrayList<String> pos = parser.GetPOS();
		ArrayList<String> tokens = parser.GetTokens();
		HashSet<Integer> det = parser.GetDetHeadIndices();
		HashSet<Integer> compound = parser.GetCompoundDepdents();
		HashSet<Integer> poss = parser.GetPOSSHeadIndices();
		HashMap<Integer, ArrayList<Integer>> compoundHead = parser.getCompoundIndices();
		
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {	
			if ((pos.get(i).equals("NN") || pos.get(i).equals("NNS"))
					&& !det.contains(i + 1)
					&& !compound.contains(i + 1)
					&& !poss.contains(i + 1)
					&& !compoundHead.containsKey(i + 1)
					&& (tokens.get(i).charAt(0) < 'A' || tokens.get(i).charAt(0) > 'Z')) {
				text += " a";
			}
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);		
			}
		}
		return text.trim();
	}
	
	// Example: Mary starred films -> films that are starred by Mary.
	private String RewritePAPhrase() {
		ArrayList<String> pos = parser.GetPOS();
		ArrayList<String> tokens = parser.GetTokens();
		
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {
			if (i + 2 < tokens.size() && (pos.get(i).equals("NNP") || pos.get(i).equals("JJ"))
					&& (pos.get(i + 1).equals("VBD") || pos.get(i + 1).equals("VBN"))
					&& pos.get(i + 2).equals("NNS")) {
				text += " " + tokens.get(i + 2) + " that are " + tokens.get(i + 1) + " by "
						+ tokens.get(i);
				i = i + 2;
				continue;
				
			}		
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);
			}
		}
		return text;
	}
	
	// Example: film written by XYZ -> film that is written by XYZ
	private String RewriteACLRelFromRule() {
		ArrayList<String> pos = parser.GetPOS();
		ArrayList<String> tokens = parser.GetTokens();
		
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {		
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);
			}
			if (i + 2 < tokens.size() && (pos.get(i).equals("NN") || pos.get(i).equals("NNS"))
					&& pos.get(i + 1).equals("VBD")
					&& tokens.get(i + 2).equals("by")) {
				text += " that is";		
			}
		}
		return text;
	}
	
	// Check whether the sentence contains WH + Noun phrases
	private boolean HasWHPhrase() {
		ArrayList<String> pos = parser.GetPOS();

		for(int i = 0; i < pos.size(); i++) {				
			if (i + 1 < pos.size() && pos.get(i).equals("WDT")
						&& pos.get(i + 1).equals("NNS")) {
					return true;			
				} 
			} 
		return false;
	}
	
	// Example: what genres -> which genres
	// Note: what genres is not accepted by Attempto Controlled English
	private String RewriteWHPhrase() {
		ArrayList<String> pos = parser.GetPOS();
		ArrayList<String> tokens = parser.GetTokens();
		
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {		
			if (i == 0 || i == tokens.size() - 1) {
				if (i + 1 < tokens.size() && pos.get(i).equals("WDT")
						&& pos.get(i + 1).equals("NNS")
						&& tokens.get(i).toLowerCase().equals("what")) {
					text += "Which";
					continue;				
				} else {
					text += tokens.get(i);
				}
			} else {
				if (i + 1 < tokens.size() && pos.get(i).equals("WDT")
						&& pos.get(i + 1).equals("NNS")
						&& tokens.get(i).equals("what")) {
					text += " which";
					continue;				
				} else {
					text += " " + tokens.get(i);
				}
			}
		}
		return text;
	}
	
	
	// Rewrite a compound word into Attempto Controlled English format
	// Example: release year -> n:release-year.
	private String RewriteCompoundWords() {
		HashSet<Integer> dep = parser.GetCompoundDepdents();
		HashMap<Integer, ArrayList<Integer>> compounds = parser.getCompoundIndices();
		ArrayList<String> tokens = parser.GetTokens();
		HashSet<Integer> det = parser.GetDetHeadIndices();
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {
			if (dep.contains(i + 1)) {
				continue;
			}
			
			String compoundWord = "";
			if (compounds.containsKey(i + 1)) {
				ArrayList<Integer> list = compounds.get(i + 1);
				for (int index : list) {
					compoundWord += "-" + tokens.get(index - 1);
				}
				compoundWord += "-" + tokens.get(i);
				compoundWord = compoundWord.substring(1);
				compoundWord = " n:" + compoundWord;
				if (!det.contains(i + 1)) {
					compoundWord = " a" + compoundWord; 
				}
				text += compoundWord;
				continue;
			}
					
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);
			}
		}
		return text.trim();
	}
	
	private boolean HasAppositivePhrase() {
		HashSet<Integer> appos = parser.GetAppositiveDepdents();
		return !appos.isEmpty();
	}
	
	// Example: writer XYZ -> writer whose name is XYZ
	private String RewriteAppositivePhrase() {
		HashSet<Integer> appos = parser.GetAppositiveDepdents();
		ArrayList<String> tokens = parser.GetTokens();
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);
			}
			if (appos.contains(i + 1)) {
				text += " whose name is";
			}
		}
		return text;
	}
	
	// Example: film directed by XYZ -> film that is directed by XYZ
	private String RewriteACLRelIntoClause() {
		HashSet<Integer> head = parser.GetACLRelHeadIndices();
		ArrayList<String> tokens = parser.GetTokens();
		String text = "";
		for(int i = 0; i < tokens.size(); i++) {
			if (i == 0 || i == tokens.size() - 1) {
				text += tokens.get(i);
			} else {
				text += " " + tokens.get(i);
			}
			if (head.contains(i + 1)) {
				text += " that is";
			}
		}
		return text;
	}
	
	private boolean HasACLRel() {
		HashSet<Integer> head = parser.GetACLRelHeadIndices();
		return !head.isEmpty();
	}
	
	// Rewrite each token such that a noun is in singular form,
	// and a verb is in present tense.
	private String GetNormalizedToken(String token, String pos) {
		if (token.equals("was") || token.equals("were")
				|| token.equals("are")) {
			return "is";
		} else if (token.equals("had") || token.equals("have")) {
			return "has";
		} else if (token.equals("do") || token.equals("did")) {
			return "does";
		} else if (pos.equals("VB") || pos.equals("VBP")
				|| pos.equals("VBD")) {
			String morphaStr = morpha.stem(token)+"s";	
				return morphaStr;
		} else if (token.charAt(0) >='A' && token.charAt(0) <= 'Z') {
			return token;
		}
		else if (pos.equals("NNS")) {
			return morpha.stem(token);
		} else if (token.equals("'s")) {
			return "\\'s";
		}
		else {
			return token;
		}
	}
	
	// Rewrite the CNL sentence where each noun is in singular form,
	// and each verb is in present tense.
	private String GetNormalizedCNL() {
		ArrayList<String> pos = parser.GetPOS();
		ArrayList<String> tokens = parser.GetTokens();
		String result = "";
		for (int i = 0; i < tokens.size(); i++) {
			String normalizedToken = GetNormalizedToken(tokens.get(i), pos.get(i));
			if (normalizedToken.equals(SameKeyWord)) {
				continue;
			}			
			if (i == 0 || i == tokens.size() - 1) {
				result  = result + normalizedToken;
			} else {
				result = result + " " + normalizedToken;
			}
		}
		return result;
	}
	
	private String RewriteSentenceWithSameKeyWord(String originalText, String processedText) {
		if (originalText.contains("directed by the same director")) {
			return processedText.replace("is directed by the director of", "is directed by the same director of");
		} else {
			return processedText;
		}
	}
}
