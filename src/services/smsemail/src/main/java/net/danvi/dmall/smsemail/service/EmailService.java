package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.EmailHistDelPO;
import net.danvi.dmall.smsemail.model.email.CustomerInfoPO;
import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;
import net.danvi.dmall.smsemail.model.email.InnerEmailSendHistSO;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : smsemail
 * 작성일     : 2016. 8. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface EmailService {

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 이메일 포인트를 추가한다.
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
     * 설명   : 이메일 전송으로 이메일 포인트를 차감 
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
     * 설명   : 대량 이메일 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param emailSendPO
     * @return
     */
    public CustomerInfoPO send(EmailSendPO emailSendPO) throws CloneNotSupportedException;

    /**
     * <pre>
     * 작성일 : 2016. 9. 20.
     * 작성자 : dong
     * 설명   : 전송 대상 상태로 변경 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 20. dong - 최초생성
     * </pre>
     *
     * @param customerInfoPO
     */
    public void sendFinish(CustomerInfoPO customerInfoPO);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 대량 이메일 전송 이력 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EmailSendHistVO> selectSendHistoryPaging(InnerEmailSendHistSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 20.
     * 작성자 : kjw
     * 설명   : 대량 이메일 전송 상세 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 20. kjw - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public EmailSendHistVO viewSendHistory(InnerEmailSendHistSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 이메일 포인트 반환
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

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 대량 이메일 전송 이력 삭제(삭제여부 Y로 변경)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param list
     * @return
     */
    public RemoteBaseResult deleteSendHistory(EmailHistDelPO po);
}
