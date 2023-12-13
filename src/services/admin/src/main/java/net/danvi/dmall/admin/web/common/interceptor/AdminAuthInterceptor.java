package net.danvi.dmall.admin.web.common.interceptor;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.MenuVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.MenuService;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.HttpUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * Created by dong on 2016-05-17.
 */
@Slf4j
public class AdminAuthInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        Long siteNo = siteService.getSiteNo(request.getServerName());
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);
        MenuVO menuVO = new MenuVO();
        String uri = request.getRequestURI();

        // ajax 요청이 아니면
        if (!HttpUtil.isAjax(request)) {
            menuVO.setUrl(uri);
            menuVO.setSiteTypeCd(siteCacheVO.getSiteTypeCd());

            // 접속 가능하지 않으면
            if (!menuService.isAccessable(menuVO)) {
                throw new AccessDeniedException("접속할 권한이 없습니다.");
            }
        }

        DmallSessionDetails details = SessionDetailHelper.getDetails();
        Session session = details.getSession();

        log.info("loginyn : {}", session);
        
        Date now = new Date();
        log.info("쿠키 마지막 접속 시간:{}", session.getLastAccessDate());
        Long timeGap = (now.getTime() - session.getLastAccessDate().getTime());

        if (timeGap > 365 * 24 * 60 * 60) {
            // 쿠키 타임 갭이 30분 초과면 (30 * 60 * 1000) , (365 * 24 * 60 * 60) 1년
            throw new AccessDeniedException("로그인 정보가 만료되었습니다.");
        }
        session.setLastAccessDate(now);
        log.info("쿠키 마지막 접속 시간 세팅:{}", session.getLastAccessDate());
        details.setSession(session);
        SessionDetailHelper.setDetailsToCookie(details, 365 * 24 * 60 * 60); // 쿠키 유효시간 30을 분으로 갱신 , (365 * 24 * 60 * 60) 1년

        return super.preHandle(request, httpServletResponse, o);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {

        String uri = request.getRequestURI();
        log.info("uri : {}", uri);
        
        boolean mallMenu;
        
        //판매자몰 menu일경우
        if ((uri.contains("/admin/seller/main/")) ||
           (uri.contains("/admin/seller/setup/")) ||
           (uri.contains("/admin/seller/goods/")) ||
           (uri.contains("/admin/seller/order/")) ||
           (uri.contains("/admin/seller/calc/"))) {
        	mallMenu = true;
        } else {
        	mallMenu = false;
        }

        log.info("isAjax : {}", HttpUtil.isAjax(request));
        log.info("modelAndView isNotNull : {}", modelAndView != null);
        // ajax 요청이 아니면
        if (!HttpUtil.isAjax(request) && modelAndView != null) {

            String[] temp = uri.split("/");
            if (temp.length > 2) {
                String url = "/" + temp[1] + "/" + temp[2];
                
                
                if (mallMenu) {
                	url = "/" + temp[1] + "/" + temp[2] + "/" + temp[3];
                }
                
                log.info("loginyn : {}", SessionDetailHelper.getSession());
                log.info("메뉴 조회 : {}", url);

                modelAndView.addObject(RequestAttributeConstants.MENU, menuService.selectMenuTree(mallMenu));
                modelAndView.addObject(RequestAttributeConstants.SUB_MENU, menuService.selectSideMenuTree(url));
            }

//            Long siteNo = siteService.getSiteNo(request.getServerName());
//
//            LoginVO loginVO = new LoginVO();
//            loginVO.setSiteNo(siteNo);
//            loginVO.setMemberNo(SessionDetailHelper.getSession().getMemberNo());
//            modelAndView.addObject(RequestAttributeConstants.LEVEL_1_MENU, menuService.getAuthLv1MenuMap(loginVO));
        }

        super.postHandle(request, response, handler, modelAndView);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 쿠키에 인증정보 추가
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param details
     * @throws Exception
     */
//    protected void setDetailsToCookie(DmallSessionDetails details, int maxAge) throws Exception {
//        String cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
//        CookieUtil.addEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, maxAge);
//        // 스프링 시큐리티에 인증정보 추가
//        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(details.getUsername(),
//                details.getPassword(), details.getAuthorities());
//        auth.setDetails(details);
//        SecurityContextHolder.getContext().setAuthentication(auth);
//    }
}
