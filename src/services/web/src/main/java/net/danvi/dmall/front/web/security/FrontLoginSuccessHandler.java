package net.danvi.dmall.front.web.security;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.app.promotion.event.service.EventService;
import net.danvi.dmall.biz.app.promotion.event.service.FrontEventService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.security.LoginSuccessHandler;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.security.core.Authentication;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import org.springframework.util.DigestUtils;

/**
 * Created by dong on 2016-04-04.
 */
@Slf4j
public class FrontLoginSuccessHandler extends LoginSuccessHandler {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "eventService")
    private EventService eventService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Resource(name = "frontEventService")
    private FrontEventService frontEventService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        Session session = SessionDetailHelper.getSession();
        Long siteNo = session.getSiteNo();

        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);
        LoginVO loginVO = new LoginVO();
        loginVO.setSiteNo(siteNo);
        loginVO.setLoginId(session.getLoginId());
        loginVO = loginService.getUser(loginVO);
        Date pwChgDttm = loginVO.getPwChgDttm();
        Calendar cal = Calendar.getInstance(Locale.KOREA);
        Date now = cal.getTime();

        try {
            // 출석체크 이벤트(EventKindCd:02)있고 타입이 로그인형(EventMethodCd:01)일 경우 출석체크처리를 한다.
            EventSO ingSo = new EventSO();
            ingSo.setSiteNo(siteNo);
            String[] ingStatusCd = { "02" };
            ingSo.setEventStatusCds(ingStatusCd);
            ingSo.setEventKindCd("02");
            ingSo.setEventMethodCd("01");
            ResultListModel<EventVO> eventIngList = eventService.selectEventList(ingSo);

            if (eventIngList.getResultList() != null) {
                int listSize = eventIngList.getResultList().size();
                int sucCnt = 0;
                if (listSize > 0) {
                    for (int i = 0; i < listSize; i++) {
                        EventVO ev = (EventVO) eventIngList.getResultList().get(i);
                        EventLettPO po = new EventLettPO();
                        po.setEventNo(ev.getEventNo());
                        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        ResultModel<EventLettPO> result = frontEventService.insertAttendanceCheck(po); // 로그인 출석체크처리
                        if (result.isSuccess()) {
                            sucCnt++;
                        }
                    }
                }

                if (sucCnt > 0) {
                    setResultMsg(request, "출석체크 하였습니다.");
                }
            }
        } catch (Exception e) {
            log.error("출석체크 오류", e);
        }

        // 비밀번호 변경 안내 사용 여부 체크
        if (CommonConstants.YN_Y.equals(siteCacheVO.getPwChgGuideYn())) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String formatNow = simpleDateFormat.format(now);
            String formatNextDate = simpleDateFormat.format(loginVO.getNextPwChgScdDttm());
            int resultCnt = formatNow.compareTo(formatNextDate);

            String mobileContext = "";
            if(SiteUtil.isMobile()){
                mobileContext = "/m";
            }
            if (resultCnt == 0 || resultCnt > 0) {
                setChildReturnUrl(request, mobileContext+"/front/login/change-password-step1");
            }
        }

        String criteoEmail = loginVO.getLoginId();
        String criteoZipcode = loginVO.getNewPostNo();
        criteoEmail = criteoEmail != null? DigestUtils.md5DigestAsHex(criteoEmail.getBytes(StandardCharsets.UTF_8)): "";
        criteoZipcode = criteoZipcode != null? criteoZipcode: "";

        request.getSession().setAttribute("criteoEmail", criteoEmail);
        request.getSession().setAttribute("criteoZipcode", criteoZipcode);

        super.onAuthenticationSuccess(request, response, authentication);
    }

    @Override
    protected int getCookieExpireTime(Long siteNo) throws Exception {
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        if (vo.getAutoLogoutTime() == 0) {
            return -1;
        } else {
            return vo.getAutoLogoutTime() * 60;
        }
    }

    private void setResultMsg(HttpServletRequest request, String msg) {
        request.setAttribute(DMALL_LOGIN_MSG, msg);
    }

    private void setChildReturnUrl(HttpServletRequest request, String url) {
        request.setAttribute(DMALL_LOGIN_RETURN_URL, url);
    }
}
