package com.davichmall.ifapi.cmmn;

import java.util.Collections;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class EncHttpServletRequestWrapper extends HttpServletRequestWrapper {
	
	private final Map<String, String[]> modifiableParameters;
	private Map<String, String[]> allParameters = null;
	
	public EncHttpServletRequestWrapper(HttpServletRequest request, final Map<String, String[]> additionalParams) {
		super(request);
		this.modifiableParameters = new TreeMap<>();
		this.modifiableParameters.putAll(additionalParams);
	}
	
	@Override
	public String getParameter(String name) {
		String[] strings = getParameterMap().get(name);
		if(strings != null) {
			return strings[0];
		}
		return super.getParameter(name);
	}
	
	@Override
	public Map<String, String[]> getParameterMap() {
		if(allParameters == null) {
			allParameters = new TreeMap<>();
			allParameters.putAll(super.getParameterMap());
			allParameters.putAll(modifiableParameters);
		}
		return Collections.unmodifiableMap(allParameters);
	}
	
	@Override
	public Enumeration<String> getParameterNames() {
		return Collections.enumeration(getParameterMap().keySet());
	}
	
	@Override
	public String[] getParameterValues(String name) {
		return getParameterMap().get(name);
	}

}
