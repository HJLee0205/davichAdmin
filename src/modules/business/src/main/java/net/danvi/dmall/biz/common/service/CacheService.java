package net.danvi.dmall.biz.common.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.design.model.PopManageVO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.MenuVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;

/**
 * Web service
 *
 * @author snw
 * @since 2013.09.02
 */

public interface CacheService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 공통코드 목록을 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     */
    public void listCodeCache();

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 공통코드 정보를 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     */
    public void listCodeCacheRefresh();

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 메뉴 화면 맵을 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     */
    public void refreshScreenMapCache();

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 메뉴화면 맵을 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public Map<String, MenuVO> getScreenMap() throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 프론트 사이트 정보를 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public SiteVO selectBasicInfo(SiteSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 무통장 계좌 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public List<NopbPaymentConfigVO> selectNopbInfo(SiteSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 7.
     * 작성자 : dong
     * 설명   : 팝업 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public List<PopManageVO> selectPopupInfo(SiteSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 카테고리 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public Map<String, String> selectGnbInfo(SiteSO so) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 카테고리 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public Map<String, String> selectLnbInfo(SiteSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 프론트 사이트 정보를 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param so
     */
    public void refreshBasicInfoCache(SiteSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 무통장 계좌 정보 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @throws Exception
     */
    public void refreshNopbInfo(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 카테고리 정보 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @throws Exception
     */
    public void refreshGnbInfo(Long siteNo);
    
    /**
     * <pre>
     * 작성일 : 2016. 9. 3.
     * 작성자 : dong
     * 설명   : 카테고리 정보 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 3. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @throws Exception
     */
    public void refreshLnbInfo(Long siteNo);

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
    public Long getSiteNo(String domain);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 사이트 번호로 사이트 정보 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
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
    public void refreshSiteInfoCache(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 유저가 가진 관리자 권한에 따른 메뉴 정보를 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public Map<String, String> getAuthLv1MenuMap(LoginVO vo) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 27.
     * 작성자 : dong
     * 설명   : 치환자 코드 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 27. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public Map<String, String> getReplaceCd() throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 27.
     * 작성자 : dong
     * 설명   : 치환자 코드 캐쉬 갱신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 27. dong - 최초생성
     * </pre>
     *
     */
    public void refreshReplaceCd();

}