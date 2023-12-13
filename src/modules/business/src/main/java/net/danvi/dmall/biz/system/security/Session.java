package net.danvi.dmall.biz.system.security;

import java.util.Date;
import java.util.List;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import net.danvi.dmall.biz.system.model.LoginVO;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 로그인 정보 쿠키에 저장될 데이터를 담은 객체
 * </pre>
 */
@Data
public class Session {
    /** 업체 번호 */
    private Long companyNo;

    /** 사이트 번호 */
    private Long siteNo;

    /** 회원 번호 */
    private Long memberNo;

    /** 로그인 ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;

    /** 회원 명 */
    private String memberNm;

    /** 성인인증 여부 */
    private Boolean adult;

    /** 서버명 */
    private String serverName;

    /** 관리자 구분 */
    private String authGbCd;
    
    /** 통합 회원 구분 */
    private String birth;
    
    /** 통합 회원 구분 */
    private String integrationMemberGbCd;
    
    private String mobile;

    private Date lastAccessDate;

    private Long memberGradeNo;
    private String memberGradeNm;
    private int couponCount;
    
    /** 업체 로그인 여부 */
    private String sellerLoginYn;
    private String sellerNm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sellerId;
    private Long sellerNo;

    //온라인 회원카드번호
    private String memberCardNo;

    private String strCode; //가맹점 코드

    /** 권한 목록 */
    private List<String> menuAuthList;

    /** sns 로그인시 토큰 **/
    private String snsType;
    private String snsToken;

    /** erp 회원정보 **/
    private String cdCust;//erp 회원 번호

    public Session() {
    }

    public Session(LoginVO vo) {
        this.companyNo = vo.getCompanyNo();
        this.siteNo = vo.getSiteNo();
        this.loginId = vo.getLoginId();
        this.memberNo = vo.getMemberNo();
        this.memberNm = vo.getMemberNm();
        this.authGbCd = vo.getAuthGbCd();
        this.birth = vo.getBirth();
        this.integrationMemberGbCd = vo.getIntegrationMemberGbCd();
        this.memberGradeNo = vo.getMemberGradeNo();
        this.memberGradeNm = vo.getMemberGradeNm();
        this.couponCount = vo.getCouponCount();
        this.adult = CommonConstants.YN_Y.equals(vo.getAdultCertifyYn());
        this.sellerLoginYn = vo.getSellerLoginYn();
        this.sellerNm = vo.getSellerNm();
        this.sellerId = vo.getSellerId();
        this.sellerNo = vo.getSellerNo();
        this.memberCardNo = vo.getMemberCardNo();
        this.mobile = vo.getMobile();
        this.snsType = vo.getSnsType();
        this.snsToken = vo.getSnsToken();
        this.cdCust = vo.getCdCust();
    }
}
