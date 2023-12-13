package net.danvi.dmall.biz.batch.order.epost.model;

import java.io.Serializable;

import lombok.Data;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

@Data
public class EpostVO implements Serializable {

    private static final long serialVersionUID = -3878977625541451017L;
    // 배송신청구분
    private String sendReqDivCd;
    // 업체구분코드
    private String siteNo;
    // 주문 번호
    private String ordNo;
    // 주문 순번
    private String ordDtlSeq;
    // 송장번호
    private String rlsInvoiceNo;
    // 수취인 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    // 수취인 일반전화
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsTel;
    // 수취인 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsMobile;
    // 수취인 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo;
    // 수취인 번지 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr;
    // 상세 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    // 주문자
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    // 주문자 휴대폰번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrMobile;
    // 주문자 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrTel;
    // 배송 메세지
    private String dlvrMsg;
    // 상품 번호
    private String goodsNo;
    // 상품 명
    private String goodsNm;
    // 선불 여부
    private String dfPayYn;
    // 배송비
    private String realDlvrAmt;

}
