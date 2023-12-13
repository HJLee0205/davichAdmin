package com.davichmall.ifapi.dist.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.ReturnMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapRegReqDTO.OrderDtlMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.ReturnMapRegReqDTO.ReturnMapDTO;
import com.davichmall.ifapi.cmmn.mapp.service.MappingService;
import com.davichmall.ifapi.dist.dao.DistDAO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelReqDTO;
import com.davichmall.ifapi.dist.dto.OrderPayInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.OrderDetailDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.PayInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO.ClaimInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderPayInfoDTO.CouponUseDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO.OrderReleaseDtlDto;
import com.davichmall.ifapi.dist.dto.OrderReleaseResDTO.ReleaseFailDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO.RefundItemDTO;
import com.davichmall.ifapi.dist.dto.ReturnInfoDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlReqDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltReqDTO;
import com.davichmall.ifapi.dist.service.DistService;
import com.davichmall.ifapi.util.SendUtil;
import com.davichmall.ifapi.util.SessionUtil;
import com.davichmall.ifapi.util.StringUtil;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.order.constants.OrdStatusConstants;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.sf.json.JSONObject;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.service.impl
 * - 파일명        : DistServiceImpl.java
 * - 작성일        : 2018. 6. 4.
 * - 작성자        : CBK
 * - 설명          : [발주] 분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("distService")
public class DistServiceImpl implements DistService {
	
	@Resource(name="distDao")
	DistDAO distDao;

	@Value("${mall.strcode}")
	String strCode;
	
	/**
	 * 쇼핑몰 배송 처리 Service
	 */
	@Resource(name="deliveryService")
	DeliveryService deliveryService;
	
	/**
	 * 쇼핑몰 주문 처리 Service
	 */
	@Resource(name="orderService")
	OrderService orderService;
	
	@Resource(name="mappingService")
	public MappingService mappingService;

	@Resource(name="sendUtil")
	public SendUtil sendUtil;
	
	// 쇼핑몰 도메인
    @Value(value = "#{business['system.domain.product']}")
    private String productDomain;

	/**
	 * 발주 및 발주 상세 데이터 저장
	 */
	@Transactional(transactionManager="transactionManager2", rollbackFor=Exception.class)
	@Override
	public synchronized void insertOrderInfo(OrderRegReqDTO param) throws Exception {

		// ERP주문일자 생성
		// 오늘 날짜 개체 생성
		Calendar cal = Calendar.getInstance();
		
		// 공통코드 테이블에서 마감 시간 조회
		String closingTime = "";
		if(Constants.ORD_RUTE.STORE_RECV.equals(param.getDestType()) || Constants.ORD_RUTE.STORE_SELLER_RECV.equals(param.getDestType())) {
			// 매장 수령인 경우
			closingTime = distDao.getClosingTimeForStoreDlvr();
		} else {
			// 집으로 배송인 경우
			closingTime = distDao.getClosingTimeForHomeDlvr();
		}
		// 현재 시간
		long nowTM = cal.getTimeInMillis();

		// 마감시간
		cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(closingTime.substring(0, 2)));
		cal.set(Calendar.MINUTE, Integer.parseInt(closingTime.substring(2)));
		long closingTM = cal.getTimeInMillis();	// 마감시각
		
		if(nowTM > closingTM) {
			// 마감시간 이후면 내일 날짜
			cal.add(Calendar.DATE, 1);
		}

