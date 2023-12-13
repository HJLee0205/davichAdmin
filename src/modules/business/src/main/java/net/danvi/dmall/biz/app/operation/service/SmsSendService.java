package net.danvi.dmall.biz.app.operation.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.operation.model.*;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SmsSendService {

    /**
     * <pre>
     * 작성일 : 2016. 8. 12.
     * 작성자 : kjw
     * 설명   : SMS 자동 발송 
     * 1. 자동발송 설정 데이터 조회(보내는 내용, 사용 유무 등)
     * 2. 관리자 수신번호 목록 조회
     * 3. 고객정보 셋팅(받는 고객명, 휴대폰번호 등)
     * 4. 관리자정보 셋팅(받는 관리자 수신번호 등)
     * 5. 사이트 정보 조회하여 보내는사람 이름을 해당 쇼핑몰 명으로 셋팅
     * 6. 고객, 관리자 문자 내용 셋팅 하여 SMS 발송 메소드 호출(sendSms)     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 12. kjw - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public boolean sendAutoSms(SmsSendSO so, ReplaceCdVO replaceCdVO) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : SMS를 발송한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SmsSendPO> sendSms(List<SmsSendPO> po) throws Exception;

    public ResultModel<SmsSendPO> sendSms(SmsSendPO po, String smsMember, SmsSendSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : SMS 발송내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<SmsSendVO> selectSmsHstPaging(SmsSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : SMS 발송 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<SmsSendVO> selectSmsHstInfo(SmsSendSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 상태별 자동발송 SMS를 수정한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SmsSendPO> updateStatusSms(SmsSendPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 관리자 수신번호를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<SmsSendVO> selectAdminNo(SmsSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 관리자 수신번호를 추가한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SmsSendPO> insertAdminNo(SmsSendPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 관리자 수신번호를 삭제한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SmsSendPO> deleteAdminNo(SmsSendPO po);

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : kjw
     * 설명   : 상태별 자동발송 SMS를 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. kjw - 최초생성
     * </pre>
     *
     * @param SmsSendSO
     * @return
     */
    public List<SmsSendVO> selectStatusSms(SmsSendSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : 인증된 발신번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. kjw - 최초생성
     * </pre>
     *
     * @param SmsSendSO
     * @return
     */
    public String selectAdminSmsNo(SmsSendSO so);

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
    public ResultListModel<SmsSendHistVO> selectSendHistPaging(InnerSmsSendHistSO so);
}
