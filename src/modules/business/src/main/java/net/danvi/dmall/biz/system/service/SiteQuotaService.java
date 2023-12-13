package net.danvi.dmall.biz.system.service;

import net.danvi.dmall.core.remote.homepage.model.request.PaymentInfoPO;

/**
 * Created by dong on 2016-07-29.
 */
public interface SiteQuotaService {
    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 디스크 용량 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    // public Long getDiskQuota(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 관리자 추가 가능여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public boolean isManagerAddible(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 아이콘 추가 가능 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public boolean isIconAddible(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 무통장계좌 추가 가능 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public boolean isAccountAddible(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 게시판 추가 가능 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public boolean isBbsAddible(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 트래픽 할당량 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    // public Long getTrafficQuota(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : SMS 포인트 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    // public int getSmsPoint(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 이메일 포인트 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    // public int getEmailPoint(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : SNS 추가 가능 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param outsideLinkCd
     *            외부연동코드
     * @return
     */
    public boolean isSnsAddible(Long siteNo, String outsideLinkCd);

    public Integer getManagerCount(Long siteNo) throws Exception;

    public Integer updateManagerCount(PaymentInfoPO po);

    public Integer getAccountCount(Long siteNo);

    public Integer updateAccountCount(PaymentInfoPO po);

    public Integer getIconCount(Long siteNo);

    public Integer updateIconCount(PaymentInfoPO po);

    public Integer getBbsCount(Long siteNo);

    public Integer updateBbsCount(PaymentInfoPO po);

    public boolean hasSnsLoginInfo(PaymentInfoPO po);

    public Integer insertSnsLoginInfo(PaymentInfoPO po);
}
