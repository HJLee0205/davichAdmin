package net.danvi.dmall.biz.ifapi.sell.service.impl;

import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.BaseService;
import net.danvi.dmall.biz.ifapi.sell.service.SellService;
import net.danvi.dmall.biz.ifapi.util.SessionUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import net.danvi.dmall.biz.ifapi.sell.dto.OfflineBuyInfoResDTO.OfflineBuyInfoDTO;
import net.danvi.dmall.biz.ifapi.sell.dto.OfflineRecvCompReqDTO;

import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.sell.service.impl
 * - 파일명        : SellServiceImpl.java
 * - 작성일        : 2018. 5. 17.
 * - 작성자        : CBK
 * - 설명          : [판매]분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("sellService")
public class SellServiceImpl extends BaseService implements SellService {

	@Resource(name="orderService")
	OrderService orderService;

	/**
	 * 고객판매완료 (구매확정처리)
	 */
//	@Transactional(transactionManager="transactionManager")
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
		
		return proxyDao.selectList("sell.selectOfflineBuyInfoList", param);
	}


	/**
	 * 오프라인 구매 목록 데이터 개수 조회
	 */
	@Override
	public int countOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception {
		return proxyDao.selectOne("sell.countOfflineBuyInfoList", param);
	}

}
