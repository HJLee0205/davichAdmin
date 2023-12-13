package com.davichmall.ifapi.rsv.service.impl;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.PreorderMapRegReqDTO;
import com.davichmall.ifapi.rsv.dao.ReserveDAO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO.PreorderProductDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchResDTO.ReserveOrderDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchResDTO.ReserveProductDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticResDTO.StoreChaoticDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoResDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchResDTO.StoreInfoDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO.ReservePrdDTO;
import com.davichmall.ifapi.rsv.service.ReserveService;
import com.davichmall.ifapi.util.SendUtil;

import net.sf.json.JSONObject;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.service.impl
 * - 파일명        : ReserveServiceImpl.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 예약 관련 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Service("reserveService")
public class ReserveServiceImpl implements ReserveService {
	
	@Resource(name="reserveDao")
	ReserveDAO reserveDao;

	@Resource(name="sendUtil")
	public SendUtil sendUtil;


	/**
	 * 가맹점의 특정 요일 혼잡도 목록 조회
	 */
	@Override
	public List<StoreChaoticDTO> getStoreChaoticList(StoreChaoticReqDTO param) throws Exception {
		return reserveDao.getStoreChaoticList(param);
	}
	
	/**
	 * 매장 방문 예약 정보 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager2")
	public void insertStoreVisitReserveInfo(StoreVisitReserveRegReqDTO param) throws Exception {
		// 이미 등록된 데이터 인지 확인
		int cnt = reserveDao.countStoreVisitReserveInfo(param);
		if(cnt > 0) {
			// 이미 등록된 방문예약정보 입니다.
			throw new CustomException("ifapi.exception.reserve.insert.already");
		}
		// maxSeqNo 조회
		int seqNo = reserveDao.getStoreVisitReserveMaxSeq(param);
		param.setSeqNo(seqNo);
		
		// 전화번호 뒷자리 잘라서 별도 세팅
		String telNo = param.getTelNo();
		if(telNo != null && telNo.length() >= 4) {
			String telNoH = telNo.substring(telNo.length() - 4);
			param.setTelNoH(telNoH);
		}

		param.setCdCust(URLDecoder.decode(param.getCdCust(), "UTF-8"));
		param.setMemName(URLDecoder.decode(param.getMemName(), "UTF-8"));
		param.setMemo(URLDecoder.decode(param.getMemo(), "UTF-8"));
		param.setPurpose(URLDecoder.decode(param.getPurpose(), "UTF-8"));

		// 등록
		reserveDao.insertStoreVisitReserveInfo(param);
		
		// 예약 상품 정보가 있으면 등록
		if(param.getRsvPrdList() != null) {
			int seq = 1;
			for(ReservePrdDTO dtl : param.getRsvPrdList()) {
				dtl.setRsvDate(param.getRsvDate());
				dtl.setSeqNo(param.getSeqNo());
				dtl.setSeq(seq++);
				reserveDao.insertStoreVisitReserveDtlInfo(dtl);
			}
		}
	}
	
	/**
	 * 다비젼 매장 방문 예약 취소(from Mall)
	 */
	@Override
	public void cancelErpStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception {
		reserveDao.cancelErpStoreVisitReserveInfo(param);
	}
	
	/**
	 * 쇼핑몰 매장 방문 예약 취소(from ERP)
	 */
	@Override
	public void cancelMallStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception {
		reserveDao.cancelMallStoreVisitReserveInfo(param);
	}
	
	/**
	 * 매장 방문 예약 정보 수정
	 */
	@Transactional(transactionManager="transactionManager1")
	@Override
	public String updateStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception {
		// 예약 번호 최대값 조회
		String rsvNo = reserveDao.getMaxRsvNo();
		param.setRsvNo(rsvNo);

		// 데이터 변경 등록
		reserveDao.insertModifiedStoreVisitReserveInfo(param);
		
		// 상세 데이터 변경 등록
		reserveDao.insertModifiedStoreVisitReserveDtl(param);
		
		// 기존 방문예약 취소처리
		StoreVisitReserveCancelReqDTO cancelDto = new StoreVisitReserveCancelReqDTO();
		cancelDto.setMallRsvNo(param.getMallRsvNo());
		cancelDto.setUpdrNo(param.getRegrNo());
		reserveDao.cancelMallStoreVisitReserveInfo(cancelDto);
		
		return rsvNo;
	}
	
	/**
	 * 가맹점 목록 검색
	 */
	@Override
	public List<StoreInfoDTO> getStoreList(StoreSearchReqDTO param) throws Exception {
		return reserveDao.getStoreList(param);
	}
	
	/**
	 * 가맹점 코드 목록 검색
	 */
	@Override
	public List<StoreInfoDTO> getStrCodeList(StoreSearchReqDTO param) throws Exception {
		return reserveDao.getStrCodeList(param);
	}

	/**
	 * 가맹점 목록 건수 조회
	 */
	@Override
	public int countStoreList(StoreSearchReqDTO param) throws Exception {
		return reserveDao.countStoreList(param);
	}

