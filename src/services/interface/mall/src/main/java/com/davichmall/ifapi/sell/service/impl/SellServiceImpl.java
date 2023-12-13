package com.davichmall.ifapi.sell.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.sell.dao.SellDAO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoResDTO.OfflineBuyInfoDTO;
import com.davichmall.ifapi.sell.dto.OfflineRecvCompReqDTO;
import com.davichmall.ifapi.sell.service.SellService;
import com.davichmall.ifapi.util.SessionUtil;

import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.sell.service.impl
 * - 파일명        : SellServiceImpl.java
 * - 작성일        : 2018. 5. 17.
 * - 작성자        : CBK
 * - 설명          : [판매]분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("sellService")
public class SellServiceImpl implements SellService {

	@Resource(name="sellDao")
	SellDAO sellDao;

	@Resource(name="orderService")
	OrderService orderService;

	/**
	 * 고객판매완료 (구매확정처리)
	 */
	@Transactional(transactionManager="transactionManager")
	@Override
	public void completeOfflineRecv(OfflineRecvCompReqDTO param) throws Exception {

		SessionUtil.setMallSession();
		
		// 각 상품별로 구매확정 처리
		for(String dtlSeq : param.getMallOrdDtlSeq()) {
			OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
			orderGoodsVO.setSiteNo(Constants.SITE_NO);
			orderGoodsVO.setOrdNo(param.getMallOrderNo());
			orderGoodsVO.setOrdDtlSeq(dtlSeq);
			orderGoodsVO.setOrdStatusCd("90"); // 구매확정
			orderGoodsVO.setUpdrNo(Constants.IF_REGR_NO);
			
			OrderGoodsVO curVo = orderService.selectCurOrdStatus(orderGoodsVO);
			String curOrdStatusCd = curVo.getOrdStatusCd(); // 현재 상태
			
			orderService.updateOrdStatus(orderGoodsVO, curOrdStatusCd);
		}
	}
	
	/**
	 * 오프라인 구매 목록 조회
	 */
	@Override
	public List<OfflineBuyInfoDTO> selectOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception {
		
		return sellDao.selectOfflineBuyInfoList(param);
	}


	/**
	 * 오프라인 구매 목록 데이터 개수 조회
	 */
	@Override
	public int countOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception {
		return sellDao.countOfflineBuyInfoList(param);
	}

}
