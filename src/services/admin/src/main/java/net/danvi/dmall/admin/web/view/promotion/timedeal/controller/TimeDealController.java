package net.danvi.dmall.admin.web.view.promotion.timedeal.controller;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.timedeal.model.TimeDealPO;
import net.danvi.dmall.biz.app.promotion.timedeal.model.TimeDealPOListWrapper;
import net.danvi.dmall.biz.app.promotion.timedeal.model.TimeDealSO;
import net.danvi.dmall.biz.app.promotion.timedeal.service.TimeDealService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 02.
 * 작성자     : dong
 * 설명       : 기획전 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/promotion")
public class TimeDealController {

    @Resource(name = "timeDealService")
    private TimeDealService timeDealService;
    
    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전목록조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/timeDeal")
    public ModelAndView viewTimeDealListPaging(@Validated TimeDealSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewTimeDealList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }

        log.info("param so = "+so);
        mv.addObject("so", so);
        mv.addObject("resultListModel", timeDealService.selectTimeDealListPaging(so));
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전등록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/timeDeal-insert-form")
    public ModelAndView viewTimeDealInsert(TimeDealSO so) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewTimeDealInsert");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        mv.addObject("siteNo", so.getSiteNo());

        // 기획전이벤트 진행 중인 모든 상품 조회
        mv.addObject("goodsListModel", timeDealService.selectTimeDealTargetTotal(so));

        
        BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        mv.addObject("brand_list", goodsManageService.selectBrandList(bv));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전수정 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/timeDeal-update-form")
    public ModelAndView viewTimeDealUpdate(@Validated TimeDealSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewTimeDealUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 기획전이벤트 진행 중인 모든 상품 조회
        mv.addObject("goodsListModel", timeDealService.selectTimeDealTargetTotal(so));
        
        BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        mv.addObject("brand_list", goodsManageService.selectBrandList(bv));
        
        // 검색조건
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 기획전 상세
        try {
            mv.addObject("resultModel", timeDealService.selectTimeDealDtl(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param timeDealPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/timeDeal-insert")
    public @ResponseBody ResultModel<TimeDealPO> insertTimeDeal(TimeDealPO po) throws Exception{
        log.info("param = "+po);
        ResultModel<TimeDealPO> result =  timeDealService.insertTimeDeal(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param timeDealPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/timeDeal-update")
    public @ResponseBody ResultModel<TimeDealPO> updateTimeDeal(@Validated(DeleteGroup.class) TimeDealPOListWrapper wrapper,
                                                                BindingResult bindingResult) throws Exception{
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<TimeDealPO> result = timeDealService.updateTimeDeal(wrapper);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/timeDeal-delete")
    public @ResponseBody ResultModel<TimeDealPO> deleteTimeDeal(@Validated(DeleteGroup.class) TimeDealPOListWrapper wrapper,
                                                                BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<TimeDealPO> result = null;
        try {
            result = timeDealService.deleteTimeDeal(wrapper);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 기획전 상세(단건)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/timeDeal-detail")
    public ModelAndView selectTimeDeal(@Validated TimeDealSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewTimeDealDtl");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 기획전 상세
        try {
            mv.addObject("resultModel", timeDealService.selectTimeDealDtl(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    // 카테고리 구별코드 가져오기

    @RequestMapping("/timeDeal-copy")
    public @ResponseBody ResultModel<TimeDealPO> copyTimeDealInfo(@Validated TimeDealPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<TimeDealPO> result = timeDealService.copyTimeDealInfo(po);
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
    @RequestMapping("/timeDeal-goods-list")
    public @ResponseBody List<GoodsVO> selectTimeDealTargetGoodsList(TimeDealSO so){
        log.info("selectTimeDealTargetGoodsList");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<GoodsVO> goodsVOList = timeDealService.selectTimeDealTargetGoodsList(so);
        log.info("selectTimeDealTargetGoodsList goodsVOList = "+goodsVOList);
        /*childKeywordCnt.put("ctgGoodsCnt", ctgGoodsCnt);
        childKeywordCnt.put("cpCnt", cpCnt);*/

        return goodsVOList;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 17.
     * 작성자 : slims
     * 설명   : 프로모션 상품 번호 목록 가져오기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 17. slims - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return
     */
    @RequestMapping("/timeDeal-goods-exist")
    public @ResponseBody Integer selectTimeDealTargetGoodsNoList(TimeDealSO so){
        log.info("selectTimeDealTargetGoodsExist");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        Integer goodsExist = timeDealService.selectTimeDealTargetGoodsExist(so);
        log.info("selectTimeDealTargetGoodsExist goodsExist = "+goodsExist);

        return goodsExist;
    }
}
