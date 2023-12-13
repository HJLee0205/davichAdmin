package com.davichmall.ifapi.cmmn;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.HashedMap;

import com.davichmall.ifapi.util.IFCryptoUtil;

public class EncDecFilter implements Filter {
	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
			throws IOException, ServletException {
		if (servletRequest instanceof HttpServletRequest) {
			HttpServletRequest request = (HttpServletRequest) servletRequest;
			try {
				servletRequest = getDecReq(request);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		filterChain.doFilter(servletRequest, servletResponse);
	}
	
	@Override
	public void destroy() {
	}
	
	@Override
	public void init(FilterConfig filterConfig) {}
	
	private EncHttpServletRequestWrapper getDecReq(HttpServletRequest request) throws Exception {
		String fromIF = request.getParameter("fromIF");
		@SuppressWarnings("unchecked")
		Map<String, String[]> additionalParams = new HashedMap();
		if(fromIF != null && "true".equals(fromIF)) {
			String encParam = request.getParameter("encParam");
			String decParam = IFCryptoUtil.decryptAES(encParam);
			String[] decParams = decParam.split("&");
			for(String param : decParams) {
				if("".equals(param)) continue;
				int substrPoint = param.indexOf("=");
				if(substrPoint> -1) {
					String key = param.substring(0, substrPoint);
					String value = URLDecoder.decode(param.substring(substrPoint + 1), "UTF-8");
					String[] valueArr = {value};
					additionalParams.put(key, valueArr);
				}
			}
		}
		EncHttpServletRequestWrapper req = new EncHttpServletRequestWrapper(request, additionalParams);
		
		return req;
	}
}
