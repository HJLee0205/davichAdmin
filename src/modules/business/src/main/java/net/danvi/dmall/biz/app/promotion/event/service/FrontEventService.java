package net.danvi.dmall.biz.app.promotion.event.service;

import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 12.
 * 작성자     : dong
 * 설명       : FRONT 이벤트 서비스
 * </pre>
 */
public interface FrontEventService {
    /** 이벤트 응모글 조회(댓글)- dong */
    public ResultListModel<EventLettVO> selectEventLettList(EventLettSO so);
    
    /** 이벤트 응모글 조회(내용)- hskim */
    public ResultModel<EventLettVO> selectEventLett(EventLettSO so);

    public ResultListModel<EventLettVO> selectEventLettListPaging(EventLettSO so);

    /** 이벤트 응모글 등록(출석체크/댓글)- dong **/
    public ResultModel<EventLettPO> insertEventLett(EventLettPO po);

    /** 이벤트 응모글 삭제(출석체크/댓글)- dong **/
    public ResultModel<EventLettPO> deleteEventLett(EventLettPO po);

    /** 출석이벤트 사용자 출석 정보 조회 **/
    public ResultListModel<EventLettVO> selectAttendanceUserInfo(EventLettSO so);

    /** 출석이벤트 출석 체크 등록(출석등록, 포인트 지급) **/
    public ResultModel<EventLettPO> insertAttendanceCheck(EventLettPO po) throws Exception;

    /** SNS 공유하기 정보 저장**/
    public ResultModel<EventLettPO> insertSnsShare(EventLettPO po);

    /** SNS 공유하기 정보 조회 */
    public ResultModel<EventLettVO> selectSnsSharedInfo(EventLettSO so);

}
