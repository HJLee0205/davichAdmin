package com.konantech.ksf.std.openapi;

import java.util.Map;
import java.util.TreeMap;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.konantech.ksf.client.impl.RestClient;
import com.konantech.ksf.client.impl.XMLResponseParser;
import com.konantech.ksf.client.request.KsfRequest;
import com.konantech.ksf.common.KsfException;
import com.konantech.ksf.std.SearchResultSetWrapper;

public class NaverImage {
	
	private static final String[] COLUMN_NAMES = { "link", "thumbnail",
			"sizewidth", "sizeheight" };

	public SearchResultSetWrapper search(String key, String query, int offset,
			int limit) {
		RestClient client = new RestClient("http://openapi.naver.com");
		KsfRequest req = new KsfRequest("/search");
		req.setParameter("key", key);
		req.setParameter("query", query);
		req.setParameter("target", "image");
		req.setParameter("start", offset + 1);
		req.setParameter("display", limit);
		req.setParameter("sort", "sim");
		req.setParameter("filter", "all");

		Element element = (Element) client.request(req, new XMLResponseParser());
		if ("error".equals(element.getTagName())) {
			throwError(element);
		}
		NodeList itemNodes = element.getElementsByTagName("item");
		int totalCount = getTotalCount(element);
		int rowCount = itemNodes.getLength(); 
		SearchResultSetWrapper srs = new SearchResultSetWrapper(totalCount, rowCount,
				COLUMN_NAMES);
		for (int i = 0; i < rowCount; i++) {
			srs.add(parseItem((Element) itemNodes.item(i)));
		}
		return srs;
	}

	private int getTotalCount(Element element) {
		return Integer.parseInt(element.getElementsByTagName("total").item(0)
				.getTextContent());
	}
	
	private Map<String, Object> parseItem(Element element) {
		Map<String, Object> columnMap = new TreeMap<String, Object>(
				String.CASE_INSENSITIVE_ORDER);
		for (String columnName : COLUMN_NAMES) {
			columnMap.put(columnName, element.getElementsByTagName(columnName)
					.item(0).getTextContent());
		}
		return columnMap;
	}
	
	private void throwError(Element element) {
		throw new KsfException(element.getElementsByTagName("message").item(0)
				.getTextContent());
	}
	
}
