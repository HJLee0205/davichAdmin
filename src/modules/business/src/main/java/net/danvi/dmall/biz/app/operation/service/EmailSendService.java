package net.danvi.dmall.biz.app.operation.service;

import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.EmailSendVO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface EmailSendService {
    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 이메일 발송내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<EmailSendVO> selectSendEmailPaging(EmailSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 이메일 발송 정보을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<EmailSendVO> selectSendEmailInfo(EmailSendSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 이메일을 발송한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public boolean sendEmail(List<MemberManageVO> toMailList, EmailSendPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 상태별 자동발송 이메일을 수정한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EmailSendPO> updateStatusEmail(EmailSendPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 상태별 자동발송 이메일을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EmailSendVO> selectStatusCfg(EmailSendSO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 이메일 발송 내역을 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EmailSendPO> insertEmailSendHst(EmailSendPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 6.
     * 작성자 : dong
     * 설명   : 자동 발생 Email 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 6. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public boolean emailAutoSend(EmailSendSO so, ReplaceCdVO replaceVO)
            throws Exception, AddressException, MessagingException;

    /**
     * <pre>
     * 작성일 : 2016. 7. 6.
     * 작성자 : dong
     * 설명   : smtp메일 전송 ( 10건 이하 이메일 )
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 6. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public boolean commonSendEmail(List<MemberManageVO> toMailList, EmailSendPO po)
            throws Exception, AddressException, MessagingException;

    /**
     * <pre>
     * 작성일 : 2016. 7. 27.
     * 작성자 : kjw
     * 설명   : 관리자 이메일 주소 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 27. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public EmailSendVO selectAdminEmail(EmailSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 08.
     * 작성자 : kjw
     * 설명   : 이메일 최근 발송 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 08. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public List<EmailSendVO> selectEmailHst(EmailSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 08.
     * 작성자 : kjw
     * 설명   : 이메일 최근 발송 조회(단건)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 08. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<EmailSendVO> selectSendEmailHstOne(EmailSendSO so);

}
