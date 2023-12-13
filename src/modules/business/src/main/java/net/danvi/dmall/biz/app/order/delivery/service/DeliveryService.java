package net.danvi.dmall.biz.app.order.delivery.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliverySO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.batch.order.epost.model.EpostVO;
import org.springframework.web.servlet.ModelAndView;

import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface DeliveryService {

    public ResultListModel<DeliveryVO> selectDeliveryListPaging(DeliverySO so) throws CustomException;

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<DeliveryVO> selectDeliveryListExcel(DeliverySO so) throws CustomException;

    public boolean updateOrdDtlDeliveryAddr(DeliveryPO po) throws CustomException;

    public ResultListModel<DeliveryVO> downInvoiceAddList(DeliverySO so) throws CustomException;

    public List<DeliveryVO> upInvoiceAddList(List<Map<String, Object>> list) throws CustomException;

    public int insertInvoiceAddList(List<DeliveryPO> vo) throws CustomException;

    /** 배송 정보 */
    public List<DeliveryVO> selectOrdDtlDelivery(DeliveryVO vo) throws CustomException;

    /** 배송 처리를 위한 목록 */
    public List<DeliveryVO> selectOrdDtlInvoice(DeliveryVO vo) throws CustomException;

    /** 배송 처리 송장 번호 등록 */
    public boolean updateOrdDtlInvoiceNew(DeliveryPO po) throws CustomException;

    /** 배송 처리 송장 번호 수정 */
    public boolean updateOrdDtlInvoice(DeliveryPO po) throws CustomException;

    public ResultModel<String> checkRlsInvoiceNo(String rlsCourierCd, String rlsInvoiceNo, String goodsflowUseYn);

    /** 사이트의 택배사 코드 조회 */
    public List<DeliveryVO> selectSiteCourierList() throws CustomException;

    /** 택배사 인터페이스 결과로 배송 정보 수정 처리 */
    public boolean updateDlvrByCourier(DeliveryVO vo) throws CustomException;

    /** 에스크로 */
    public ResultModel<PaymentModel<?>> doEscrowAction(DeliveryPO po, Map<String, Object> reqMap, ModelAndView mav,
            String method) throws Exception;

    /** 배송완료 조회 ( 구매확정 배치용 ) */
    public List<OrderGoodsVO> selectDeliveryCompletedList(int cnt) throws CustomException;

    /** 배송중 조회 ( 우체국 배치용 ) */
    public List<EpostVO> selectDeliveryEpostList() throws CustomException;
}
