package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 29.
 * 작성자     : kjw
 * 설명       : 카테고리 전시존 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CategoryDisplayManageVO extends EditorBaseVO<CategoryDisplayManageVO> {
    // 카테고리 전시 ZONE 번호
    private String ctgDispzoneNo;
    // 카테고리 번호
    private String ctgNo;
    // 카테고리 전시존 명
    private String dispzoneNm;
    // 카테고리 전시존 사용 여부
    private String useYn;
    // 카테고리 전시존 전시 코드
    private String ctgDispDispTypeCd;
    // 카테고리 전시존 진열 유형 코드
    private String ctgExhbtionTypeCd;
    // 카테고리 전시존 이미지 경로
    private String ctgDispzoneImgPath;
    // 카테고리 전시존 이미지 명
    private String ctgDispzoneImgNm;
    // 카테고리 전시존 이미지 너비
    private String ctgDispzoneImgWidth;
    // 카테고리 전시존 이미지 높이
    private String ctgDispzoneImgHeight;

    // 카테고리 네비게이션
    private String categoryNavigation;
}
