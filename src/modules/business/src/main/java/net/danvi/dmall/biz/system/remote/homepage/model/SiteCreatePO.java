package net.danvi.dmall.biz.system.remote.homepage.model;

import dmall.framework.common.model.BaseModel;

import java.io.Serializable;
import java.util.Arrays;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 3.
 * 작성자     : dong
 * 설명       : 사이트(몰) 생성 요청 정보
 * </pre>
 */
public class SiteCreatePO extends BaseModel<SiteCreatePO> implements Serializable {
    private String siteStatusCd;
    private String siteId;
    private String dlgtDomain;
    private String tempDomain;
    private String svcStartDt;
    private String svcEndDt;

    // TS_SITE_DTL
    private String siteNm;
    private String siteTypeCd;
    private Integer goodsDefaultImgWidth;
    private Integer goodsDefaultImgHeight;
    private Integer goodsListImgWidth;
    private Integer goodsListImgHeight;
    private Integer goodsDispImgTypeAHeight;
    private Integer goodsDispImgTypeAWidth;
    private Integer goodsDispImgTypeBHeight;
    private Integer goodsDispImgTypeBWidth;
    private Integer goodsDispImgTypeCHeight;
    private Integer goodsDispImgTypeCWidth;
    private Integer goodsDispImgTypeDHeight;
    private Integer goodsDispImgTypeDWidth;
    private Integer goodsDispImgTypeEHeight;
    private Integer goodsDispImgTypeEWidth;

    /** 헤더 로고 */
    private String logoPath;
    /** 푸터 로고 */
    private String bottomLogoPath;

    /** 고객센터 - 전화번호 */
    private String custCtTelNo;
    /** 고객센터 - 상담시간 */
    private String custCtOperTime;
    /** 고객센터 - 점심시간 */
    private String custCtLunchTime;
    /** 고객센터 - 휴무정보 */
    private String custCtClosedInfo;

    /** 담당자 이메일 */
    private String email;

    /** SMS/대량메일 인증키 */
    private String certKey;

    /** 금칙어 */
    private String[] bannedWordArray;

    private String pwChgGuideYn;
    private String pwChgGuideCycle;
    private String pwChgNextChgDcnt;
    private String dormantMemberCancelMethod;


    public String getSiteStatusCd() {
        return siteStatusCd;
    }

    public void setSiteStatusCd(String siteStatusCd) {
        this.siteStatusCd = siteStatusCd;
    }

    public String getSiteId() {
        return siteId;
    }

    public void setSiteId(String siteId) {
        this.siteId = siteId;
    }

    public String getDlgtDomain() {
        return dlgtDomain;
    }

    public void setDlgtDomain(String dlgtDomain) {
        this.dlgtDomain = dlgtDomain;
    }

    public String getTempDomain() {
        return tempDomain;
    }

    public void setTempDomain(String tempDomain) {
        this.tempDomain = tempDomain;
    }

    public String getSvcStartDt() {
        return svcStartDt;
    }

    public void setSvcStartDt(String svcStartDt) {
        this.svcStartDt = svcStartDt;
    }

    public String getSvcEndDt() {
        return svcEndDt;
    }

    public void setSvcEndDt(String svcEndDt) {
        this.svcEndDt = svcEndDt;
    }

    public String getSiteNm() {
        return siteNm;
    }

    public void setSiteNm(String siteNm) {
        this.siteNm = siteNm;
    }

    public String getSiteTypeCd() {
        return siteTypeCd;
    }

    public void setSiteTypeCd(String siteTypeCd) {
        this.siteTypeCd = siteTypeCd;
    }

    public Integer getGoodsDefaultImgWidth() {
        return goodsDefaultImgWidth;
    }

    public void setGoodsDefaultImgWidth(Integer goodsDefaultImgWidth) {
        this.goodsDefaultImgWidth = goodsDefaultImgWidth;
    }

    public Integer getGoodsDefaultImgHeight() {
        return goodsDefaultImgHeight;
    }

    public void setGoodsDefaultImgHeight(Integer goodsDefaultImgHeight) {
        this.goodsDefaultImgHeight = goodsDefaultImgHeight;
    }

    public Integer getGoodsListImgWidth() {
        return goodsListImgWidth;
    }

