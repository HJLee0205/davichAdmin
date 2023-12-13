package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 29.
 * 작성자     : kjw
 * 설명       : 카테고리 전시존 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CategoryDisplayManagePO extends EditorBasePO<CategoryDisplayManagePO> {

    // 카테고리 번호
    private String ctgNo;
    // 카테고리 전시존 번호
    @NotNull(groups = { UpdateGroup.class })
    private String ctgDispzoneNoArr;
    private String ctgDispzoneNo;
    // 카테고리 전시존 명
    private String dispzoneNmArr;
    private String dispzoneNm;
    // 카테고리 전시존 사용 여부
    private String[] useYnArray;
    private String useYn;
    // 카테고리 전시존 전시 유형 코드
    private String ctgDispDispTypeCd;
    private String ctgDispDispTypeCd1;
    // 카테고리 전시존 전시 유형 코드
    private String ctgDispDispTypeCd2;
    // 카테고리 전시존 전시 유형 코드
    private String ctgDispDispTypeCd3;
    // 카테고리 전시존 전시 유형 코드
    private String ctgDispDispTypeCd4;
    // 카테고리 전시존 전시 유형 코드
    private String ctgDispDispTypeCd5;
    // 카테고리 전시존 상품 번호
    private String dispZoneGoods;
    // 카테고리 전시존 상품 번호
    private String[] dispZoneGoods1;
    // 카테고리 전시존 상품 번호
    private String[] dispZoneGoods2;
    // 카테고리 전시존 상품 번호
    private String[] dispZoneGoods3;
    // 카테고리 전시존 상품 번호
    private String[] dispZoneGoods4;
    // 카테고리 전시존 상품 번호
    private String[] dispZoneGoods5;
    // 카테고리 전시존 진열 유형 코드1
    private String ctgExhbtionTypeCd1;
    // 카테고리 전시존 진열 유형 코드2
    private String ctgExhbtionTypeCd2;
    // 카테고리 전시존 진열 유형 코드3
    private String ctgExhbtionTypeCd3;
    // 카테고리 전시존 진열 유형 코드4
    private String ctgExhbtionTypeCd4;
    // 카테고리 전시존 진열 유형 코드5
    private String ctgExhbtionTypeCd5;

    // 카테고리 전시존 꾸미기 이미지 파일 경로1
    private String dispzoneFilePath1;
    // 카테고리 전시존 꾸미기 이미지 파일 경로2
    private String dispzoneFilePath2;
    // 카테고리 전시존 꾸미기 이미지 파일명1
    private String dispzoneFileName1;
    // 카테고리 전시존 꾸미기 이미지 파일명2
    private String dispzoneFileName2;
    // 카테고리 전시존 꾸미기 이미지 경로
    private String ctgDispzoneImgPath;
    // 카테고리 전시존 꾸미기 이미지 명
    private String ctgDispzoneImgNm;
    // 카테고리 전시존 진열 유형 코드
    private String ctgExhbtionTypeCd;

    // 카테고리 전시존1 이미지 파일 삭제 여부
    private String dispZoneDelYn1;
    // 카테고리 전시존2 이미지 파일 삭제 여부
    private String dispZoneDelYn2;

    // 주력제품
    private String ctgDispDispTypeCd6;
    private String ctgExhbtionTypeCd6;
    private String[] dispZoneGoods6;

    //카테고리 전시존 정렬순서
    private int sortSeq;
}
