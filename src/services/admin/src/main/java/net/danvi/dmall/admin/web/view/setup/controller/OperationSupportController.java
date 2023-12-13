package net.danvi.dmall.admin.web.view.setup.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigPO;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigVO;
import net.danvi.dmall.biz.app.setup.operationsupport.service.OperationSupportConfigService;
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
@RequestMapping("/admin/setup/config/opersupport")
public class OperationSupportController {
    @Resource(name = "operationSupportConfigService")
    private OperationSupportConfigService operationSupportConfigService;

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 SEO설정 페이지 이동
     */
    @RequestMapping("/operation-support-settings")
    public ModelAndView viewOperSupportConfig(HttpServletRequest request) {
        String typeCd = request.getParameter("typeCd");
        ModelAndView mav = new ModelAndView("/admin/setup/opersupport/" + typeCd + "Config");
        mav.addObject("typeCd", typeCd);
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 SEO설정 정보를 조회한다.
     */
    @RequestMapping("/seo-config")
    public @ResponseBody ResultModel<OperSupportConfigVO> selectSeoConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<OperSupportConfigVO> result = operationSupportConfigService.selectSeoConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 GA설정 정보를 조회한다.
     */
    @RequestMapping("/ga-config")
    public @ResponseBody ResultModel<OperSupportConfigVO> selectGaConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<OperSupportConfigVO> result = operationSupportConfigService.selectGaConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 080 수신거부 서비스 설정 정보를 조회한다.
     */
    @RequestMapping("/080-config")
    public @ResponseBody ResultModel<OperSupportConfigVO> select080Config() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<OperSupportConfigVO> result = operationSupportConfigService.select080Config(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 이미지 호스팅 설정 정보를 조회한다.
     */
    @RequestMapping("/image-config")
    public @ResponseBody ResultModel<OperSupportConfigVO> selectImageConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<OperSupportConfigVO> result = operationSupportConfigService.selectImageConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 SEO설정 정보를 수정한다
     */
    @RequestMapping("/seo-config-update")
    public @ResponseBody ResultModel<OperSupportConfigPO> updateSeoConfig(
            @Validated(UpdateGroup.class) OperSupportConfigPO po, HttpServletRequest request,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<OperSupportConfigPO> result = operationSupportConfigService.updateSeoConfig(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 사이트에 설정된 GA설정 정보를 수정한다
     */
    @RequestMapping("/ga-config-update")
    public @ResponseBody ResultModel<OperSupportConfigPO> updateGaConfig(
            @Validated(UpdateGroup.class) OperSupportConfigPO po, HttpServletRequest request,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<OperSupportConfigPO> result = operationSupportConfigService.updateGaConfig(po, request);
        return result;
    }
}