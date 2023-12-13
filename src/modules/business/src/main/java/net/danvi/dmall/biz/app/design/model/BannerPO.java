package net.danvi.dmall.biz.app.design.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

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
public class BannerPO extends BaseModel<BannerPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long bannerNo; // 배너 번호
    private Long skinNo; // 스킨 번호
    // private String siteNo;
    private String pcGbCd; // PC 구분 코드
    private String bannerMenuCd; // 배너 메뉴코드
    private String bannerAreaCd; // 배너 영역 코드
    private String bannerNm; // 배너명
    private String bannerDscrt; // 배너 설명
    private String dispStartDttm; // 전시 시작일시
    private String dispEndDttm; // 전시 종료일시
    private String linkUrl; // 링크 url
    private String dispLinkCd; // 전시 링크 코드
    private String filePath; // 파일 경로
    private String orgFileNm; // 원본 파일명
    private String fileNm; // 파일명
    private Long fileSize; // 파일 사이즈
    private String filePathM; // 모바일 파일 경로
    private String orgFileNmM; // 모바일 원본 파일명
    private String fileNmM; // 모바일 파일명
    private Long fileSizeM; // 모바일 파일 사이즈
    private Long sortSeq; // 정렬순서
    private String dispYn; // 전시 여부
    private String topBannerColorValue; //최상단배너 컬러값
    private String goodsTypeCd; // 베너 유형
    private String applyAlwaysYn; // 무제한 적용 여부
    private String[] goodsList; // 상품 리스트
    // 이전 정렬 순서
    private Long orgSortSeq;
    // 이전 베너 번호
    private Long orgBannerNo;
}
