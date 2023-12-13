package net.danvi.dmall.admin.web.view.promotion.exhibition.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPOListWrapper;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;

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
public class ExhibitionController {

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;
    
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
    @RequestMapping("/exhibition")
    public ModelAndView viewExhibitionListPaging(@Validated ExhibitionSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewExhibitionList");
        mv.addObject(so);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }
        if(so.getGoodsTypeCds() != null && so.getGoodsTypeCds().length > 3) {
            so.setGoodsTypeCdSelectAll("Y");
        } else {
            so.setGoodsTypeCdSelectAll("N");
        }
        log.info("param so ::::::::::::::::::::::: "+so);
        mv.addObject("so", so);
        mv.addObject("resultListModel", exhibitionService.selectExhibitionListPaging(so));
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
    @RequestMapping("/exhibition-insert-form")
    public ModelAndView viewExhibitionInsert(ExhibitionSO so) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewExhibitionInsert");

        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("prmtNo", exhibitionService.selectNewPrmtNo());
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
    @RequestMapping("/exhibition-update-form")
    public ModelAndView viewExhibitionUpdate(ExhibitionSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewExhibitionUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        
        // 검색조건
        mv.addObject("so", so);
        mv.addObject("siteNo", so.getSiteNo());
        // 기획전 상세
        try {
            ResultModel<ExhibitionVO> result = exhibitionService.selectExhibitionDtl(so);
            mv.addObject("resultModel", result);

            ObjectMapper mapper = new ObjectMapper();
            mv.addObject("attachImages", mapper.writeValueAsString(result.getData().getAttachImages()));
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
     * @param exhibitionPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/exhibition-insert")
    public @ResponseBody ResultModel<ExhibitionPO> insertExhibition(ExhibitionPO po, BindingResult bindingResult, HttpServletRequest request) throws Exception{
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ExhibitionPO> result =  exhibitionService.insertExhibition(po, request);
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
     * @param exhibitionPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/exhibition-update")
    public @ResponseBody ResultModel<ExhibitionPO> updateExhibition(@Validated ExhibitionPO po,BindingResult bindingResult, HttpServletRequest request) throws Exception{
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<ExhibitionPO> result = exhibitionService.updateExhibition(po, request);
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
    @RequestMapping("/exhibition-delete")
    public @ResponseBody ResultModel<ExhibitionPO> deleteExhibition(
            @Validated(DeleteGroup.class) ExhibitionPOListWrapper wrapper, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<ExhibitionPO> result = null;
        try {
            result = exhibitionService.deleteExhibition(wrapper);
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
    @RequestMapping("/exhibition-detail")
    public ModelAndView selectExhibition(@Validated ExhibitionSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewExhibitionDtl");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 기획전 상세
        try {
            mv.addObject("resultModel", exhibitionService.selectExhibitionDtl(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    // 기획전 정보 복사

    @RequestMapping("/exhibition-copy")
    public @ResponseBody ResultModel<ExhibitionPO> copyExhibitionInfo(@Validated ExhibitionPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ExhibitionPO> result = exhibitionService.copyExhibitionInfo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 17.
     * 작성자 : slims
     * 설명   : 프로모션 상품 목록 가져오기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/exhibition-goods-list")
    public @ResponseBody List<GoodsVO> selectExhibitionTargetGoodsList(ExhibitionSO so){
        log.info("selectExhibitionTargetGoodsList");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<GoodsVO> goodsVOList = exhibitionService.selectExhibitionTargetGoodsList(so);
        log.info("selectExhibitionTargetGoodsList goodsVOList = "+goodsVOList);
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
     * @param so
     * @return
     */
    @RequestMapping("/exhibition-goods-exist")
    public @ResponseBody Integer selectExhibitionTargetGoodsNoList(ExhibitionSO so){
        //log.info("selectExhibitionTargetGoodsNoList ::::::::::::::::::: so "+so);
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if(StringUtil.isNotEmpty(so.getGoodsNos())) {
            so.setGoodsNoArr(so.getGoodsNos().split(","));
        }
        log.info("selectExhibitionTargetGoodsNoList ::::::::::::::::::: so "+so);
        Integer goodsExist = exhibitionService.selectExhibitionTargetGoodsExist(so);
        log.info("selectExhibitionTargetGoodsNoList goodsExist = "+goodsExist);

        return goodsExist;
    }
}
