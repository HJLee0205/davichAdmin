package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.SaleRankGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.SaleRankGoodsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 5.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface SaleRankGoodsAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : sin
     * 설명   : 판매순위 상품 분석 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. sin - 최초생성
     * </pre>
     *
     * @param saleRankGoodsSO
     * @return
     */
    public ResultListModel<SaleRankGoodsVO> selectSaleRankGoodsList(SaleRankGoodsSO saleRankGoodsSO);
}
