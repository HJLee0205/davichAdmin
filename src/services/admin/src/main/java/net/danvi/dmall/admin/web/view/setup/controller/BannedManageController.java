package net.danvi.dmall.admin.web.view.setup.controller;

import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.util.MessageUtil;
import net.danvi.dmall.biz.app.setup.banned.model.*;
import net.danvi.dmall.biz.app.setup.banned.service.BannedManageService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 19.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/")
public class BannedManageController {
    @Resource(name = "bannedManageService")
    private BannedManageService bannedManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 금칙어 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("banned")
    public ModelAndView viewBannedList() {
        ModelAndView mv = new ModelAndView("/admin/setup/banned/BannedManage");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 금칙어 목록을 조회 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/banned-list")
    public @ResponseBody List<BannedManageVO> selectBannedList(BannedManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<BannedManageVO> resultListModel = bannedManageService.selectBannedList(so);

        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 금칙어 등록 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/banned-insert")
    public @ResponseBody ResultModel<BannedManagePO> insertBanned(@Validated(InsertGroup.class) BannedManagePO po,
                                                                  BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<BannedManagePO> result = bannedManageService.insertBanned(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 금칙어을 삭제한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/banned-delete")
    public @ResponseBody ResultModel<BannedManagePO> deleteBanned(@Validated(DeleteGroup.class) BannedManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<BannedManagePO> result = bannedManageService.deleteBanned(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 금칙어 초기화 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/banned-init-update")
    public @ResponseBody ResultModel<BannedManagePO> updateBannedInit(@Validated(InsertGroup.class) BannedManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }

        ResultModel<BannedManagePO> result = bannedManageService.updateBannedInit(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 금칙어 사용 설정 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/banned-config-info")
    public @ResponseBody ResultModel<BannedConfigVO> selectOrderConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<BannedConfigVO> result = bannedManageService.selectBannedConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 9. 22.
     * 작성자 : slims
     * 설명   : 금칙어 사용 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 22. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/banned-config-update")
    public @ResponseBody ResultModel<BannedConfigPO> updateOrderConfig(@Validated(UpdateGroup.class) BannedConfigPO po,
                                                                       BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<BannedConfigPO> result = bannedManageService.updateBannedConfig(po);
        return result;
    }
}
