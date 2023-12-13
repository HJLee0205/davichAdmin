package net.danvi.dmall.biz.app.setup.delivery.service;

import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 18.
 * 작성자     : dong
 * 설명       : 택배사 연계 정보 설정 관련 서비스를 관리한다.
 * </pre>
 */
public interface DeliveryInterfaceService {

    /**
     * <pre>
     * 작성일 : 2016. 7. 18.
     * 작성자 : dong
     * 설명   : 사이트의 특정 택배사의 연동 정보를 조회하여 반환한다.
     *          (관리자 택배연동 설정 화면에서 사용 )
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 18. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public ResultModel<CourierVO> selectDeliveryInterface(CourierVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 7. 18.
     * 작성자 : dong
     * 설명   : 택배 연동 정보를 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 18. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<CourierPO> updateDeliveryInterface(CourierPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 18.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 특정 택배사의 택배연동 정보를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 18. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<CourierPO> deleteDeliveryInterface(CourierPO po) throws Exception;

}