    public void setGoodsListImgWidth(Integer goodsListImgWidth) {
        this.goodsListImgWidth = goodsListImgWidth;
    }

    public Integer getGoodsListImgHeight() {
        return goodsListImgHeight;
    }

    public void setGoodsListImgHeight(Integer goodsListImgHeight) {
        this.goodsListImgHeight = goodsListImgHeight;
    }

    public Integer getGoodsDispImgTypeAHeight() {
        return goodsDispImgTypeAHeight;
    }

    public void setGoodsDispImgTypeAHeight(Integer goodsDispImgTypeAHeight) {
        this.goodsDispImgTypeAHeight = goodsDispImgTypeAHeight;
    }

    public Integer getGoodsDispImgTypeAWidth() {
        return goodsDispImgTypeAWidth;
    }

    public void setGoodsDispImgTypeAWidth(Integer goodsDispImgTypeAWidth) {
        this.goodsDispImgTypeAWidth = goodsDispImgTypeAWidth;
    }

    public Integer getGoodsDispImgTypeBHeight() {
        return goodsDispImgTypeBHeight;
    }

    public void setGoodsDispImgTypeBHeight(Integer goodsDispImgTypeBHeight) {
        this.goodsDispImgTypeBHeight = goodsDispImgTypeBHeight;
    }

    public Integer getGoodsDispImgTypeBWidth() {
        return goodsDispImgTypeBWidth;
    }

    public void setGoodsDispImgTypeBWidth(Integer goodsDispImgTypeBWidth) {
        this.goodsDispImgTypeBWidth = goodsDispImgTypeBWidth;
    }

    public Integer getGoodsDispImgTypeCHeight() {
        return goodsDispImgTypeCHeight;
    }

    public void setGoodsDispImgTypeCHeight(Integer goodsDispImgTypeCHeight) {
        this.goodsDispImgTypeCHeight = goodsDispImgTypeCHeight;
    }

    public Integer getGoodsDispImgTypeCWidth() {
        return goodsDispImgTypeCWidth;
    }

    public void setGoodsDispImgTypeCWidth(Integer goodsDispImgTypeCWidth) {
        this.goodsDispImgTypeCWidth = goodsDispImgTypeCWidth;
    }

    public Integer getGoodsDispImgTypeDHeight() {
        return goodsDispImgTypeDHeight;
    }

    public void setGoodsDispImgTypeDHeight(Integer goodsDispImgTypeDHeight) {
        this.goodsDispImgTypeDHeight = goodsDispImgTypeDHeight;
    }

    public Integer getGoodsDispImgTypeDWidth() {
        return goodsDispImgTypeDWidth;
    }

    public void setGoodsDispImgTypeDWidth(Integer goodsDispImgTypeDWidth) {
        this.goodsDispImgTypeDWidth = goodsDispImgTypeDWidth;
    }

    public Integer getGoodsDispImgTypeEHeight() {
        return goodsDispImgTypeEHeight;
    }

    public void setGoodsDispImgTypeEHeight(Integer goodsDispImgTypeEHeight) {
        this.goodsDispImgTypeEHeight = goodsDispImgTypeEHeight;
    }

    public Integer getGoodsDispImgTypeEWidth() {
        return goodsDispImgTypeEWidth;
    }

    public void setGoodsDispImgTypeEWidth(Integer goodsDispImgTypeEWidth) {
        this.goodsDispImgTypeEWidth = goodsDispImgTypeEWidth;
    }

