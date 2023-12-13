package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
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
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CtgImgPO extends BaseModel<CtgImgPO> {
    // 배너 이미지 번호
    private String ctgImgNo;
    // 카테고리 번호
    private String ctgNo;
    // pc: 01 / mobile: 02
    private String deviceType;
    // 등록순서
    private String sortSeq;
    // 이미지경로
    private String imgPath;
    // 이미지명
    private String imgNm;
    // 원본 이미지명
    private String orgImgNm;

    // 존재하는 이미지명
    private String[] existImgNm;
}
