package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.CtgGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.CtgGoodsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 1.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface CtgGoodsAnlsService {
    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : sin
     * 설명   : 카테고리 인기순위 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. sin - 최초생성
     * </pre>
     *
     * @param ctgGoodsSO
     * @return
     */
    public ResultListModel<CtgGoodsVO> selectCtgGoodsList(CtgGoodsSO ctgGoodsSO);
}
