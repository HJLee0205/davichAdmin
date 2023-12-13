package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       : SMS 발송 PO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SmsSendPO extends BaseModel<SmsSendPO> {
    private String smsSendNo;
    // 발신 유형 구분 코드
    private String sendTypeCd;
    // 수신대상 그룹 구분 코드
    private String sendTargetCd;
    // 발신 메세지 유형 구분 코드 (01 : SMS / 02 : LMS)
    private String sendFrmCd;
    // 전송 상태 코드
    private String resultCd;
    // 발신 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sendTelno;
    // 발신 메세지 내용
    private String sendWords;
    private long senderNo;
    private String senderId;
    private String senderNm;
    private String sendDttm;
    private String realSendDttm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String recvTelNo;
    private String receiverNo;
    private String receiverId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    private String recvDttm;
    private String autoSendYn;
    private String ordNo;
    private Integer possCnt;
    private Integer minusPossCnt;

    private SmsSendSO so;

    // kftel 컬럼
    private String fdestine; // 받는사람 번호
    private String fcallback; // 보내는 사람 번호
    private String fuserid; // 고객 아이디

    // SMS 자동 발송 상태 목록
    private String[] useYnCode;
    // SMS 자동 발송 상태별 사용 여부 목록
    private String[] useYnArray;

    // SMS 자동 발송 관리자 발신 여부 목록
    private String[] adminSendYnArr;
    // SMS 자동 발송 고객 발신 여부 목록
    private String[] memberSendYnArr;
    // SMS 자동 발송 판매자 발신 여부 목록
    private String[] sellerSendYnArr;
    // SMS 자동 발송 가맹점 발신 여부 목록
    private String[] storeSendYnArr;
    // SMS 자동 발송 임직원 발신 여부 목록
    private String[] staffSendYnArr;

    // 관리자 수신번호1 목록
    private String[] adminRcvNo1;
    // 관리자 수신번호2 목록
    private String[] adminRcvNo2;
    // 관리자 수신번호3 목록
    private String[] adminRcvNo3;
    // 관리자 수신번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String recvMobile;

    // 고객 수신 내용 목록
    private String[] memberSendWords;
    // 관리자 수신 내용
    private String[] adminSendWords;
    // 판매자 수신 내용 목록
    private String[] sellerSendWords;
    // 가맹점 수신 내용 목록
    private String[] storeSendWords;
    // 임직원 수신 내용 목록
    private String[] staffSendWords;

    // 관리자 수신 내용 목록
    private String[] managerSendWords;

    // 사용 여부
    private String useYn;
    // 고객 수신 여부
    private String memberSendYn;
    // 관리자 수신 여부
    private String adminSendYn;
    // 판매자 수신 여부
    private String sellerSendYn;
    // 가맹점 수신 여부
    private String storeSendYn;
    // 임직원 수신 여부
    private String staffSendYn;

    // 고객 수신 내용
    private String memberSendWord;
    // 관리자 수신 내용
    private String adminSendWord;
    // 판매자 수신 내용
    private String sellerSendWord;
    // 가맹점 수신 내용
    private String storeSendWord;
    // 임직원 수신 내용
    private String staffSendWord;


    // 관리자 수신 여부 목록
    private String[] managerSendYn;
    // 관리자 수신 여부1
    private String manager1SendYn;
    // 관리자 수신 여부2
    private String manager2SendYn;
    // 관리자 수신 여부3
    private String manager3SendYn;
    // 관리자 수신 여부4
    private String manager4SendYn;
    // 관리자 수신 여부5
    private String manager5SendYn;
    // 관리자 수신 여부6
    private String manager6SendYn;
    // 관리자 수신 여부7
    private String manager7SendYn;
    // 관리자 수신 여부8
    private String manager8SendYn;
    // 관리자 수신 여부9
    private String manager9SendYn;
    // 관리자 수신 여부10
    private String manager10SendYn;
    // 고객 수신 내용
    private String memSendWords;

    private String templateCode;
}
