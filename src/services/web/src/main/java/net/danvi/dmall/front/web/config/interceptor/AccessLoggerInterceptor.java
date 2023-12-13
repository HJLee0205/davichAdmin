package net.danvi.dmall.front.web.config.interceptor;

import eu.bitwalker.useragentutils.DeviceType;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.WebLogPO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.LoggerService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import dmall.framework.common.util.HttpUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;

/**
 * 상점벌 화면으로 이동
 * Created by dong on 2016-03-14.
 */
@Slf4j
public class AccessLoggerInterceptor extends HandlerInterceptorAdapter {

    private static final String DEVICE_TYPE_PC = "P";
    private static final String DEVICE_TYPE_MOBILE = "M";
    //구글
    private static final String REFERER_GOOGLE = "G";
    //네이버
    private static final String REFERER_NAVER = "N";
    //다음
    private static final String REFERER_DAUM = "D";
    //네이트
    private static final String REFERER_NATE = "T";
    //다이렉트
    private static final String REFERER_DIRECT = "O"; //알파벳 O
    //기타
    private static final String REFERER_ETC = "E";

    //네이버블로그
    private static final String REFERER_NAVER_BLOG = "B";
    //줌
    private static final String REFERER_ZUM = "Z";
    //다비치보청기
    private static final String REFERER_HEARING = "H";
    //다비치안경
    private static final String REFERER_GLASS = "S";
    //다비치렌즈
    private static final String REFERER_LENS = "L";
    //광고매체
    private static final String REFERER_DREAM_SEARCH = "C";
    //페이스북
    private static final String REFERER_FACEBOOK = "F";
    //유투브
    private static final String REFERER_YOUTUBE = "Y";
    //인스타그램
    private static final String REFERER_INSTAGRAM = "I";
    //핀터레스트
    private static final String REFERER_PINTEREST = "P";
    //카카오
    private static final String REFERER_KAKAO = "K";


    @Resource(name = "loggerService")
    private LoggerService loggerService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        // ajax 가 아닐 경우만 처리
        if (!HttpUtil.isAjax(request)) {

            WebLogPO po = new WebLogPO();
            // Cookie jsessionid = CookieUtil.getCookieByName(request, CommonConstants.SESSION_ID_COOKIE_NAME);
            String jsessionid = request.getSession().getId();
            // 쿠키의 JSESSIONID와 세션의 ID는 같음
            UserAgent ua = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));

            if (ua.getOperatingSystem().getDeviceType() == DeviceType.COMPUTER) {
                po.setDeviceType(DEVICE_TYPE_PC);
            } else {
                po.setDeviceType(DEVICE_TYPE_MOBILE);
            }

            DmallSessionDetails details = SessionDetailHelper.getDetails();

            if (details != null) {
                po.setSiteNo(details.getSiteNo());
                po.setMemberNo(details.getSession().getMemberNo());
            }

            String referer = request.getHeader("referer");

            request.setAttribute("refererUrl" , referer);

            String url = request.getRequestURL().toString();
            if (request.getParameterMap() != null && !request.getParameterMap().isEmpty()) {
                Enumeration<String> names = request.getParameterNames();
                String name;
                int i=0;
                while (names.hasMoreElements()) {
                    name = names.nextElement();

                    if (!"_csrf".equals(name)) {
                        if(i>0) {
                            url += "&" + name + "=" + request.getParameter(name);
                        }else{
                            url += "?" + name + "=" + request.getParameter(name);
                        }
                        i++;
                    }
                }
            }
            log.debug("session ID : {}", jsessionid);
            po.setJsessionid(jsessionid);
            po.setIp(HttpUtil.getClientIp(request));

            if(request.getParameter("refererType")!=null && !request.getParameter("refererType").equals("")) {
                po.setReferer(request.getParameter("refererType"));
                request.setAttribute("refererType", request.getParameter("refererType"));
            }else{
                po.setReferer(getReferer(referer));
                request.setAttribute("refererType", getReferer(referer));
            }

            po.setUrl(StringUtils.left(url, 16000));

            log.debug("logger : {}", po);

            try {
                loggerService.insert(po);
            } catch (Exception e) {
                log.error("접속 로그 등록 에러:{}", e);
            }
        }

        return super.preHandle(request, httpServletResponse, o);
    }

    private String getReferer(String referer) {
        if (referer == null) {
            return REFERER_DIRECT;
        }

        if (referer.contains("?")) {
            referer = referer.substring(0, referer.indexOf("?"));
        }

        if (referer.indexOf("davichmarket.com") > -1 || referer.indexOf("admin.davichmarket.com") > -1) {
            return REFERER_DIRECT;
        } else if (referer.indexOf("blog.naver.") > -1) {//네이버 블로그
            return REFERER_NAVER_BLOG;
        } else if (referer.indexOf(".naver.") > -1) {//네이버
            return REFERER_NAVER;
        } else if (referer.indexOf(".daum.") > -1) {//다음
            return REFERER_DAUM;
        } else if (referer.indexOf(".nate.") > -1) {//네이트
            return REFERER_NATE;
        } else if (referer.indexOf(".google.") > -1) {//구글
            return REFERER_GOOGLE;
        } else if (referer.indexOf(".zum.") > -1) {//줌
            return REFERER_ZUM;
        } else if (referer.indexOf("davichhearing.") > -1) {//다비치보청기
            return REFERER_HEARING;
        } else if (referer.indexOf("davich.") > -1) {//다비치 안경
            return REFERER_GLASS;
        } else if (referer.indexOf("davichlens.") > -1) {//다비치 렌즈
            return REFERER_LENS;
        } else if (referer.indexOf("dreamsearch.") > -1) {//광고 매체
            return REFERER_DREAM_SEARCH;
        } else if (referer.indexOf(".facebook.") > -1) {//페이스북
            return REFERER_FACEBOOK;
        } else if (referer.indexOf("youtube.") > -1) {//유투브
            return REFERER_YOUTUBE;
        } else if (referer.indexOf(".instagram.") > -1) {//인스타그램
            return REFERER_INSTAGRAM;
        } else if (referer.indexOf("pinterest.") > -1) {//핀터레스트
            return REFERER_PINTEREST;
        } else if (referer.indexOf("kakao.") > -1) {//카카오
            return REFERER_KAKAO;
        } else {
            return REFERER_ETC;
        }
    }
}