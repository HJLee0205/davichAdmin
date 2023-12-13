package net.danvi.dmall.biz.app.promotion.exhibition.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ExhibitionVO extends EditorBaseVO<ExhibitionVO> {
    // 단건조회
    private int prmtNo;
    private String prmtNm;
    private String prmtDscrt;
    private String applyStartDttm;
    private String applyEndDttm;
    private String prmtContentHtml; // 기획전 내용
    private String prmtWebBannerImgPath; // 웹배너 경로
    private String prmtWebBannerImg; // 웹배너 이미지
    private String prmtMobileBannerImgPath; // 모바일배너 경로
    private String prmtMobileBannerImg; // 모바일배너 이미지
    private int prmtDcValue; // 할인률
    private int applySeq; // 적용 순서
    private String prmtTargetExptCd; // 기획전대상예외 코드 1.전체 02.적용대상
    private String useYn; // 사용여부
    private String prmtTypeCd;	//프로모션 유형
    private String prmtDcGbCd;	//프로모션 할인 구분 코드

    // 목록조회
    private String rownum;
    private String pagingNum;
    private String sortNum;
    private String[] prmtStatusCds; // 기획전 상태코드
    private String prmtStatusNm; // 기획전 상태명

    // 기획전대상
    private List<ExhibitionTargetVO> goodsList;
    
    // 전시존
    private List<ExhibitionDispzoneVO> dispzoneList;

    private String goodsNo; // 대상이 전체상품일 경우, 필요
    
    //기획전 전시존 번호
    private String prmtDispzoneNo;
    // 기획전 전시존 이름
    private String dispzoneNm;
    //전시유형
    private String prmtDispDispTypeCd;
    //본사부담율
    private int prmtLoadrate;
    
    private String prmtGoodsGbCd; //기획전 상품 설정 유형
    private String prmtBrandNo; // 기획전 상품 브랜드 번호
    private String brandNm; // 기획전 상품 브랜드명
    
    private String prmtMainExpsUseYn; //메인노출 사용여부
    private String prmtMainExpsPst; //메인노출 위치
    private int prmtMainExpsSeq; //메인노출 순서
    
    //추가
    private String regDate;
    private String detailLink;

    private int firstBuySpcPrice; // 첫구매가격
    private String seoSearchWord; //SEO 검색용 태그
    private String ageCd;	//연령대
    private String ageCdNm;
    private String goodsTypeCd; // 상품군

    private String dlgtImg;
    private String dlgtImgOrgNm;
}
