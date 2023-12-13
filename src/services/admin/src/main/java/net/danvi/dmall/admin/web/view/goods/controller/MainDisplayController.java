package net.danvi.dmall.admin.web.view.goods.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.CategoryPO;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsListWrapper;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsPO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsSO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsVO;
import net.danvi.dmall.biz.app.goods.service.MainDisplayService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPOListWrapper;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       : 게시판 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class MainDisplayController {

	@Resource(name = "mainDisplayService")
	private MainDisplayService mainDisplayService;

	@RequestMapping("/main-display")
    public ModelAndView selectDisplay(@Validated DisplayGoodsSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/goods/display/mainDisplay");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        
        if (so.getMainAreaGbCd() == null || "".equals(so.getMainAreaGbCd())) {
            so.setMainAreaGbCd("01");
        }

        //마지막 SITE_DISP_SEQ 확인
        int maxSiteDispSeq = mainDisplayService.getMaxSiteDispSeq(so);
        so.setMaxSiteDispSeq(maxSiteDispSeq);

        mv.addObject("so", so);

        ResultModel<DisplayGoodsVO> result = mainDisplayService.selectMainDisplayGoods(so);

        mv.addObject("resultModel", result);
        
;

        return mv;
    }

	@RequestMapping("/main-display-update")
	public @ResponseBody ResultModel<DisplayGoodsPO> updateMainDisplay(@Validated(UpdateGroup.class) DisplayGoodsPO po,
			HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

		// 필수 파라메터 확인
		if (bindingResult.hasErrors()) {
			log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
			throw new JsonValidationException(bindingResult);
		}

		ResultModel<DisplayGoodsPO> result = mainDisplayService.updateMainDisplay(po);

		return result;
	}

	@RequestMapping("/main-display-insert")
	public @ResponseBody ResultModel<DisplayGoodsPO> insertMainDisplay(@Validated(InsertGroup.class) DisplayGoodsPO po,
			BindingResult bindingResult) throws Exception {

		// 필수 파라메터 확인
		if (bindingResult.hasErrors()) {
			log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
			throw new JsonValidationException(bindingResult);
		}
		
		ResultModel<DisplayGoodsPO> result = mainDisplayService.insertMainDisplay(po);

		return result;
	}
	
    @RequestMapping("/main-display-delete")
    public @ResponseBody ResultModel<DisplayGoodsPO> deleteMainDisplay(
            @Validated(DeleteGroup.class) DisplayGoodsPO po, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DisplayGoodsPO> result = null;
        try {
            result = mainDisplayService.deleteMainDisplay(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }


}
