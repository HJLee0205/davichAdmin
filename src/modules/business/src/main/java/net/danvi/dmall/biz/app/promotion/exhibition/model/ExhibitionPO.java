package net.danvi.dmall.biz.app.promotion.exhibition.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ExhibitionPO extends EditorBasePO<ExhibitionPO> {
    private int prmtNo;
    private int newPrmtNo;
    private int applySeq;
    private String prmtNm;
    private String prmtDscrt;
    private String applyStartDttm;
    private String applyEndDttm;
    private String prmtContentHtml;
    private String prmtWebBannerImgPath; // 경로
    private String prmtWebBannerImg; // 파일명
    private String prmtWebBannerImgOrg; // 파일명(수정 전)
    private String prmtMobileBannerImgPath;
    private String prmtMobileBannerImg;
    private String prmtMobileBannerImgOrg;
    private String prmtTargetExptCd; // 기획전대상예외 코드 01.전체 02.적용대상
    private String goodsNo; // 상품 번호
    private String[] goodsNoArr;
    private String prmtTypeCd;	//프로모션 유형
    private String prmtDcGbCd;	//프로모션 할인 구분 코드
    private int prmtDcValue; // 할인률

    private String from; // 시작 일
    private String fromHour; // 시작 시
    private String fromMinute; // 시작 분
    private String to; // 종료 일
    private String toHoure; // 종료 시
    private String toMinute; // 종료 분;
    
    private List<ExhibitionPO> dispzoneList;
    private List<String> goodsNoList;
    
    private String dispzoneNo;
    private String dispzoneNm;
    private String useYn;
    private String delDispzoneNo;
    
    private int prmtDispzoneNo;
    private int prmtLoadrate; //본사부담율
    private String prmtGoodsGbCd; //기획전 상품 설정 유형
    private String prmtBrandNo; // 기획전 상품 브랜드 번호
    
    private String prmtMainExpsUseYn; //메인노출 사용여부
    private String prmtMainExpsPst; //메인노출 위치
    private int prmtMainExpsSeq; //메인노출 순서
    private int firstBuySpcPrice; // 첫구매가격

    private String seoSearchWord; //SEO 검색용 태그
    private String ageCd;	//연령대
    private String goodsTypeCd;	//상품군

    private String dlgtImgPath; //대표이미지 경로
    private String dlgtImgNm;   //대표이미지 이름
    private String dlgtImgOrgNm;//대표이미지 원본 이름
}
