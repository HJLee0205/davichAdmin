package net.danvi.dmall.biz.app.promotion.event.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import net.danvi.dmall.biz.app.promotion.event.model.EventSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 12.
 * 작성자     : dong
 * 설명       : FRONT 이벤트 서비스
 * </pre>
 */
@Slf4j
@Service("frontEventService")
@Transactional(rollbackFor = Exception.class)
public class FrontEventServiceImpl extends BaseService implements FrontEventService {

    @Resource(name = "eventService")
    private EventService eventService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    /** 이벤트 응모글 조회(댓글)- dong */
    @Override
    public ResultListModel<EventLettVO> selectEventLettList(EventLettSO so) {
        List<EventLettVO> list = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectEventLettList", so);
        ResultListModel<EventLettVO> result = new ResultListModel<>();
        log.debug("=========== list : {}", list.toString());
        
        result.setResultList(list);

        return result;
    }
    
    /** 이벤트 응모글 조회(내용)- hskim */
    @Override
    public ResultModel<EventLettVO> selectEventLett(EventLettSO so) {
        EventLettVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectEventLett", so);
        ResultModel<EventLettVO> result = new ResultModel<EventLettVO>(vo);
        result.setData(vo);
        
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see FrontEventService#
     * selectEventLettListPaging(net.danvi.dmall.biz.app.promotion.event.model
     * .EventLettSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<EventLettVO> selectEventLettListPaging(EventLettSO so) {
        ResultListModel<EventLettVO> resultList = proxyDao
                .selectListPage(MapperConstants.PROMOTION_EVENT + "selectEventLettListPaging", so);

        List<EventLettVO> list = resultList.getResultList();
        //2016.10.10 모바일 변경
        if(list != null){
	        for (int i = 0; i < list.size(); i++) {
	            EventLettVO tempVo = list.get(i);
	            if ("Y".equals(tempVo.getBlindPrcYn())) {
	                tempVo.setContent("블라이드 처리된 댓글 입니다.");
	            }
	        }
	        //resultList.setResultList(list);
        }
        //
        return resultList;
    }

    /** 이벤트 응모글 등록(출석체크/댓글)- dong **/
    @Override
    public ResultModel<EventLettPO> insertEventLett(EventLettPO po) {
        ResultModel<EventLettPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertEventLett", po);
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /** 이벤트 응모글 삭제(출석체크/댓글)- dong **/
    @Override
    public ResultModel<EventLettPO> deleteEventLett(EventLettPO po) {
        ResultModel<EventLettPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.PROMOTION_EVENT + "deleteEventLett", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    /** 출석이벤트 사용자 출석 정보 조회 **/
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<EventLettVO> selectAttendanceUserInfo(EventLettSO so) {
        List<EventVO> list = proxyDao.selectList(MapperConstants.PROMOTION_EVENT + "selectAttendanceUserInfo", so);
        ResultListModel<EventLettVO> result = new ResultListModel<>();

        result.put("list", list);

        return result;
    }

    /**
     * 출석이벤트 출석 체크 등록(출석등록, 포인트 지급)
     *
     * @throws Exception
     **/
    @Override
    public ResultModel<EventLettPO> insertAttendanceCheck(EventLettPO po) throws Exception {

        ResultModel<EventLettPO> result = new ResultModel<>();
        // 이벤트 정보 조회
        EventSO eventSO = new EventSO();
        eventSO.setEventNo(Integer.parseInt(Long.toString(po.getEventNo())));
        eventSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        eventSO.setDelYn("N");
        ResultModel<EventVO> event = eventService.selectEventInfo(eventSO);

        String today = DateUtil.getNowDate();
        
        // 출석 중복 확인
        EventLettSO eventLettSO = new EventLettSO();
        eventLettSO.setEventNo(Integer.parseInt(Long.toString(po.getEventNo())));
        eventLettSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        eventLettSO.setRegDt(today);
        eventLettSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        int lettCnt = eventService.selectAttendanceEventLettCnt(eventLettSO);
        if (lettCnt == 0) {

            // 포인트 지급(무조건 자동)
            SavedmnPointPO sp = new SavedmnPointPO();
            String stRegDttm = event.getData().getApplyStartDttm().substring(0, 8);
            String endRegDttm = event.getData().getApplyEndDttm().substring(0, 8);
            sp.setGbCd("10"); // 적립
            sp.setTypeCd("A"); // 자동
            sp.setReasonCd("01"); // 이벤트 출석체크 적립
            sp.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            sp.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            String pointApplyEndDttm = "";
            if (StringUtils.equals(event.getData().getEventPointApplyCd(), "01")) {
                pointApplyEndDttm = event.getData().getPointApplyEndDttm().substring(0, 8);
            } else {
                pointApplyEndDttm = DateUtil.addDays(today, event.getData().getEventApplyIssueAfPeriod());
            }

            sp.setEtcValidPeriod(pointApplyEndDttm); // 유효기간
            sp.setPointUsePsbYn("Y"); // 포인트 사용 가능 여부

            // 출석이벤트 조건
            EventLettSO so = new EventLettSO();
            so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            so.setEventNo(event.getData().getEventNo());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
            ResultListModel<EventLettVO> attendanceList = this.selectAttendanceUserInfo(so);
            // 이벤트 기간내 총 출석횟수
            int attendanceCnt = ((List)attendanceList.getExtraData().get("list")).size();

            SavedmnPointSO ps = new SavedmnPointSO();
            ps.setMemberNoSelect(SessionDetailHelper.getDetails().getSession().getMemberNo());
            ps.setPointGbCd("10"); // 지급
            ps.setReasonCd("01"); // 이벤트 출석체크 적립

            if (StringUtils.equals(event.getData().getEventCndtCd(), "01")) { // 조건완성형
            	// 출석체크 등록
                po.setRegDt(today);
                result = this.insertEventLett(po);
                
                // 이벤트 조건 만족 포인트 지급
                if (attendanceCnt >= event.getData().getEventTotPartdtCndt()) {
                    // 기간내 포인트 지급 내역 카운트
                    ps.setStRegDttm(stRegDttm);
                    ps.setEndRegDttm(endRegDttm);
                    int cnt = savedMnPointService.selectPointGiveHistoryCnt(ps);
                    if (cnt == 0) { // 기간 내에 지급한 적이 없다면
                    	String eventPvdPoint = Integer.toString(event.getData().getEventPvdPoint());
                        sp.setPrcPoint(eventPvdPoint); // 지급포인트
                        savedMnPointService.insertPoint(sp);
                        result.setMessage("마켓포인트 "+eventPvdPoint+"원 증정되었습니다!");
                    }
                }
            } else if (StringUtils.equals(event.getData().getEventCndtCd(), "02")) { // 추가지급형
                
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat dateFmt = new SimpleDateFormat("yyyyMMdd");
                int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); /*오늘의 요일*/
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                String monday = dateFmt.format(cal.getTime()); /*금주 월요일 날짜*/
                cal.set(Calendar.DAY_OF_WEEK, Calendar.FRIDAY);
                String friday = dateFmt.format(cal.getTime()); /*금주 금요일 날짜*/
                
                if(dayOfWeek == 1 || dayOfWeek == 7) { /* 토,일은 기본지급포인트만 */
                	//이벤트 설정중에 기간 예외설정이 토요일제외 or 일요일제외 일경우
                	if( ("01".equals(event.getData().getEventApplyIssueAfPeriod()) && dayOfWeek == 7) || ("02".equals(event.getData().getEventApplyIssueAfPeriod()) && dayOfWeek == 1) ) {
                		if("01".equals(event.getData().getEventApplyIssueAfPeriod())){
                			result.setMessage("해당 이벤트는 토요일 제외 이벤트입니다.<br>다음에 다시 도전해주세요.");
                		}else if("02".equals(event.getData().getEventApplyIssueAfPeriod())){
                			result.setMessage("해당 이벤트는 일요일 제외 이벤트입니다.<br>다음에 다시 도전해주세요.");
                		}
                	}else {
                		// 출석체크 등록
                        po.setRegDt(today);
                        result = this.insertEventLett(po);
                        
                		// 기본지급포인트
                    	String eventPvdPoint = Integer.toString(event.getData().getEventPvdPoint());
                        sp.setPrcPoint(eventPvdPoint);
                        savedMnPointService.insertPoint(sp);
                        result.setMessage("마켓포인트 "+eventPvdPoint+"원 증정되었습니다!");
                	}
                }else {
                	/* 금주 출석체크 정보 조회 */
                	EventLettSO eso = new EventLettSO();
                    eso.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    eso.setEventNo(event.getData().getEventNo());
                    eso.setStRegDttm(monday);
                    eso.setEndRegDttm(friday);
                    ResultListModel<EventLettVO> thisWeekAttendanceList = this.selectAttendanceUserInfo(eso);
                    int thisWeekAttendanceCnt = ((List)thisWeekAttendanceList.getExtraData().get("list")).size();/* 금주 출석체크 횟수 */
                    int partdtCndt = event.getData().getEventTotPartdtCndt(); /*이벤트 참여횟수 충족 조건*/
                    
                    if(thisWeekAttendanceCnt == (dayOfWeek - 1)) { /*금일까지 출석체크 만근인 경우*/
                    	// 출석체크 등록
                        po.setRegDt(today);
                        result = this.insertEventLett(po);
                        
                    	// 기본지급포인트
                        sp.setPrcPoint(Integer.toString(event.getData().getEventPvdPoint()));
                        savedMnPointService.insertPoint(sp);
                        result.setMessage("마켓포인트 50원 증정되었습니다!");
                        
                        if(dayOfWeek == 6 && thisWeekAttendanceCnt >= partdtCndt) { /*금일이 금요일이고 만근일 경우 추가지급포인트*/
                        	ps.setStRegDttm(stRegDttm);
                            ps.setEndRegDttm(endRegDttm);
                            ps.setReasonCd("05"); // 이벤트 출석체크 추가 적립
                            String eventAddPvdPoint = Integer.toString(event.getData().getEventAddPvdPoint());
                            sp.setPrcPoint(eventAddPvdPoint); // 추가지급포인트
                            savedMnPointService.insertPoint(sp);
                            
                            result.setMessage("이번주 개근하셨네요!<br>마켓포인트 더블증정!!<br>"+eventAddPvdPoint+"원 추가 증정되었습니다.");
                        }
                    }else {
                    	result.setMessage("아쉽지만(˘ㅅ˘)<br>다음주 월요일 다시 도전해보세요.");
                    }
                	
                }

            }
        } else {
            result.setMessage("금일은 출석체크를 완료하였습니다.<br>다음에 다시 참여해주세요.");
        }

        return result;
    }

    /** SNS 공유하기 정보 저장**/
    @Override
    public ResultModel<EventLettPO> insertSnsShare(EventLettPO po) {
        ResultModel<EventLettPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.PROMOTION_EVENT + "insertSnsShare", po);
        result.setData(po);
        return result;
    }

    /** SNS 공유하기 정보 조회 */
    @Override
    public ResultModel<EventLettVO> selectSnsSharedInfo(EventLettSO so) {
        EventLettVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EVENT + "selectSnsSharedInfo", so);

        ResultModel<EventLettVO> result = new ResultModel<EventLettVO>(vo);
        result.setSuccess(true);
        result.setData(vo);

        return result;
    }
}
