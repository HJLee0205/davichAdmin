package net.danvi.dmall.biz.app.setup.snsoutside.service;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigPO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigSO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

public interface SnsOutsideLinkService {
    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 컨텐츠 공유관리 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigVO> selectContentsConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 컨텐츠 공유관리 설정 정보를 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigPO> updateContentsConfig(SnsConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 SNS 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigVO> selectSnsConfig(SnsConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 SNS 설정 정보 리스트를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultListModel<SnsConfigVO> selectSnsConfigList(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 SNS 설정 정보를 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigPO> updateSnsConfig(SnsConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 10.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 네이버 SNS 설정 정보를 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigPO> updateNaverSnsConfig(SnsConfigPO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : SNS 로그인 설정 정보 초기값 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SnsConfigPO> updateInitSnsConfig() throws Exception;
}
