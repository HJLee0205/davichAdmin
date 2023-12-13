package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.EditorBasePO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : keyword 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class KeywordPO extends EditorBasePO<KeywordPO> {
    // keyword 번호
    @NotNull(groups = { DeleteGroup.class, UpdateGroup.class })
    private String KeywordNo;
    // keyword명
    private String keywordNm;
    // keyword 설명
    private String keywordDscrt;
    // keyword 이미지 사용 여부
    private String keywordImgUseYn;
    // keyword 이미지 경로
    private String keywordImgPath;
    // keyword 이미지명
    private String keywordImgNm;
    // 디폴트 이미지 경로
    private String dftFilePath;
    // 디폴트 이미지명
    private String dftFileName;
    // keyword 메뉴 타입
    private String keywordMenuType;
    // 등록 카테고리명
    private String[] insKeywordNm;
    // 카테고리 레벨
    private String keywordLvl;
    // 상위 카테고리 번호
    private String upKeywordNo;
    // keyword 정렬순번
    private String sortSeq;
    // 기존 카테고리 레벨
    private String orgKeywordLvl;
    // 하위 카테고리 번호
    private String downKeywordNo;
    // 변경 레벨값 계산
    private int calcLvl;

    // 하위 카테고리 번호 목록
    private List<Integer> childKeywordNoList;
    // 전시존 번호 목록
    private List<String> dispNoList;

    // keyword 일련 번호
    private long keywordSerialNo;
    // 서브 페이지 카테고리 내비게이션 노출 여부
    private String navigExpsYn;

    // 디폴트 이미지 삭제여부
    private String dftDelYn;
    // 마우스오버 이미지 삭제여부
    private String moverDelYn;
    // 사용 여부
    private String useYn;
    // 메인 노출 여부
    private String mainExpsYn;
    // 메인 노출 순번
    private int mainExpsSeq;

    // 하위 keyword 동일 적용 여부
    private String subKeywordCmsRateApplyYn;

    // 필터 type
    private String keywordType;
    // slide 필터 min value
    private String keywordSlideMin;
    // slide 필터 max value
    private String keywordSlideMax;
    // keyword child code
    private String keywordChildCd;
    // 상품 번호
    private String goodsNo;
    // 상품 번호 목록
    private String[] insKeywordGoodsNoList;
    // 상품 유형
    private String goodsTypeCd;
}
