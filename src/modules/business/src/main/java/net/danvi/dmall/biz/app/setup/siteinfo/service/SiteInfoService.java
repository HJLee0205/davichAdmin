package net.danvi.dmall.biz.app.setup.siteinfo.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.goods.model.GoodsIconVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.danvi.dmall.biz.app.goods.model.GoodsImageSizePO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizeVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SitePO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SiteInfoService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트의 기본 정보를 조회하여 리턴한다.
     *          (관리자의 사이트 기본설정에서 사용)
     *          
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<SiteVO> selectSiteInfo(SiteSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트 기본정보 중 에디터로 작성된 사이트 상세설명 HTML정보를 조회하여 반환한다.  
     *          (관리자의 사이트 기본설정에서 사용)
     *          
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<SiteVO> selectSiteInfoHtml(SiteSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트 기본 설정 정보를 수정한다.
     *          (관리자의 사이트 기본설정에서 사용)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SitePO> updateSiteInfo(SitePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트의 정보를 삭제한다.
     *          (사이트 삭제 시의 저리 로직에 대해서는 아직 미정으로 미구현, 사용금지) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SitePO> deleteSiteInfo(SitePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 30.
     * 작성자 : dong
     * 설명   : 사이트의 이미지 설정 정보를 조회하여 리턴한다.
     *          
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<GoodsImageSizeVO> selectGoodsImageInfo(SiteSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 30.
     * 작성자 : dong
     * 설명   : 사이트에 등록된 아이콘 리스트를 조회하여 리턴한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<GoodsIconVO> selectIconList(SiteSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 30.
     * 작성자 : dong
     * 설명   : 아이콘 추가 정보 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 30. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> saveIconInfo(Model model, MultipartHttpServletRequest mRequest) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 8.
     * 작성자 : dong
     * 설명   : 사이트 상품 이미지 설정 정보를 수정한다.
     *          (관리자 상품 등록에서 사용)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<GoodsImageSizePO> udpateImageConfig(GoodsImageSizePO po) throws Exception;
}
