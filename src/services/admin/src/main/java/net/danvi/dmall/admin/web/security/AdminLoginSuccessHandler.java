package net.danvi.dmall.admin.web.security;

import com.ckd.common.reqInterface.SolutionResult;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.remote.homepage.service.HomepageRemoteDelegateService;
import net.danvi.dmall.biz.system.security.LoginSuccessHandler;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.time.DateFormatUtils;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.security.core.Authentication;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.SiteUtil;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 4. 4.
 * 작성자     : dong
 * 설명       : 스프링 시큐리티 로그인 성공 핸들러
 * </pre>
 */
@Slf4j
@EnableAsync
public class AdminLoginSuccessHandler extends LoginSuccessHandler {

    @Resource(name = "homepageRemoteDelegateService")
    private HomepageRemoteDelegateService homepageRemoteService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        super.onAuthenticationSuccess(request, response, authentication);

        Session session = SessionDetailHelper.getSession();

        if (CommonConstants.AUTH_GB_CD_ADMIN.equals(session.getAuthGbCd())) {
            // 관리자인 경우 로그인 정보를 홈페이지로 전송,
            SolutionResult vo = new SolutionResult();
            vo.setAdminId(session.getLoginId());
            vo.setSiteNo(session.getSiteNo());
            vo.setSiteId(SiteUtil.getSiteId());
            vo.setVisitDate(DateFormatUtils.format(session.getLastAccessDate(), "yyyyMMddhhmmSSS"));

            try {
                // 홈페이지로 전송
                //homepageRemoteService.reqSolutionAdminLoginHistoryInfo(vo);
            } catch (Exception e) {
                log.warn("홈페이지 로그인 이력 전송 오류, [{}:{}]", vo.getSiteNo(), vo.getAdminId());
            }
        }
    }

    @Override
    protected int getCookieExpireTime(Long siteNo) {
        return 60*60*24; // 1일
    }
}
