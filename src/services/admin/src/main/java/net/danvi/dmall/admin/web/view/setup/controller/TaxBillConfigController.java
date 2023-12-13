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
import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigPO;
import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigVO;
import net.danvi.dmall.biz.app.setup.taxbill.service.TaxBillConfigService;
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
@RequestMapping("/admin/setup/config/taxbill")
public class TaxBillConfigController {
    // @Value("#{system['system.upload.path']}")
    // private String taxbillPath;

    @Resource(name = "taxbillConfigService")
    private TaxBillConfigService taxbillConfigService;

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 세금계산서 설정 페이지 이동
     */
    @RequestMapping("/taxbill-config")
    public ModelAndView viewTaxBillConfig() {
        log.debug("================================");
        log.debug("Start : " + "세금계산서 설정 페이지 시작");
        log.debug("================================");

        ModelAndView mav = new ModelAndView("/admin/setup/taxbillConfig");
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 세금계산서 단건 정보조회
     */
    @RequestMapping("/taxbill-config-info")
    public @ResponseBody ResultModel<TaxBillConfigVO> selectTaxBillConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<TaxBillConfigVO> result = taxbillConfigService.selectTaxBillConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 세금계산서 설정 정보 수정
     */
    @RequestMapping("/taxbill-config-update")
    public @ResponseBody ResultModel<TaxBillConfigPO> updateTaxBillConfig(
            @Validated(UpdateGroup.class) TaxBillConfigPO po, BindingResult bindingResult, HttpServletRequest request)
            throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<TaxBillConfigPO> result = taxbillConfigService.updateTaxBillConfig(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 세금계산서 인감 이미지 삭제
     */
    @RequestMapping("/taxbill-image-delete")
    public @ResponseBody ResultModel<TaxBillConfigPO> deleteTaxBillImage(
            @Validated(UpdateGroup.class) TaxBillConfigPO po, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<TaxBillConfigPO> result = taxbillConfigService.deleteTaxBillImage(po);
        return result;
    }
}