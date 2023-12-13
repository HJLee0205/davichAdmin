package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : 김길승
 * 설명       : 브랜드 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class BrandPO extends EditorBasePO<BrandPO> {
    // 카테고리 번호
    @NotNull(groups = { DeleteGroup.class, UpdateGroup.class })
    private Long brandNo; // 브랜드번호
    private String brandNm; // 브랜드명
    private String newBrandNm; // 새 브랜드 명
    private String brandExhbtionTypeCd; // 브랜드 진열 유형 코드
    private String dispYn; // 전시여부
    // private String brandDispTypeCd;
    private String brandImgPath; // 브랜드 이미지 경로
    private String brandImgNm; // 브랜드 이미지 명
    private String mouseoverImgPath; // 마우스 오버 이미지 경로
    private String mouseoverImgNm; // 마우스오버 이미지 명

    private String listImgPath;// 목록 이미지 경로
    private String listImgNm; // 목록 이미지 명
    private String dtlImgPath;// 상세 이미지 경로
    private String dtlImgNm; // 상세 이미지 명
    private String logoImgPath;// 로고 이미지 경로
    private String logoImgNm; // 로고 이미지 명

    // private String totalConnectAuthYn;
    // private String memberConnectAuthYn;
    // 디폴트 이미지 경로 / 명
    private String dftFilePath; // 기본파일경로
    private String dftFileName; // 기본파일명

    // 마우스오버 이미지 경로 / 명
    private String moverFilePath; // 마우스오버 이미지경로
    private String moverFileName; // 마우스오버 이미지 경로

    // 브랜드 목록 이미지 경로 / 명
    private String listFilePath; // 브랜드 목록 이미지경로
    private String listFileName; // 브랜드 목록 이미지 경로

    // 브랜드 상세 이미지 경로 / 명
    private String dtlFilePath; // 브랜드 상세 이미지경로
    private String dtlFileName; // 브랜드 상세 이미지 경로

    // 브랜드 로고 이미지 경로 / 명
    private String logoFilePath; // 브랜드 로고 이미지경로
    private String logoFileName; // 브랜드 로고 이미지 경로


    private String mainDispYn; // 메인 전시 여부

    private String goodsTypeCd; //상품유형
    private String brandEnnm; //브랜드 영문명
}
