package net.danvi.dmall.biz.batch.link.sabangnet.model.result;

import dmall.framework.common.model.BaseModel;
import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 문의사항수집 연계 PO
 * </pre>
 */
@Data
// @EqualsAndHashCode
public class InquiryClctIfPO extends BaseModel<InquiryClctIfPO> {

    private String ifSno; // 연계 일련번호
    private String ifId; // 연계 ID
    private String ifNo; // 연계 번호
    private Long siteNo; // 사이트 번호
    private String sbnSno; // 사방넷 일련번호
    private String spmallId; // 쇼핑몰 ID
    private String spmallLoginId; // 쇼핑몰 로그인 ID
    private String prcGb; // 처리 구분
    private String lettNo; // 글 번호
    private String grpNo; // 그룹 번호
    private String bbsId; // 게시판 아이디
    private String clctDt; // 수집 일자
    private String spmallOrdNo; // 쇼핑몰 주문 번호
    private String goodsNo; // 상품 번호
    private String itemNo; // 단품 번호
    private String goodsNm; // 상품 명
    private String title; // 제목
    private String content; // 내용
    private String wrtr; // 작성자
    private String custRegDt; // 고객 등록 일자
    private String replyContent; // 답변 내용
    private String rplr; // 답변자
    private String replyRegDttm; // 답변 등록 일시
    private String replySendDttm; // 답변 전송 일시
    private String inquiryGb; // 문의 구분
    private String sbnIfYn; // 사방넷 연계 여부
    private String sbnIfMsg; // 사방넷 연계 메세지
    private String btchPrcYn; // 배치 처리 여부
    private Long regrNo; // 등록자 번호
    private Long updrNo; // 수정자 번호

    private String resultContent;
}
