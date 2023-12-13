package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.EditorBasePO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       : Email 발송 PO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class EmailSendPO extends EditorBasePO<EmailSendPO> {
    // 메일 발송 번호
    private String mailSendNo;

    // 회원 발송 여부
    private String memberSendYn;
    // 관리자 발송 여부
    private String adminSendYn;
    // 판매자 발송 여부
    private String sellerSendYn;
    // 가맹점 발송 여부
    private String storeSendYn;
    // 임직원 발송 여부
    private String staffSendYn;

    // 메일 제목
    private String mailTitle;
    // 메일 내용
    private String mailContent;


    // 관리자 발송 여부
    private String managerSendYn;
    // 운영자 발송 여부
    private String operatorSendYn;
    // 발송 형태 코드
    private String sendFrmCd;

    // Email 발송 이력
    private long ordNo;
    // 발송 대상 코드
    private String sendTargetCd;
    // 메일 유형 코드
    private String mailTypeCd;
    // 메일 유형 코드 명
    private String mailTypeNm;
    // 결과 코드
    private String resultCd;
    // 발송 메일
    private String sendEmail;
    // 발송 제목
    private String sendTitle;
    // 발송 내용
    private String sendContent;
    // 발신자 번호
    private long senderNo;
    // 발신자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String senderNm;
    // 발송 일시
    private String sendDttm;
    // 수신 이메일
    private String receiverEmail;
    // 수신자 번호
    private long receiverNo;
    private String receiverId;

    // 수신자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    // 자동 발송 여부
    private String autoSendYn;

    // 수신거부회원 제외 여부
    private String excludeRecvN;
    // 이메일 발신 대상 형식(회원그룹별, 기념일(생일))
    private String sendTargetType;
    // 회원등급
    private String memberGrade;
    // 기념일타입(생일)
    private String anniversarySel;
    // 생월
    private String bornMonth;
    // 이메일 구분(광고, 공지)
    private String emailshotGb;
    // 발송시간(일반,예약)
    private String sendTimeSel;
    // 예약발송시간
    private String reservationDttm;
    // 풋터 사용 여부
    private String footerUseYn;
    // 발송 기준
    private String sendStndrd;

    // 이메일 보유 건수
    private Integer possCnt;

    private String curPage;

    private String emailMember;

    private String delYn;

    private String[] recvEmailTotal;
    private long[] receiverNoTotal;
    private String[] receiverNmTotal;

    private String[] recvEmailSearch;
    private long[] receiverNoSearch;
    private String[] receiverNmSearch;

    private String[] recvEmailSelect;
    private long[] receiverNoSelect;
    private String[] receiverNmSelect;

    // 삭제 이메일 발송 번호
    private String[] delEmailShotHst;
    // 삭제 이메일 발송 기준
    private String[] sendStndrdArray;
    // 삭제 이메일 발송 시간
    private String[] sendDttmArray;

}
