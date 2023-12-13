package net.danvi.dmall.biz.common.service;

/**
 * Web service
 * 
 * @author snw
 * @since 2013.09.02
 */

public interface BizService {

    /**
     * 구분값으로 시퀀스 번호 생성
     * 10000000000보다 커지면 1로 리셋됨
     * 내부적으로 테이블 Update 가 이루어지니 트랜잭션 설정에 유의하세요
     *
     * @param seqGb
     *            시퀀스 구분값
     * @return Integer
     * @throws Exception
     */
    Long getSequence(String seqGb) throws Exception;

    /**
     * 사이트별 구분값으로 시퀀스 생성
     * 10000000000보다 커지면 1로 리셋됨
     * 내부적으로 테이블 Update 가 이루어지니 트랜잭션 설정에 유의하세요
     *
     * @param seqGb
     *            시퀀스 구분값
     * @param siteNo
     *            사이트번호
     * @return
     * @throws Exception
     */
    Long getSequence(String seqGb, Long siteNo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @param domain
     * @return
     */
    Long getSiteNo(String domain);
}