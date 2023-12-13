package net.danvi.dmall.biz.app.promotion.event.service;

import java.util.List;

import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import net.danvi.dmall.biz.app.promotion.event.model.EventPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventPOListWrapper;
import net.danvi.dmall.biz.app.promotion.event.model.EventSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 이벤트 서비스
 * </pre>
 */
public interface EventService {
    /**
     * <pre>
     * 작성일 : 2016. 10. 7.
     * 작성자 : Administrator
     * 설명   : 이벤트 리스트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 7. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventVO> selectEventList(EventSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 26
     * 작성자 : dong
     * 설명   : 이벤트 리스트 페이징 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     *
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventVO> selectEventListPaging(EventSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트기본정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventPO> insertEvent(EventPO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트기본정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventPO> updateEvent(EventPO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석이벤트기본정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventPO> insertAttendanceCheck(EventPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 출석이벤트기본정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventPO> updateAttendanceCheck(EventPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 이벤트 상세(단건)조회 + 출석체크이벤트 상세(단건)조회 : 공용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */

    public ResultModel<EventVO> selectEventInfo(EventSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 18.
     * 작성자 : 이헌철
     * 설명   : 이벤트 삭제 + 출석체크이벤트 삭제 : 공용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. Administrator - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     * @throws Exception
     */
    public ResultModel<EventPO> deleteEvent(EventPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : 이헌철
     * 설명   : 이벤트댓글 목록조회POP + 이벤트 지원자 목록조회POP
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventLettVO> selectEventLettListPaging(EventLettSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 8.
     * 작성자 : KMS
     * 설명   : 출석체크 이벤트 중복 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 8. KMS - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public int selectAttendanceEventLettCnt(EventLettSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : 이헌철
     * 설명   : 이벤트 댓글 블라인드 수정 + 이벤트댓글블라인드 이력 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. 이헌철 - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventLettPO> updateEventCmntBlind(EventLettPO po);

    /**
     * <pre>
     * 작성일 : 2016. 8. 5.
     * 작성자 : 이헌철
     * 설명   : 이벤트댓글처리이력 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 5. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<EventLettVO> selectEventCmntProcHistList(EventLettSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 5.
     * 작성자 : 이헌철
     * 설명   : 이벤트당청처리 업데이트 + 이벤트 당첨자처리 이력 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 5. 이헌철 - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<EventLettPO> updateEventWng(EventLettPO po);

    /**
     * <pre>
     * 작성일 : 2016. 8. 5.
     * 작성자 : 이헌철
     * 설명   : 이벤트당첨목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 5. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventLettVO> selectEventWngListPaging(EventLettSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 5.
     * 작성자 : 이헌철
     * 설명   : 이벤트당첨처리이력 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 5. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<EventLettVO> selectEventWngProcHistList(EventLettSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : 이헌철
     * 설명   : 이벤트당첨내용등록popup
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. Administrator - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EventPO> insertWngContent(EventPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : 이헌철
     * 설명   : 이벤트당첨내용수정popup
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. Administrator - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EventPO> updateWngContent(EventPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : 이헌철
     * 설명   : 모든 이벤트 당첨내용목록을 조회(이벤트목록화면에서 ‘당첨내용등록’ 당첨내용수정’ 버튼을 결정)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventVO> selectWngContentList(EventSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : 이헌철
     * 설명   : 다른 출석체크이벤트 시작일시와 종료일시를 조회(출석체크이벤트 중복방지)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EventVO> selectOtherEventDttm(EventSO so);
    
    
    public int insertImoticonInfo(EventLettPO po) throws Exception;

    ResultModel<EventVO> selectWngContent(EventPO po);
}
