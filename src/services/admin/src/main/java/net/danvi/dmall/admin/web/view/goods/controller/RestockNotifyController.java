package net.danvi.dmall.admin.web.view.goods.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.model.CtgVO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyPO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyPOListWrapper;
import net.danvi.dmall.biz.app.goods.model.RestockNotifySO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.goods.service.RestockNotifyService;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.model.SmsSendVO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;

/**
 * 사이트 정보 Controller
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
@RequestMapping("/admin/goods/restocknotify")
public class RestockNotifyController {

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "restockNotifyService")
    private RestockNotifyService restockNotifyService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 재입고 알림 상품 관리 화면(/admin/goods/restockNotifyList)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/restock-notifiy")
    public ModelAndView viewRestockNotifyList() {

        ModelAndView mav = new ModelAndView("/admin/goods/restockNotifyList");
        SmsSendSO smsSendSo = new SmsSendSO();
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        // 발신자 번호 정보
        String adminSmsNo = smsSendService.selectAdminSmsNo(smsSendSo);
        mav.addObject("adminSmsNo", adminSmsNo);

        // 재입고 알림 SMS 정보
        smsSendSo.setSendTypeCd("18");
        List<SmsSendVO> smsVO = smsSendService.selectStatusSms(smsSendSo);

        // 1레벨 카테고리 조회
        CtgVO vo = new CtgVO();
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        vo.setCtgLvl("1");
        List<CtgVO> list = goodsManageService.selectCtgList(vo);
        mav.addObject("ctgList", list);
//
//        mav.addObject("restockSmsWord", smsVO.get(0).getMemberSendWords());

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 재입고 알림상품 관리 화면에서 선택한 조건에 해당하는 
     *          재입고 알림 정보를 조회하여 JSON 형태로 반환한다. 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param goodsSO
     * @return
     */
    @RequestMapping("/restock-notify-list")
    public @ResponseBody ResultListModel<RestockNotifyVO> selectRestockNotifyListPaging(RestockNotifySO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultListModel<RestockNotifyVO> result = restockNotifyService.selectRestockNotifyListPaging(so);
        return result;
    }

    @RequestMapping("/restock-notify-detail")
    public ModelAndView viewRestockNotifyDetail(RestockNotifyVO po) {
        ModelAndView mav = new ModelAndView("/admin/goods/restockNotifyDetail");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        po.setSiteNo(sessionInfo.getSiteNo());

        ResultModel<RestockNotifyVO> resultModel = restockNotifyService.selectRestockNotify(po);

        mav.addObject("resultModel", resultModel);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 카테고리 목록을 조회하여 JSON 형태로 반환한다.
     *          파라메터에 설정된 상위 카테고리 번호가 존재할 경우
     *          해당 상위 카테고리의 하위 카테고리 목록을 반환한다.   
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/goods-restocknotify-category")
    public @ResponseBody ResultListModel<CtgVO> selectCtgList(CtgVO vo) {
        ResultListModel<CtgVO> result = new ResultListModel<>();

        List<CtgVO> list = goodsManageService.selectCtgList(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 재입고 알림 전송 정보를 취득하여 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/restock-notify")
    public @ResponseBody ResultModel<RestockNotifyVO> selectRestockNotify(@Validated RestockNotifyVO vo,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<RestockNotifyVO> result = restockNotifyService.selectRestockNotify(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 재입고 알림 정보를 수정한 후 결과를 반환한다. 
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
    @RequestMapping("/restock-notify-update")
    public @ResponseBody ResultModel<RestockNotifyPO> updateRestockNotify(
            @Validated(UpdateGroup.class) RestockNotifyPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<RestockNotifyPO> result = restockNotifyService.updateRestockNotify(po);
        return result;
    }

    @RequestMapping("/restock-notify-memo-update")
    public @ResponseBody ResultModel<RestockNotifyPO> updateRestockNotifyMemo(RestockNotifyPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        po.setRegrNo(SessionDetailHelper.getSession().getMemberNo());
        po.setUpdrNo(SessionDetailHelper.getSession().getMemberNo());

        ResultModel<RestockNotifyPO> result = restockNotifyService.updateRestockNotifyMemo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 재입고 알림 정보를 삭제한 후 결과를 반환한다.
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
    @RequestMapping("/restock-notifiy-delete")
    public @ResponseBody ResultModel<RestockNotifyPOListWrapper> deleteRestockNotify(RestockNotifyPOListWrapper po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<RestockNotifyPOListWrapper> result = restockNotifyService.deleteRestockNotify(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 재입고 알림 정보를 전송한 후 결과를 반환한다.
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
    @RequestMapping("/restock-sms-send")
    public @ResponseBody ResultModel<RestockNotifyPOListWrapper> sendRestockSms(
            @Validated(UpdateGroup.class) RestockNotifyPOListWrapper po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<RestockNotifyPOListWrapper> result = restockNotifyService.sendRestockSms(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 재입고 알림 목록을 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @param model
     * @return
     */
    @RequestMapping("/restock-notify-excel")
    public String viewMemListExcel(RestockNotifySO so, BindingResult bindingResult, Model model) {
        so.setRows(10000);
        ResultListModel<RestockNotifyVO> resultList = restockNotifyService.selectRestockNotifyListPaging(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "상품명", "재고수량", "가용수량", "상태", "재입고알림 요청번호", "재입고알림 회원이름",
                "재입고알림 회원번호", "재입고알림 회원등급", "재입고알림 신청일", "재입고알림 통보일자" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rownum", "goodsNm", "stockQtt", "availStockQtt", "goodsSaleStatusNm",
                "mobile", "memberNm", "memberNo", "memberGradeNm", "strRegDttm", "strAlarmDttm" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("재입고 알림 목록", headerName, fieldName, resultList.getResultList()));
        // 파일명
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "alramlist_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
    }

    @RequestMapping("/checked-restock-sms-send")
    public @ResponseBody ResultModel<RestockNotifyPOListWrapper> sendCheckedRestock(RestockNotifyPOListWrapper po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<RestockNotifyPOListWrapper> result = restockNotifyService.sendCheckedRestock(po);
        return result;
    }

    @RequestMapping("/restock-notify-send-list")
    public @ResponseBody ResultListModel<RestockNotifyVO> selectRestockNotifySendListPaging(RestockNotifySO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultListModel<RestockNotifyVO> result = restockNotifyService.selectRestockNotifySendListPaging(so);
        return result;
    }
}