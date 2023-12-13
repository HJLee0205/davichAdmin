package net.danvi.dmall.admin.web.view.goods.controller;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.KeywordManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : 상품 keyword 정보 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class KeywordGoodsManageController {

    @Resource(name = "keywordManageService")
    private KeywordManageService keywordManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : keyword 관리 화면을 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    @RequestMapping("/keyword-info")
    public ModelAndView viewKeywordInfo() {
        ModelAndView mv = new ModelAndView("/admin/goods/KeywordGoodsManage");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        mv.addObject("siteNo", sessionInfo.getSiteNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : keyword 리스트 조회(트리목록)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @param
     * @return
     */
    @RequestMapping("/keyword-list")
    public @ResponseBody List<KeywordVO> selectKeywordList(KeywordSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<KeywordVO> result = keywordManageService.selectKeywordList(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 12. 10.
     * 작성자 : hskim
     * 설명   : keyword 리스트 조회(배너관리 1depth keyword 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @param
     * @return
     */
    @RequestMapping("/keyword-list-1depth")
    public @ResponseBody ResultListModel<KeywordVO> selectKeywordList1depth(KeywordSO so, BindingResult bindingResult) {

    	ResultListModel<KeywordVO> result = new ResultListModel<>();
    	
        List<KeywordVO> list = keywordManageService.selectKeywordList1depth(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 10. 27.
     * 작성자 : slims
     * 설명   : keyword depth 별 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 27. slims - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @param
     * @return
     */
    @RequestMapping("/keyword-list-depth")
    public @ResponseBody ResultListModel<KeywordVO> selectKeywordListDepth(KeywordSO so, BindingResult bindingResult) {

        ResultListModel<KeywordVO> result = new ResultListModel<>();

        List<KeywordVO> list = keywordManageService.selectKeywordListDepth(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : keyword에 상품, 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return
     */
    @RequestMapping("/keyword-goods-list")
    public @ResponseBody List<GoodsVO> selectKeywordGoodsList(KeywordSO so){
        log.info("selectKeywordGoodsList");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<GoodsVO> goodsVOList = keywordManageService.selectKeywordGoodsList(so);
        log.info("selectKeywordGoodsList goodsVOList = "+goodsVOList);
        /*childKeywordCnt.put("ctgGoodsCnt", ctgGoodsCnt);
        childKeywordCnt.put("cpCnt", cpCnt);*/

        return goodsVOList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : keyword 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/keyword-delete")
    public @ResponseBody ResultModel<KeywordPO> deleteKeyword(@Validated(DeleteGroup.class) KeywordPO po,
            BindingResult bindingResult) throws Exception {

        // 삭제자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<KeywordPO> result = keywordManageService.deleteKeyword(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : keyword 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return
     * @throws Exception
     */
    @RequestMapping("/keyword")
    public @ResponseBody ResultModel<KeywordVO> selectKeyword(KeywordSO so, BindingResult bindingResult)
            throws Exception {
        log.info("selectKeyword so : {}", so);
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<KeywordVO> result = keywordManageService.selectKeyword(so);

        List<GoodsVO> goodsVOList = keywordManageService.selectKeywordGoodsList(so);
        result.put("goods_list", goodsVOList);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : keyword 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/keyword-update")
    public @ResponseBody ResultModel<KeywordPO> updateKeyword(@Validated(UpdateGroup.class) KeywordPO po,
            BindingResult bindingResult) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<KeywordPO> result = keywordManageService.updateKeyword(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : keyword 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManagePO
     * @return
     * @throws Exception
     */
    /*@RequestMapping("/keyword-display-update")
    public @ResponseBody ResultModel<KeywordDisplayManagePO> updateKeywordDisplayManage(KeywordDisplayManagePO po,
            BindingResult bindingResult) throws Exception {

        // po.setUseYnArray();

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<KeywordDisplayManagePO> result = keywordManageService.updateKeywordDisplayManage(po);

        return result;
    }*/

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : keyword 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/keyword-insert")
    public @ResponseBody ResultModel<KeywordPO> insertKeyword(KeywordPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<KeywordPO> result = new ResultModel<>();
        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        String[] ctgNmArr = po.getInsKeywordNm();


        for (int i = 0; i < ctgNmArr.length; i++) {
//            po.setKeywordSerialNo(bizService.getSequence("CTG_SERIAL_NO", po.getSiteNo()));
            po.setKeywordNm(ctgNmArr[i]);
            if (po.getKeywordNm() != null && po.getKeywordNm() != "") {
                result = keywordManageService.insertKeyword(po);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : keyword 전시존 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManageSO
     * @return
     * @throws Exception
     */
    /*@RequestMapping("/keyword-displaymanage-list")
    public @ResponseBody List<KeywordDisplayManageVO> selectKeywordDispMngList(KeywordDisplayManageSO so,
            BindingResult bindingResult) throws Exception {

        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<KeywordDisplayManageVO> result = keywordManageService.selectKeywordDispMngList(so);

        return result;
    }*/

    /**
     * <pre>
     * 작성일 : 2016. 7. 04.
     * 작성자 : dong
     * 설명   : keyword 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 04. dong - 최초생성
     * </pre>
     *
     * @param KeywordDisplayManageSO
     * @return
     * @throws Exception
     */
    /*@RequestMapping("/keyword-display-goods")
    public @ResponseBody List<GoodsVO> selectKeywordDispGoodsList(KeywordDisplayManageSO so, BindingResult bindingResult)
            throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<GoodsVO> result = keywordManageService.selectKeywordDispGoodsList(so);

        return result;
    }*/
    
    /**
     * <pre>
     * 작성일 : 2018. 9. 20.
     * 작성자 : hskim
     * 설명   : keyword 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 20. hskim - 최초생성
     * </pre>
     *
     * @param KeywordPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/keyword-sort")
    public @ResponseBody ResultModel<KeywordPO> updateKeywordSort(@Validated(UpdateGroup.class) KeywordPO po,
            BindingResult bindingResult) throws Exception {

        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<KeywordPO> result = keywordManageService.updateKeywordSort(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 07.
     * 작성자 : dong
     * 설명   : keyword 노출 상품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. dong - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return
     * @throws Exception
     */
    // @RequestMapping("/keyword-rank-status")
    // public @ResponseBody List<DisplayGoodsVO> selectKeywordGoodsList(KeywordSO so, BindingResult bindingResult)
    // throws Exception {
    //
    // // 사이트 번호
    // so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    //
    // if (bindingResult.hasErrors()) {
    // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
    // throw new JsonValidationException(bindingResult);
    // }
    //
    // List<DisplayGoodsVO> result = keywordManageService.selectKeywordGoodsList(so);
    //
    // return result;
    // }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 7. 07.
    // * 작성자 : dong
    // * 설명 : keyword 노출 상품 관리 전시 여부 설정
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 7. 07. dong - 최초생성
    // * </pre>
    // *
    // * @param KeywordPO
    // * @return
    // * @throws Exception
    // */
    // @RequestMapping("/goods-display-update")
    // public @ResponseBody ResultModel<KeywordPO> updateKeywordGoodsDispYn(KeywordPO po, BindingResult bindingResult)
    // throws Exception {
    //
    // // 등록자 번호
    // po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    // // 사이트 번호
    // po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    //
    // if (bindingResult.hasErrors()) {
    // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
    // throw new JsonValidationException(bindingResult);
    // }
    //
    // ResultModel<KeywordPO> result = keywordManageService.updateKeywordGoodsDispYn(po);
    //
    // return result;
    // }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 7. 08.
    // * 작성자 : dong
    // * 설명 : keyword 노출 상품 관리 설정
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 7. 08. dong - 최초생성
    // * </pre>
    // *
    // * @param KeywordPO
    // * @return
    // * @throws Exception
    // */
    // @RequestMapping("/goods-show-update")
    // public @ResponseBody ResultModel<KeywordPO> updateKeywordShowGoodsManage(KeywordPO po, BindingResult bindingResult)
    // throws Exception {
    //
    // // 등록자 번호
    // po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    // // 사이트 번호
    // po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    //
    // if (bindingResult.hasErrors()) {
    // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
    // throw new JsonValidationException(bindingResult);
    // }
    //
    // ResultModel<KeywordPO> result = keywordManageService.updateKeywordShowGoodsManage(po);
    //
    // return result;
    // }
}
