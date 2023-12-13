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
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigPO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigSO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * Created by dong on 2016-06-08.
 */

@Slf4j
@Controller
@RequestMapping("/admin/setup/config/snsoutside")
public class SnsOutsideLinkController {
    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 컨텐츠 공유관리 설정정보 페이지 이동
     */
    @RequestMapping("/content-config")
    public ModelAndView viewContentConfig() {
        ModelAndView mav = new ModelAndView("/admin/setup/snsoutside/contentsLinkConfig");
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 컨텐츠 공유관리 설정정보 단건 조회
     */
    @RequestMapping("/contents-config")
    public @ResponseBody ResultModel<SnsConfigVO> selectContentsConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<SnsConfigVO> result = snsOutsideLinkService.selectContentsConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 컨텐츠 공유관리 설정정보 수정
     */
    @RequestMapping("/contents-config-update")
    public @ResponseBody ResultModel<SnsConfigPO> updateContentsConfig(@Validated(UpdateGroup.class) SnsConfigPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<SnsConfigPO> result = snsOutsideLinkService.updateContentsConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : SNS/외부연동 설정정보 페이지 이동
     */
    @RequestMapping("/sns-config")
    public ModelAndView viewSnsConfig() {
        ModelAndView mav = new ModelAndView("/admin/setup/snsoutside/snsLinkConfig");
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : SNS/외부연동 설정정보 단건 조회
     */
    @RequestMapping("/sns-addible-validation")
    public @ResponseBody ResultModel<SnsConfigVO> snsAddibleValidation(SnsConfigVO vo) {
        ResultModel<SnsConfigVO> result = new ResultModel<SnsConfigVO>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        if ("01".equals(vo.getOutsideLinkCd()) || "04".equals(vo.getOutsideLinkCd())) { // 기본, 페이스북
            result.setSuccess(true);
        } else { // 네이버, 카카오
            boolean isFlag = siteQuotaService.isSnsAddible(vo.getSiteNo(), vo.getOutsideLinkCd());
            if (!isFlag) {
                result.setMessage("홈페이지에서 구매후 설정가능합니다");
            }
            result.setSuccess(isFlag);
        }

        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : SNS/외부연동 설정정보 단건 조회
     */
    @RequestMapping("/sns-config-info")
    public @ResponseBody ResultModel<SnsConfigVO> selectSnsConfig(SnsConfigSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultModel<SnsConfigVO> result = snsOutsideLinkService.selectSnsConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : SNS/외부연동 설정정보 리스트 조회
     */
    @RequestMapping("/sns-config-list")
    public @ResponseBody ResultListModel<SnsConfigVO> selectSnsConfigList() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        // 솔직히 페이징은 필요가없다.
        return snsOutsideLinkService.selectSnsConfigList(sessionInfo.getSiteNo());
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : SNS/외부연동 설정정보 수정
     */
    @RequestMapping("/sns-config-update")
    public @ResponseBody ResultModel<SnsConfigPO> updateSnsConfig(@Validated(UpdateGroup.class) SnsConfigPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setRegrNo(sessionInfo.getSession().getMemberNo());
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<SnsConfigPO> result = null;
        if ("02".equals(po.getOutsideLinkCd())) {
            result = snsOutsideLinkService.updateNaverSnsConfig(po, request);
        } else {
            result = snsOutsideLinkService.updateSnsConfig(po);
        }

        return result;
    }
}