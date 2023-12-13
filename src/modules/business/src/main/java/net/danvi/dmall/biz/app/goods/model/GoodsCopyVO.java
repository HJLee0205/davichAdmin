package net.danvi.dmall.biz.app.goods.model;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 28.
 * 작성자     : dong
 * 설명       : 상품 복사 정보 Value Object
 * </pre>
 */
@Data
public class GoodsCopyVO implements Serializable {

    private static final long serialVersionUID = 8073939677216308663L;
    // 사이트 번호
    private Long siteNo;
    // 대상 상품 번호
    private String targetGoodsNo;
    // 신규 상품 번호
    private String newGoodsNo;
    // 신규 상품 명
    private String newGoodsNm;
    // 등록자 번호
    private Long regrNo;
    // 수정자 번호
    private Long updrNo;

 // 전시 이미지 경로 Type A
    private String dispImgPathTypeA;
    // 전시 이미지 명 Type A
    private String dispImgNmTypeA;
    // 전시 이미지 임시 파일 경로 Type A
    private String dispTempFileNameTypeA;
    // 전시 이미지 사이즈 Type A
    private String dispImgFileSizeTypeA;
    // 전시 이미지 경로 Type B
    private String dispImgPathTypeB;
    // 전시 이미지 명 Type B
    private String dispImgNmTypeB;
    // 전시 이미지 임시 파일 경로 Type B
    private String dispTempFileNameTypeB;
    // 전시 이미지 사이즈 Type B
    private String dispImgFileSizeTypeB;
    // 전시 이미지 경로 Type C
    private String dispImgPathTypeC;
    // 전시 이미지 명 Type C
    private String dispImgNmTypeC;
    // 전시 이미지 임시 파일 경로 Type C
    private String dispTempFileNameTypeC;
    // 전시 이미지 사이즈 Type C
    private String dispImgFileSizeTypeC;
    // 전시 이미지 경로 Type D
    private String dispImgPathTypeD;
    // 전시 이미지 명 Type D
    private String dispImgNmTypeD;
    // 전시 이미지 임시 파일 경로 Type D
    private String dispTempFileNameTypeD;
    // 전시 이미지 사이즈 Type D
    private String dispImgFileSizeTypeD;
    // 전시 이미지 경로 Type E
    private String dispImgPathTypeE;
    // 전시 이미지 명 Type E
    private String dispImgNmTypeE;
    // 전시 이미지 임시 파일 경로 Type E
    private String dispTempFileNameTypeE;
    // 전시 이미지 사이즈 Type E
    private String dispImgFileSizeTypeE;

    // 전시 이미지 경로 Type F
    private String dispImgPathTypeF;
    // 전시 이미지 명 Type F
    private String dispImgNmTypeF;
    // 전시 이미지 임시 파일 경로 Type F
    private String dispTempFileNameTypeF;
    // 전시 이미지 사이즈 Type F
    private String dispImgFileSizeTypeF;

    // 전시 이미지 경로 Type G
    private String dispImgPathTypeG;
    // 전시 이미지 명 Type G
    private String dispImgNmTypeG;
    // 전시 이미지 임시 파일 경로 Type G
    private String dispTempFileNameTypeG;
    // 전시 이미지 사이즈 Type G
    private String dispImgFileSizeTypeG;

    // 전시 이미지 경로 Type S
    private String dispImgPathTypeS;
    // 전시 이미지 명 Type S
    private String dispImgNmTypeS;
    // 전시 이미지 임시 파일 경로 Type S
    private String dispTempFileNameTypeS;
    // 전시 이미지 사이즈 Type S
    private String dispImgFileSizeTypeS;

    // 전시 이미지 경로 Type M
    private String dispImgPathTypeM;
    // 전시 이미지 명 Type M
    private String dispImgNmTypeM;
    // 전시 이미지 임시 파일 경로 Type M
    private String dispTempFileNameTypeM;
    // 전시 이미지 사이즈 Type M
    private String dispImgFileSizeTypeM;
    
    // 전시 이미지 경로 Type O
    private String dispImgPathTypeO;
    // 전시 이미지 명 Type O
    private String dispImgNmTypeO;
    // 전시 이미지 임시 파일 경로 Type O
    private String dispTempFileNameTypeO;
    // 전시 이미지 사이즈 Type O
    private String dispImgFileSizeTypeO;
    
    // 전시 이미지 경로 Type P
    private String dispImgPathTypeP;
    // 전시 이미지 명 Type P
    private String dispImgNmTypeP;
    // 전시 이미지 임시 파일 경로 Type P
    private String dispTempFileNameTypeP;
    // 전시 이미지 사이즈 Type P
    private String dispImgFileSizeTypeP;
    
}
