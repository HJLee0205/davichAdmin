package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.sms.InnerSmsSendHistSO;
import dmall.framework.common.model.ResultListModel;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : smsemail
 * 작성일     : 2016. 8. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SmsService {

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : SMS 포인트 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param point
     * @param gbCd
     *            01:충전, 03:오류로 인한 사용 포인트 복원
     * @return
     */
    public Integer addPoint(String siteNo, Integer point, String gbCd);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : SMS 전송으로 SMS 포인트를 차감
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param point
     * @return
     */
    public Integer subPoint(String siteNo, Integer point);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : SMS 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param sitNo
     * @param list
     * @return
     */
    public RemoteBaseResult send(String sitNo, List<SmsSendPO> list);

    public RemoteBaseResult send(String sitNo, List<MemberManageVO> list, SmsSendPO po);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : SMS 전송 이력 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel selectSendHistoryPaging(InnerSmsSendHistSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 자동발신 SMS 전송 이력 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel selectAutoSendHistoryPaging(InnerSmsSendHistSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : SMS 포인트 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public Integer getPoint(String siteNo);
}
