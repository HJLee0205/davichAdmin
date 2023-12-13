package net.danvi.dmall.smsemail.batch.service;

import java.util.List;

import net.danvi.dmall.smsemail.model.sms.SmsSendHistVO;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 8. 17.
 * 작성자     : parkyt
 * 설명       : 회원 관련 배치 Service
 * </pre>
 */
public interface SmsBatchService {
    public List<SmsSendHistVO> smsFailCountListReader();

    public List<SmsSendHistVO> lmsFailCountListReader();

    public void updSmsStatus();

    public void updLmsStatus();

    public void updateSmsFailPointAdd(SmsSendHistVO vo);
}
