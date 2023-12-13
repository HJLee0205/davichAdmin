package com.davichmall.ifapi.cmmn.mapp.service.impl;


import javax.annotation.Resource;

import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dao.MappingDAO;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.ReturnMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.ReturnMapRegReqDTO.ReturnMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapRegReqDTO.OrderDtlMapDTO;
import com.davichmall.ifapi.cmmn.mapp.service.MappingService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.service.impl
 * - 파일명        : MappingServiceImpl.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 - ERP 데이터 매핑 정보 처리 Service
 * </pre>
 */
@Service("mappingService")
public class MappingServiceImpl implements MappingService {
	
	@Resource(name="mappingDao")
	MappingDAO mappingDao;

	/**
	 * ERP 상품코드로 쇼핑몰 상품 코드(옵션코드) 조회
	 */
	@Override
	public String getMallItemCode(String erpItmCode) throws Exception {
		return mappingDao.getMallItemCode(erpItmCode);
	}

	/**
	 * 쇼핑몰 상품코드(옵션코드)로 ERP상품코드 조회
	 */
	@Override
	public String getErpItemCode(String mallItmCode) throws Exception {
		return mappingDao.getErpItemCode(mallItmCode);
	}

	/**
	 * 쇼핑몰-ERP 상품코드 매핑 정보 등록
	 */
	@Override
	public void insertItemCodeMap(String mallGoodsNo, String mallItmCode, String erpItmCode) throws Exception {
		try {
			mappingDao.insertItemCodeMap(mallGoodsNo, mallItmCode, erpItmCode);
		} catch(DuplicateKeyException e) {
			throw new CustomException("ifapi.exception.data.exists");
		}
		
	}

	/**
	 * 쇼핑몰-ERP 상품코드 매핑 정보 삭제
	 */
	@Override
	public void deleteItemCodeMap(String mallGoodsNo, String mallItmCode) throws Exception {
		mappingDao.deleteItemCodeMap(mallGoodsNo, mallItmCode);
	}

