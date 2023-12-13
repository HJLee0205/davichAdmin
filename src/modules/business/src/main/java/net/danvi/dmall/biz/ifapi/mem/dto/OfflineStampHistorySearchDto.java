package net.danvi.dmall.biz.ifapi.mem.dto;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OfflineStampHistorySearchDto
 * 작성자:   gh.jo
 * 작성일:   2023/02/23
 * 설명:     스탬프 증감내역 조회 요청 DTO
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/23 gh.jo  최초 생성
 */
@Data
public class OfflineStampHistorySearchDto extends BaseSearchVO {

    /**
     * 쇼핑몰 회원번호
     */
    private String memNo;

    //다비전 회원 정보
    private String cdCust;

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
}
