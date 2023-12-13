package net.danvi.dmall.biz.app.setup.payment.model;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       : PG연동 설정 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CommPaymentConfigPO extends BaseModel<CommPaymentConfigPO> {
    // 통합전자결제
    // 수정 or 등록
    private String editYn;
    // 가맹점 코드
    private String shopCd;
    // 수정 전 가맹점 코드
    private String beforeShopCd;
    // 가맹점 명
    private String shopNm;
    // PG코드
    private String pgCd;
    // PG명
    private String pgNm;
    // 사용여부
    private String useYn;
    // 신용카드 결제 여부
    private String credPaymentYn;
    // 계좌이체 결제 여부
    private String acttransPaymentYn;
    // 가상계좌 결제 여부
    private String virtactPaymentYn;
    // 휴대폰 결제 여부
    private String mobilePaymentYn;
    // 입금확인 URL 사용 여부
    private String dpstCheckUrlUseYn;
    // PGID
    @Length(min = 0, max = 50)
    private String pgId;
    // SIGN KEY
    @Length(min = 0, max = 300)
    private String signKey;
    // KEY_PASSWORD
    @Length(min = 0, max = 300)
    private String keyPasswd;
    // PGKEY
    @Length(min = 0, max = 300)
    private String pgKey;
    // PGKEY2
    private String pgKey2;
    // PGKEY3
    private String pgKey3;
    // PGKEY4
    private String pgKey4;
    // 할부 기간
    @Length(min = 0, max = 11)
    private String instPeriod;
    // 무이자 유형코드
    private String nointTypeCd;
    // 무이자 기간 코드
    private String nointPeriodCd;
    // 현금 영수증 사용 여부
    private String cashRctUseYn;
    // 에스크로 사용 여부
    private String escrowUseYn;
    // 에스크로 신용카드 결제 여부
    private String escrowCredPaymentYn;
    // 에스크로 계좌이체 결제 여부
    private String escrowActtransPaymentYn;
    // 에스크로 가상계좌 결제 여부
    private String escrowVirtactPaymentYn;
    // 에스크로 사용 금액
    @Length(min = 0, max = 20)
    private String escrowUseAmt;
    // 구매안전 이미지 경로
    private String safebuyImgPath;
    // 구매안전 이미지 표시 설정 코드
    private String safebuyImgDispSetCd;
    // 에스크로 아이디
    private String escrowId;
    // 에스크로 인증 파일 경로1
    private String escrowCertKeyFilePath1;
    // 에스크로 인증 파일 경로2
    private String escrowCertKeyFilePath2;
    // 에스크로 인증 파일 경로3
    private String escrowCertKeyFilePath3;
    // 에스크로 인증 마크 내용
    @Length(min = 0, max = 300)
    private String escrowCertifyMarkContent;
    // 해외결제(TS_SITE 테이블에 존재하는 해외결제 컬럼을 통합전자결제 VO, PO에 같이 넣는이유는 3개밖에 되지않아서 같이
    // 넣는다.)
    private String frgPaymentYn;
    // 해외결제 스토어ID
    @Length(min = 0, max = 200)
    private String frgPaymentStoreId;
    // 해외결제 패스워드
    @Length(min = 0, max = 200)
    private String frgPaymentPw;
}
