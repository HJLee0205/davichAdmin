package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.EditorBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : filter 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FilterVO extends EditorBaseVO<FilterVO> implements Serializable {
    private static final long serialVersionUID = -9094312352377171961L;

    /* filter 리스트 조회(트리구조) start */
    // filter 번호
    private String id;
    // 부모 filter 번호
    private String parent;
    // filter명
    private String text;
    /* filter 리스트 조회(트리구조) end */

    // filter레벨
    private String filterLvl;
    // 상위filter 번호
    private String upFilterNo;
    // filter번호
    private String filterNo;
    // filter명
    private String filterNm;
    // filter 설명
    private String filterDscrt;
    // filter 메뉴 타입
    private String filterMenuType;
    // filter 하위 메뉴 타입
    private String filterType;
    // filter 이미지 사용 여부
    private String filterImgUseYn;
    // filter 이미지 경로
    private String filterImgPath;
    // filter 이미지명
    private String filterImgNm;
    // filter 명 이미지 가로 크기
    private String filterNmImgWidth;
    // filter 명 이미지 세로 크기
    private String filterNmImgHeight;
    // filter 메인 사용 여부
    private String filterImgSizeType;
    // filter type
    private String filterDispType;
    // filter slide typ min value
    private String filterSlideMin;
    // filter slide typ max value
    private String filterSlideMax;
    // filter child code
    private String filterChildCd;

    // 삭제 여부
    private String delYn;
    // 사용 여부
    private String useYn;
    
    // 필터 적용 여부
    private String filterApplyYn;
    // 필터 유형코드
    private String filterTypeCd;
    //베스트브랜드 사용여부
    private String bestBrandUseYn;
    //베스트브랜드 번호
    private String bestBrandNo;
    
    //배너 filter 조회용
    private String dtlNm;
    private String dtlCd;

    //filter 최종레벨
    private String maxLvl;
    //filter 상품유형
    private String goodsTypeCd;

    //filter 선택
    private String selectedFilterNo;
    //M: Mandatory, O: Optional
    private String filterRequire;
    // 상위filter disp type
    private String upFilterDispType;
    // 상위filter 페이지 상단 표시 여부
    private String upFilterMainDispYn;
}
