package net.danvi.dmall.biz.app.order.manage.model;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문정보(등록,수정)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderInfoPO extends BaseModel<OrderInfoPO> implements Cloneable {

    // 주문 번호
    private long ordNo;
    // 원본 주문 번호
    private long orgOrdNo;
    // 주문 상태 코드
    private String ordStatusCd;
    // 주문 매체 코드
    private String ordMediaCd;
    // 판매 채널 코드
    private String saleChannelCd;
    // 회원 주문 여부
    private String memberOrdYn;
    // 주문자 번호
    private long memberNo;
    // 로그인 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    // 회원 등급 코드
    private long memberGradeNo;
    // 주문 비밀 번호
    private String ordSectNo;
    // 주문자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    // 주문자 이메일
    private String ordrEmail;
    // 주문자 전화
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrTel;
    // 주문자 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrMobile;
    // 주문자 IP
    private String ordrIp;
    // 주문 접수 일시
    private Date ordAcceptDttm;
    // 주문 완료 일시
    private Date ordCmpltDttm;
    // 주문 취소 일시
    private Date ordCancelDttm;
    // 결제 완료 일시
    private Date paymentCmpltDttm;
    // SMS 수신 여부
    private String smsRecvYn;
    // 이메일 수신 여부
    private String emailRecvYn;
    // 배송지 번호
    private long deliveryNo;
    // 지급 마켓포인트
    private long pvdSvmn;
    // 수기 주문 여부
    private String manualOrdYn;
    // 결제 금액
    private long paymentAmt;
    // 판매 금액
    private long saleAmt;
    // 할인 금액
    private long dcAmt;
    // 정가금액
    private long customerAmt;
    // 지급금액
    private long pvdsvmnAmt;
    // 마켓포인트
    private long mileageAmt;
    // 포인트
    private long pointAmt;
    // 스탬프적립개수
    private long stampsaveAmt;
    // 사용스탬프개수
    private long stampuseAmt;
    // 추가배송비
    private long dlvraddAmt;
    // 배송비
    private long dlvrAmt;
    // 주문 메모
    private String memoContent;
    // 추천인 회원번호
    private String recomMemberNo;

    /** 주문 배송지 **/
    // 지역 배송 설정 번호
    private long areaDlvrSetNo;
    // 배송지명
    private String deliveryNm;
    // 수취인명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    // 수취인 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsTel;
    // 수취인 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsMobile;
    // 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo;
    // 지번주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr;
    // 도로명주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr;
    // 상세주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    // 배송메세지
    private String dlvrMsg;
    // 회원구분코드
    private String memberGbCd;
    // 해외주소 CITY
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCity;
    // 해외주소 COUNTRY
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCountry;
    // 해외주소 STATE
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrState;
    // 해외주소 ZIP CODE
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrZipCode;
    // 해외주소 상세1
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl1;
    // 해외 주소 상세2
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl2;

    /*
     * (non-Javadoc)
     *
     * @see java.lang.Object#clone()
     */
    @Override
    public OrderInfoPO clone() throws CloneNotSupportedException {
        return (OrderInfoPO) super.clone();
    }

    private String partCancelYn;
}
