package net.danvi.dmall.biz.system.model;

import java.util.Date;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

@Data
@EqualsAndHashCode(callSuper = false)
public class LoginVO extends BaseModel<T> implements Cloneable {

    private static final long serialVersionUID = -6329689199358629578L;

    private Long memberNo;
    private String memberCardNo;
    private String memberTypeCd;
    private Long siteNo;
    //나의 단골 스토어 번호
    private String customStoreNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String birth;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String genderGbCd;
    private String ntnGbCd;
    private Date joinDttm;
    private String certifyMethodCd;
    private String emailRecvYn;
    private String smsRecvYn;
    private String memberStatusCd;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    private String pw;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String tel;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    private String email;
    private String joinPathCd;
    private String pwInitYn;
    private Date pwChgDttm;
    private Date nextPwChgScdDttm;
    private Integer loginFailCnt;
    private Integer svmnRemainAmnt;
    private Integer blcRemainAmt;
    private String bizMemberYn;
    /** 권한 구분 코드 */
    private String authGbCd;
    /** 통합 회원 구분 코드 */
    private String integrationMemberGbCd;

    /** 성인 인증 여부 */
    private String adultCertifyYn;

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadAddr;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String newPostNo;

    private Long mileage;
    private Long point;
    private Long memberGradeNo;
    private String memberGradeNm;
    private int couponCount;

    /** 최초 가입 여부 */
    private String firstJoinYn;
    
    /** 업체 로그인 여부 */
    private String sellerLoginYn;
    private String sellerNm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sellerId;
    private Long sellerNo;

    /** 가맹점 회원 회원 코드*/
    private String strCode;

    /** sns 로그인시 토큰 **/
    private String snsType;
    private String snsToken;

    /** erp 회원정보 **/
    private String cdCust;//erp 회원 번호

    @Override
    public LoginVO clone() throws CloneNotSupportedException {
        return (LoginVO) super.clone();
    }
    
    
}