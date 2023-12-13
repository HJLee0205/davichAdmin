package net.danvi.dmall.biz.app.setup.order.service;

import net.danvi.dmall.biz.app.setup.order.model.OrderConfigPO;
import net.danvi.dmall.biz.app.setup.order.model.OrderConfigVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface OrderConfigService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 주문관련 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<OrderConfigVO> selectOrderConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 주문관련 설정 정보 값을 수정한다.  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<OrderConfigPO> updateOrderConfig(OrderConfigPO po) throws Exception;
}
