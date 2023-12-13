package net.danvi.dmall.admin.web.view.login.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.BizService;
import dmall.framework.common.util.HttpUtil;

/**
 * 로그인 Controller
 * 
 * @author dykim
 * @since 2016.02.25
 */
@Slf4j
@Controller
@RequestMapping("/admin/login")
public class LoginController {

    @Resource(name = "bizService")
    private BizService bizService;

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 로그인 페이지
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/member-login")
    public ModelAndView viewLogin() {
        log.debug("================================");
        log.debug("Start : " + "로그인 페이지 시작");
        log.debug("================================");

        ModelAndView mav = new ModelAndView("/admin/login/login");

        String domain = HttpUtil.getHttpServletRequest().getServerName();
        log.debug("domain : {}", domain);

        bizService.getSiteNo(domain);

        return mav;
    }

    // @RequestMapping(value = "/loginprocess", method = RequestMethod.POST)
    // public String login(Model model, @RequestParam("loginId") String id, @RequestParam("password") String pwd) {
    //
    // String resultCode = adminLoginService.getLoginCheck(id, pwd);
    // String resultMsg = null;
    // if (StringUtil.isNotBlank(resultCode)) {
    // resultMsg = message.getMessage(ExceptionConstants.BIZ_EXCEPTION + resultCode);
    // resultCode = AdminConstants.CONTROLLER_RESULT_CODE_FAIL;
    // } else {
    // resultCode = AdminConstants.CONTROLLER_RESULT_CODE_SUCCESS;
    // }
    //
    // model.addAttribute(AdminConstants.CONTROLLER_RESULT_CODE, resultCode);
    // model.addAttribute(AdminConstants.CONTROLLER_RESULT_MSG, resultMsg);
    // model.addAttribute("returnUrl", "/admin/main/main-view");
    //
    // return View.jsonView();
    // }

    // @RequestMapping("/logout")
    // public String logout(HttpServletRequest request) {
    //
    // HttpSession session = request.getSession(false);
    //
    // if (session != null) {
    // session.invalidate();
    // }
    //
    // return View.redirect("/admin/login/member-login");
    // }

}