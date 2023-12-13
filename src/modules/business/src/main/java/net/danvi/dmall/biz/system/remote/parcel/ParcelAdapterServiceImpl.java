package net.danvi.dmall.biz.system.remote.parcel;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.core.constants.CoreConstants;
import net.danvi.dmall.core.model.parcel.EpostPO;
import net.danvi.dmall.core.model.parcel.ParcelModel;
import net.danvi.dmall.core.service.ParcelCommonService;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.BeansUtil;
import dmall.framework.common.util.ConverterUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 5. 3.
 * 작성자     : KNG
 * 설명       : 결제 공통 서비스 클래스
 * </pre>
 */
@Slf4j
@Service("parcelAdapterService")
@Transactional(rollbackFor = Exception.class)
public class ParcelAdapterServiceImpl implements ParcelAdapterService {
    private ParcelCommonService parcelCommonService;

    @Resource(name = "parcelEpostService")
    private ParcelCommonService parcelEpostService;
    // @Resource(name = "parcelDoortodoorService")
    // private ParcelCommonService parcelDoortodoorService;

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
    @Override
    public ParcelCommonService getParcelService(String courierCd) {
        // 사이트의 택배수단 기준으로 구현클래스 가져오기 생성
        // parcelCommonService = (ParcelCommonService) BeansUtil.getBean(CoreConstants.getCourierCd(courierCd));
        switch (courierCd) {
        case CoreConstants.COURIER_CD_EPOST:
            parcelCommonService = parcelEpostService;
            break;
        // 대한통운 계약 불가로 삭제
        // case CoreConstants.COURIER_CD_DOORTODOOR:
        // parcelCommonService = parcelDoortodoorService;
        // break;
        default:
            parcelCommonService = null;
            break;
        }

        log.debug("Debug : {}", "택배 처리용 서비스 클래스는 [" + parcelCommonService + "] 입니다.");
        return parcelCommonService;
    }

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
     * @return Class
     */
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public <C extends ParcelModel> Class<C> getChildPO(String courierCd) {
        Class<C> childClass = null;
        switch (courierCd) {
        case CoreConstants.COURIER_CD_EPOST:
            childClass = (Class<C>) EpostPO.class;
            break;
// 대한통운 계약 불가로 삭제
//        case CoreConstants.COURIER_CD_DOORTODOOR:
//            childClass = (Class<C>) DoortodoorPO.class;
//            break;
        }
        return childClass;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends ParcelModel> ResultModel<ParcelModel<?>> deliverySend(ParcelModel<?> parcelModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        String MethodName = "택배 배송의뢰송신";
        log.debug("================================");
        log.debug(" " + MethodName + " 페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<ParcelModel<?>> resultModel = new ResultModel<>();
        String courierCd = parcelModel.getCourierCd();
        // 01. 계약된 CourierCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(courierCd); // 자식PO
        ParcelCommonService parcelCommonService = getParcelService(courierCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",parcelCommonService=" + parcelCommonService);
        if (childClass == null) {
            // <entry key="core.parcel.couriercd.illegal">처리하려는 택배사코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.parcel.couriercd.illegal", new Object[] { courierCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, parcelModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(parcelModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        // childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        resultModel = parcelCommonService.deliverySend(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        ParcelModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, ParcelModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(ParcelModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());

        return resultModel;
    }

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
     *
     * @param parcelModel
     * @param reqMap
     * @param mav
     * @return
     */
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends ParcelModel> ResultModel<ParcelModel<?>> deliveryReceive(ParcelModel<?> parcelModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        String MethodName = "택배 배송결과수신";
        log.debug("================================");
        log.debug(" " + MethodName + "  페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<ParcelModel<?>> resultModel = new ResultModel<>();
        String courierCd = parcelModel.getCourierCd();
        // 01. 계약된 CourierCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(courierCd); // 자식PO
        ParcelCommonService parcelCommonService = getParcelService(courierCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",parcelCommonService=" + parcelCommonService);
        if (childClass == null) {
            // <entry key="core.parcel.couriercd.illegal">처리하려는 택배사코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.parcel.couriercd.illegal", new Object[] { courierCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, parcelModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(parcelModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        resultModel = parcelCommonService.deliverySend(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        ParcelModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, ParcelModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(ParcelModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());

        return resultModel;
    }

}