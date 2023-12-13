package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 택배사 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CourierVO extends BaseModel<CourierVO> {

    // 택배사 코드
    private String courierCd;
    // 택배사 명
    private String courierNm;
    // 사용 여부
    private String useYn;
    // 배송비
    private String dlvrc;

    // 업체명
    private String companyNm;
    // 대표자명
    private String ceoNm;
    // 이메일
    private String email;
    // 우편번호
    private String postNo;
    // 주소지번
    private String addrNum;
    // 주소 도로명
    private String addrRoadnm;
    // 주소 공통 상세
    private String addrCmnDtl;
    // 전화번호
    private String telNo;
    // 사업자번호
    private String bizNo;

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

    private int rownum;
    private String rowNum;
    private String viewUseYn;

}
