package net.danvi.dmall.biz.app.order.salesproof.model;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class SalesProofPO extends BaseModel<SalesProofPO> {

    // 현금영수증
    private String reqMode; // 현금영수증 요청 종류(pay:발급, mod:취소)
    private String cashRctStatusCd; // 현금영수증상태코드(01:접수,02:승인,03:보류)
    private long svcchrgAmt; // 봉사료금액
    private String goodsNm; // 상품명
    private String paymentPgCd; // 결제 PG 코드

    // 세금계산서
    private String taxBillStatusCd; // 세금 계산서상태코드(01:접수,02:승인,03:보류)
    private String companyNm; // 업체명
    private String bizNo; // 사업자번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ceoNm; // 대표자명
    private String bsnsCdts; // 업태
    private String item; // 업종
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo; // 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr; // 도로명주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr; // 지번주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr; // 상세주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String managerNm; // 담당자명

    // 공통변수(현금영수증,세금계산서)
    private long ordNo; // 주문번호
    private String applicantGbCd; // 신청자구분코드(공통코드없음)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String applicantNm; // 신청자명
    private Long memberNo; // 회원번호
    private String useGbCd; // 사용구분코드(개인소득공제,사업자지출증빙)
    private String issueWayCd; // 발급수단코드(01:주민등록번호,02:휴대폰번호,03:사업자번호)
    private String issueWayNo; // 인증번호(휴대폰번호,사업자번호,주민등록번호)
    private long supplyAmt; // 공급가액
    private long vatAmt; // 부가세금액
    private long totAmt; // 총금액
    private Date acceptDttm; // 접수일시

    private Date linkDttm; // 연동일시
    private String linkTxNo; // 연동거래번호
    private String linkResultCd; // 연동결과코드(공통코드없음)
    private String linkResultMsg; // 연동결과메시지
    private String memo; // 메모
    private String email; // 이메일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String telNo; // 전화번호

    private String proofType;
    private String proofNo;

}
