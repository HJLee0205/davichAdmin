package net.danvi.dmall.admin.web.view.goods.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.util.MessageUtil;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManagePO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageSO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageVO;
import net.danvi.dmall.biz.app.goods.model.CategoryPO;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 6. 22.
 * 작성자     : dong
 * 설명       : 상품 카테고리 정보 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class CategoryManageController {

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : 카테고리 관리 화면을 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    @RequestMapping("/category-info")
    public ModelAndView viewCategoryInfo() {
        ModelAndView mv = new ModelAndView("/admin/goods/CategoryManage");

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
     * 설명   : 카테고리 리스트 조회(트리목록)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @param
     * @return
     */
    @RequestMapping("/category-list")
    public @ResponseBody List<CategoryVO> selectCategoryList(CategorySO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<CategoryVO> result = categoryManageService.selectCategoryList(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 12. 10.
     * 작성자 : hskim
     * 설명   : 카테고리 리스트 조회(배너관리 1depth 카테고리 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @param
     * @return
     */
    @RequestMapping("/category-list-1depth")
    public @ResponseBody ResultListModel<CategoryVO> selectCategoryList1depth(CategorySO so, BindingResult bindingResult) {

    	ResultListModel<CategoryVO> result = new ResultListModel<>();
    	
        List<CategoryVO> list = categoryManageService.selectCategoryList1depth(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : 카테고리에 상품, 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return
     */
    @RequestMapping("/category-goods-coupon")
    public @ResponseBody Map<String, Integer> selectCtgGoodsCpCnt(CategorySO so, BindingResult bindingResult)
            throws Exception {

        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        CategoryPO po = new CategoryPO();
        po.setCtgNo(so.getCtgNo());
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<Integer> ctgNoList = categoryManageService.selectChildCtgNo(po);

        po.setChildCtgNoList(ctgNoList);

        Integer cpCnt = categoryManageService.selectCpYn(po);

        Integer ctgGoodsCnt = categoryManageService.selectCtgGoodsYn(po);

        Map<String, Integer> childCtgCnt = new HashMap<String, Integer>();
        childCtgCnt.put("ctgGoodsCnt", ctgGoodsCnt);
        childCtgCnt.put("cpCnt", cpCnt);

        return childCtgCnt;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 카테고리 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-delete")
    public @ResponseBody ResultModel<CategoryPO> deleteCategory(@Validated(DeleteGroup.class) CategoryPO po,
            BindingResult bindingResult) throws Exception {

        // 삭제자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CategoryPO> result = categoryManageService.deleteCategory(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 카테고리 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category")
    public @ResponseBody ResultModel<CategoryVO> selectCategory(CategorySO so, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        ResultModel<CategoryVO> result = categoryManageService.selectCategory(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 카테고리 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-update")
    public @ResponseBody ResultModel<CategoryPO> updateCatagory(@Validated(UpdateGroup.class) CategoryPO po,
                                                                BindingResult bindingResult,
                                                                HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        ResultModel<CategoryPO> result = categoryManageService.updateCatagory(po, request);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 카테고리 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManagePO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-display-update")
    public @ResponseBody ResultModel<CategoryDisplayManagePO> updateCatagoryDisplayManage(CategoryDisplayManagePO po,
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

        ResultModel<CategoryDisplayManagePO> result = categoryManageService.updateCatagoryDisplayManage(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 카테고리 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-insert")
    public @ResponseBody ResultModel<CategoryPO> insertCategory(CategoryPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<CategoryPO> result = new ResultModel<>();
        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        String[] ctgNmArr = po.getInsCtgNm();

        // 카테고리 진열 유형 코드 디폴트 값 set
        if (po.getCtgExhbtionTypeCd() == null || po.getCtgExhbtionTypeCd() == "") {
            po.setCtgExhbtionTypeCd("1");
        }

        // 카테고리 전시 유형 코드 디폴트 값 set
        if (po.getCtgDispTypeCd() == null || po.getCtgDispTypeCd() == "") {
            po.setCtgDispTypeCd("03");
        }

        // 모바일 쇼핑몰 적용 여부 디폴트 값 set
        if (po.getMobileSpmallApplyYn() == null || po.getMobileSpmallApplyYn() == "") {
            po.setMobileSpmallApplyYn("Y");
        }

        // 카테고리 메인 사용 여부 디폴트 값 set
        if (po.getCtgMainUseYn() == null || po.getCtgMainUseYn() == "") {
            po.setCtgMainUseYn("N");
        }

        for (int i = 0; i < ctgNmArr.length; i++) {
//            po.setCtgSerialNo(bizService.getSequence("CTG_SERIAL_NO", po.getSiteNo()));
            po.setCtgNm(ctgNmArr[i]);
            if (po.getCtgNm() != null && po.getCtgNm() != "") {
                result = categoryManageService.insertCategory(po);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 카테고리 전시존 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManageSO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-displaymanage-list")
    public @ResponseBody List<CategoryDisplayManageVO> selectCtgDispMngList(CategoryDisplayManageSO so,
            BindingResult bindingResult) throws Exception {

        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<CategoryDisplayManageVO> result = categoryManageService.selectCtgDispMngList(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 04.
     * 작성자 : dong
     * 설명   : 카테고리 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 04. dong - 최초생성
     * </pre>
     *
     * @param CategoryDisplayManageSO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-display-goods")
    public @ResponseBody List<GoodsVO> selectCtgDispGoodsList(CategoryDisplayManageSO so, BindingResult bindingResult)
            throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<GoodsVO> result = categoryManageService.selectCtgDispGoodsList(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 9. 20.
     * 작성자 : hskim
     * 설명   : 카테고리 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 20. hskim - 최초생성
     * </pre>
     *
     * @param CategoryPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-sort")
    public @ResponseBody ResultModel<CategoryPO> updateCatagorySort(@Validated(UpdateGroup.class) CategoryPO po,
            BindingResult bindingResult) throws Exception {

        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CategoryPO> result = categoryManageService.updateCatagorySort(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 07.
     * 작성자 : dong
     * 설명   : 카테고리 노출 상품 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 07. dong - 최초생성
     * </pre>
     *
     * @param CategorySO
     * @return
     * @throws Exception
     */
    // @RequestMapping("/category-rank-status")
    // public @ResponseBody List<DisplayGoodsVO> selectCtgGoodsList(CategorySO so, BindingResult bindingResult)
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
    // List<DisplayGoodsVO> result = categoryManageService.selectCtgGoodsList(so);
    //
    // return result;
    // }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 7. 07.
    // * 작성자 : dong
    // * 설명 : 카테고리 노출 상품 관리 전시 여부 설정
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 7. 07. dong - 최초생성
    // * </pre>
    // *
    // * @param CategoryPO
    // * @return
    // * @throws Exception
    // */
    // @RequestMapping("/goods-display-update")
    // public @ResponseBody ResultModel<CategoryPO> updateCtgGoodsDispYn(CategoryPO po, BindingResult bindingResult)
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
    // ResultModel<CategoryPO> result = categoryManageService.updateCtgGoodsDispYn(po);
    //
    // return result;
    // }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 7. 08.
    // * 작성자 : dong
    // * 설명 : 카테고리 노출 상품 관리 설정
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 7. 08. dong - 최초생성
    // * </pre>
    // *
    // * @param CategoryPO
    // * @return
    // * @throws Exception
    // */
    // @RequestMapping("/goods-show-update")
    // public @ResponseBody ResultModel<CategoryPO> updateCtgShowGoodsManage(CategoryPO po, BindingResult bindingResult)
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
    // ResultModel<CategoryPO> result = categoryManageService.updateCtgShowGoodsManage(po);
    //
    // return result;
    // }
}
