package net.danvi.dmall.admin.web.view.goods.controller;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.RecommendManageService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2022. 11. 12.
 * 작성자     : slims
 * 설명       : 사은품 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class GoodsRecommendManageController {

    @Resource(name = "recommendManageService")
    private RecommendManageService recommendManageService;

    @Resource(name = "siteService")
    private SiteService siteService;

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 목록 화면(/admin/goods/freebie/freebieManageList)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/recommend-info")
    public ModelAndView viewRecommendInfoList(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("/admin/goods/goodsRecommend/goodsRecommendManageList");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        String typeCd = request.getParameter("typeCd");
        mav.addObject("typeCd", typeCd);
        mav.addObject("siteNo", sessionInfo.getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 상세 화면으로 이동한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/recommend-item-insert")
    public ModelAndView viewRecommendItemInsert(GoodsRecommendPO po) {
        ModelAndView mav = new ModelAndView("/admin/goods/goodsRecommend/goodsRecommendItmInsert");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        mav.addObject("po", po);
        mav.addObject("siteNo", sessionInfo.getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 리스트 화면에서 선택한 조건에 해당하는 사은품 관련 정보를 취득하여 JSON 형태로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/recommend-list")
    public @ResponseBody List<GoodsRecommendVO> selectRecommendListPaging(GoodsRecommendSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        log.info("param SiteNo = " + sessionInfo.getSiteNo());
        so.setSiteNo(sessionInfo.getSiteNo());
        log.info("param so = " + so);
        List<GoodsRecommendVO> result = recommendManageService.selectGoodsRecommendList(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 상세 화면에서 사은품 관련 정보를 취득하여 JSON 형태로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/recommend-contents")
    public @ResponseBody ResultModel<GoodsRecommendVO> selectFreebieContents(GoodsRecommendSO so) throws Exception {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultModel<GoodsRecommendVO> result = recommendManageService.selectGoodsRecommendContents(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 목록을 취득하여 엑셀 다운로드 처리한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param so
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/recommend-excel-download")
    public String downloadExcel(GoodsRecommendSO so, Model model) throws Exception {
        // 엑셀로 출력할 데이터 조회
        List<GoodsRecommendVO> result = recommendManageService.selectGoodsRecommendList(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "사은품명", "사용여부", "등록일", "수정일" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "freebieNm", "useNm", "regDate", "updDate" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("사은품 목록", headerName, fieldName, result));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "test_excel"); // 엑셀
                                                                                 // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 정보를 등록 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/recommend-items-insert")
    public @ResponseBody ResultModel<GoodsRecommendPO> insertRecommendItems(GoodsRecommendPO po) throws Exception {
        ResultModel<GoodsRecommendPO> resultModel = recommendManageService.insertGoodsRecommendItems(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 정보 수정 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/recommend-contents-update")
    public @ResponseBody ResultModel<GoodsRecommendPO> updateFreebieContents(GoodsRecommendPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<GoodsRecommendPO> resultModel = recommendManageService.updateGoodsRecommendContents(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 체크된 정보 삭제 후 결과를 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/check-recommend-delete")
    public @ResponseBody ResultModel<GoodsRecommendPO> deleteCheckRecommendContents(GoodsRecommendPO po,
            @RequestParam(value = "paramRecommendNo[]") ArrayList<String> paramRecommendNo, BindingResult bindingResult)
            throws Exception {
        ResultModel<GoodsRecommendPO> resultModel = null;

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setInsRecommendGoodsNoList(paramRecommendNo);
        resultModel = recommendManageService.deleteGoodsRecommendContents(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 단일 정보 삭제 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/recommend-delete")
    public @ResponseBody ResultModel<GoodsRecommendPO> deleteGoodsRecommendContents(GoodsRecommendPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<GoodsRecommendPO> resultModel = null;

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        resultModel = recommendManageService.deleteGoodsRecommendContents(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 22.
     * 작성자 : truesol
     * 설명   : 추천 상품 순서 변경 기능
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 22. truesol - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/recommend-sort-update")
    public @ResponseBody List<GoodsRecommendVO> updateRecommendSort(GoodsRecommendPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<GoodsRecommendVO> result = recommendManageService.updateRecommendSort(po);

        return result;
    }
}
