package net.danvi.dmall.admin.web.view.statistics.controller;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusSO;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusVO;
import net.danvi.dmall.biz.app.statistics.service.LoginCurrentStatusService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;

@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class LoginCurrentStatusAnlsController {

    @Resource(name = "loginCurrentStatusService")
    private LoginCurrentStatusService loginCurrentStatusService;

    @RequestMapping("/login-currentstatus-analysis")
    public ModelAndView viewLoginCurrentStatusList(LoginCurrentStatusSO loginCurrentStatusSO) {
        ModelAndView mav = new ModelAndView("/admin/statistics/loginCurrentStatusAnls");
        return mav;
    }

    @RequestMapping("/login-currentstatus")
    public @ResponseBody ResultListModel<LoginCurrentStatusVO> selectLoginCurrentStatusList(LoginCurrentStatusSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        so.setSiteNo(sessionInfo.getSiteNo());

        ResultListModel<LoginCurrentStatusVO> resultListModel = loginCurrentStatusService.selectLoginCurrentStatusList(so);
        return resultListModel;
    }
}
