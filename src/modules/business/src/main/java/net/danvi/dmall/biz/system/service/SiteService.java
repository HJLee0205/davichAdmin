package net.danvi.dmall.biz.system.service;

import net.danvi.dmall.biz.system.model.SiteCacheVO;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SiteService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 도메인명으로 사이트 번호 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param domain
     * @return
     */
    public Long getSiteNo(String domain) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : HttpServletRequest의 도메인명으로 사이트 번호 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param request
     * @return
     */
    public Long getSiteNo(HttpServletRequest request);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 사이트 번호로 사이트 정보 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public SiteCacheVO getSiteInfo(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 사이트 번호의 사이트 정보 갱신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     */
    public void refreshSiteInfo(Long siteNo);
}
