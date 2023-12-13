package net.danvi.dmall.admin.web.view.setup.controller;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.app.setup.delivery.service.DeliveryInterfaceService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 9. 30.
 * 작성자     : dong
 * 설명       : 배송연동 설정 정보 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/deliveryInteface")
public class DeliveryInterfaceController {

    @Resource(name = "deliveryInterfaceService")
    private DeliveryInterfaceService deliveryInterfaceService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 배송 연동 설정 관리 화면(/admin/setup/delivery/deliveryInterfaceSetup)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery-interface-config")
    public ModelAndView viewDeliveryInterfaceSetup() {
        ModelAndView mav = new ModelAndView("/admin/setup/delivery/deliveryInterfaceSetup");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 배송 연동 설정 정보를 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/delevery-interface")
    public @ResponseBody ResultModel<CourierVO> selectDeliveryInterfaceSetup(CourierVO vo) {
        ResultModel<CourierVO> result = deliveryInterfaceService.selectDeliveryInterface(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 배송 연동 설정 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery-interface-update")
    public @ResponseBody ResultModel<CourierPO> updateDeliveryInterface(@Validated(UpdateGroup.class) CourierPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // 연동 신청 상태 설정 값이 없을 경우, "00"(연동신청)으로 설정
        if (StringUtils.isEmpty(po.getLinkApplyStatus())) {
            po.setLinkApplyStatus("00");
        }

        ResultModel<CourierPO> result = deliveryInterfaceService.updateDeliveryInterface(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 배송 연동 설정 정보를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery-interface-delete")
    public @ResponseBody ResultModel<CourierPO> deleteDeliveryInterface(@Validated(UpdateGroup.class) CourierPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<CourierPO> result = deliveryInterfaceService.deleteDeliveryInterface(po);
        return result;
    }

}