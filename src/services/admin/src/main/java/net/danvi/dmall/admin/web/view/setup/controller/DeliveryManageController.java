package net.danvi.dmall.admin.web.view.setup.controller;

import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.exception.CustomException;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierSO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPOListWrapper;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdPO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdSO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdVO;
import net.danvi.dmall.biz.app.setup.delivery.service.DeliveryManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * 택배 배송사 관련 정보 Controller
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
@RequestMapping("/admin/setup/delivery")
public class DeliveryManageController {

    @Resource(name = "deliveryManageService")
    private DeliveryManageService deliveryManageService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 설정 화면 (/admin/setup/deliveryManage)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/courier-config")
    public ModelAndView viewCourierList() {
        ModelAndView mav = new ModelAndView("/admin/setup/deliveryManage");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 정보 상세 화면 (/admin/setup/deliveryInfo)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/courier-info")
    public ModelAndView viewCourierInfo(@Validated CourierVO vo, BindingResult bindingResult) {
        ModelAndView mav = new ModelAndView("/admin/setup/deliveryInfo");//
        mav.addObject("paramModel", vo.getCourierCd());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 페이징 목록을 취득하여 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/courier-list-paging")
    public @ResponseBody ResultListModel<CourierVO> selectCourierListPaging(CourierSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        ResultListModel<CourierVO> result = deliveryManageService.selectCourierListPaging(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 정보를 취득하여 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/courier")
    public @ResponseBody ResultModel<CourierVO> selectCourier(@Validated CourierVO vo, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CourierVO> result = deliveryManageService.selectCourier(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 택배사 목록을 취득하여 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/courier-list")
    public @ResponseBody ResultListModel<String> selectCourierList(CourierVO vo) {
        ResultListModel<String> result = new ResultListModel<>();

        List<String> list = deliveryManageService.selectCourierList(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 사용 여부를 수정한다.
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
    @RequestMapping("/courier-use-update")
    public @ResponseBody ResultModel<CourierPO> updateCourierForUse(@Validated(UpdateGroup.class) CourierPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<CourierPO> result = deliveryManageService.updateCourierForUse(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 정보를 등록 처리한다.
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
    @RequestMapping("/courier-insert")
    public @ResponseBody ResultModel<CourierPO> insertCourier(@Validated(UpdateGroup.class) CourierPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        // 택배사 코드에서 파마미터 이름으로 조회
        List<CmnCdDtlVO> listCode = ServiceUtil.listCode("COURIER_CD");
        for (CmnCdDtlVO vo : listCode) {
            if(vo.getDtlNm().equals(po.getCourierNm())) {
                po.setChgCourierCd(vo.getDtlCd());
                break;
            }
        }

        if(po.getChgCourierCd() == null || po.getChgCourierCd().equals("")) {
            throw new CustomException("biz.exception.setup.delivery.code.check");
        }

        ResultModel<CourierPO> result = deliveryManageService.insertCourier(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 택배사 정보를 삭제 처리한다.
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
    @RequestMapping("/courier-delete")
    public @ResponseBody ResultModel<CourierPO> deleteCourier(@Validated(UpdateGroup.class) CourierPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<CourierPO> result = deliveryManageService.deleteCourier(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송관련 설정 화면 (/admin/setup/deliveryConfig)을 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery-config")
    public ModelAndView viewDeliveryConfig() {
        ModelAndView mav = new ModelAndView("/admin/setup/deliveryConfig");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송 관련 설정 정보를 취득하여 json 형태로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery-config-info")
    public @ResponseBody ResultModel<DeliveryConfigVO> selectDeliveryConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<DeliveryConfigVO> result = deliveryManageService.selectDeliveryConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송 관련 설정 정보를 수정한다.
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
    @RequestMapping("/delivery-config-update")
    public @ResponseBody ResultModel<DeliveryConfigPO> updateDeliveryConfig(
            @Validated(UpdateGroup.class) DeliveryConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryConfigPO> result = deliveryManageService.updateDeliveryConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 목록을 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/delivery-area-list")
    public @ResponseBody ResultListModel<DeliveryAreaVO> selectDeliveryAreaListPaging(DeliveryAreaSO so) {
        ResultListModel<DeliveryAreaVO> result = deliveryManageService.selectDeliveryListPaging(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 등록한다.
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
    @RequestMapping("/delivery-area-insert")
    public @ResponseBody ResultModel<DeliveryAreaPO> insertDeliveryArea(@Validated(InsertGroup.class) DeliveryAreaPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryAreaPO> result = deliveryManageService.insertDeliveryArea(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 수정한다.
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
    @RequestMapping("/delivery-area-update")
    public @ResponseBody ResultModel<DeliveryAreaPO> updateDeliveryArea(@Validated(UpdateGroup.class) DeliveryAreaPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryAreaPO> result = deliveryManageService.updateDeliveryArea(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 17.
     * 작성자 : dong
     * 설명   : 기본 배송비 설정을 적용한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 17. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("default-delivery-update")
    public @ResponseBody ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po)
            throws Exception {
        ResultModel<DeliveryAreaPO> resultModel = deliveryManageService.updateApplyDefaultDeliveryArea(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 삭제한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("delivery-area-delete")
    public @ResponseBody ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<DeliveryAreaPO> resultModel = deliveryManageService.deleteDeliveryArea(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 26.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 전체 삭제한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 26. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("alldelivery-area-delete")
    public @ResponseBody ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po) {
        ResultModel<DeliveryAreaPO> resultModel = deliveryManageService.deleteAllDeliveryArea(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보 목록을 취득하여 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/hscode-list")
    public @ResponseBody ResultListModel<HscdVO> selectHscdListPaging(HscdSO so) {
        ResultListModel<HscdVO> result = deliveryManageService.selectHscdListPaging(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보를 등록 및 수정한다.
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
    @RequestMapping("/hscode-update")
    public @ResponseBody ResultModel<HscdPO> updateHscd(@Validated(UpdateGroup.class) HscdPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<HscdPO> result = deliveryManageService.updateHscd(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보를 삭제한다.
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
    @RequestMapping("hscode-delete")
    public @ResponseBody ResultModel<HscdPO> deleteHscd(HscdPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<HscdPO> resultModel = deliveryManageService.deleteHscd(po);
        return resultModel;
    }

}