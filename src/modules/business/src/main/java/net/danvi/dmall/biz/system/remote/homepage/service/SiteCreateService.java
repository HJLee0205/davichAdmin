package net.danvi.dmall.biz.system.remote.homepage.service;

import net.danvi.dmall.core.remote.homepage.model.request.DomainPO;
import net.danvi.dmall.core.remote.homepage.model.request.SitePO;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.core.remote.homepage.model.result.SiteResult;

/**
 * Created by dong on 2016-08-17.
 */
public interface SiteCreateService {

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 사이트 아이디로 기존 사이트 존재 여부 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param siteId
     * @return
     */
    public boolean isExistSiteId(String siteId);

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 사이트 기본 정보를 생성
     *          업체, 쇼핑몰, 관리자 그룹, 관리자, 관리자 회원, 게시판, 소셜로그인, 
     *          약관, 금칙어, 상품 아이콘, 회원등급 및 혜택 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public SiteResult createSite(SitePO po);

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 홈페이지ID 정보로 업체번호 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param homepageId
     * @throws Exception
     */
    public Long getCompanyNo(String homepageId);

    public RemoteBaseResult setDomain(DomainPO po);

    /**
     * <pre>
     * 작성일 : 2016. 10. 6.
     * 작성자 : dong
     * 설명   : 호스팅 작업 데이터 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 6. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws Exception
     */
    void createSiteSystemWork(SitePO po);

    /**
     * <pre>
     * 작성일 : 2016. 10. 6.
     * 작성자 : dong
     * 설명   : 호스팅 작업 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 6. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws Exception
     */
    SitePO getSiteSystemWork(SitePO po);
}
