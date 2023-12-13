package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.BasketGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.BasketGoodsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 6.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface BasketGoodsAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 6.
     * 작성자 : sin
     * 설명   : 장바구니 순위 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 6. sin - 최초생성
     * </pre>
     *
     * @param basketGoodsSO
     * @return
     */
    public ResultListModel<BasketGoodsVO> selectBasketGoodsList(BasketGoodsSO basketGoodsSO);
}
