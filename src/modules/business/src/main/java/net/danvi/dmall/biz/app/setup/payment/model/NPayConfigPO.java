package net.danvi.dmall.biz.app.setup.payment.model;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 5.
 * 작성자     : dong
 * 설명       : NPay 관리 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class NPayConfigPO extends BaseModel<NPayConfigPO> {
    // 네이버 공통 인증키
    private String naverCmnCertKey;
    // WHITE LIST
    private String whiteList;
    // 체크아웃 사용 여부
    private String checkoutUseYn;
    // 체크아웃 테스트 사용 여부
    private String checkoutTestUseYn;
    // 배송 업체 선택
    private String dlvrCompanySelect;
    // 착불 배송비
    @Length(min = 0, max = 20)
    private String recvpayDlvrc;
    // 미니샵 사용 여부
    private String mnshopUseYn;
    // 네이버 가맹점 ID
    @Length(min = 0, max = 50)
    private String naverFrcId;
    // 연동 인증키
    @Length(min = 0, max = 300)
    private String linkCertKey;
    // 이미지 인증키
    @Length(min = 0, max = 300)
    private String imgCertKey;
    // PC 버튼 선택
    private String pcBtnSelect;
    // 모바일 버튼 선택
    private String mobileBtnSelect;
    // 버튼 링크 대상
    private String btnLinkTarget;
    // 치환 코드
    @Length(min = 0, max = 300)
    private String replaceCd;
    // 재고 연동 사용 여부
    private String stockLinkUseYn;
    // 주문 통합 관리 사용 여부
    private String ordIntegrationManageUseYn;
}
