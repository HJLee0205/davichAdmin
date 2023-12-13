package net.danvi.dmall.admin.web.view.goods.controller;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.FilterManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchResDTO;
import net.danvi.dmall.biz.ifapi.prd.service.ProductService;
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
 * 설명       : 상품 filter 정보 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class FilterManageController {

    @Resource(name = "filterManageService")
    private FilterManageService filterManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "logService")
    private LogService logService;

    @Resource(name = "productService")
    private ProductService productService;
    /**
     * <pre>
     * 작성일 : 2022. 6. 22.
     * 작성자 : slims
     * 설명   : filter 관리 화면을 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 22. slims - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    @RequestMapping("/filter-info")
    public ModelAndView viewFilterInfo() {
        ModelAndView mv = new ModelAndView("/admin/goods/FilterManage");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        mv.addObject("siteNo", sessionInfo.getSiteNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 22.
     * 작성자 : slims
     * 설명   : filter 리스트 조회(트리목록)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 22. slims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @param
     * @return
     */
    @RequestMapping("/filter-list")
    public @ResponseBody List<FilterVO> selectFilterList(FilterSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<FilterVO> result = filterManageService.selectFilterList(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2018. 12. 10.
     * 작성자 : hskim
     * 설명   : filter 리스트 조회(배너관리 1depth filter 조회용)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 10. hskim - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @param
     * @return
     */
    @RequestMapping("/filter-list-1depth")
    public @ResponseBody ResultListModel<FilterVO> selectFilterList1depth(FilterSO so, BindingResult bindingResult) {

    	ResultListModel<FilterVO> result = new ResultListModel<>();
    	
        List<FilterVO> list = filterManageService.selectFilterList1depth(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 10. 27.
     * 작성자 : slims
     * 설명   : filter depth 별 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 27. slims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @param
     * @return
     */
    @RequestMapping("/filter-list-depth")
    public @ResponseBody ResultListModel<FilterVO> selectFilterListDepth(FilterSO so, BindingResult bindingResult) {

        ResultListModel<FilterVO> result = new ResultListModel<>();

        List<FilterVO> list = filterManageService.selectFilterListDepth(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 22.
     * 작성자 : slims
     * 설명   : filter에 상품, 쿠폰 존재 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 22. slims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return
     */
    @RequestMapping("/filter-goods-coupon")
    public @ResponseBody Map<String, Integer> selectFilterGoodsCpCnt(FilterSO so, BindingResult bindingResult)
            throws Exception {

        // 사이트 번호
        /*so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        FilterPO po = new FilterPO();
        po.setFilterNo(so.getFilterNo());
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<String> ctgNoList = filterManageService.selectChildFilterNo(po);

        po.setChildFilterNoList(ctgNoList);

        Integer cpCnt = filterManageService.selectCpYn(po);

        Integer ctgGoodsCnt = filterManageService.selectFilterGoodsYn(po);*/

        Map<String, Integer> childFilterCnt = new HashMap<String, Integer>();
        /*childFilterCnt.put("ctgGoodsCnt", ctgGoodsCnt);
        childFilterCnt.put("cpCnt", cpCnt);*/

        return childFilterCnt;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 21.
     * 작성자 : slims
     * 설명   : filter 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 21. slims - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/filter-delete")
    public @ResponseBody ResultModel<FilterPO> deleteFilter(@Validated(DeleteGroup.class) FilterPO po,
            BindingResult bindingResult) throws Exception {

        // 삭제자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<FilterPO> result = filterManageService.deleteFilter(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 21.
     * 작성자 : slims
     * 설명   : filter 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 21. slims - 최초생성
     * </pre>
     *
     * @param FilterSO
     * @return
     * @throws Exception
     */
    @RequestMapping("/filter")
    public @ResponseBody ResultModel<FilterVO> selectFilter(FilterSO so, BindingResult bindingResult)
            throws Exception {
        log.info("selectFilter so : {}", so);
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        List<BrandVO> brand_list = goodsManageService.selectBrandList(bv);
        /*mav.addObject("brand_list", brand_list);*/

        ResultModel<FilterVO> result = filterManageService.selectFilter(so);
        result.put("brand_list",brand_list);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 21.
     * 작성자 : slims
     * 설명   : filter 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 21. slims - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/filter-update")
    public @ResponseBody ResultModel<FilterPO> updateFilter(@Validated(UpdateGroup.class) FilterPO po,
            BindingResult bindingResult) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<FilterPO> result = filterManageService.updateFilter(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2022. 6. 30.
     * 작성자 : slims
     * 설명   : filter 전시존 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 30. slims - 최초생성
     * </pre>
     *
     * @param FilterDisplayManagePO
     * @return
     * @throws Exception
     */
    /*@RequestMapping("/filter-display-update")
    public @ResponseBody ResultModel<FilterDisplayManagePO> updateFilterDisplayManage(FilterDisplayManagePO po,
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

        ResultModel<FilterDisplayManagePO> result = filterManageService.updateFilterDisplayManage(po);

        return result;
    }*/

    /**
     * <pre>
     * 작성일 : 2022. 6. 28.
     * 작성자 : slims
     * 설명   : filter 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 6. 28. slims - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/filter-insert")
    public @ResponseBody ResultModel<FilterPO> insertFilter(FilterPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<FilterPO> result = new ResultModel<>();
        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        String[] ctgNmArr = po.getInsFilterNm();


        for (int i = 0; i < ctgNmArr.length; i++) {
//            po.setFilterSerialNo(bizService.getSequence("CTG_SERIAL_NO", po.getSiteNo()));
            po.setFilterNm(ctgNmArr[i]);
            if (po.getFilterNm() != null && po.getFilterNm() != "") {
                result = filterManageService.insertFilter(po);
            }
        }

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2022. 9. 20.
     * 작성자 : slims
     * 설명   : filter 순서 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 20. slims - 최초생성
     * </pre>
     *
     * @param FilterPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/filter-sort")
    public @ResponseBody ResultModel<FilterPO> updateFilterSort(@Validated(UpdateGroup.class) FilterPO po,
            BindingResult bindingResult) throws Exception {

        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<FilterPO> result = filterManageService.updateFilterSort(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 29.
     * 작성자 : slims
     * 설명   : 다비젼 상품 filter 검색
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 29. slims - 최초생성
     * </pre>
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/erp-filter-list")
    public @ResponseBody ProductSearchResDTO searchErpFilterList(ProductSearchReqDTO param) throws Exception {
        String ifId = Constants.IFID.PRODUCT_FILTER_SEARCH;

        try {

            // 쇼핑몰 처리 부분
            // Response DTO 생성
            ProductSearchResDTO resDto = new ProductSearchResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 상품목록
            List<ProductSearchResDTO.ProductInfoDTO> prdList = productService.getProductList(param);
            if(prdList.size() > 100) {
                prdList = prdList.subList(0, 10);
            }
            resDto.setPrdList(prdList);

            // 목록개수
            resDto.setTotalCnt(productService.countProductList(param));

            logService.writeInterfaceLog(ifId, param, resDto);

            return resDto;

        } catch (CustomIfException ce) {
            ce.setReqParam(param);
            ce.setIfId(ifId);
            throw ce;
        }/* catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, param, ifId);
        }*/
        //return InterfaceUtil.send2("IF_PRD_001", param);
    }
}
