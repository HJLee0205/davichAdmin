package com.konantech.ksf.std;

import org.apache.commons.lang3.StringUtils;

public class Stuffs {

	private String query;
	private String previousQuery;
	private String sort;
	private String[] previousQueries;
	private int totalCount = 0;

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public String getPreviousQuery() {
		return previousQuery;
	}

	public void setPreviousQuery(String previousQuery) {
		this.previousQuery = previousQuery;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}
	
	public String getLogSort() {
		return "d".equals(sort) ? "날짜순" : "정확도순";
	}

	public String[] getPreviousQueries() {
		return previousQueries;
	}

	public void setPreviousQueries(String[] previousQueries) {
		this.previousQueries = previousQueries;
	}

	public boolean isResrch() {
		return (previousQueries != null && previousQueries.length > 0);
	}
	
	public String getLogType() {
		return isResrch() ? "재검색" : "첫검색";
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void incTotalCount(int count) {
		totalCount += count;
	}
	
	public String getHighlightingText() {
		return isResrch() 
				? new StringBuffer(query).append(' ')
						.append(StringUtils.join(previousQueries, ' '))
						.toString()
				: query;
	}

}
