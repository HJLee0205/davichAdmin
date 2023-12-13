package net.danvi.dmall.admin.web.view.setup.controller;

import javax.annotation.Resource;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.order.model.OrderConfigPO;
import net.danvi.dmall.biz.app.setup.order.model.OrderConfigVO;
import net.danvi.dmall.biz.app.setup.order.service.OrderConfigService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * 주문 관련 설정 정보 Controller
 * 
 * @author dong
 * @since 2016.05.04
 */
/**
 * 네이밍 룰
 * View 화면
 * Grid 그리드
 * Tree 트리
 * Ajax Ajax
 * Insert 입력
 * Update 수정
 * Delete 삭제
 * Save 입력 / 수정
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/config/order")
public class OrderConfigController {

    @Resource(name = "orderConfigService")
    private OrderConfigService orderConfigService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 주문 관련 설정 화면(/admin/setup/orderConfig)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-config")
    public ModelAndView viewtSiteInfo() {
        ModelAndView mav = new ModelAndView("/admin/setup/orderConfig");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 주문 관련 설정 정보를 취득하여 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-config-info")
    public @ResponseBody ResultModel<OrderConfigVO> selectOrderConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<OrderConfigVO> result = orderConfigService.selectOrderConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 주문 관련 설정 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/order-config-update")
    public @ResponseBody ResultModel<OrderConfigPO> updateOrderConfig(@Validated(UpdateGroup.class) OrderConfigPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<OrderConfigPO> result = orderConfigService.updateOrderConfig(po);
        return result;
    }

}