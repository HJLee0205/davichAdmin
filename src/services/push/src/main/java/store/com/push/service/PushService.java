package store.com.push.service;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.springframework.scheduling.annotation.Async;

/**
 * 푸시 전송 인터페이스 클래스
 * @author 김현열
 * @since 2018.12.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2018.12.20  김현열          최초 생성
 *  </pre>
 */
public interface PushService {

	/* 다비젼 푸시 예약정보 조회 */
    public List<EgovMap> getPushRsvList() throws Exception;

    /* 푸시 예약정보 총 건수 조회 */
    public int getPushRsvListTotalCount() throws Exception;

    /* 다비젼 푸시 예약정보 조회 */
    public List<EgovMap> getPushRsvListPaging(EgovMap paramMap) throws Exception;

    /* 푸시 예약정보 결과 등록 */
    public int registPushRsv(List<EgovMap> send_list) throws Exception;

	/* 푸시 예약정보 입력 */
    public void insertPushRsv(EgovMap map) throws Exception;
    
	/* 푸시 예약 정보 update */
    public void updatePushRsv(EgovMap map) throws Exception;
    
	/* 푸시 에약정보 중복여부 조회 */
    public int selectExsistData(EgovMap map) throws Exception;
    
	/* 다비젼 푸시 예약정보 동기화 결과 update */
    public void updatePushRsvByDv(EgovMap map) throws Exception;
    
	/* 푸시 발송예약정보 조회 */
    public List<EgovMap> getPushSendRsvList() throws Exception;
    
	/* 푸시 발송대상정보 조회 */
    public List<EgovMap> getPushSendList() throws Exception;

    /* 푸시 발송대상정보 총 건수 조회 */
    public int getPushSendListPagingCount() throws Exception;

    /* 푸시 발송대상정보 페이징 조회 */
    public List<EgovMap> getPushSendListPaging(EgovMap paramMap) throws Exception;
    
	/* 쇼핑몰 회원정보 조회 */
    public EgovMap selectMemberInfo(EgovMap map) throws Exception;
    
	/* 푸시 예약 추가정보 저장 */
    public void updatePushRsvAdd(EgovMap map) throws Exception;

	/* 다비젼 푸시 전송 결과 update */
    public void updateSendPushRsltByDv(EgovMap map) throws Exception;
    
	/* 푸시 전송 결과 update */
    public void updateSendPushRslt(EgovMap map) throws Exception;

    /* 푸시 전송 결과 update */
    public int updateSendPush(List<EgovMap> send_list) throws Exception;
    @Async
    public int sendPush(EgovMap map) throws Exception;

    @Async
    public int sendPush(List<EgovMap> send_list) throws Exception;


    
}
