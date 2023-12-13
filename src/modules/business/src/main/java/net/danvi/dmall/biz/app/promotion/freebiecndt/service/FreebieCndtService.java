package net.danvi.dmall.biz.app.promotion.freebiecndt.service;

import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPOListWrapper;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 서비스
 * </pre>
 */
public interface FreebieCndtService {
    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 이헌철
     * 설명   : 사은품이벤트 목록조회(페이징)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<FreebieCndtVO> selectFreebieCndtListPaging(FreebieCndtSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 이헌철
     * 설명   : 사은품이벤트 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<FreebieCndtPO> insertFreebieCndt(FreebieCndtPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 이헌철
     * 설명   : 사은품이벤트 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<FreebieCndtPO> updateFreebieCndt(FreebieCndtPO po);

    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 이헌철
     * 설명   : 사은품이벤트 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    public ResultModel<FreebieCndtPO> deleteFreebieCndt(FreebieCndtPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 이헌철
     * 설명   : 사은품이벤트 상세조회(단건)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<FreebieCndtVO> selectFreebieCndtDtl(FreebieCndtSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 21.
     * 작성자 : 
     * 설명   : 상품번호로 사은품 이벤트 조회 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 21. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<FreebieTargetVO> selectFreebieListByGoodsNo(FreebieCndtSO so);

    // 사은품대상 전체조회(중복체크)
    // public ResultListModel<FreebieTargetVO> selectFreebieTargetTotal();
}
