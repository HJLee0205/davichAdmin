package net.danvi.dmall.biz.app.member.manage.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MemberFacePO extends BaseModel<MemberFacePO> implements Cloneable{
    /* 회원얼굴정보 리스트 조회(트리구조) start */
    // 회원얼굴정보 번호
    private String id;
    // 부모 회원얼굴정보 번호
    private String parent;
    // 회원얼굴정보명
    private String text;
    /* 회원얼굴정보 리스트 조회(트리구조) end */

    // 회원번호
    private Long memberNo;
    // 회원배송지 번호
    // face레벨
    private String faceLvl;
    // 상위face 번호
    private String upFaceNo;
    // face번호
    private String faceNo;
    // face명
    private String faceNm;
    // face 적용 상품쿤 유형
    private String goodsTypeCd;
    // face 유형
    private String faceMenuType;
    // face 이미지 사용 여부
    private String faceImgUseYn;
    // face 이미지 경로
    private String faceImgPath;
    // face 이미지명
    private String faceImgNm;

    @Override
    public MemberFacePO clone() throws CloneNotSupportedException {
        return (MemberFacePO) super.clone();
    }

}
