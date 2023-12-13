package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 선택 아이콘 정보 설정 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsIconPO extends BaseModel<GoodsIconPO> {
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
    // 사용 여부
    private String useYn;
    // 파일 확장자
    private String fileExtension;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
}
