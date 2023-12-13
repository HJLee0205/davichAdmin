package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OffStampHistorySearchReqDTO
 * 작성자:   gh.jo
 * 작성일:   2023/02/23
 * 설명:
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/23 gh.jo  최초 생성
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffStampHistorySearchReqDTO extends BaseReqDTO {

    /**
     * 쇼핑몰 회원번호
     */
    private String memNo;

    /**
     * 검색조건 - 기간 From
     */
    private String searchFrom;

    /**
     * 검색조건 - 기간 To
     */
    private String searchTo;

    /**
     * 거래구분 [1:적립, 2:사용]
     */
    private String dealType;

    /**
     * 페이지번호 (zero-base)
     */
    private Integer pageNo = 0;

    /**
     * 페이지당 표시할 데이터 개수
     */
    private Integer cntPerPage = 10;


    // 변환용 변수
    /**
     * 다비젼 회원번호
     */
    @ExceptLog
    private String cdCust;

    /**
     * <pre>
     * - 프로젝트명    : davichmall_interface
     * - 패키지명      : com.davichmall.ifapi.mem.dto
     * - 파일명        : PointHistorySearchResDTO.java
     * - 작성일        : 2018. 5. 29.
     * - 작성자        : CBK
     * - 설명          : 포인트 증감내역 DTO
     * </pre>
     */
    @Data
    public static class StampHistoryDTO {

        /**
         * 거래일자
         */
        private String dealDate;

        /**
         * 거래 가맹점명
         */
        private String strName;

        /**
         * 취소구분 (정상/반품)
         */
        private String cancType;

        /**
         * 입력구분(누적/통합/소멸/변경/사용)
         */
        private String inFlag;

        /**
         * 구매금액
         */
        private int salAmt;

        /**
         * 발생포인트
         */
        private int salPoint;

        /**
         * 사용포인트
         */
        private int usePoint;

        /**
         * 보유포인트
         */
        private int curPoint;
    }
}
