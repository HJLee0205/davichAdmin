package net.danvi.dmall.admin.web.view.setup.controller;

import javax.annotation.Resource;

import dmall.framework.common.model.ResultListModel;
import net.danvi.dmall.biz.app.goods.model.FreebieSO;

import net.danvi.dmall.biz.app.setup.term.model.TermConfigListVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigPO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigVO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * 본인 인증 확인 설정 정보 Controller
 *
 * @author dong
 * @since 2016.05.04
 */
/**
 * 네이밍 룰
 * View 화면
 * Grid 그리드
 * Tree 트리
 * Ajax Ajax
 * Insert 입력
 * Update 수정
 * Delete 삭제
 * Save 입력 / 수정
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/config/term")
public class TermConfigController {

    static final String[] SITE_INOF_CD_FOR_MAIN_TAB = { "03", "04", "05", "07", "08", "09", "10", "21", "22" };

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * 2022. 09. 06. slims - 리스트 화면
     * </pre>
     *
     * @return
     */
    @RequestMapping("/terms-list")
    public @ResponseBody ResultListModel<TermConfigListVO> selectTermList(TermConfigSO so) throws Exception {
        ResultListModel<TermConfigListVO> result = termConfigService.selectTermConfigList(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * 2022. 09. 06. slims - 리스트 화면
     * </pre>
     *
     * @return
     */
    @RequestMapping("/terms-config-list")
    public @ResponseBody ModelAndView viewTermConfigList(TermConfigSO so) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/setup/termsList");

        if (StringUtils.isEmpty(so.getSiteInfoCd())) {
            so.setSiteInfoCd(SITE_INOF_CD_FOR_MAIN_TAB[0]);
        }

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        mv.addObject("termInfo", so);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 약관 개인정보 설정 화면 (/admin/setup/termConfig)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/terms-config")
    public ModelAndView viewTermConfig(TermConfigSO so) {
        ModelAndView mv = new ModelAndView("/admin/setup/termConfig");

        mv.addObject("so", so);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 약관 개인정보 설정 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/term-config")
    public @ResponseBody ResultModel<TermConfigVO> selectTermConfig(TermConfigSO so) throws Exception {
        ResultModel<TermConfigVO> result = termConfigService.selectTermConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 시스템에 설정된 표준 약관 정보를 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/defaultterm-config")
    public @ResponseBody ResultModel<TermConfigVO> selectDefaultTermConfig(TermConfigSO so) {
        ResultModel<TermConfigVO> result = termConfigService.selectDefaultTermConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 약관 개인정보 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/term-config-insert")
    public @ResponseBody ResultModel<TermConfigPO> insertTermConfig(@Validated(UpdateGroup.class) TermConfigPO po,
                                                                    BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<TermConfigPO> result = termConfigService.insertTermConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 약관 개인정보 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/term-config-update")
    public @ResponseBody ResultModel<TermConfigPO> updateTermConfig(@Validated(UpdateGroup.class) TermConfigPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<TermConfigPO> result = termConfigService.updateTermConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 09. 22.
     * 작성자 : slims
     * 설명   : 약관/개인정보 설정 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 09. 22. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("term-config-delete")
    public @ResponseBody ResultModel<TermConfigPO> deleteTermConfig(TermConfigPO po,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<TermConfigPO> resultModel = termConfigService.deleteTermConfig(po);

        return resultModel;
    }
}