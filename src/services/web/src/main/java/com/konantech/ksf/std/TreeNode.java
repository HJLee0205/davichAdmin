package com.konantech.ksf.std;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.konantech.ksf.client.result.SearchResultSet;

public class TreeNode {

	private String title = null;
	private String key = null;
	private int count = -1;
	private Map<String, TreeNode> children;

	public TreeNode() {
		this("", "");
	}
	
	public TreeNode(String title, String key) {
		this.title = title;
		this.key = key;
	}
	
	public String getTitle() {
		return title;
	}

	public String getKey() {
		return key;
	}

	public int getCount() {
		// not calculated
		if (count == -1) {
			if (hasChildren()) {
				// summing up children's count
				count = 0;
				for (TreeNode child : children.values()) {
					count += child.getCount();
				}
			} else {
				count = 0;
			}
		}
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public Collection<TreeNode> getChildren() {
		return (children != null) ? children.values() : null;
	}
	
	public TreeNode getChild(String title) {
		if (children != null) {
			return children.get(title);
		}
		return null;
	}
	
	public TreeNode addChild(String title, String key) {
		if (children == null) {
			children = new HashMap<String, TreeNode>();
		}
		TreeNode node = new TreeNode(title, key);
		children.put(title, node);
		return node;
	}
	
	public boolean hasChildren() {
		return (children != null && children.size() > 0);
	}
	
	public static TreeNode createSubtree(SearchResultSet groups,
			char separatorChar) {
		TreeNode root = new TreeNode();
		// reset result set
		groups.absolute(0);
		while (groups.next()) {
			String path = (String) groups.getObject("key");
			String[] tokens = StringUtils.split(path, separatorChar);
			int count = (Integer) groups.getObject("size");
			int pos = -1;
			TreeNode node = root;
			for (int i = 0; i < tokens.length; i++) {
				pos += tokens[i].length() + 1;
				TreeNode child = node.getChild(tokens[i]);
				node = (child == null) 
						? node.addChild(tokens[i], path.substring(0, pos)) 
						: child;
				if (i == tokens.length - 1) {
					// leaf
					node.setCount(count);
				}
			}
		}
		return root;
	}
	
}