		// 날짜가 토요일이거나 일요일이면..
		if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			// 월요일을 만들어 준다.
			while(cal.get(Calendar.DAY_OF_WEEK) != Calendar.MONDAY) {
				cal.add(Calendar.DATE, 1);
			}
		}
		// 발주 일자 생성
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String ordDate = sdf.format(cal.getTime());
		param.setOrdDate(ordDate);
		
		// 가맹점코드 설정
		param.setStrCode(strCode);
		
		// 전표번호 취득
		String ordSlip = distDao.getNextOrdSlip(param);
		param.setOrdSlip(ordSlip);
		
		// 발주전표번호 설정
		param.setOrdSlipNo(param.getOrdDate().substring(2) + param.getOrdSlip());

		// 기본 값 설정
		//  발주구분 : 정상발주
		param.setGubun(Constants.ORDER_GUBUN.ORDER);
		
		// 배송루트 (다비치상품 직접수령:1, 다비치상품 매장수령:2, 셀러상품 매장수령:3)
		String ordRute = "";
		if(param.getDelivStrCode() != null && !"".equals(param.getDelivStrCode())) {
			if(Constants.ORD_RUTE.STORE_SELLER_RECV.equals(param.getDestType())) {
				ordRute = Constants.ORD_RUTE.STORE_SELLER_RECV;
				// 입출고 반영 설정
				param.setInoutYn("N");
				// 정산 반영 설정
				param.setChargeYn("N");
			}else {
				ordRute = Constants.ORD_RUTE.STORE_RECV;
				// 입출고 반영 설정
				param.setInoutYn("Y");
				// 정산 반영 설정
				param.setChargeYn("Y");
			}
		} else {
			ordRute = Constants.ORD_RUTE.DIRECT_RECV;
			// 입출고 반영 설정
			param.setInoutYn("Y");
			// 정산 반영 설정
			param.setChargeYn("Y");
		}
		//String ordRute = param.getDelivStrCode() != null && !"".equals(param.getDelivStrCode()) ? Constants.ORD_RUTE.STORE_RECV : Constants.ORD_RUTE.DIRECT_RECV;
		param.setOrdRute(ordRute);

		// 발주 데이터 저장
		distDao.insertOrderInfo(param);

		// 발주 상세 데이터 저장
		List<OrderDtlMapDTO> ordDtlMapList = new ArrayList<>();
		// 발주 상세번호, 추가옵션번호 Map생성
		// 번호 설정의 기준이 쇼핑몰과 다비젼이 달라서 쇼핑몰의 순번을 다비젼에 맞는 형태로 변경하기 위함
		// 다비젼에서는 추가옵션인 경우 기본옵션의 주문상세번호를 그대로 따르고, 추가옵션번호를 001부터 증가하며 설정(기본옵션은 000)
		int erpOrdDtlSeq = 1;
		Map<String, Integer> ordDtlSeqMap = new HashMap<>(); 
		Map<String, Integer> ordAddNoMap = new HashMap<>();
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 패스
				continue;
			}
			
			// 발주상세번호 Map데이터
			ordDtlSeqMap.put(dtl.getItmCode(), erpOrdDtlSeq++);
			// 추가옵션번호 Map데이터
			ordAddNoMap.put(dtl.getItmCode(), 0);
		}

		// 발주 상세 데이터 저장
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			
			//ITM_CODE
			dtl.setItmCode(dtl.getItmCode().trim());
			
			// 부모 key설정
			dtl.setOrdDate(param.getOrdDate());
			dtl.setStrCode(param.getStrCode());
			dtl.setOrdSlip(param.getOrdSlip());
			
			// 순번 설정
			dtl.setErpOrdDtlSeq(String.valueOf(ordDtlSeqMap.get(dtl.getItmCode())));
			
			// ORD_ADD_NO 설정
			Integer ordAddNo = 0;	// 추가옵션번호 (기본은 0)
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 추가옵션번호 재설정
				ordAddNo = ordAddNoMap.get(dtl.getItmCode()) + 1;
				ordAddNoMap.put(dtl.getItmCode(), ordAddNo);
				dtl.setErpItmCode("*");
			}
			dtl.setErpOrdAddNo(StringUtil.lpad(ordAddNo, 3, '0'));

			// 데이터 저장
			distDao.insertOrderDetailInfo(dtl);

			// 매핑 데이터 설정(발주상세 데이터)
			OrderDtlMapDTO mapDto = new OrderDtlMapDTO();
			mapDto.setMallOrderDtlNo(dtl.getOrdDtlSeq());
			mapDto.setErpOrderDtlNo(dtl.getErpOrdDtlSeq());
			mapDto.setErpOrderAddNo(dtl.getErpOrdAddNo());
			
			ordDtlMapList.add(mapDto);
		}

		// 결제 정보 등록
		// 실 결제 수단 조회
		String payWayCd = null;
		String payWayNm = null;
		for(PayInfoDTO payDto : param.getPayList()) {
			if(!Constants.PAY_WAY.MILEAGE_CD.equals(payDto.getPayWayCd())
					&& !Constants.PAY_WAY.OFF_MILEAGE_CD.equals(payDto.getPayWayCd())) {
				// 실 결제 수단 설정 
				payWayCd = payDto.getPayWayCd();
				payWayNm = payDto.getPayWayNm();
			}
		}

		for(OrderDetailDTO dtlDto : param.getOrdDtlList()) {
			// 주문상세 데이터를 바탕으로 결제 DTO생성
			OrderPayInfoDTO payDto = new OrderPayInfoDTO(dtlDto, param.getCouponList());
			// 취소구분 설정
			payDto.setCancType(Constants.CANC_TYPE.NORMAL);
			
			payDto.setInDates(param.getPayDate());
			
			Integer seqNo = 1;
			// 할인 내역이 있으면 할인 저장 (쿠폰)
			if(payDto.getCouponUseList() != null && payDto.getCouponUseList().size() > 0) {
				// 결제 금액 일시 저장
				int payAmt = payDto.getPayAmt();
				
				for(CouponUseDTO cpnUseDto : payDto.getCouponUseList()) {
					
					// 지불수단설정
					payDto.setPayType(Constants.PAY_WAY.DISCOUNT_CD);
					payDto.setPayName(Constants.PAY_WAY.DISCOUNT_NM);
					// 할인코드/이름  설정
					payDto.setDcCode(cpnUseDto.getDcCode());
					payDto.setDcName(cpnUseDto.getDcName());
					// 할인 금액을 결제 금액으로 설정
					payDto.setPayAmt(cpnUseDto.getDcAmt());
					
					// seq 설정 및 저장
					payDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
					distDao.insertOrderPaymentInfo(payDto);
				}
				// 할인 정보 제거
				payDto.setDcCode(null);
				payDto.setDcName(null);
				// 결제금액 다시 설정
				payDto.setPayAmt(payAmt);
			}
			
			// 적립금 사용액이 있는 경우
			if(payDto.getMileageUseAmt() > 0) {
				// 결제 금액 임시 저장
				int payAmt = payDto.getPayAmt();
				
				// 지불수단설정
				payDto.setPayType(Constants.PAY_WAY.MILEAGE_CD);
				payDto.setPayName(Constants.PAY_WAY.MILEAGE_NM);
				// 적립금 사용액으로 지불금액 설정
				payDto.setPayAmt(payDto.getMileageUseAmt());
				payDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
				distDao.insertOrderPaymentInfo(payDto);
				
				// 결제금액 다시 설정
				payDto.setPayAmt(payAmt);
			}
			
			// 오프라인 적립금 사용액이 있는 경우
			if(payDto.getOffMileageUseAmt() > 0) {
				// 결제 금액 임시 저장
				int payAmt = payDto.getPayAmt();
				
				// 지불수단설정
				payDto.setPayType(Constants.PAY_WAY.OFF_MILEAGE_CD);
				payDto.setPayName(Constants.PAY_WAY.OFF_MILEAGE_NM);
				// 적립금 사용액으로 지불금액 설정
				payDto.setPayAmt(payDto.getOffMileageUseAmt());
				payDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
				distDao.insertOrderPaymentInfo(payDto);
				
				// 결제금액 다시 설정
				payDto.setPayAmt(payAmt);
			}
			
			// 결제 수단이 있는 경우 (전액 적립금 결제가 있기 때문에.. 이게 null일 수 있다.)
			if(payWayCd != null) {
				// 지불수단 설정
				payDto.setPayType(payWayCd);
				payDto.setPayName(payWayNm);
				payDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
				distDao.insertOrderPaymentInfo(payDto);
			}
			
		}

		// 매핑 정보 저장
		OrderMapRegReqDTO mapParam = new OrderMapRegReqDTO();
		mapParam.setMallOrderNo(param.getOrderNo());
		mapParam.setErpOrdDate(param.getOrdDate());
		mapParam.setErpStrCode(param.getStrCode());
		mapParam.setErpOrdSlip(param.getOrdSlip());
		mapParam.setOrdDtlMapList(ordDtlMapList);
		mapParam.setOrdRute(ordRute);
		
		String resParam = sendUtil.send(mapParam, "insertOrderMap");
		
		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}
	}

	/**
	 * 발주취소
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor= {Exception.class})
	public void cancelOrder(OrderCancelReqDTO param) throws Exception {
		distDao.cancelOrder(param);

		OrderMapRegReqDTO mapParam = new OrderMapRegReqDTO();
		mapParam.setMallOrderNo(param.getOrderNo());
		String resParam = sendUtil.send(mapParam, "deleteOrderMap");
		
		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}
	}

	/**
	 * 출고정보 등록
	 */
	@Transactional(transactionManager="transactionManager", rollbackFor= {Exception.class})
	@Override
	public List<ReleaseFailDTO> insertReleaseInfo(OrderReleaseReqDTO param) throws Exception {
		
		// 실패 데이터를 담을 리스트
		List<ReleaseFailDTO> failList = new ArrayList<>();
		
		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();
		
		for(OrderReleaseDtlDto dtl : param.getReleaseList()) {

			try {
				// ERP 주문 번호를 쇼핑몰 주문번호로 변경
				OrderMapDTO mapDtlDto = mappingService.getMallOrderDtlNo(dtl.getOrdDate(), dtl.getStrCode(), dtl.getOrdSlip(), dtl.getOrdSeq(), "000");
				if(mapDtlDto == null) {
					// 매핑되지 않은 주문상세번호입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
				}
				dtl.setMallOrderNo(mapDtlDto.getMallOrderNo());
				dtl.setMallOrdDtlSeq(mapDtlDto.getMallOrderDtlNo());
				
				// 송장번호 유효성 체크
				ResultModel<String> chkModel = deliveryService.checkRlsInvoiceNo(dtl.getCourierCd(), dtl.getInvoiceNo(), "");
				if (!chkModel.isSuccess()) {
					// 송장번호가 유효하지 않습니다.
					throw new CustomException("ifapi.exception.order.invoice.invalid");
				}
				
				// 쇼핑몰 배송 정보 조회
				Map<String, Object> mallDlvrInfo = distDao.getMallDlvrInfo(dtl.getMallOrderNo(), dtl.getMallOrdDtlSeq());
				
				// 배송정보 수정을 위한 기본 값들 설정
				DeliveryPO po = new DeliveryPO();
				po.setDlvrNo(mallDlvrInfo.get("dlvr_no").toString());
				po.setDlvrQtt(mallDlvrInfo.get("dlvr_qtt").toString());
				if(mallDlvrInfo.get("dlvr_msg") != null) {
					po.setDlvrMsg(mallDlvrInfo.get("dlvr_msg").toString());
				}
				po.setOrdNo(dtl.getMallOrderNo());
				po.setOrdDtlSeq(dtl.getMallOrdDtlSeq());
				po.setDlvrcPaymentCd(mallDlvrInfo.get("dlvrc_payment_cd").toString());
				po.setGoodsNo(mallDlvrInfo.get("goods_no").toString());
				po.setOrdStatusCd(mallDlvrInfo.get("ord_dtl_status_cd").toString());
				
				po.setRlsCourierCd(dtl.getCourierCd());
				po.setRlsInvoiceNo(dtl.getInvoiceNo());
				
				po.setRegrNo(Constants.IF_REGR_NO);
				po.setSiteNo(Constants.SITE_NO);
				
				boolean isSuccess = deliveryService.updateOrdDtlInvoiceNew(po);
				
				if(!isSuccess) {
					// 출고정보 등록에 실패했습니다.
					throw new CustomException("ifapi.exception.order.release.failed");
				}
				
			} catch(CustomException ce) {
				// CustomException 발생시 발생한 발주 정보와 실패 사유를 목록에 담아서 반환한다.
				failList.add(new ReleaseFailDTO(dtl, ce.getExCode()));
			}
		}
		
		return failList;
	}

	/**
	 * 매장 배송 완료 처리
	 */
	@Transactional(transactionManager="transactionManager", rollbackFor= {CustomException.class, Exception.class})
	@Override
	public void completeStoreDelivery(StoreDlvrCmpltReqDTO param) throws Exception {
		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();
		
		for(String mallOrdDtlSeq : param.getMallOrdDtlSeq()) {
			
			// 해당 데이터의 현재 상태를 확인 - 구매확정 상태이면 수정 안함.
			String currStatusCd = distDao.getOrderDtlCurrentStatus(param.getMallOrderNo(), mallOrdDtlSeq);
			if(OrdStatusConstants.BUY_CONFIRM.equals(currStatusCd)) {
				continue;
			}
			
			// 쇼핑몰 배송완료 처리 서비스 호출을 위한 파라미터 설정
			OrderGoodsVO vo = new OrderGoodsVO();
			vo.setRegrNo(Constants.IF_REGR_NO);
			vo.setSiteNo(Constants.SITE_NO);
			vo.setOrdStatusCd(OrdStatusConstants.DELIV_DONE);
			vo.setOrdNo(param.getMallOrderNo());
			vo.setOrdDtlSeq(mallOrdDtlSeq);
//			vo.setDlvrMsg(dlvrMsg);

			String curOrdStatusCd = orderService.selectCurOrdStatus(vo).getOrdStatusCd();
			orderService.updateOrdStatus(vo, curOrdStatusCd);
		}
	}
	
	/**
	 * 반품신청등록(쇼핑몰)
	 */
	@Transactional(transactionManager="transactionManager2", rollbackFor=Exception.class)
	@Override
	public void insertMallReturnReq(OrderRegReqDTO param) throws Exception {
		
		// 발주일자 설정
		param.setOrdDate(param.getOrderDate());
		
		// 가맹점코드 설정
		param.setStrCode(strCode);
		
		// 전표번호 취득
		String ordSlip = distDao.getNextOrdSlip(param);
		param.setOrdSlip(ordSlip);

		// 발주전표번호 설정
		param.setOrdSlipNo(param.getOrdDate().substring(2) + param.getOrdSlip());
		
		// 입출고 반영 설정
		param.setInoutYn("Y");
		// 정산 미반영 설정
		param.setChargeYn("N");
		
		// 발주 데이터 저장
		distDao.insertOrderInfo(param);
		
		// 반품 상세 매핑을 담을 리스트
		List<ReturnMapDTO> returnMapList = new ArrayList<>();

		// 발주 상세번호, 추가옵션번호 Map생성
		// 번호 설정의 기준이 쇼핑몰과 다비젼이 달라서 쇼핑몰의 순번을 다비젼에 맞는 형태로 변경하기 위함
		// 다비젼에서는 추가옵션인 경우 기본옵션의 주문상세번호를 그대로 따르고, 추가옵션번호를 001부터 증가하며 설정(기본옵션은 000)
		int erpOrdDtlSeq = 1;
		Map<String, Integer> ordDtlSeqMap = new HashMap<>(); 
		Map<String, Integer> ordAddNoMap = new HashMap<>();
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 패스
				continue;
			}
			
			// 발주상세번호 Map데이터
			ordDtlSeqMap.put(dtl.getItmCode(), erpOrdDtlSeq++);
			// 추가옵션번호 Map데이터
			ordAddNoMap.put(dtl.getItmCode(), 0);
		}
		
		// 발주 상세 데이터 저장
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			
			//ITM_CODE
			dtl.setItmCode(dtl.getItmCode().trim());
			
			// 부모 key설정
			dtl.setOrdDate(param.getOrderDate());
			dtl.setStrCode(param.getStrCode());
			dtl.setOrdSlip(param.getOrdSlip());
			
			// 반품상태 설정 (반품신청)
			dtl.setReturnStatus(Constants.RETURN_STATUS.RETURN_REQ);
			
			// 순번 설정
			dtl.setErpOrdDtlSeq(String.valueOf(ordDtlSeqMap.get(dtl.getItmCode())));
			
			// ORD_ADD_NO 설정
			Integer ordAddNo = 0;	// 추가옵션번호 (기본은 0)
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 추가옵션번호 재설정
				ordAddNo = ordAddNoMap.get(dtl.getItmCode()) + 1;
				ordAddNoMap.put(dtl.getItmCode(), ordAddNo);
				dtl.setErpItmCode("*");
			}
			dtl.setErpOrdAddNo(StringUtil.lpad(ordAddNo, 3, '0'));
			

			// 데이터 저장
			distDao.insertOrderDetailInfo(dtl);

			// 매핑 데이터 설정(반품상세 데이터)
			ReturnMapDTO mapDto = new ReturnMapDTO();
			mapDto.setMallClaimNo(param.getClaimNo());
			mapDto.setMallOrderNo(param.getOrderNo());
			mapDto.setMallOrderDtlNo(dtl.getOrdDtlSeq());

			mapDto.setErpOrdDate(param.getOrdDate());
			mapDto.setErpStrCode(param.getStrCode());
			mapDto.setErpOrdSlip(param.getOrdSlip());
			mapDto.setErpOrderDtlNo(dtl.getErpOrdDtlSeq());
			mapDto.setErpOrderAddNo(dtl.getErpOrdAddNo());
			
			returnMapList.add(mapDto);
		}
		
		// 매핑 정보 저장
		ReturnMapRegReqDTO mapParam = new ReturnMapRegReqDTO();
		mapParam.setMapList(returnMapList);
		
		String resParam = sendUtil.send(mapParam, "insertReturnMap");
		
		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}
	}
	
	/**
	 * 반품확정(반품완료) 정보를 다비젼에 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager2")
	public void updateErpReturnComfirm(MallReturnConfirmReqDTO param) throws Exception {
		// 발주 상세 상태 갱신
		for(ClaimInfoDTO dto : param.getClaimList()) {
			// 파라미터에 상태코드 설정 - 반품확정
			dto.setStatus(Constants.RETURN_STATUS.RETURN_CONFIRM);
			
			distDao.updateErpOrderDtlStatus(dto);
		}
		// 반품 확정 되지 않은 데이터 개수
		int notConfirmCnt = distDao.countErpOrderDtlOtherStatus(param.getClaimList().get(0));
		
		if(notConfirmCnt == 0) {
			// 모두 확정이면 마스터도 확정으로 갱신
			distDao.updateErpOrderStatus(param.getClaimList().get(0));
		}
	}

	/**
	 * 쇼핑몰 반품 확정 처리
	 */
	@Override
	@Transactional(transactionManager="transactionManager1", rollbackFor=CustomException.class)
	public void updateMallReturnConfirm(ErpReturnConfirmReqDTO param) throws Exception {
		
		distDao.updateMallReturnStatus(param);
		
	}

	/**
	 * ERP 주문 상세에 구매확정 정보 갱신
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor=CustomException.class)
	public void updateErpPurchaseConfirm(PurchaseConfirmReqDTO param) throws Exception {
		
		int resultCnt = distDao.updateErpPurchaseConfirm(param);
		
		if(resultCnt != param.getOrdDtlList().size()) {
			// 구매확정 정보가 일치하지 않습니다.
			throw new CustomException("ifapi.exception.purchseconfirm.invaliddata");
		}
	}

	/**
	 * 쇼핑몰 반품 추가 정보 팝업 URL
	 */
	@Override
	public String getMallReturnAddInfoPopUrl(ReturnPopUrlReqDTO param) throws Exception {
		String url = "http://";
		// 쇼핑몰 기본 도메인
		url += productDomain;
		// 팝업 URI
		url += "/admin/order/refund/refund-check-popup";
		// 파라미터
		url += "?claimNo=" + param.getMallClaimNo();
		url += "&ordNo=" + param.getMallOrderNo();
		url += "&ordDtlSeq=" + param.getMallOrderDtlNo();
		url += "&erpYn=Y";
		
		return url;
	}

	/**
	 * 환불 완료 데이터 저장
	 */
	@Override
	@Transactional(transactionManager="transactionManager2")
	public void completeRefund(RefundCmpltReqDTO param) throws Exception {
		
		// 상세 정보 loop
		for(RefundItemDTO dtl : param.getOrdDtlList()) {
			// 각 상세 별로 환불결제 정보 등록
			insertRefundPayInfo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), dtl.getOrdSeq(), dtl.getOrdAddNo(), param.getPayDate());
		}
		
		// 반품 발주 정보에 charge_yn을 'Y'로 설정
		distDao.setOrderChargeYnToY(param.getOrdDate(), param.getStrCode(), param.getOrdSlip());
		
	}
	
	private List<OrderPayInfoDTO> insertRefundPayInfo(String ordDate, String strCode, String ordSlip, String ordSeq, String ordAddNo, String payDate) throws Exception {

		List<OrderPayInfoDTO> resultList = new ArrayList<>();
		
		// 데이터 조회를 위한 parameter 생성
		Map<String, String> searchParam = new HashMap<>();
		searchParam.put("ordDate", ordDate);
		searchParam.put("strCode", strCode);
		searchParam.put("ordSlip", ordSlip);
		searchParam.put("ordSeq", ordSeq);
		searchParam.put("ordAddNo", ordAddNo);
		
		// 반품 발주 정보 조회(원발주번호 포함)
		ReturnInfoDTO rtnDtl = distDao.getReturnOrderDtlInfo(searchParam);
		
		// 반품 발주의 원 발주 수량조회(기 환불완료된거 마이너스 처리 해서 조회)
		int ordQty = distDao.getOrgOrderQtyExceptRefund(rtnDtl);
		
		// 반품 발주의 원 발주 결제 정보 조회 (기 환불완료된거 마이너스 처리 해서 조회)
		List<OrderPayInfoDTO> orgPayList = distDao.getOrgPaymentInfoListExceptRefund(rtnDtl);
		
		if(rtnDtl.getSupQty() == ordQty) {
			// 조회한 원 발주와 신청한 반품발주의 수량이 일치 하면
			// 결제 정보 그대로 플래그, PK만 바꿔서 등록
			int seqNo = 1;
			for(OrderPayInfoDTO payInfoDto : orgPayList) {
				payInfoDto.setDates(rtnDtl.getOrdDate());
				payInfoDto.setStrCode(rtnDtl.getStrCode());
				payInfoDto.setOrdSlip(rtnDtl.getOrdSlip());
				payInfoDto.setOrdSeq(rtnDtl.getOrdSeq());
				payInfoDto.setOrdAddNo(rtnDtl.getOrdAddNo());
				payInfoDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
				payInfoDto.setCancType(Constants.CANC_TYPE.RETURN);
				payInfoDto.setInDates(payDate);
				
				distDao.insertOrderPaymentInfo(payInfoDto);
				
				resultList.add(payInfoDto);
			}
			
		} else {
			// 수량이 일치하지 않으면 수량에 따른 환불금액을 계산해서 환불

			// 환불 금액
			int refundAmt = rtnDtl.getSprc() * rtnDtl.getSupQty();
			
			// 환불 우선 순위에 따라 결제정보 정렬
			Collections.sort(orgPayList, new Comparator<OrderPayInfoDTO>() {
				@Override
				public int compare(OrderPayInfoDTO dto1, OrderPayInfoDTO dto2) {
					if(dto1.getRefundPriority() > dto2.getRefundPriority()) {
						return 1;
					} else {
						return -1;
					}
				}
			});
			
			int seqNo = 1;
			for(OrderPayInfoDTO payInfoDto : orgPayList) {
				payInfoDto.setDates(rtnDtl.getOrdDate());
				payInfoDto.setStrCode(rtnDtl.getStrCode());
				payInfoDto.setOrdSlip(rtnDtl.getOrdSlip());
				payInfoDto.setOrdSeq(rtnDtl.getOrdSeq());
				payInfoDto.setOrdAddNo(rtnDtl.getOrdAddNo());
				payInfoDto.setSeqNo(StringUtil.lpad(seqNo++, 3, '0'));
				payInfoDto.setCancType(Constants.CANC_TYPE.RETURN);
				payInfoDto.setInDates(payDate);

				if(refundAmt < payInfoDto.getPayAmt()) {
					// 환불금액보다 원 실결제 금액이 크면
					// 환불 금액으로 설정해서 환불 결제 등록
					payInfoDto.setPayAmt(refundAmt);
				} else {
					// 환불 금액 보다 원 결제 금액이 작으면
					// 원 결제 금액 그대로 환불 결제 등록
				}
				
				distDao.insertOrderPaymentInfo(payInfoDto);
				
				resultList.add(payInfoDto);
				
				// 남은 환불 금액에서 처리된 환불금액 제외
				refundAmt -= payInfoDto.getPayAmt();
				
				// 남은 환불금액이 없으면 종료
				if(refundAmt <= 0) {
					break;
				}
			}
		}
		
		return  resultList;
	}
	
	/**
	 * 교환완료 - 재주문
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor={Exception.class})
	public void completeChange(OrderRegReqDTO param) throws Exception {
		
		// 재주문 헤더 등록
		// ERP주문일자 생성
		// 오늘 날짜 개체 생성
		Calendar cal = Calendar.getInstance();
		
		// 공통코드 테이블에서 마감 시간 조회
		String closingTime = "";
		if(Constants.ORD_RUTE.STORE_RECV.equals(param.getDestType())) {
			// 매장 수령인 경우
			closingTime = distDao.getClosingTimeForStoreDlvr();
		} else {
			// 집으로 배송인 경우
			closingTime = distDao.getClosingTimeForHomeDlvr();
		}
		// 현재 시간
		long nowTM = cal.getTimeInMillis();

		// 마감시간
		cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(closingTime.substring(0, 2)));
		cal.set(Calendar.MINUTE, Integer.parseInt(closingTime.substring(2)));
		long closingTM = cal.getTimeInMillis();	// 마감시각
		
		if(nowTM > closingTM) {
			// 마감시간 이후면 내일 날짜
			cal.add(Calendar.DATE, 1);
		}

		// 날짜가 토요일이거나 일요일이면..
		if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			// 월요일을 만들어 준다.
			while(cal.get(Calendar.DAY_OF_WEEK) != Calendar.MONDAY) {
				cal.add(Calendar.DATE, 1);
			}
		}
		// 발주 일자 생성
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String ordDate = sdf.format(cal.getTime());
		param.setOrdDate(ordDate);
		
		// 가맹점코드 설정
		param.setStrCode(strCode);
		
		// 전표번호 취득
		String ordSlip = distDao.getNextOrdSlip(param);
		param.setOrdSlip(ordSlip);
		
		// 발주전표번호 설정
		param.setOrdSlipNo(param.getOrdDate().substring(2) + param.getOrdSlip());

		//  발주구분 : 정상발주
		param.setGubun(Constants.ORDER_GUBUN.ORDER);
		
		// 배송루트 : 가맹점코드 존재 여부에 따라 설정 (존재하면 매장수령, 없으면 직접수령)
		String ordRute = param.getDelivStrCode() != null && !"".equals(param.getDelivStrCode()) ? Constants.ORD_RUTE.STORE_RECV : Constants.ORD_RUTE.DIRECT_RECV;
		param.setOrdRute(ordRute);
		
		// 입출고 반영 설정
		param.setInoutYn("Y");
		// 정산 반영 설정
		param.setChargeYn("Y");

		// 발주 데이터 저장
		distDao.insertOrderInfo(param);

		// 발주 상세 OrdDtlSeq, OrdAddNo 맵 생성
		List<OrderDtlMapDTO> ordDtlMapList = new ArrayList<>();
		// 발주 상세번호, 추가옵션번호 Map생성
		// 번호 설정의 기준이 쇼핑몰과 다비젼이 달라서 쇼핑몰의 순번을 다비젼에 맞는 형태로 변경하기 위함
		// 다비젼에서는 추가옵션인 경우 기본옵션의 주문상세번호를 그대로 따르고, 추가옵션번호를 001부터 증가하며 설정(기본옵션은 000)
		int erpOrdDtlSeq = 1;
		Map<String, Integer> ordDtlSeqMap = new HashMap<>(); 
		Map<String, Integer> ordAddNoMap = new HashMap<>();
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 패스
				continue;
			}
			
			// 발주상세번호 Map데이터
			ordDtlSeqMap.put(dtl.getItmCode(), erpOrdDtlSeq++);
			// 추가옵션번호 Map데이터
			ordAddNoMap.put(dtl.getItmCode(), 0);
		}
		
		// 반품 결제 등록 및 교환 발주 등록
		for(OrderDetailDTO dtl : param.getOrdDtlList()) {
			// 반품 결제 내역 등록
			List<OrderPayInfoDTO> payInfoList = insertRefundPayInfo(param.getOrgOrdDate(), param.getOrgStrCode(), param.getOrgOrdSlip(), dtl.getOrgOrdSeq(), dtl.getOrgOrdAddNo(), param.getPayDate());
			
			//ITM_CODE
			dtl.setItmCode(dtl.getItmCode().trim());
			
			// 발주 상세 등록
			// 부모 key설정
			dtl.setOrdDate(param.getOrdDate());
			dtl.setStrCode(param.getStrCode());
			dtl.setOrdSlip(param.getOrdSlip());
			
			// 순번 설정
			dtl.setErpOrdDtlSeq(String.valueOf(ordDtlSeqMap.get(dtl.getItmCode())));
			
			// ORD_ADD_NO 설정
			Integer ordAddNo = 0;	// 추가옵션번호 (기본은 0)
			if("Y".equals(dtl.getAddOptYn())) {
				// 추가옵션인 경우 추가옵션번호 재설정
				ordAddNo = ordAddNoMap.get(dtl.getItmCode()) + 1;
				ordAddNoMap.put(dtl.getItmCode(), ordAddNo);
				dtl.setErpItmCode("*");
			}
			dtl.setErpOrdAddNo(StringUtil.lpad(ordAddNo, 3, '0'));

			// 데이터 저장
			distDao.insertOrderDetailInfo(dtl);

			// 매핑 데이터 설정(발주상세 데이터)
			OrderDtlMapDTO mapDto = new OrderDtlMapDTO();
			mapDto.setMallOrderDtlNo(dtl.getOrdDtlSeq());
			mapDto.setErpOrderDtlNo(dtl.getErpOrdDtlSeq());
			mapDto.setErpOrderAddNo(dtl.getErpOrdAddNo());
			
			ordDtlMapList.add(mapDto);
			
			// 결제 등록
			// 환불 완료에서 등록한 결제 내역을 PK바꾸고(재주문에 물리도록), canc_type바꿔서 재등록
			for(OrderPayInfoDTO payInfoDto : payInfoList) {
				payInfoDto.setDates(param.getOrdDate());
				payInfoDto.setStrCode(param.getStrCode());
				payInfoDto.setOrdSlip(param.getOrdSlip());
				payInfoDto.setOrdSeq(dtl.getErpOrdDtlSeq());
				payInfoDto.setOrdAddNo(dtl.getErpOrdAddNo());
				payInfoDto.setCancType(Constants.CANC_TYPE.NORMAL);
				
				distDao.insertOrderPaymentInfo(payInfoDto);
			}
		}
		
		// 반품 발주 정보에 charge_yn을 'Y'로 설정
		distDao.setOrderChargeYnToY(param.getOrgOrdDate(), param.getOrgStrCode(), param.getOrgOrdSlip());

		// 매핑 정보 저장
		OrderMapRegReqDTO mapParam = new OrderMapRegReqDTO();
		mapParam.setMallOrderNo(param.getOrderNo());
		mapParam.setErpOrdDate(param.getOrdDate());
		mapParam.setErpStrCode(param.getStrCode());
		mapParam.setErpOrdSlip(param.getOrdSlip());
		mapParam.setOrdDtlMapList(ordDtlMapList);
		
		String resParam = sendUtil.send(mapParam, "insertOrderMap");
		
		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}
	}

	/**
	 * 반품신청 사유 팝업 URL 조회
	 */
	public String getMallReturnReasonPopUrl(ReturnPopUrlReqDTO param) throws Exception {
		String url = "http://";
		// 쇼핑몰 기본 도메인
		url += productDomain;
		// 팝업 URI
		url += "/admin/order/refund/claim-reason";
		// 파라미터
		url += "?claimNo=" + param.getMallClaimNo();
		url += "&ordNo=" + param.getMallOrderNo();
		url += "&ordDtlSeq=" + param.getMallOrderDtlNo();
		url += "&erpYn=Y";
		
		return url;
		
	}
}


