package net.danvi.dmall.admin.web.view.promotion.freebiecndt.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPOListWrapper;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 02.
 * 작성자     : dong
 * 설명       : 사은품이벤트 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/promotion")
public class FreebieCndtController {

    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트목록 조회
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

    @RequestMapping("/freebie-event")
    public ModelAndView viewFreebieCndtListPaging(@Validated FreebieCndtSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewFreebieCndtList");

        mv.addObject(so);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 이벤트진행상태 초기값으로 '진행 전''진행 중' '종료' 모두 선택
        if (so.getFreebieStatusCds() == null) {
            String[] statusCds = { "01", "02", "03" };
            so.setFreebieStatusCds(statusCds);
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }

        mv.addObject("so", so);
        mv.addObject("resultListModel", freebieCndtService.selectFreebieCndtListPaging(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트등록 화면
     *          
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */

    @RequestMapping("/freebieevent-insert-form")
    public ModelAndView viewFreebieCndtInsert() {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewFreebieCndtInsert");
        // 사은품대상(상품) 중복을 피하기 위해 목록 전체를 가져와 미리 세팅.
        // mv.addObject("goodsListModel", freebieCndtService.selectFreebieTargetTotal());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/freebieevent-insert")
    public @ResponseBody ResultModel<FreebieCndtPO> insertFreebieCndt(FreebieCndtPO po) throws Exception {
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<FreebieCndtPO> result = freebieCndtService.insertFreebieCndt(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트수정 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/freebieevent-update-form")
    public ModelAndView viewFreebieCndtUpdate(@Validated FreebieCndtSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewFreebieCndtUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 사은품이벤트대상(상품) 중복을 피하기 위해 목록 전체를 가져와 미리 세팅.
        // mv.addObject("goodsListModel", freebieCndtService.selectFreebieTargetTotal());
        // 검색조건
        mv.addObject("so", so);
        // 사은품이벤트 상세
        mv.addObject("resultModel", freebieCndtService.selectFreebieCndtDtl(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/freebieevent-update")
    public @ResponseBody ResultModel<FreebieCndtPO> updateFreebieCndt(@Validated FreebieCndtPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<FreebieCndtPO> result = freebieCndtService.updateFreebieCndt(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param wrapper
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/freebieevent-delete")
    public @ResponseBody ResultModel<FreebieCndtPO> deleteFreebieCndt(
            @Validated(DeleteGroup.class) FreebieCndtPOListWrapper wrapper, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<FreebieCndtPO> result = freebieCndtService.deleteFreebieCndt(wrapper);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 사은품이벤트상세(단건) 조회 
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
    @RequestMapping("/freebieevent-detail")
    public ModelAndView selectFreebieCndt(@Validated FreebieCndtSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewFreebieCndtDtl");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 검색조건
        mv.addObject("so", so);
        // 사은품이벤트 상세
        mv.addObject("resultModel", freebieCndtService.selectFreebieCndtDtl(so));
        return mv;
    }

}
