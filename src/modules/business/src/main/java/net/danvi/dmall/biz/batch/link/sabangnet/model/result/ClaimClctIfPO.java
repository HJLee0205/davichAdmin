package net.danvi.dmall.biz.batch.link.sabangnet.model.result;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 클레임수집 연계 PO
 * </pre>
 */
@Data
// @EqualsAndHashCode
public class ClaimClctIfPO extends BaseModel<ClaimClctIfPO> {

    private String spmallOrdNo; // 쇼핑몰 주문 번호
    private String ifSno; // 연계 일련번호
    private String ifId; // 연계 ID
    private String ifNo; // 연계 번호
    private Long siteNo; // 사이트 번호
    private String claimNo; // 클레임 번호
    private String claimDtlSeq; // 클레임 상세 순번
    private String sbnClaimNo; // 사방넷 클레임 번호
    private String ordNo; // 주문 번호
    private String orgOrdNo; // 원본 주문 번호
    private String ordDtlSeq; // 주문 상세 순번
    private String sbnOrdNo; // 사방넷 주문 번호
    private String spmallId; // 쇼핑몰 ID
    private String spmallLoginId; // 쇼핑몰 로그인 ID
    private String ordDlvrStatus; // 주문 배송 상태
    private String ordrNm; // 주문자 명
    private String ordrTel; // 주문자 전화
    private String ordrMobile; // 주문자 휴대폰
    private String ordrEmail; // 주문자 이메일
    private String adrsTel; // 수취인 전화
    private String adrsMobile; // 수취인 휴대폰
    private String dlvrMsg; // 배송 메세지
    private String adrsNm; // 수취인 명
    private String postNo; // 우편 번호
    private String dtlAddr; // 상세 주소
    private String saleAmt; // 판매 금액
    private String paymentAmt; // 결제 금액
    private String ordAcceptDttm; // 주문 접수 일시
    private String goodsNm; // 상품 명
    private String optNm; // 옵션 명
    private String salePrice; // 판매 단가
    private String ordQtt; // 주문 수량
    private String goodsNo; // 상품 번호
    private String itemNo; // 단품 번호
    private String attrVer; // 속성 VER
    private String claimType; // 클레임 유형
    private String claimMemo; // 클레임 메모
    private String claimAcceptDttm; // 클레임 접수 일시
    private String claimClctDttm; // 클레임 수집 일시
    private String sbnIfYn; // 사방넷 연계 여부
    private String sbnIfMsg; // 사방넷 연계 메세지
    private String btchPrcYn; // 배치 처리 여부
    private Long regrNo; // 등록자 번호
    private Long updrNo; // 수정자 번호

    private String localOrdDtlStatusCd; // 로컬주문상세상태코드
    private int localOrdDtlCnt; // 로컬주문상세 갯수
    private int claimClctCnt; // 클레임수집 갯수
    private int localClaimDtlCnt; // 로컬클레임상세 갯수
    private int claimRemainCnt; // 클레임 잔여 갯수
}
