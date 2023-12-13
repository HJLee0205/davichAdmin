package net.danvi.dmall.biz.app.goods.service;

import net.danvi.dmall.biz.app.goods.model.RestockNotifyPO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyPOListWrapper;
import net.danvi.dmall.biz.app.goods.model.RestockNotifySO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface RestockNotifyService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트내 특정 상품에 등록된 상품 재입고 알림 대상 목록 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<RestockNotifyVO> selectRestockNotifyListPaging(RestockNotifySO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트내 특정 상품에 등록된 상품 재입고 알림 대상 정보를 단건 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    ResultModel<RestockNotifyVO> selectRestockNotify(RestockNotifyVO vo);

    /** 재입고 알림 등록여부 조회 **/
    RestockNotifyVO selectDuplicateAlarm(RestockNotifyVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 상품 재입고 알림 대상 정보를 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<RestockNotifyPO> insertRestockNotify(RestockNotifyPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트내 특정 상품에 등록된 상품 재입고 알림 대상 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<RestockNotifyPO> updateRestockNotify(RestockNotifyPO po) throws Exception;

    ResultModel<RestockNotifyPO> updateRestockNotifyMemo(RestockNotifyPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트내 특정 상품에 등록된 상품 재입고 알림 대상 정보를 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<RestockNotifyPOListWrapper> deleteRestockNotify(RestockNotifyPOListWrapper po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 18.
     * 작성자 : dong
     * 설명   : 재입고 알림 SMS 전송
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param replaceCdVO
     * @return
     * @throws Exception
     */
    ResultModel<RestockNotifyPOListWrapper> sendRestockSms(RestockNotifyPOListWrapper po) throws Exception;

    ResultModel<RestockNotifyPOListWrapper> sendCheckedRestock(RestockNotifyPOListWrapper po) throws Exception;

    ResultListModel<RestockNotifyVO> selectRestockNotifySendListPaging(RestockNotifySO so);
}
