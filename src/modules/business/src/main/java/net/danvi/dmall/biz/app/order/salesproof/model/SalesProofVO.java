package net.danvi.dmall.biz.app.order.salesproof.model;

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
public class SalesProofVO extends BaseModel<SalesProofVO> {
    private String rowNum;
    // 증빙서류 종류 01:매출전표, 02:현금영수증
    private String proofType;
    private String proofNm;
    private String ordDay;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    private String ordrEmail;
    private String paymentAmt;
    private String mainAmt;
    private String ordStatusNm;
    // 처리 상태명
    private String proofStatusNm;
    private String regDay;
    private String proofNo;
    private String paymentPgCd;
    private String paymentWayNm; // 결제 수단명

    // 현금영수증
    private String cashRctStatusCd; // 현금영수증상태코드(1:접수,2:승인,3:보류)
    private String svcchrgAmt; // 봉사료금액
    private String email; // 이메일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String telNo; // 전화번호
    private String goodsNm; // 상품명

    // 세금계산서
    private String taxBillStatusCd; // 세금 계산서번호
    private String companyNm; // 업체명
    private String bizNo; // 사업자번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ceoNm; // 대표자명
    private String bsnsCdts; // 업태
    private String item; // 종목
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo; // 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr; // 도로명주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr; // 지번주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr; // 상세주소

    // 공통변수(현금영수증,세금계산서)
    private String ordNo; // 주문번호
    private String applicantGbCd; // 신청자구분코드(공통코드없음)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String applicantNm; // 신청자명
    private String memberNo; // 회원번호
    private String useGbCd; // 사용구분코드(공통코드없음)
    private String issueWayCd; // 발급수단코드(1:주민등록번호,2:휴대폰번호,3:사업자번호)
    private String issueWayNo; // 발급수단번호
    private String supplyAmt; // 공급가액
    private String vatAmt; // 부가세금액
    private String totAmt; // 총금액
    private String acceptDttm; // 접수일시
    private String prcNo; // 처리자번호
    private String linkDttm; // 연동일시
    private String linkTxNo; // 연동거래번호
    private String linkResultCd; // 연동결과코드(공통코드없음)
    private String linkResultMsg; // 연동결과메시지
    private String memo; // 메모
    private String claimNo;
    private String linkYn; // 연동 여부
}