	/**
	 * ERP 주문번호로 쇼핑몰 주문번호 조회
	 */
	@Override
	public OrderMapDTO getMallOrderNo(String erpOrdDate, String erpStrCode, String erpOrdSlip) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		return mappingDao.getMallOrderNo(param);
	}

	/**
	 * ERP 주문번호 조회
	 */
	@Override
	public OrderMapDTO getErpOrderNo(OrderRegReqDTO param) throws Exception {
		OrderMapDTO param2 = new OrderMapDTO();
		param2.setMallOrderNo(param.getOrderNo());
		param2.setMallClaimNo(param.getClaimNo());
		param2.setOrdRute(param.getOrdRute());
		return mappingDao.getErpOrderNo(param2);
	}

	/**
	 * 쇼핑몰 주문번호로 ERP 주문번호 조회
	 */
	@Override
	public OrderMapDTO getErpOrderNo(String mallOrderNo) throws Exception {
		return this.getErpOrderNo(mallOrderNo, null);
	}

	/**
	 * 쇼핑몰 주문번호로 ERP 주문번호 조회
	 */
	public OrderMapDTO getErpOrderNo(String mallOrderNo, String mallClaimNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallOrderNo(mallOrderNo);
		param.setMallClaimNo(mallClaimNo);
		return mappingDao.getErpOrderNo(param);
	}

	/**
	 * 쇼핑몰 주문번호로 반품재발주 포함 마지막 주문번호 매핑 조회(교환 재발주는 제회)
	 */
	@Override
	public OrderMapDTO getLatestOrderMapWithoutChangeReorder(String mallOrderNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallOrderNo(mallOrderNo);
		return mappingDao.getLatestOrderMapWithoutChangeReorder(param);
	}

	/**
	 * 쇼핑몰-ERP 주문번호 매핑 정보 등록
	 */
	@Override
	public void insertOrderNoMap(String mallOrderNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String ordRute) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallOrderNo(mallOrderNo);
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		param.setOrdRute(ordRute);
		mappingDao.insertOrderNoMap(param);
	}

	/**
	 * ERP 주문상세번호로 쇼핑몰 주문상세번호 조회
	 */
	@Override
	public OrderMapDTO getMallOrderDtlNo(String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		param.setErpOrderDtlNo(erpOrderDtlNo);
		param.setErpOrderAddNo(erpOrderAddNo);
		return mappingDao.getMallOrderDtlNo(param);
	}

	/**
	 * 쇼핑몰 주문상세번호로 ERP 주문상세번호 조회
	 */
	@Override
	public OrderMapDTO getErpOrderDtlNo(String mallOrderNo, String mallOrderDtlNo) throws Exception {
		return this.getErpOrderDtlNo(mallOrderNo, null, mallOrderDtlNo);
	}
	
	@Override
	public OrderMapDTO getErpOrderDtlNo(String mallOrderNo, String mallClaimNo, String mallOrderDtlNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallOrderNo(mallOrderNo);
		param.setMallClaimNo(mallClaimNo);
		param.setMallOrderDtlNo(mallOrderDtlNo);
		return mappingDao.getErpOrderDtlNo(param);
	}

	/**
	 * 쇼핑몰-ERP 주문상세번호 매핑 정보 등록
	 */
	@Override
	public void insertOrderDtlNoMap(String mallOrderNo, String mallOrderDtlNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo)
			throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallOrderNo(mallOrderNo);
		param.setMallOrderDtlNo(mallOrderDtlNo);
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		param.setErpOrderDtlNo(erpOrderDtlNo);
		param.setErpOrderAddNo(erpOrderAddNo);
		mappingDao.insertOrderDtlNoMap(param);
	}
	

	/**
	 * 쇼핑몰 - ERP 반품 번호 매핑 정보 등록
	 */
	@Override
	public void insertClaimNoMap(String mallClaimNo, String mallOrderNo, String mallOrderDtlNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallClaimNo(mallClaimNo);
		param.setMallOrderNo(mallOrderNo);
		param.setMallOrderDtlNo(mallOrderDtlNo);
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		param.setErpOrderDtlNo(erpOrderDtlNo);
		param.setErpOrderAddNo(erpOrderAddNo);
		mappingDao.insertClaimNoMap(param);
	}
	
	/**
	 * 쇼핑몰 반품 번호로 ERP 반품주문 번호 조회
	 */
	@Override
	public OrderMapDTO getErpClaimNo(String mallClaimNo, String mallOrderNo, String mallOrderDtlNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setMallClaimNo(mallClaimNo);
		param.setMallOrderNo(mallOrderNo);
		param.setMallOrderDtlNo(mallOrderDtlNo);
		return mappingDao.getErpClaimNo(param);
	}
	
	/**
	 * ERP 반품주문 번호로 쇼핑몰 반품번호 조회
	 */
	@Override
	public OrderMapDTO getMallClaimNo(String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception {
		OrderMapDTO param = new OrderMapDTO();
		param.setErpOrdDate(erpOrdDate);
		param.setErpStrCode(erpStrCode);
		param.setErpOrdSlip(erpOrdSlip);
		param.setErpOrderDtlNo(erpOrderDtlNo);
		param.setErpOrderAddNo(erpOrderAddNo);
		return mappingDao.getMallClaimNo(param);
	}
	
	/**
	 * 쇼핑몰 회원번호로 ERP 회원번호 조회
	 */
	@Override
	public String getErpMemberNo(String mallMemberNo) throws Exception {
		return mappingDao.getErpMemberNo(mallMemberNo);
	}

	/**
	 * ERP 회원번호로 쇼핑몰 회원번호 조회
	 */
	@Override
	public String getMallMemberNo(String erpMemberNo) throws Exception {
		return mappingDao.getMallMemberNo(erpMemberNo);
	}

	/**
	 * 쇼핑몰-ERP 회원번호 매핑 정보 등록
	 */
	@Override
	public void insertMemberMap(String mallMemberNo, String erpMemberNo, String erpMemberLvl) throws Exception {
		// 기존 매핑 데이터 확인
		String existErpMemNo = this.getErpMemberNo(mallMemberNo);
		if(existErpMemNo != null) {
			// 이미 통합된 회원입니다.
			throw new CustomException("ifapi.exception.member.combine.already");
		}
		String existMallMemNo = this.getMallMemberNo(erpMemberNo);
		if(existMallMemNo != null) {
			// 이미 통합된 회원입니다.
			throw new CustomException("ifapi.exception.member.combine.already");
		}
		
		// 데이터 등록
		mappingDao.insertMemberMap(mallMemberNo, erpMemberNo, erpMemberLvl);
	}
	
	/**
	 * 쇼핑몰 -ERP 회원번호 매핑 정보 삭제
	 */
	@Override
	public void deleteMemberMap(String mallMemberNo, String erpMemberNo) throws Exception {
		mappingDao.deleteMemberMap(mallMemberNo, erpMemberNo);
	}

	/**
	 * 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (쇼핑몰 회원번호 기준)
	 */
	@Override
	public void deleteMemberMapByMall(String mallMemberNo) throws Exception {
		mappingDao.deleteMemberMapByMall(mallMemberNo);
	}

	/**
	 * 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (ERP 회원번호 기준)
	 */
	@Override
	public void deleteMemberMapByErp(String erpMemberNo) throws Exception {
		mappingDao.deleteMemberMapByErp(erpMemberNo);
	}

	/**
	 * 쇼핑몰-ERP 사전예약 기획전 매핑 정보 등록
	 */
	@Override
	public void insertPOMap(String mallPrmtNo, String erpPrmtNo) throws Exception {
		mappingDao.insertPOMap(mallPrmtNo, erpPrmtNo);
	}

	/**
	 * 쇼핑몰 기획전 번호로 ERP 사전예약 번호 조회
	 */
	@Override
	public String getErpPrmtNo(String mallPrmtNo) throws Exception {
		return mappingDao.getErpPrmtNo(mallPrmtNo);
	}

	/**
	 * ERP 사전예약 번호로 쇼핑몰 기획전 번호 조회
	 */
	@Override
	public String getMallPrmtNo(String erpPrmtNO) throws Exception {
		return mappingDao.getMallPrmtNo(erpPrmtNO);
	}
	
	/**
	 * 쇼핑몰-ERP 오프라인포인트 매핑 정보 등록
	 */
	@Override
	public void insertOfflinePointMap(OffPointMapDTO param) throws Exception {
		mappingDao.insertOfflinePointMap(param);
	}
	
	/**
	 * 쇼핑몰 주문번호로 ERP 포인트 로그번호 조회
	 */
	@Override
	public OffPointMapDTO getOfflinePointMapByMall(OffPointMapDTO param) throws Exception {
		return mappingDao.getOfflinePointMapByMall(param);
	}
	
	/**
	 * 쇼핑몰 주문번호로 ERP 포인트 로그 매핑 삭제
	 */
	@Override
	public void deleteOfflinePointMapByMall(OffPointMapDTO param) throws Exception {
		mappingDao.deleteOfflinePointMapByMall(param);
	}

	/**
	 * 주문 및 주문 상세 매핑 정보 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void insertOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception {
		
		// 주문 번호 매핑 저장
		this.insertOrderNoMap(param.getMallOrderNo(), param.getErpOrdDate(), param.getErpStrCode(), param.getErpOrdSlip(), param.getOrdRute());
		// 주문상세 매핑 저장
		for(OrderDtlMapDTO dtlMap : param.getOrdDtlMapList()) {
			String dtlMallOrderNo = dtlMap.getMallOrderNo();
			if(dtlMallOrderNo == null || "".equals(dtlMallOrderNo)) {
				dtlMallOrderNo = param.getMallOrderNo();
			}
			this.insertOrderDtlNoMap(dtlMallOrderNo, dtlMap.getMallOrderDtlNo(), param.getErpOrdDate(), param.getErpStrCode(), param.getErpOrdSlip(), dtlMap.getErpOrderDtlNo(), dtlMap.getErpOrderAddNo());
		}
	}
	
	/**
	 * 주문 및 주문상세 매핑 제거
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void deleteOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception {
		OrderMapDTO delParam = new OrderMapDTO();
		delParam.setMallOrderNo(param.getMallOrderNo());
		// 주문 매핑 삭제
		mappingDao.deleteOrderMap(delParam);
		// 주문 상세 매핑 삭제
		mappingDao.deleteOrderDtlMap(delParam);
	}

	/**
	 * 반품 매핑 정보 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void insertReturnMap(ReturnMapRegReqDTO param) throws Exception {
		for(ReturnMapDTO map : param.getMapList()) {
			// 매핑 정보 저장 
			this.insertClaimNoMap(map.getMallClaimNo(), map.getMallOrderNo(), map.getMallOrderDtlNo(), map.getErpOrdDate(), map.getErpStrCode(), map.getErpOrdSlip(), map.getErpOrderDtlNo(), map.getErpOrderAddNo());
		}
	}

	/**
	 * 오프라인 포인트 사용 매핑 정보 등록
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void insertOfflinePointMap(OffPointMapRegReqDTO param) throws Exception {

		if(Constants.ORDER_MAP_ORDER_TYPE.RETURN.equals(param.getMallOrderType())) {
			// 반품이면 원거래 데이터 삭제
			OffPointMapDTO delParam = new OffPointMapDTO();
			delParam.setMallOrderNo(param.getMallOrderNo());
			delParam.setMallOrderType(Constants.ORDER_MAP_ORDER_TYPE.ORDER);
			this.deleteOfflinePointMapByMall(delParam);
		}
		
		for(String erpSeq : param.getErpSeqNo()) {
			OffPointMapDTO mapDto = new OffPointMapDTO();
			mapDto.setMallOrderNo(param.getMallOrderNo());
			mapDto.setMallOrderType(param.getMallOrderType());
			mapDto.setErpDates(param.getErpDates());
			mapDto.setErpMemberNo(param.getErpMemberNo());
			mapDto.setErpSeqNo(erpSeq);
			this.insertOfflinePointMap(mapDto);
		}
	}

}
