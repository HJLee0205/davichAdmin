package net.danvi.dmall.admin.web.view.operation.controller;

import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigPO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigSO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigVO;
import net.danvi.dmall.biz.app.operation.model.PointConfigPO;
import net.danvi.dmall.biz.app.operation.model.PointConfigSO;
import net.danvi.dmall.biz.app.operation.model.PointConfigVO;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointVO;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 09.
 * 작성자     : kjw
 * 설명       : 마켓포인트, 포인트 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/operation/")
public class SavedMnPointController {

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 마켓포인트 내역 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("savemoney-history")
    public ModelAndView viewSavemoneyHistory() {
        return new ModelAndView("/admin/operation/savedMnPoint/SavemoneyHistory");
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 마켓포인트 설정 화면(/admin/setup/savedMoneyConfig)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/savemoney-config")
    public ModelAndView viewSavedMoneyConfig() {
        ModelAndView mav = new ModelAndView("/admin/operation/savedMnPoint/savedMoneyConfig");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 마켓포인트 관련 설정 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/savedmoney-config")
    public @ResponseBody ResultModel<SavedMoneyConfigVO> selectSavedMoneyConfig(SavedMoneyConfigSO so) {
        ResultModel<SavedMoneyConfigVO> result = savedMnPointService.selectSavedMoneyConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 마켓포인트 설정 정보를 등록 및 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/savedmoney-config-update")
    public @ResponseBody ResultModel<SavedMoneyConfigPO> updateSavedMoneyConfig(
            @Validated(UpdateGroup.class) SavedMoneyConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<SavedMoneyConfigPO> result = savedMnPointService.updateSavedMoneyConfig(po);
        return result;
    }
    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 포인트 내역 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("point-history")
    public ModelAndView viewPointHistory() {
        return new ModelAndView("/admin/operation/savedMnPoint/PointHistory");
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : kjw
     * 설명   : 현재 년도 가져오기
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. kjw - 최초생성
     * </pre>
     *
     * @return
     */
    public static String getYearStr() {
        Calendar cal = Calendar.getInstance();
        return Integer.toString(cal.get(Calendar.YEAR));
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : kjw
     * 설명   : 마켓포인트 지급/차감
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. kjw - 최초생성
     * </pre>
     *
     * @param SavedmnPointPO
     * @return
     */
    @RequestMapping("/savedMnPoint/savedmoney-insert")
    public @ResponseBody ResultModel<SavedmnPointPO> insertSavedMn(HttpServletRequest request,
            @Validated(InsertGroup.class) SavedmnPointPO po, BindingResult bindingResult) throws Exception {

        // 마켓포인트 사용 가능 여부
        po.setSvmnUsePsbYn("Y");
        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        if (po.getTypeCd() == null) {
            po.setTypeCd("M");
        }
        // 유효기간이 직접입력일 경우 사용자 입력 유효기간 set
        if (po.getValidPeriod().equals("02")) {
            po.setEtcValidPeriod(getYearStr() + "1231");
        } else if (po.getValidPeriod().equals("03")) {
            po.setEtcValidPeriod(request.getParameter("etcValidPeriod").replaceAll("-", ""));
        }

        // 마켓포인트 차감일 경우 차감 구분 코드 set
        if (po.getGbCd().equals("20")) {
            if (po.getReasonCd().equals("03")) {
                // 마켓포인트 차감 구분 코드 (사용)
                po.setDeductGbCd("01");
            } else if (po.getReasonCd().equals("04")) {
                // 마켓포인트 차감 구분 코드 (소멸)
                po.setDeductGbCd("02");
            }
        }

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SavedmnPointPO> result = savedMnPointService.insertSavedMn(po);

        // return null;
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 09.
     * 작성자 : kjwj
     * 설명   : 마켓포인트 내역 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 09. kjw - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO
     * @param
     * @return
     */
    @RequestMapping("/savedMnPoint/savedmoney")
    public @ResponseBody ResultListModel<SavedmnPointVO> selectSavedmnGetPaging(SavedmnPointSO so,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<SavedmnPointVO> result = savedMnPointService.selectSavedmnGetPaging(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : kjw
     * 설명   : 포인트 지급/차감
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. kjw - 최초생성
     * </pre>
     *
     * @param SavedmnPointPO
     * @return
     */
    @RequestMapping("/savedMnPoint/point-insert")
    public @ResponseBody ResultModel<SavedmnPointPO> insertPoint(HttpServletRequest request,
            @Validated(InsertGroup.class) SavedmnPointPO po, BindingResult bindingResult) throws Exception {

        // 포인트 사용 가능 여부
        po.setPointUsePsbYn("Y");
        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        if (po.getTypeCd() == null) {
            po.setTypeCd("M");
        }
        // 유효기간이 직접입력일 경우 사용자 입력 유효기간 set
        if (po.getValidPeriod().equals("02")) {
            po.setEtcValidPeriod(getYearStr() + "1231");
        } else if (po.getValidPeriod().equals("03")) {
            po.setEtcValidPeriod(request.getParameter("etcValidPeriod").replaceAll("-", ""));
        }

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SavedmnPointPO> result = savedMnPointService.insertPoint(po);

        // return null;
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : kjwj
     * 설명   : 포인트 내역 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. kjw - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO
     * @param
     * @return
     */
    @RequestMapping("/savedMnPoint/point")
    public @ResponseBody ResultListModel<SavedmnPointVO> selectPointGetPaging(SavedmnPointSO so,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<SavedmnPointVO> result = savedMnPointService.selectPointGetPaging(so);

        return result;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 전체 마켓포인트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/savedMnPoint/total-savedmoney")
    public @ResponseBody ResultModel<SavedmnPointVO> selectTotalSvmn(SavedmnPointSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SavedmnPointVO> result = savedMnPointService.selectTotalSvmn(so);

        return result;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 전체 포인트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/savedMnPoint/total-point")
    public @ResponseBody ResultModel<SavedmnPointVO> selectTotalPoint(SavedmnPointSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SavedmnPointVO> result = savedMnPointService.selectTotalPoint(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 포인트 설정 화면(/admin/setup/pointConfig)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/point-config")
    public ModelAndView viewPointConfig() {
        ModelAndView mav = new ModelAndView("admin/operation/savedMnPoint/pointConfig");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 포인트 설정 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/point-config-info")
    public @ResponseBody ResultModel<PointConfigVO> selectPointConfig(PointConfigSO so) {
        ResultModel<PointConfigVO> result = savedMnPointService.selectPointConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 포인트 설정 정보를 수정 후 결과를 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/point-config-update")
    public @ResponseBody ResultModel<PointConfigPO> updatePointConfig(@Validated(UpdateGroup.class) PointConfigPO po,
                                                                      BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<PointConfigPO> result = savedMnPointService.updatePointConfig(po);
        return result;
    }
}
