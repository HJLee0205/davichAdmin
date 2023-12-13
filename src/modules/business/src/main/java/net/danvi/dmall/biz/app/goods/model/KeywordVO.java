package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import dmall.framework.common.model.EditorBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : keyword 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class KeywordVO extends BaseModel<KeywordVO> implements Serializable {
    private static final long serialVersionUID = 5837399304350026018L;

    /* keyword 리스트 조회(트리구조) start */
    // keyword 번호
    private String id;
    // 부모 keyword 번호
    private String parent;
    // keyword명
    private String text;
    /* keyword 리스트 조회(트리구조) end */

    // keyword레벨
    private String keywordLvl;
    // 상위keyword 번호
    private String upKeywordNo;
    // keyword번호
    private String keywordNo;
    // keyword명
    private String keywordNm;
    // keyword 설명
    private String keywordDscrt;
    // keyword 유형
    private String keywordMenuType;
    // keyword 이미지 사용 여부
    private String keywordImgUseYn;
    // keyword 이미지 경로
    private String keywordImgPath;
    // keyword 이미지명
    private String keywordImgNm;
    // keyword 명 이미지 가로 크기
    private String keywordNmImgWidth;
    // keyword 명 이미지 세로 크기
    private String keywordNmImgHeight;
    // keyword 메인 사용 여부
    private String keywordImgSizeType;
    // keyword type
    private String keywordType;
    // keyword slide typ min value
    private String keywordSlideMin;
    // keyword slide typ max value
    private String keywordSlideMax;
    // keyword child code
    private String keywordChildCd;

    // 삭제 여부
    private String delYn;
    // 사용 여부
    private String useYn;
    
    // 필터 적용 여부
    private String keywordApplyYn;
    // 필터 유형코드
    private String keywordTypeCd;
    //베스트브랜드 사용여부
    private String bestBrandUseYn;
    //베스트브랜드 번호
    private String bestBrandNo;
    
    //배너 keyword 조회용
    private String dtlNm;
    private String dtlCd;

    //keyword 최종레벨
    private String maxLvl;

    //keyword 상품 유형
    private String goodsTypeCd;
}
