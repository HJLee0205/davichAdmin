package net.danvi.dmall.biz.app.setup.delivery.service;

import java.util.List;

import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierSO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPOListWrapper;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdPO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdSO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 8.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface DeliveryManageService {
    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 택배사 정보 목록을 페이징 처리하여 반환한다.
     *          (관리자 택배사 설정 화면에서 사용) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<CourierVO> selectCourierListPaging(CourierSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트의 특정 택배사 정보를 조회하여 반환한다.
     *          (관리자 택배사 상세 정보 화면에서 사용 )
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public ResultModel<CourierVO> selectCourier(CourierVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 택배사 목록을 리스트 형태로 조회하여 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public List<String> selectCourierList(CourierVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 택배사 정보(택배사명, 택배비, 사용여부, 등록일자)를 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<CourierPO> updateCourierForUse(CourierPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 택배사 정보를 신규 등록한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<CourierPO> insertCourier(CourierPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 해당 택배사 정보를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<CourierPO> deleteCourier(CourierPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 기본 배송설정 정보를 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<DeliveryConfigVO> selectDeliveryConfig(long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 기본 배송설정 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DeliveryConfigPO> updateDeliveryConfig(DeliveryConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 지역별 추가 배송비 목록을 페이징 처리하여 리턴한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<DeliveryAreaVO> selectDeliveryListPaging(DeliveryAreaSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 지역별 추가 배송비 목록을 처리하여 리턴한다.(페이징X) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<DeliveryAreaVO> selectDeliveryList(DeliveryAreaSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 시스템에 설정된 지역별 추가 배송비 기본 목록을 페이징 처리하여 리턴한다.
     *          (현재 미구현 - 06.08)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<DeliveryAreaVO> selectDefaultDeliveryListPaging(DeliveryAreaSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 지역별 배송비 정보를 등록한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DeliveryAreaPO> insertDeliveryArea(DeliveryAreaPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 지역별 배송비 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DeliveryAreaPO> updateDeliveryArea(DeliveryAreaPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 10. 17.
     * 작성자 : dong
     * 설명   : 기본 배송 지역 정보를 읽어와서 해당 사이트에 추가 배송비 정보로 설정 한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 지역별 배송비 정보를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    public ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 10. 26.
     * 작성자 : dong
     * 설명   : 지역별 배송비 정보를 전체 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 26. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    public ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po);

    /**
     * <pre>
     * 작성일 : 2016. 8. 19.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 HSCD 목록을 페이징 처리하여 리턴한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 19. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<HscdVO> selectHscdListPaging(HscdSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : HS코드 정보를 수정한다.
     *          사이트에 해당 HS코드로 기등록된 HS코드정보가 있을 경우, 기존의 데이터를 수정하며
     *          기등록된 정보가 없을 경우에는 설정된 정보로 신규 등록한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<HscdPO> updateHscd(HscdPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : HS코드 정보를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<HscdPO> deleteHscd(HscdPO po) throws Exception;
}
