package net.danvi.dmall.biz.system.security;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.CookieUtil;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

@Slf4j
public class SessionDetailHelper {

    public static DmallSessionDetails getDetails() {
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();

        if (authentication == null) {
            log.debug("## authentication object is null!!");
            return null;
        }

        if (authentication.getPrincipal() instanceof DmallSessionDetails) {
            DmallSessionDetails details = (DmallSessionDetails) authentication.getPrincipal();

            log.debug("## UserDetailHelper.getAuthenticatedUser : AuthenticatedUser is {}", details.getUsername());

            return details;
        } else {
            if (authentication.getDetails() instanceof DmallSessionDetails) {
                return (DmallSessionDetails) authentication.getDetails();
            } else {
                return null;
            }
        }
    }

    /**
     * 인증된 사용자 세션 객체 모델을 가져온다.
     * @return 사용자 객체 모델
     */
    public static Session getSession() {
        DmallSessionDetails details = getDetails();

        if(details != null) {
            return details.getSession();
        } else {
            return null;
        }
    }

    /**
     * 인증된 사용자의 권한 정보를 가져온다.
     * 예) [ROLE_ADMIN, ROLE_USER,
     * ROLE_A, ROLE_B, ROLE_RESTRICTED,
     * IS_AUTHENTICATED_FULLY,
     * IS_AUTHENTICATED_REMEMBERED,
     * IS_AUTHENTICATED_ANONYMOUSLY]
     * @return 사용자 권한정보 목록
     */
    public static List<String> getAuthorities() {
        List<String> listAuth = new ArrayList<String>();

        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();

        if (authentication == null) {
            log.debug("## authentication object is null!!");
            return null;
        }

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        Iterator<? extends GrantedAuthority> iter = authorities.iterator();

        while(iter.hasNext()) {
            GrantedAuthority auth = iter.next();
            listAuth.add(auth.getAuthority());

            log.debug("## UserDetailHelper.getAuthorities : Authority is {}", auth.getAuthority());

        }

        return listAuth;
    }

    /**
     * 인증된 사용자 여부를 체크한다.
     * @return 인증된 사용자 여부(TRUE / FALSE)
     */
    public static Boolean isAuthenticated() {
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();

        if (authentication == null) {
            log.debug("## authentication object is null!!");
            return Boolean.FALSE;
        }

        String username = authentication.getName();
        if (username.equals("anonymousUser")) {     // 기존 2.0.8의 경우 'roleAnonymous'
            log.debug("## username is {}", username);
            return Boolean.FALSE;
        }

        Object principal = authentication.getPrincipal();

        return (Boolean.valueOf(principal != null));
    }

    public static void setDetailsToCookie(DmallSessionDetails details, int maxAge) throws Exception {
        String cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
        CookieUtil.addEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, maxAge);
        // 스프링 시큐리티에 인증정보 추가
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(details.getUsername(),details.getPassword(), details.getAuthorities());
        auth.setDetails(details);
        SecurityContextHolder.getContext().setAuthentication(auth);
    }
}
