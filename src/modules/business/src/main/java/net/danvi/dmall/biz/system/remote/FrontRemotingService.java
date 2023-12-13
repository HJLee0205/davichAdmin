package net.danvi.dmall.biz.system.remote;

/**
 * Created by dong on 2016-06-21.
 */
public interface FrontRemotingService {
    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 사이트 정보 갱신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     */
    public void refreshBasicInfoCache(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 카테고리 갱신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     */
    public void refreshGnbInfo(Long siteNo);
    
    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 카테고리 갱신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     */
    public void refreshLnbInfo(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 무통장 갱신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     */
    public void refreshNopbInfo(Long siteNo);

    public void refreshSiteInfoCache(Long siteNo);
}