	/**
	 * 가맹점 상세 정보 조회
	 */
	@Override
	public StoreDtlInfoResDTO getStoreDtlInfo(StoreDtlInfoReqDTO param) throws Exception {
		return reserveDao.getStoreDtlInfo(param);
	}
	
	/**
	 * 방문 예약 상품 목록 조회
	 */
	@Override
	public List<ReserveProductDTO> getReserveProductList(ReserveProductSearchReqDTO param) throws Exception {
		return reserveDao.selectReserveProductList(param);
	}
	
	/**
	 * 방문 예약 주문 목록 조회
	 */
	@Override
	public List<ReserveOrderDTO> getReserveOrderList(ReserveOrderSearchReqDTO param) throws Exception {
		return reserveDao.selectReserveOrderList(param);
	}

	/**
	 * 사전 예약 기획전 정보 등록 (공통코드 테이블에 등록)
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor=Exception.class)
	public synchronized String insertPreorderCtrCode(PreorderPromotionRegReqDTO param) throws Exception {
		// max ctr_code 조회
		String erpPrmtNo = reserveDao.getMaxPreorderCtrCode();
		// 파라미터에 ctr_code 설정
		param.setErpPrmtNo(erpPrmtNo);
		// 데이터 등록
		reserveDao.insertPreorderCtrCode(param);

		// 매핑 정보 저장
		PreorderMapRegReqDTO mapParam = new PreorderMapRegReqDTO();
		mapParam.setMallPrmtNo(param.getPrmtNo());
		mapParam.setErpPrmtNo(erpPrmtNo);
		String resParam = sendUtil.send(mapParam, "insertPreorderMap");

		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}
		
		return erpPrmtNo;
	}

	/**
	 * 사전 예약 주문 정보 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager2")
	public synchronized void insertPreorderInfo(PreorderRegReqDTO param) throws Exception {
		// max receipt_seq 조회
		int receiptSeq = reserveDao.getMaxReceiptSeqForPreorder(param.getErpPrmtNo());
		param.setReceiptSeq(receiptSeq);
		
		int itmSeq = 1;
		for(PreorderProductDTO prdDto : param.getPrdList()) {
			// 상품 순번 설정
			prdDto.setItmSeq(itmSeq++);
			// 상품 정보 조회
			Map<String, String> prdMap = reserveDao.selectProductInfoForPreorder(prdDto.getErpItmCode());

			// PreorderRegReqDTO로 JsonObject만들기 
			JSONObject jsonObj = JSONObject.fromObject(param);
			jsonObj.remove("prdList");	// prdList는 제거
			// 조회한 상품 정보 담기
			jsonObj.putAll(prdMap);
			// 저장용 DTO 생성(위에서 만든 JsonObject를 기반으로..)
			PreorderRegDTO regParam = (PreorderRegDTO) JSONObject.toBean(jsonObj, PreorderRegDTO.class);
			// 파라미터로 받은 상품 정보 세팅
			regParam.setItmSeq(prdDto.getItmSeq());
			regParam.setErpItmCode(prdDto.getErpItmCode());
			regParam.setQty(prdDto.getQty());
			
			// 데이터 저장
			reserveDao.insertPreorderInfo(regParam);
		}
	}

	/**
	 * 사전 예약 기획전 정보 수정
	 */
	@Transactional(transactionManager="transactionManager2")
	@Override
	public synchronized void updatePreorderPromotion(PreorderPromotionModReqDTO param) throws Exception {
		// 기획전 정보 수정(기획전명 - 공통코드 테이블)
		reserveDao.updatePreorderCtrCode(param);
		
		// 등록된 사전예약 주문 정보 수정(기획전명,기간)
		reserveDao.updatePreorderInfo(param);
	}

	/**
	 * 가맹점 휴일 목록 조회
	 */
	@Override
	public List<String> getStoreHolidayList(StoreHolidayReqDTO param) throws Exception {
		List<String> holidayList = new ArrayList<>();
		
		Map<String, String> map = reserveDao.getStoreHolidayList(param);

		// 데이터가 없으면 빈값 리턴
		if(map == null) return holidayList;
		
		// 특정일자 조회인 경우
		if(param.getTargetD() != null && !"".equals(param.getTargetD())) {
			// 일자 앞의 0 제거
			while(param.getTargetD().startsWith("0")) {
				param.setTargetD(param.getTargetD().substring(1));
			}
			// 해당 일자가 쉬는 날이면 목록에 담기
			if("Y".equals(map.get("DAY" + param.getTargetD()))) {
				holidayList.add(param.getTargetD());
			}
			// 결과 반환
			return holidayList;
		}
		
		// 쉬는날만 목록에 담기
		for(int i=1; i<=31; i++) {
			String holidayYn = map.get("DAY" + i);
			if("Y".equals(holidayYn)) {
				holidayList.add(String.valueOf(i));
			}
		}
		
		return holidayList;
	}
	
	/**
	 * 쇼핑몰에서 방문예약 정보 수정 (ERP쪽 데이터 변경)
	 */
	@Override
	public void updateErpStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception {
		reserveDao.updateErpStoreVisitReserveInfo(param);
	}

}
