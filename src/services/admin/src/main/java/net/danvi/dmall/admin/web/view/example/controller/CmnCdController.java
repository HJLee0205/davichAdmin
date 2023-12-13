package net.danvi.dmall.admin.web.view.example.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.example.model.CmnCdGrpPO;
import net.danvi.dmall.biz.example.model.CmnCdGrpPOListWrapper;
import net.danvi.dmall.biz.example.model.CmnCdGrpSO;
import net.danvi.dmall.biz.example.model.CmnCdGrpVO;
import net.danvi.dmall.biz.example.service.CmnCdService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 3. 31.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/example")
public class CmnCdController {

    @Resource(name = "cmnCdService")
    private CmnCdService cmnCdService;

    @RequestMapping("/common-code-view")
    public ModelAndView viewExample(@Validated CmnCdGrpSO cmnCdGrpSO, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/example/CmnCd");
        mv.addObject(cmnCdGrpSO);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("cmnCdGrpSO", cmnCdGrpSO);
        mv.addObject("resultListModel", cmnCdService.selectCmnCdGrpPaging(cmnCdGrpSO));

        return mv;
    }

    @RequestMapping("/common-group-code")
    public @ResponseBody ResultModel<CmnCdGrpVO> selectCmnCdGrp(@Validated CmnCdGrpVO cmnCdGrpVO,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CmnCdGrpVO> result = cmnCdService.selectCmnCdGrp(cmnCdGrpVO);

        return result;
    }

    @RequestMapping("/insert-group-code")
    public @ResponseBody ResultModel<CmnCdGrpPO> insertCmnCdGrp(@Validated(InsertGroup.class) CmnCdGrpPO cmnCdGrpPO,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CmnCdGrpPO> result = cmnCdService.insertCmnCdGrp(cmnCdGrpPO);

        return result;
    }

    @RequestMapping("/update-group-code")
    public @ResponseBody ResultModel<CmnCdGrpPO> updateCmnCdGrp(@Validated(UpdateGroup.class) CmnCdGrpPO cmnCdGrpPO,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CmnCdGrpPO> result = cmnCdService.updateCmnCdGrp(cmnCdGrpPO);

        return result;
    }

    @RequestMapping("/delete-group-code")
    public @ResponseBody ResultModel<CmnCdGrpPO> deleteCmnCdGrp(
            @Validated(DeleteGroup.class) CmnCdGrpPOListWrapper wrapper, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CmnCdGrpPO> result = cmnCdService.deleteCmnCdGrp(wrapper);

        return result;
    }
}
