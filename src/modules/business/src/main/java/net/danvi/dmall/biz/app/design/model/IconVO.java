package net.danvi.dmall.biz.app.design.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 아이콘관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class IconVO extends BaseModel<IconVO> {
    // private String siteNo;
    private int rownum;
    private String iconNo; // 아이콘 번호
    // private String siteNo;
    private String goodsTypeCd; // 상품 유형
    private String[] goodsTypeCdArr; // 상품 유형
    private String iconDispnm; // 아이콘 명
    private String imgPath; // 이미지경로
    private String orgImgNm; // 원본 이미지명
    private String imgNm; // 이미지명
    private String imgSize; // 이미지 사이즈
    private String icnImgInfo;// 아이콘 이미지 정보

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm; // 등록일 포맷
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date updDttm; // 수정일 포맷

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm; // 등록자

}
