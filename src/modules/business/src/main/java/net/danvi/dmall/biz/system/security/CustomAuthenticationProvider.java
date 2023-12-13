package net.danvi.dmall.biz.system.security;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.LoginVO;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.DormantAccountException;
import dmall.framework.common.exception.LockedAccountException;
import dmall.framework.common.exception.LoginCaptchaException;
import dmall.framework.common.exception.WithdrawalAccountException;
import dmall.framework.common.util.CaptchaUtil;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;

/**
 * Created by dong on 2016-04-04.
 */
@Slf4j
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        log.info("authenticate =====================================");

        // 밖으로 던저지는 예외는 LoginFailureHandler 에서 처리...

        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        String username = authentication.getName();
        String password = (String) authentication.getCredentials();
        DmallSessionDetails details = SessionDetailHelper.getDetails();
        Long siteNo = details.getSiteNo();
        LoginVO user;

        try {
            user = new LoginVO();
            user.setLoginId(username);
            user.setSiteNo(siteNo);
            user = loginService.getUser(user);
        } catch (Exception e) {
            log.info("error", e);
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_FAIL));
        }

        // 아이디에 해당하는 사용자가 없으면
        if (user == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_NOT_EXSITS_ID));
        }

        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        HttpSession httpSession = request.getSession();
        String captcha = (String) httpSession.getAttribute(CaptchaUtil.CAPTCHA_DATA);
        String answer = request.getParameter("captcha");
        
        //log.info(CryptoUtil.encryptSHA512(password));
        
        if (user.getPw().equals(CryptoUtil.encryptSHA512(password))) {

            // 캡차 코드 설정되어 있고 입력받은 값과 다르면
            if (captcha != null && !captcha.equals(answer)) {
                throw new LoginCaptchaException("");
            }

            // 비밀번호가 같으면
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));

            if (user.getLoginFailCnt() > 0) {
                // 로그인 실패 카운트가 0보다 크면
                try {
                    loginService.resetUserFailCnt(user);
                } catch (CloneNotSupportedException e) {
                    log.info("로그인 실패 카운트 갱신 오류 : {}", user, e);
                }
            }
            httpSession.removeAttribute(CaptchaUtil.CAPTCHA_DATA);
        } else {
            // 비밀번호 다름 오류 카운트 추가
            loginService.updateLoginErrorCount(user);

            // 비밀번호 오류 카운트 처리
            /*if (user.getLoginFailCnt() >= 4) {

                if (user.getLoginFailCnt() == 4) {
                    throw new LockedAccountException("");
                } else if (captcha == null || !captcha.equals(answer)) {
                    throw new LoginCaptchaException("");
                }
                httpSession.removeAttribute(CaptchaUtil.CAPTCHA_DATA);
            }*/

            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_WRONG_PASSWORD));
        }
        
        // 사업자 미승인 상태인 경우 로그인 불가 처리 - 회원구분코드 (개인:01, 사업자:02, 사업자 미승인상태:03)
        if ("03".equals(user.getMemberTypeCd())) {
        	throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_NOT_CONFIRM_ID));
        }

        // 회원 권한에 따른 처리
        if ("A".equals(user.getAuthGbCd()) || "M".equals(user.getAuthGbCd())) {
            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        }
        
        // 판매자 메인 권한 추가
        if ("S".equals(user.getAuthGbCd())) {
            authorities.add(new SimpleGrantedAuthority("ROLE_SELLER"));
        }
        

        // TODO: 회원 상태에 따른 처리
        switch (user.getMemberStatusCd()) {
        case "01":
            // 일반회원
            break;
        case "02":
            log.info("휴면회원:{}", username);
            // 휴면회원 복구 처리
            throw new DormantAccountException("");
        default:
            log.info("탈퇴회원:{}", username);
            // 탈퇴회원 및 미분류회원
            throw new WithdrawalAccountException("");
        }

        /**
         * 로그인 정보로 세션 데이터 생성
         */
        Session session = new Session(user);
        session.setLastAccessDate(Calendar.getInstance().getTime());

        // TODO: 성능 문제 생기면 쿠키에 박는 것도 고려...
        // if("A".equals(user.getAuthGbCd()) || "M".equals(user.getAuthGbCd())) {
        // session.setMenuAuthList(menuService.getAuthMenuList(user));
        // }

        UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(username, password,authorities);
        try {
            result.setDetails(new DmallSessionDetails(username, CryptoUtil.encryptSHA512(password), session, authorities));

            //코드정보 갱신
            cacheService.listCodeCacheRefresh();
        } catch (Exception e) {
            throw new CustomException("비밀번호 암호화 중 오류가 발생하였습니다.", e);
        }

        return result;
    }

    public boolean supports(Class<?> aClass) {
        return (UsernamePasswordAuthenticationToken.class.isAssignableFrom(aClass));
    }
}
