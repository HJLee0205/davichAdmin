package net.danvi.dmall.admin.web.view.promotion.event.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.biz.app.promotion.event.model.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.event.service.EventService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 이벤트 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/promotion")
public class EventController {

    @Resource(name = "eventService")
    private EventService eventService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트목록조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/event")
    public ModelAndView viewEventListPaging(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewEventList");
        mv.addObject(so);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 이벤트진행상태 초기값으로 '진행 전''진행 중' '종료' 모두 선택
        if (so.getEventStatusCds() == null) {
            String[] statusCds = { "01", "02", "03" };
            so.setEventStatusCds(statusCds);
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }

        if(so.getGoodsTypeCd() != null && so.getGoodsTypeCd().length > 3) {
            so.setGoodsTypeCdSelectAll("Y");
        } else {
            so.setGoodsTypeCdSelectAll("N");
        }
        // 당첨내용등록 했는지 여부 체크 : 등록했으면 수정버튼을 보여주고, 안했으면 등록버튼 보여줌
        mv.addObject("resultWngContent", eventService.selectWngContentList(so));
        log.info("so :::::::::::::::::::: {}", so);
        mv.addObject("so", so);
        mv.addObject("resultListModel", eventService.selectEventListPaging(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/event-insert-form")
    public ModelAndView viewEventInsert() {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewEventInsert");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/event-update-form")
    public ModelAndView viewEventUpdate(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewEventUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // 검색조건
        mv.addObject("so", so);
        // 쿠폰 상세
        try {
            so.setDelYn("N");
            ResultModel<EventVO> result = eventService.selectEventInfo(so);

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
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param eventPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-insert")
    public @ResponseBody ResultModel<EventPO> insertEvent(@Validated EventPO po, BindingResult bindingResult, HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.insertEvent(po, request);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param eventPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-update")
    public @ResponseBody ResultModel<EventPO> updateEvent(@Validated EventPO po, BindingResult bindingResult, HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.updateEvent(po, request);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 이벤트 상세(단건)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-info")
    public ModelAndView viewEventInfo(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewEventInfo");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);

        // 이벤트 상세
        try {
            so.setDelYn("N");
            mv.addObject("resultModel", eventService.selectEventInfo(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석체크이벤트목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/attendancecheck")
    public ModelAndView viewAttendanceCheckListPaging(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewAttendanceCheckList");
        mv.addObject(so);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 이벤트참여방법 초기값으로 '스탬프형' '로그인형' 모두 선택
        if (so.getEventMethodCds() == null) {
            String[] methodCds = { "01", "02" };
            so.setEventMethodCds(methodCds);
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }

        mv.addObject("so", so);
        so.setEventKindCd("02");// 출석체크이벤트
        mv.addObject("resultListModel", eventService.selectEventListPaging(so));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석체크이벤트등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/attendancecheck-insert-form")
    public ModelAndView viewAttendanceCheckInsert(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewAttendanceCheckInsert");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        try {
            so.setEventKindCd("02"); /* 이벤트종류 : 출석체크이벤트 */
            mv.addObject("resultModel", eventService.selectOtherEventDttm(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석체크이벤트수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/attendancecheck-update-form")
    public ModelAndView viewAttendanceCheckUpdate(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewAttendanceCheckUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);
        // 이벤트종류 : 출석체크이벤트
        so.setEventKindCd("02");
        // 다른 출석체크이벤트 시작종료일시 조회
        mv.addObject("list", eventService.selectOtherEventDttm(so));
        // 출석체크이벤트 상세
        try {
            so.setDelYn("N");
            mv.addObject("resultModel", eventService.selectEventInfo(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석체크이벤트 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param eventPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/attendancecheck-insert")
    public @ResponseBody ResultModel<EventPO> insertAttendanceCheck(@Validated EventPO po,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.insertAttendanceCheck(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석체크이벤트 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/attendance-check-update")
    public @ResponseBody ResultModel<EventPO> updateAttendanceCheck(@Validated EventPO po,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.updateAttendanceCheck(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 18.
     * 작성자 : dong
     * 설명   : 출석체크이벤트 상세(단건)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/attendance-check-info")
    public ModelAndView viewAttendanceCheckInfo(@Validated EventSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewAttendanceCheckInfo");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);

        // 이벤트 상세
        try {
            so.setDelYn("N");
            so.setEventKindCd("02");// 출석체크이벤트
            mv.addObject("resultModel", eventService.selectEventInfo(so));
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 18.
     * 작성자 : dong
     * 설명   : 이벤트 삭제 + 출석체크이벤트 삭제 ( 공용 )
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-delete")
    public @ResponseBody ResultModel<EventPO> deleteEvent(@Validated(DeleteGroup.class) EventPOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;

        result = eventService.deleteEvent(wrapper);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 이벤트댓글 목록조회 POPUP + 이벤트 지원자 목록조회 POPUP 
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-letter-list")
    public @ResponseBody ResultListModel<EventLettVO> selectEventLettListPaging(@Validated EventLettSO so,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // 이벤트 댓글 조회
        ResultListModel<EventLettVO> list = eventService.selectEventLettListPaging(so);
        // 이벤트 로그 조회
        List<EventLettVO> histList = eventService.selectEventCmntProcHistList(so);
        list.put("histList", histList);

        return list;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 29.
     * 작성자 : hskim
     * 설명   : 이벤트 지원자 리스트 엑셀다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 29. hskim - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-lett-excel-download")
    public String downloadExcelEventLettList(EventLettSO so, Model model) throws Exception {
        // 엑셀로 출력할 데이터 조회
    	so.setRows(10000);
        ResultListModel<EventLettVO> resultListModel = eventService.selectEventLettListPaging(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "아이디", "이벤트명", "내용", "당첨자 발표일", "당첨여부"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "loginId", "eventNm", "content", "eventWngDttm", "wngYn" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("이벤트 지원자 목록", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "eventLettExcel_" + DateUtil.getNowDateTime()); // 엑셀 파일명

        return View.excelDownload();
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 29.
     * 작성자 : hskim
     * 설명   : 이벤트 당첨자 리스트 엑셀다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 29. hskim - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-wng-excel-download")
    public String downloadExcelEventWngList(EventLettSO so, Model model) throws Exception {
        // 엑셀로 출력할 데이터 조회
    	so.setRows(10000);
        ResultListModel<EventLettVO> resultListModel = eventService.selectEventWngListPaging(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "아이디", "이벤트명", "내용", "당첨자 발표일", "당첨여부"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "loginId", "eventNm", "content", "eventWngDttm", "wngYn" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("이벤트 당첨자 목록", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "eventWngExcel_" + DateUtil.getNowDateTime()); // 엑셀 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 이벤트댓글 블라인드 수정 + 이벤트댓글블라인드 이력 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-commentblind-update")
    public @ResponseBody ResultModel<EventLettPO> updateEventCmntBlind(@Validated(UpdateGroup.class) EventLettPO po,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventLettPO> result = null;
        try {
            result = eventService.updateEventCmntBlind(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 이벤트 댓글 처리 이력 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-comment-history")
    public @ResponseBody ResultListModel<EventLettVO> selectEventCmntProcHistList(@Validated EventLettSO so,
            BindingResult bindingResult) {
        ResultListModel<EventLettVO> result = new ResultListModel<EventLettVO>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        List<EventLettVO> list = eventService.selectEventCmntProcHistList(so);
        result.setResultList(list);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 4.
     * 작성자 : dong
     * 설명   : 이벤트 당첨자 업데이트 + 이벤트 당첨자처리 이력 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-winning-update")
    public @ResponseBody ResultModel<EventLettPO> updateEventWng(@Validated EventLettPO po,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventLettPO> result = null;
        try {
            result = eventService.updateEventWng(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 4.
     * 작성자 : dong
     * 설명   : 이벤트 당첨자 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-winning-list")
    public @ResponseBody ResultListModel<EventLettVO> selectEventWngListPaging(@Validated EventLettSO so,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultListModel<EventLettVO> list = eventService.selectEventWngListPaging(so);
        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 4.
     * 작성자 : dong
     * 설명   : 이벤트 당첨자처리내역 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-winning-history")
    public @ResponseBody ResultListModel<EventLettVO> selectEventWngProcHistList(@Validated EventLettSO so,
            BindingResult bindingResult) {
        ResultListModel<EventLettVO> result = new ResultListModel<EventLettVO>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        List<EventLettVO> list = eventService.selectEventCmntProcHistList(so);
        result.setResultList(list);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 4. 11.
     * 작성자 : truesol
     * 설명   : 이벤트 당첨 내용 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 4. 11. truesol - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/winning-content-select")
    public @ResponseBody ResultModel<EventVO> selectWngContent(@Validated EventPO po, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<EventVO> result = eventService.selectWngContent(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 이벤트당첨내용등록popup
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/winning-content-insert")
    public @ResponseBody ResultModel<EventPO> insertWngContent(@Validated EventPO po, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.insertWngContent(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 이벤트당첨내용 수정popup
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/event-winconent-update")
    public @ResponseBody ResultModel<EventPO> updateWngContent(@Validated EventPO po, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<EventPO> result = null;
        try {
            result = eventService.updateWngContent(po);
        } catch (Exception e) {
            // TODO Auto-generated catch block

        }
        return result;
    }

}
