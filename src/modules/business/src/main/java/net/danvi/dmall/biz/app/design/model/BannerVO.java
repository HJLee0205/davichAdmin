package net.danvi.dmall.biz.app.design.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 07. 04.
 * 작성자     : dong
 * 설명       : 배너관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class BannerVO extends BaseModel<BannerVO> {
    // private String siteNo;
    private int rowNum;
    private String bannerNo; // 배너 번호
    private String skinNo; // 스킨번호
    private String skinNm; // 스킨 명
    // private String siteNo;
    private String pcGbCd; // 피씨 구분 코드
    private String bannerMenuCd; // 배너 메뉴코드
    private String bannerAreaCd; // 배너 영역 코드
    private String goodsTypeCd; // 상품 유형
    private String bannerMenuNm; // 배너 메뉴 명
    private String bannerAreaNm; // 배너 영역 명
    private String bannerNm; // 배너명
    private String bannerDscrt; // 배너 설명
    private String dispStartDttm; // 전시 시작일시
    private String dispEndDttm; // 전시 종료일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date dispStartDttmView; // 전시 시작일시 화면에 보여줄 포맷
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date dispEndDttmView; // 전시 종료일시 화면에 보여줄 포맷
    private String linkUrl; // 링크 url
    private String dispLinkCd; // 전시 링크 코드
    private String filePath; // 파일경로
    private String orgFileNm; // 원본 파일명
    private String fileNm; // 파일명
    private String fileSize; // 모바일 파일 사이즈
    private String filePathM; // 모바일 파일경로
    private String orgFileNmM; // 모바일 원본 파일명
    private String fileNmM; // 모바일 파일명
    private String fileSizeM; // 파일 사이즈
    private String imgFileInfo; // 이미지 파일정보
    private String imgFileInfoM; // 모바일 이미지 파일정보
    private String sortSeq; // 정렬순서
    private String dispYn; // 전시 여부
    private String dispYnNm; // 전시 여부명
    private String applyAlwaysYn; // 무제한 적용 여부

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm; // 등록일 포맷
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date updDttm; // 수정일 포맷

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm; // 등록자

    private List<SkinVO> skinList; // 스킨리스트정보
    
    private String topBannerColorValue; //최상단배너 컬러값

}
