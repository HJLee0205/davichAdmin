package com.konantech.ksf.std;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SearchResultSetWrapper {
	
	private int totalCount;
	private int rowCount;
	private String[] columnNames;
	private List<Map<String, Object>> rows;
	
	public SearchResultSetWrapper(int totalCount, int rowCount,
			String[] columnNames) {
		this.totalCount = totalCount;
		this.rowCount = rowCount;
		this.columnNames = columnNames;
		this.rows = new ArrayList<Map<String, Object>>(rowCount);
	}
	
	public int getTotalCount() {
		return totalCount;
	}

	public int getRowCount() {
		return rowCount;
	}
	
	public String[] getColumnNames() {
		return columnNames;
	}

	public List<Map<String, Object>> getRows() {
		return rows;
	}	
	
	public void add(Map<String, Object> columnMap) {
		rows.add(columnMap);
	}

}
