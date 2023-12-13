package net.danvi.dmall.biz.app.setup.payment.service;

import java.io.Writer;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.design.model.PopManageSO;
import net.danvi.dmall.biz.app.design.model.PopManageVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigPO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.NPayConfigPO;
import net.danvi.dmall.biz.app.setup.payment.model.NPayConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigPO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigPO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

public interface PaymentManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 팝업 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<CommPaymentConfigVO> selectPaymentPaging(CommPaymentConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 무통장 계좌 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigVO> selectNopbPaymentConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 사이트에 등록된 무통장 은행 계좌 리스트 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultListModel<NopbPaymentConfigVO> selectNopbPaymentList(Long siteNo);

    // 무통장 은행계좌 리스트 정보 조회 서비스(set Cache Service)
    public List<NopbPaymentConfigVO> selectNopbInfo(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 14.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 통합전자결제 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 14. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigVO> selectCommPaymentConfig(CommPaymentConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 간편결제 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SimplePaymentConfigVO> selectSimplePaymentConfig(SimplePaymentConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 5.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 NPAY 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 5. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NPayConfigVO> selectNPayConfig(Long siteNo);


    /**
     * <pre>
     * 작성일 : 2016. 7. 5.
     * 작성자 : dong
     * 설명   : NPAY 상품정보요청
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 5. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    void _writeItemInfo(String itemId, Writer writer , HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 해외결제 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigVO> selectForeignPaymentConfig(Long siteNo);

     /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 알리페이 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigVO> selectAlipayPaymentConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 텐페이 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigVO> selectTenpayPaymentConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 위챗페이 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigVO> selectWechpayPaymentConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 무통장 계좌 설정 정보 값을 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigPO> updateNopbPaymentConfig(NopbPaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 무통장 은행계좌 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigPO> insertNopbAccount(NopbPaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 무통장 은행계좌 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigPO> updateNopbAccount(NopbPaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 7.
     * 작성자 : dong
     * 설명   : 무통장 대표계좌 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 7. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigPO> updateNopbPaymentDlgtActConfig(NopbPaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 무통장 은행계좌 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NopbPaymentConfigPO> deleteNopbAccount(NopbPaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 1. 13.
     * 작성자 : slims
     * 설명   : 사이트에 설정된통합전자결제 설정 정보 값을 등록/수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 13. slims - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigPO> insertCommPaymentConfig(CommPaymentConfigPO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 15.
     * 작성자 : dong
     * 설명   : 사이트에 설정된통합전자결제 설정 정보 값을 등록/수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 15. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigPO> updateCommPaymentConfig(CommPaymentConfigPO po, HttpServletRequest request)
            throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 1. 15.
     * 작성자 : slims
     * 설명   : 사이트에 설정된통합전자결제 설정 정보 값을 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 15. slims - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigPO> deleteCommPaymentConfig(CommPaymentConfigPO po) throws Exception;
    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 간편결제 사용 설정 정보 값을 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SimplePaymentConfigPO> updateSimplePaymentUseYnConfig(SimplePaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 간편결제 설정 정보 값을 등록/수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<SimplePaymentConfigPO> updateSimplePaymentConfig(SimplePaymentConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 NPay 설정 정보 값을 등록/수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<NPayConfigPO> updateNPayConfig(NPayConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 해외결제 설정 정보 값을 등록/수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public ResultModel<CommPaymentConfigPO> updateForeignPaymentConfig(CommPaymentConfigPO po) throws Exception;


}
