package net.danvi.dmall.admin.web.view.setup.controller;

import javax.annotation.Resource;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigPO;
import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigVO;
import net.danvi.dmall.biz.app.setup.memberinfo.service.MemberInfoChgService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * Created by dong on 2016-05-03.
 */

@Slf4j
@Controller
@RequestMapping("/admin/setup/config/memberinfo")
public class MemberInfoChgController {
    @Resource(name = "memberinfoChgService")
    private MemberInfoChgService memberinfoChgService;

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 회원정보 변경 설정 페이지 이동
     */
    @RequestMapping("/memberinfo-change-config")
    public ModelAndView viewMemberInfoChg() {
        log.debug("================================");
        log.debug("Start : " + "회원정보 변경 관리 페이지 시작");
        log.debug("================================");

        ModelAndView mav = new ModelAndView("/admin/setup/memberInfoChg");
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 회원정보 변경 설정정보 단건 조회
     */
    @RequestMapping("/memberinfo-change-info")
    public @ResponseBody ResultModel<PasswordChgConfigVO> selectMemberInfoChg() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<PasswordChgConfigVO> result = memberinfoChgService.selectPasswordChgConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 회원정보 변경 설정 정보 수정
     */
    @RequestMapping("/passwordchange-config-update")
    public @ResponseBody ResultModel<PasswordChgConfigPO> updatePasswordChgConfig(
            @Validated(UpdateGroup.class) PasswordChgConfigPO po, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<PasswordChgConfigPO> result = memberinfoChgService.updatePasswordChgConfig(po);
        return result;
    }
}