package net.danvi.dmall.biz.app.operation.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SmsSendVO extends BaseModel<SavedmnPointVO> {
    String rowNum;
    // SMS 발송 번호
    String smsSendNo;
    // 수신자 아이디
    String receiverId;
    // 수신자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    String receiverNm;
    // 수신 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    String recvTelno;
    // 수신 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    Date recvDttm;
    // 결과 코드
    String resultCd;
    // 발송 문구
    String sendWords;
    // 발신자 아이디
    String senderId;
    // 발송시간
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    Date sendDttm;

    // 실제 발송 시간
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    Date realSendDttm;

    // 발송 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    String sendTelno;

    // 발송 형태 코드명
    String sendFrmNm;

    // 발송 유형 코드
    String sendTypeCd;
    // 사용 여부
    String useYn;

    // 회원 발송 여부
    String memberSendYn;
    // 관리자 발송 여부
    String adminSendYn;
    // 판매자 발송 여부
    String sellerSendYn;
    // 가맹점 발송 여부
    String storeSendYn;
    // 임직원 발송 여부
    String staffSendYn;

    // 관리자1 발송 여부
    String manager1SendYn;
    // 관리자2 발송 여부
    String manager2SendYn;
    // 관리자3 발송 여부
    String manager3SendYn;
    // 관리자4 발송 여부
    String manager4SendYn;
    // 관리자5 발송 여부
    String manager5SendYn;
    // 관리자6 발송 여부
    String manager6SendYn;
    // 관리자7 발송 여부
    String manager7SendYn;
    // 관리자8 발송 여부
    String manager8SendYn;
    // 관리자9 발송 여부
    String manager9SendYn;
    // 관리자10 발송 여부
    String manager10SendYn;

    // 회원 발송 문구
    String memberSendWords;
    // 관리자 발송 문구
    String adminSendWords;
    // 판매자 발송 문구
    String sellerSendWords;
    // 가맹점 발송 문구
    String storeSendWords;
    // 임직원 발송 문구
    String staffSendWords;
    // 관리자 발송 문구
    String managerSendWords;


    // SMS 발신 번호 순번
    String seq;
    // SMS 발신 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    String recvMobile;

    String storeHandPhone;
}
