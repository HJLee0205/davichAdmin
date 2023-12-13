package com.davichmall.ifapi.util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import com.davichmall.ifapi.cmmn.constant.Constants;

import dmall.framework.common.util.CryptoUtil;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.util
 * - 파일명        : SessionUtil.java
 * - 작성일        : 2018. 6. 14.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 서비스 호출시 세션에서 값을 꺼내 사용하는 부분이 있어 해당 값들을 설정하여 강제로 세션을 생성
 * </pre>
 */
public class SessionUtil {
	
	public static void setMallSession() throws Exception {

		if(SessionDetailHelper.getDetails() != null) {
			return;
		}
		
		// 기본 값
		Long username = Constants.IF_REGR_NO;
		Long siteNo = Constants.SITE_NO;
		String password = "";
		List<SimpleGrantedAuthority> authorities = new ArrayList<>();
		
        LoginVO user = new LoginVO();
        user.setSiteNo(siteNo);
        user.setMemberNo(username);
        
        // 세션 생성
        Session session = new Session(user);
        session.setLastAccessDate(Calendar.getInstance().getTime());
        
        // Authentication 생성
		UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(username, password, authorities);
		// Authentication개체에 상세 설정
		auth.setDetails(new DmallSessionDetails(username.toString(), CryptoUtil.encryptSHA512(password), session, authorities));
		
		// context 개체 취득
		SecurityContext context = SecurityContextHolder.getContext();
		
		// context에 Authentication설정
		context.setAuthentication(auth);
	}

}
