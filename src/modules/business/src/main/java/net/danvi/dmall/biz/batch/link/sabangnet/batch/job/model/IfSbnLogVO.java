package net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class IfSbnLogVO implements Serializable {
    private static final long serialVersionUID = -5868615968347416367L;

    private String ifNo; // 연계번호
    private String ifId; // 연계아이디
    private Long siteNo; // 사이트번호
    private String ifPgmId; // 연계프로그램ID
    private String ifPgmNm; // 연계프로그램명
    private String goodsCdReturnYn; // 상품코드반환여부
    private String resultContent; // 결과내용
    private String srchStartDt; // 검색시작일자
    private String srchEndDt; // 검색종료일자
    private String prtFieldList; // 출력필드리스트
    private String salesCalculateCheckYn; // 매출정산확인여부
    private String ordNo; // 주문번호
    private String spmallCd; // 쇼핑몰코드
    private String ordDlvrStatusCd; // 주문배송상태코드
    private String invoiceInfoUpdYn; // 송장정보수정여부
    private String srchPrcGbCd; // 검색처리구분코드
    private Long regrNo;
    private Long updrNo;
}
