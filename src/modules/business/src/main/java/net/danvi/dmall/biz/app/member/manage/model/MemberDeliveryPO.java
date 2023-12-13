package net.danvi.dmall.biz.app.member.manage.model;

import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MemberDeliveryPO extends BaseModel<MemberDeliveryPO> implements Cloneable{
    // 회원번호
    private Long memberNo;
    // 회원배송지 번호
    @NotEmpty(groups = { UpdateGroup.class })
    private Long memberDeliveryNo;
    // 구분명
    private String gbNm;
    // 수취인명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    // 전화
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String tel;
    // 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    // 내선번호
    private String interphone;
    // 우편번호(구)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String oldPostNo;
    // 우편번호(신)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String newPostNo;
    // 번지 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String strtnbAddr;
    // 도로 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadAddr;
    // 상세주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    // 기본 여부
    private String defaultYn;
    // 거주지코드(국내:10,해외:20)
    private String memberGbCd;
    // country(해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCountry;
    // 우편번호(해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrZipCode;
    // state (해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrState;
    // city(해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCity;
    // 상세1(해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl1;
    // 상세2(해외주소)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl2;
    // 해외주소여부
    private String frgAddrYn;

    @Override
    public MemberDeliveryPO clone() throws CloneNotSupportedException {
        return (MemberDeliveryPO) super.clone();
    }

}
