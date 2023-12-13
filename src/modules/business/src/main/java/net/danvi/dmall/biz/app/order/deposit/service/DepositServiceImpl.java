package net.danvi.dmall.biz.app.order.deposit.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.order.deposit.model.DepositSO;
import net.danvi.dmall.biz.app.order.deposit.model.DepositVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * Created by dong on 2016-05-02.
 */
/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 무통장/가상계좌 목록 컴포넌트의 서비스 인터페이스
 * </pre>
 */
@Slf4j
@Service("depositService")
@Transactional(rollbackFor = Exception.class)
public class DepositServiceImpl extends BaseService implements DepositService {

    @Resource(name = "orderService")
    private OrderService orderService;

    /**
     * 무통장 가상계좌 주문 목록 조회
     */
    @Override
    public ResultListModel<DepositVO> selectDepositListPaging(DepositSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        ResultListModel<DepositVO> resultListModel = proxyDao
                .selectListPage(MapperConstants.ORDER_DEPOSIT + "selectDepositListPaging", so);
        return resultListModel;

    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<DepositVO> selectDepositListExcel(DepositSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<DepositVO> resultList = proxyDao.selectList(MapperConstants.ORDER_DEPOSIT + "selectDepositListPaging", so);
        return resultList;

    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : kdy
     * 설명   : 무통장 결제 완료일시 변경 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws CustomException
     */
    public boolean updateOrdStatusPayDoneCommon(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException {
        int rCnt = 0;
        try {
            OrderInfoVO infoVO = new OrderInfoVO();
            infoVO.setOrdNo(vo.getOrdNo());
            infoVO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
            infoVO = orderService.selectOrdDtlInfo(infoVO);
            // 무통장/가상계좌 결제 처리의 경우에만 별도 처리
            if ("11".equals(infoVO.getPaymentWayCd()) || "22".equals(infoVO.getPaymentWayCd())) {
                log.debug("----------------무통장/가상계좌 결제 처리 ------------");
                ResultModel<OrderInfoVO> result = new ResultModel<>();
                vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                if (vo.getRegrNo() == null || ("").equals(vo.getRegrNo())) {
                    vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    vo.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                }

                rCnt = proxyDao.update(MapperConstants.ORDER_DEPOSIT + "updateOrdStatusPayDone", vo);

                // 재고 차감 처리
                List<OrderGoodsVO> goodsVoList = orderService.selectOrdDtlList(infoVO);
                List<OrderGoodsPO> goodsPoList = new ArrayList();
                for (OrderGoodsVO gvo : goodsVoList) {
                    OrderGoodsPO goodsPO = new OrderGoodsPO();
                    if ("N".equals(gvo.getAddOptYn())) {
                        goodsPO.setOrdNo(new Long(gvo.getOrdNo()));
                        goodsPO.setOrdDtlSeq(new Long(gvo.getOrdDtlSeq()));
                        goodsPO.setItemNo(gvo.getItemNo());
                        goodsPO.setOrdQtt(new Long(gvo.getOrdQtt()));
                        goodsPO.setAddOptYn(gvo.getAddOptYn());
                        goodsPoList.add(goodsPO);
                    }
                }
                orderService.updateGoodsStock(goodsPoList);
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }
        return (rCnt > 0) ? true : false;
    }

    /**
     * 무통장/가상계좌의 결제 처리
     */
    public boolean updateOrdStatusPayDone(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException {

        ResultModel<OrderInfoVO> result = new ResultModel<>();
        try {
            OrderGoodsVO curVo = orderService.selectCurOrdStatus(vo);
            if (curVo.getOrdStatusCd().equals(curOrdStatusCd)) {
                // updateOrdStatusPayDoneCommon(vo, curOrdStatusCd);
                result = orderService.updateOrdStatus(vo, curOrdStatusCd);
                if (!result.isSuccess())
                    throw new CustomException("biz.exception.ord.invalidOrdStatus", new Object[] { vo.getOrdNo() });
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }
        return result.isSuccess();
    }
}
