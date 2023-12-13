package net.danvi.dmall.smsemail.batch.service;

import java.util.List;

import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 9. 23.
 * 작성자     : kjw
 * 설명       : 대량메일 발송 관련 배치 Service
 * </pre>
 */
public interface EmailBatchService {
    public List<EmailSendHistVO> selectEmailSendingList();

    public List<EmailSendHistVO> selectEmailSendCompletList(List<EmailSendHistVO> emailSendingList);

    public void updateEmailSendResult(EmailSendHistVO vo);

    public String selectEmailSucsCnt(EmailSendHistVO vo);

}
