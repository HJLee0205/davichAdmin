package net.danvi.dmall.admin.web.view.goods.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.BrandPO;
import net.danvi.dmall.biz.app.goods.model.BrandSO;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import net.danvi.dmall.biz.app.goods.service.BrandManageService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 22.
 * 작성자     : dong
 * 설명       : 상품 브랜드 정보 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class BrandManageController {

    @Resource(name = "brandManageService")
    private BrandManageService brandManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 브랜드 관리 화면을 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    @RequestMapping("/brand-info")
    public ModelAndView viewBrandInfo(BrandSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/goods/brand/brandManage");

        so.setDispYn("Y");

        mv.addObject("so", so);
        mv.addObject("resultListModel", brandManageService.selectBrandList(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 21.
     * 작성자 : dong
     * 설명   : 브랜드 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 21. dong - 최초생성
     * </pre>
     *
     * @param BrandSO
     * @return
     * @throws Exception
     */
    @RequestMapping("/brand")
    public @ResponseBody ResultModel<BrandVO> selectBrand(BrandSO so, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BrandVO> result = brandManageService.selectBrand(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 21.
     * 작성자 : dong
     * 설명   : 브랜드 정보 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 21. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/brand-update")
    public @ResponseBody ResultModel<BrandPO> updateBrand(@Validated(UpdateGroup.class) BrandPO po,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BrandPO> result = brandManageService.updateBrand(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 28.
     * 작성자 : dong
     * 설명   : 브랜드 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 28. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/brand-insert")
    public @ResponseBody ResultModel<BrandPO> insertBrand(BrandPO po, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BrandPO> result = brandManageService.insertBrand(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 21.
     * 작성자 : dong
     * 설명   : 브랜드 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 21. dong - 최초생성
     * </pre>
     *
     * @param BrandPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/brand-delete")
    public @ResponseBody ResultModel<BrandPO> deleteBrand(@Validated(DeleteGroup.class) BrandPO po,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BrandPO> result = brandManageService.deleteBrand(po);

        return result;
    }

}
