package net.danvi.dmall.biz.batch.order.job;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.order.service.BatchOrderService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import dmall.framework.common.util.StringUtil;


/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 30.
 * 작성자     : KNG
 * 설명       : 입금누락 SMS 발송 처리 tasklet
 * </pre>
 */
public class BaO004Tasklet implements Tasklet {

    @Resource(name = "batchOrderService")
    private BatchOrderService batchOrderService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        Map<String, Object> inParam = new HashMap<String, Object>();
        if(!StringUtil.isEmpty(param.getString("stdDate"))) {inParam.put("stdDate", param.getString("stdDate"));}
        if(!StringUtil.isEmpty(param.getLong("intCnt"))) {inParam.put("intCnt", param.getLong("intCnt"));}
        if(!StringUtil.isEmpty(param.getString("jobId"))) {inParam.put("jobId", param.getString("jobId"));}
        if(!StringUtil.isEmpty(param.getString("sendDate"))) {inParam.put("sendDate", param.getString("sendDate"));}
        if(!StringUtil.isEmpty(param.getLong("ordNo"))) {inParam.put("ordNo", param.getLong("ordNo"));}
        List<Map> OrdNoneDepositList = batchOrderService.OrdNoneDepositList(inParam);
        for (int i = 0; i < OrdNoneDepositList.size(); i++) {
            batchOrderService.sendOrdAutoSms("","13", OrdNoneDepositList.get(i).get("SITE_NO").toString() , OrdNoneDepositList.get(i).get("ORD_NO").toString());
        }
        return RepeatStatus.FINISHED;
    }
}
