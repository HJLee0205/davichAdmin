package net.danvi.dmall.biz.system.remote.parcel;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import net.danvi.dmall.core.model.parcel.ParcelModel;
import net.danvi.dmall.core.service.ParcelCommonService;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 5. 3.
 * 작성자     : KNG
 * 설명       : 택배 공통 서비스 클래스
 * </pre>
 */
public interface ParcelAdapterService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : 택배사 코드로 택배처리 서비스 클래스 얻기
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     * 
     * @param courierCd
     * @return ParcelCommonService
     */
    public ParcelCommonService getParcelService(String courierCd);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : KNG
     * 설명   : 택배사 자식PO클래스 얻기
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. KNG - 최초생성
     * </pre>
     *
     * @param courierCd
     */
    @SuppressWarnings("rawtypes")
    public <C extends ParcelModel> Class<C> getChildPO(String courierCd);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : 택배 배송의뢰송신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param parcelModel
     * @param reqMap
     * @param mav
     * @return
     */
    @SuppressWarnings("rawtypes")
    public <C extends ParcelModel> ResultModel<ParcelModel<?>> deliverySend(ParcelModel<?> parcelModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception ;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : 택배 배송결과수신
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     * @param parcelModel
     * @param reqMap
     * @param mav
     * @return
     */
    @SuppressWarnings("rawtypes")
    public <C extends ParcelModel> ResultModel<ParcelModel<?>> deliveryReceive(ParcelModel<?> parcelModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception ;
}