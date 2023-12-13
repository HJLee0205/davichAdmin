package net.danvi.dmall.biz.app.setup.delivery.model;

import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CourierPO extends BaseModel<CourierPO> {

    // 택배사 코드
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class, DeleteGroup.class })
    private String courierCd;
    // 변경할 택배사 코드
    private String chgCourierCd;
    // 택배사 명
    private String courierNm;
    // 사용 여부
    private String useYn;
    // 배송비
    private String dlvrc;
    // 연동 사용 여부
    private String linkUseYn;
    // 연동 신청 상태 (00.연동신청, 01.연동완료, 99.연동에러)
    private String linkApplyStatus;
    // 연동 ID
    private String linkID;
    // 연동 비밀번호
    private String linkPw;
    // 연동 상점 ID
    private String linkStoreID;
    // 연동 고객번호
    private String linkCustno;
    // 연동 계약 지점 명
    private String linkContrtPtNm;
    // 개인정보 수집 동의 여부
    private String privacyClctApplyYn;
    // 개인정보 사용 동의 여부
    private String privacyUseApplyYn;

}