    public String getLogoPath() {
        return logoPath;
    }

    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }

    public String getBottomLogoPath() {
        return bottomLogoPath;
    }

    public void setBottomLogoPath(String bootomLogoPath) {
        this.bottomLogoPath = bootomLogoPath;
    }

    public String getCustCtTelNo() {
        return custCtTelNo;
    }

    public void setCustCtTelNo(String custCtTelNo) {
        this.custCtTelNo = custCtTelNo;
    }

    public String getCustCtOperTime() {
        return custCtOperTime;
    }

    public void setCustCtOperTime(String custCtOperTime) {
        this.custCtOperTime = custCtOperTime;
    }

    public String getCustCtLunchTime() {
        return custCtLunchTime;
    }

    public void setCustCtLunchTime(String custCtLunchTime) {
        this.custCtLunchTime = custCtLunchTime;
    }

    public String getCustCtClosedInfo() {
        return custCtClosedInfo;
    }

    public void setCustCtClosedInfo(String custCtClosedInfo) {
        this.custCtClosedInfo = custCtClosedInfo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCertKey() {
        return certKey;
    }

    public void setCertKey(String certKey) {
        this.certKey = certKey;
    }

    public String[] getBannedWordArray() {
        return bannedWordArray;
    }

    public void setBannedWordArray(String[] bannedWordArray) {
        this.bannedWordArray = bannedWordArray;
    }

    public String getPwChgGuideYn() {
        return pwChgGuideYn;
    }

    public void setPwChgGuideYn(String pwChgGuideYn) {
        this.pwChgGuideYn = pwChgGuideYn;
    }

    public String getPwChgGuideCycle() {
        return pwChgGuideCycle;
    }

    public void setPwChgGuideCycle(String pwChgGuideCycle) {
        this.pwChgGuideCycle = pwChgGuideCycle;
    }

    public String getPwChgNextChgDcnt() {
        return pwChgNextChgDcnt;
    }

    public void setPwChgNextChgDcnt(String pwChgNextChgDcnt) {
        this.pwChgNextChgDcnt = pwChgNextChgDcnt;
    }

    public String getDormantMemberCancelMethod() {
        return dormantMemberCancelMethod;
    }

    public void setDormantMemberCancelMethod(String dormantMemberCancelMethod) {
        this.dormantMemberCancelMethod = dormantMemberCancelMethod;
    }

    @Override
    public String toString() {
        return "SiteCreatePO{" +
                "siteStatusCd='" + siteStatusCd + '\'' +
                ", siteId='" + siteId + '\'' +
                ", dlgtDomain='" + dlgtDomain + '\'' +
                ", tempDomain='" + tempDomain + '\'' +
                ", svcStartDt='" + svcStartDt + '\'' +
                ", svcEndDt='" + svcEndDt + '\'' +
                ", siteNm='" + siteNm + '\'' +
                ", siteTypeCd='" + siteTypeCd + '\'' +
                ", goodsDefaultImgWidth=" + goodsDefaultImgWidth +
                ", goodsDefaultImgHeight=" + goodsDefaultImgHeight +
                ", goodsListImgWidth=" + goodsListImgWidth +
                ", goodsListImgHeight=" + goodsListImgHeight +
                ", goodsDispImgTypeAHeight=" + goodsDispImgTypeAHeight +
                ", goodsDispImgTypeAWidth=" + goodsDispImgTypeAWidth +
                ", goodsDispImgTypeBHeight=" + goodsDispImgTypeBHeight +
                ", goodsDispImgTypeBWidth=" + goodsDispImgTypeBWidth +
                ", goodsDispImgTypeCHeight=" + goodsDispImgTypeCHeight +
                ", goodsDispImgTypeCWidth=" + goodsDispImgTypeCWidth +
                ", goodsDispImgTypeDHeight=" + goodsDispImgTypeDHeight +
                ", goodsDispImgTypeDWidth=" + goodsDispImgTypeDWidth +
                ", goodsDispImgTypeEHeight=" + goodsDispImgTypeEHeight +
                ", goodsDispImgTypeEWidth=" + goodsDispImgTypeEWidth +
                ", logoPath='" + logoPath + '\'' +
                ", bottomLogoPath='" + bottomLogoPath + '\'' +
                ", custCtTelNo='" + custCtTelNo + '\'' +
                ", custCtOperTime='" + custCtOperTime + '\'' +
                ", custCtLunchTime='" + custCtLunchTime + '\'' +
                ", custCtClosedInfo='" + custCtClosedInfo + '\'' +
                ", email='" + email + '\'' +
                ", certKey='" + certKey + '\'' +
                ", bannedWordArray=" + Arrays.toString(bannedWordArray) +
                ", pwChgGuideYn='" + pwChgGuideYn + '\'' +
                ", pwChgGuideCycle='" + pwChgGuideCycle + '\'' +
                ", pwChgNextChgDcnt='" + pwChgNextChgDcnt + '\'' +
                ", dormantMemberCancelMethod='" + dormantMemberCancelMethod + '\'' +
                "} " + super.toString();
    }
}
