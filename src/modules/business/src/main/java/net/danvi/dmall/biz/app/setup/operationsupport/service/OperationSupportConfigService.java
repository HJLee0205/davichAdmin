package net.danvi.dmall.biz.app.setup.operationsupport.service;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigPO;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigVO;
import net.danvi.dmall.core.remote.homepage.model.request.ImageHostingPO;
import dmall.framework.common.model.ResultModel;

public interface OperationSupportConfigService {

    /**
     * <pre>
     * 작성일 : 2016. 08. 24
     * 작성자 : dong
     * 설명   : 사이트에 설정된 SEO설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 24 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigVO> selectSeoConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 08. 24
     * 작성자 : dong
     * 설명   : 사이트에 설정된 GA설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 24 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigVO> selectGaConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 09. 09
     * 작성자 : dong
     * 설명   : 사이트에 설정된 080 수신거부 서비스 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 2016. 09. 09 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigVO> select080Config(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 09. 28
     * 작성자 : dong
     * 설명   : 사이트에 설정된 이미지 호스팅 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 2016. 09. 28 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigVO> selectImageConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 08. 24
     * 작성자 : dong
     * 설명   : 사이트에 설정된 SEO설정 정보 값을 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 24 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigPO> updateSeoConfig(OperSupportConfigPO po, HttpServletRequest request)
            throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 08. 24
     * 작성자 : dong
     * 설명   : 사이트에 설정된 GA설정 정보 값을 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 24 dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OperSupportConfigPO> updateGaConfig(OperSupportConfigPO po, HttpServletRequest request)
            throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 09. 09
     * 작성자 : dong
     * 설명   : 사이트에 설정된 080 수신거부 서비스 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 2016. 09. 09 dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public int update080Config(OperSupportConfigPO po);

    public int updateImgServConfig(ImageHostingPO po);
}
