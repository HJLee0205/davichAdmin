package net.danvi.dmall.biz.app.setup.taxbill.service;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigPO;
import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigVO;
import dmall.framework.common.model.ResultModel;

public interface TaxBillConfigService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 세금계산서 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<TaxBillConfigVO> selectTaxBillConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 세금계산서 설정 정보 값을 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<TaxBillConfigPO> updateTaxBillConfig(TaxBillConfigPO po, HttpServletRequest request)
            throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 5.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 세금계산서 설정된 인감이미지를 삭제한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<TaxBillConfigPO> deleteTaxBillImage(TaxBillConfigPO po) throws Exception;
}
