package net.danvi.dmall.biz.system.security;

import org.springframework.security.web.util.matcher.RegexRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Created by dong on 2016-05-09.
 */
public class CsrfSecurityRequestMatcher implements RequestMatcher {
    private Pattern allowedMethods = Pattern.compile("^(GET|HEAD|TRACE|OPTIONS)$");
    private List<RegexRequestMatcher> unprotectedMatchers;

    public CsrfSecurityRequestMatcher(List<String> urls) {
        unprotectedMatchers = new ArrayList<>();
        RegexRequestMatcher matcher;
        for(String url : urls) {
            matcher = new RegexRequestMatcher(url, null);
            unprotectedMatchers.add(matcher);
        }
    }

    public CsrfSecurityRequestMatcher(String url) {
        unprotectedMatchers = new ArrayList<>();
        RegexRequestMatcher matcher = new RegexRequestMatcher(url, null);
        unprotectedMatchers.add(matcher);
    }

    @Override
    public boolean matches(HttpServletRequest request) {
        if(allowedMethods.matcher(request.getMethod()).matches()){
            return false;
        }

        boolean match = false;
        for(RequestMatcher unprotectedMatcher : unprotectedMatchers) {
            if(unprotectedMatcher.matches(request)) {
                return true;
            }
        }

        return match;
    }
}
