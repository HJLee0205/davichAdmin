package net.danvi.dmall.biz.system.interceptor;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.exception.SiteClosedException;
import dmall.framework.common.exception.SiteNotExistException;
import dmall.framework.common.exception.SitePrepareException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
public class CommonSiteInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        log.debug("ServerName : {}", httpServletRequest.getServerName());
        log.debug("URL : {}", httpServletRequest.getRequestURL());
        log.debug("URI : {}", httpServletRequest.getRequestURI());

        setSiteIdToSession(httpServletRequest, httpServletResponse);

        return super.preHandle(httpServletRequest, httpServletResponse, o);
    }

    private void setSiteIdToSession(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws SiteClosedException, SitePrepareException, SiteNotExistException {
        HttpSession session = httpServletRequest.getSession();
        Long siteNo = siteService.getSiteNo(httpServletRequest);
        String siteStatusCd = "";
        SiteCacheVO vo = null;
        if(siteNo != null) {
            vo = siteService.getSiteInfo(siteNo);
        }

        if(vo != null) {
            siteStatusCd = vo.getSiteStatusCd();
        }

        switch (siteStatusCd) {
            case "01": // 등록
                throw new SitePrepareException("[" + vo.getSiteNm() + "]는 현재 등록중인 쇼핑몰입니다.");
            case "02": // 정상
                break;
            case "03": // 중지
                throw new SiteClosedException("[" + vo.getSiteNm() + "]는 현재 중지 상태인 쇼핑몰입니다.");
            case "04": // 휴면
                throw new SiteClosedException("[" + vo.getSiteNm() + "]는 현재 휴면 상태인 쇼핑몰입니다.");
            case "05": // 폐쇄
            default:
                httpServletResponse.setStatus(404);
                throw new SiteNotExistException("찾을 수 없는 페이지입니다.");
        }

        session.setAttribute(RequestAttributeConstants.SITE_ID, vo.getSiteId());
    }
}