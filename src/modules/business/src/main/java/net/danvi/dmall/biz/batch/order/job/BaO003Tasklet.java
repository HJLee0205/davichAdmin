package net.danvi.dmall.biz.batch.order.job;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 구매확정 Tasklet
 * </pre>
 */
public class BaO003Tasklet implements Tasklet {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setRegrNo(300L); // 배치 > 시스템, 필요할 경우 배치 > 시스템 > 사방넷연계 로 101L등으로 수정
        vo.setUpdrNo(300L); // 배치 > 시스템
        vo.setSiteNo(param.getLong(SabangnetConstant.SITE_NO));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        String domain = param.getString(SabangnetConstant.DOMAIN);

        // 배송완료 + 3 경과 조회
        int cnt = 3;

        List<OrderGoodsVO> orderGoodsList = deliveryService.selectDeliveryCompletedList(cnt);
        
        //주문상세 - 구매확정
        if (orderGoodsList.size() > 0) {
            for (int i = 0; i < orderGoodsList.size(); i++) {
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO = orderGoodsList.get(i);
                // 구매확정 업데이트 
                orderGoodsVO.setOrdDtlStatusCd("90");
                orderGoodsVO.setRegrNo(CommonConstants.MEMBER_BATCH_SYSTEM);
                orderService.updateOrderDtl(orderGoodsVO);
            }
        }

        //주문 - 구매확정 
        if (orderGoodsList.size() > 0) {
            for (int i = 0; i < orderGoodsList.size(); i++) {
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO = orderGoodsList.get(i);
                // 구매확정 업데이트 및 구매마켓포인트 지급
                orderGoodsVO.setOrdDtlStatusCd("90");
                orderGoodsVO.setRegrNo(CommonConstants.MEMBER_BATCH_SYSTEM);
                orderService.updateOrdStatusCdConfirm(orderGoodsVO);
            }
        }

        return null;
    }
}
