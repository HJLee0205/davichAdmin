package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MemberSvmnVO extends BaseModel<MemberSvmnVO> {
    public String periodGb;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public int rank;
    public String memberId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    public String memberNm;
    public String pvdSvmnCnt;
    public String pvdSvmn;
    public String useSvmnCnt;
    public String useSvmn;
    public String cancelSvmnCnt;
    public String cancelSvmn;
    public String remainSvmn;
    public String totPvdSvmnCnt;
    public String totPvdSvmn;
    public String totUseSvmnCnt;
    public String totUseSvmn;
    public String totCancelSvmnCnt;
    public String totCancelSvmn;
    public String totRemainSvmn;
}
