package net.danvi.dmall.biz.app.goods.service;

import net.danvi.dmall.biz.app.goods.model.DisplayGoodsListWrapper;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsPO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsSO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPOListWrapper;
import dmall.framework.common.model.ResultModel;

import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 1.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface MainDisplayService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 메인 전시 상세 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayGoodsVO> selectMainDisplayGoods(DisplayGoodsSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 메인 전시 등록한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayGoodsPO> insertMainDisplay(DisplayGoodsPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 메인 전시 수정한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayGoodsPO> updateMainDisplay(DisplayGoodsPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 메인 전시 상세 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<DisplayGoodsVO> selectMainDisplayGoodsFront(DisplayGoodsSO so) throws Exception;

    Map<String, Object> seleceAllMainDisplayGoodsFront(DisplayGoodsSO so) throws Exception;

    Map<String, Object> selectIntroFront(DisplayGoodsSO so) throws Exception;

	public int getMaxSiteDispSeq(DisplayGoodsSO so) throws Exception;

	public ResultModel<DisplayGoodsPO> deleteMainDisplay(DisplayGoodsPO po) throws Exception;

}
