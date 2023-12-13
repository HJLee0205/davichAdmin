package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 선택 아이콘 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsIconVO {
    // 상품 번호
    private String goodsNo;
    // 아이콘 번호
    private long iconNo;
    // 아이콘 유형 코드
    private String iconTypeCd;
    // 아이콘 이름
    private String iconDispnm;
    // 아이콘 이미지 경로
    private String imgPath;
    // 아이콘 이미지 이름
    private String imgNm;
    // 표시 우선 순위
    private String priorrank;
    // 아이콘 표시 URL
    private String iconPathNm;
    // 사용 여부
    private String useYn;
    // 저장 대상인지 여부 (DB취득의 경우 'U'값을 설정)
    private String registFlag;
    // 이미지 INFO
    private String imgFileInfo;
}
