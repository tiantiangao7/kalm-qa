package main.java.edu.stonybrook.cs.queryprocessing;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;

import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.parser.nndep.DependencyParser;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.semgraph.SemanticGraph;
import edu.stanford.nlp.semgraph.SemanticGraphCoreAnnotations;
import edu.stanford.nlp.semgraph.SemanticGraphEdge;
import edu.stanford.nlp.util.CoreMap;
import edu.stanford.nlp.util.PropertiesUtils;
// This class annotates a sentence using Stanford Parser
// and extract a subset of relations from the parse result.
// The meaning of the dep relations, such as ACL, DET,
// which are named as the function signature in this class
// can be referred to https://nlp.stanford.edu/software/dependencies_manual.pdf
public class QueryParser {
	private	Properties props = PropertiesUtils.asProperties(	
			"annotators", "tokenize,ssplit,pos,depparse",	        
			"depparse.model", DependencyParser.DEFAULT_MODEL	    
			);
	
	private StanfordCoreNLP pipeline;
	private ArrayList<String> tokens = new ArrayList<String>();
	private ArrayList<String> pos = new ArrayList<String>();
	private ArrayList<DependencyRelation> depRels = new ArrayList<DependencyRelation>();
	
	public QueryParser() {
		this.setPipeline(new StanfordCoreNLP(props));
	}

	public StanfordCoreNLP getPipeline() {
		return pipeline;
	}

	public void setPipeline(StanfordCoreNLP pipeline) {
		this.pipeline = pipeline;
	}
	
	public void Annotate(String text) {
		// Clear token, pos, and dep relations.
		tokens.clear();
		pos.clear();
		depRels.clear();
		
		Annotation document = new Annotation(text);
	    pipeline.annotate(document);
	    		
	    List<CoreMap> sentences = document.get(CoreAnnotations.SentencesAnnotation.class);
	    assert(sentences.size() == 1);
	    
	    for(CoreMap sentence: sentences) {
	      for (CoreLabel token: sentence.get(CoreAnnotations.TokensAnnotation.class)) {	      
	        String word = token.get(CoreAnnotations.TextAnnotation.class);
	        String partOfSpeech = token.get(CoreAnnotations.PartOfSpeechAnnotation.class);
	        tokens.add(word);
	        pos.add(partOfSpeech);
	      }
	      SemanticGraph sg = sentence.get(SemanticGraphCoreAnnotations.BasicDependenciesAnnotation.class);
	      for (SemanticGraphEdge edge : sg.edgeIterable()) {
	    	  int headIndex = edge.getGovernor().index();
	    	  int depIndex = edge.getDependent().index();
	    	  String relation = edge.getRelation().getShortName();
	    	  DependencyRelation depRel = new DependencyRelation(relation, headIndex, depIndex);
	    	  //System.out.println(relation + "(" + headIndex + "," + depIndex + ")");
	    	  depRels.add(depRel);
	      }
	      
	    }
	}
	
	public ArrayList<String> GetTokens() {
		return tokens;
	}
	
	public ArrayList<String> GetPOS() {
		return pos;
	}
	
	public HashSet<Integer> GetACLRelHeadIndices() {
		HashSet<Integer> head = new HashSet<Integer>();
		for (DependencyRelation rel : depRels) {
			if (rel.GetRelName().equals("acl") && pos.get(rel.GetDepIndex() - 1).equals("VBN")) {
				head.add(rel.GetHeadIndex());
			}
		}
		return head;
	}
	
	public HashSet<Integer> GetDetHeadIndices() {
		HashSet<Integer> head = new HashSet<Integer>();
		for (DependencyRelation rel : depRels) {
			if (rel.GetRelName().equals("det")) {
				head.add(rel.GetHeadIndex());
			}
		}
		return head;
	}
	
	public HashSet<Integer> GetPOSSHeadIndices() {
		HashSet<Integer> head = new HashSet<Integer>();
		for (DependencyRelation rel : depRels) {
			if (rel.GetRelName().equals("nmod:poss")) {
				head.add(rel.GetHeadIndex());
			}
		}
		return head;
	}
	
	public HashSet<Integer> GetCompoundDepdents() {
		HashSet<Integer> compound = new HashSet<Integer>();
		for (DependencyRelation rel : depRels) {
			if (IsCompoundWordsConditions(rel)) {
				compound.add(rel.GetDepIndex());
			}
		}
		return compound;
	}
	
	public HashSet<Integer> GetAppositiveDepdents() {
		HashSet<Integer> appositive = new HashSet<Integer>();
		for (DependencyRelation rel : depRels) {
			if (rel.GetRelName().equals("compound")
					&& pos.get(rel.GetHeadIndex() - 1).equals("NNP")
					&& pos.get(rel.GetDepIndex() - 1).equals("NN")
					&& rel.GetDepIndex() < rel.GetHeadIndex()) {
				appositive.add(rel.GetDepIndex());
			}
		}
		return appositive;
	}
	
	
	public HashMap<Integer, ArrayList<Integer>> getCompoundIndices() {
		HashMap<Integer, ArrayList<Integer>> compound = new HashMap<Integer, ArrayList<Integer>>();
		for (DependencyRelation rel : depRels) {
			if (IsCompoundWordsConditions(rel)) {
				if (compound.containsKey(rel.GetHeadIndex())) {
					ArrayList<Integer> list = compound.get(rel.GetHeadIndex());
					list.add(rel.GetDepIndex());
					Collections.sort(list);
					compound.put(rel.GetHeadIndex(), list);
				} else {
					ArrayList<Integer> list = new ArrayList<Integer>();
					list.add(rel.GetDepIndex());
					compound.put(rel.GetHeadIndex(), list);
				}
			}
		}
		return compound;
	}
	
	public boolean HasCompoundWords() {
		for (DependencyRelation rel : depRels) {
			if (IsCompoundWordsConditions(rel)) {
				return true;
			}
		}
		return false;
	}
	
	private boolean IsCompoundWordsConditions(DependencyRelation rel) {
		int head = rel.GetHeadIndex();
		int dep = rel.GetDepIndex();
		if (rel.GetRelName().equals("compound") &&
				(pos.get(head - 1).equals("NN") || pos.get(head - 1).equals("NNS")) &&
				(pos.get(dep - 1).equals("NN") || pos.get(dep - 1).equals("NNS"))) {
			return true;
		}
		return false;
	}
}
