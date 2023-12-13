package net.danvi.dmall.biz.batch.link.sabangnet.batch.job;

import javax.annotation.Resource;

import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.service.SabangnetService;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 송장 등록 Tasklet
 * </pre>
 */
public class InvoiceRegiTasklet implements Tasklet {

    @Resource(name = "sabangnetService")
    private SabangnetService sabangnetService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {

        // 잡 파라미터
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();
        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setSendCompaynyId(param.getString(SabangnetConstant.SEND_COMPAYNY_ID));
        vo.setSendAuthKey(param.getString(SabangnetConstant.SEND_AUTH_KEY));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        vo.setSiteNo(param.getLong(SabangnetConstant.SITE_NO));
        vo.setSiteId(param.getString(SabangnetConstant.SITE_ID));
        vo.setSiteNm(param.getString(SabangnetConstant.SITE_NM));

        vo.setSendInvEditYn(SabangnetConstant.SEND_INV_EDIT_YN); // 송장정보수정여부
        vo.setIfId(SabangnetConstant.IF_ID_INVOICE);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_INVOICE);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_INVOICE);
        vo.setIfGbCd(SabangnetConstant.IF_GB_CD);
        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 등록자 번호
        vo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 수정자 번호
        vo.setLang(param.getString(SabangnetConstant.LANG)); // 인코딩타입

        vo.setStDate("");
        vo.setEdDate("");
        vo.setOrdField("");
        vo.setClmField("");
        vo.setJungChkYn2("");
        vo.setOrderId("");
        vo.setMallId("");
        vo.setSendGoodsCdRt("");
        vo.setCsStatus("");

        String domain = param.getString(SabangnetConstant.DOMAIN);

        sabangnetService.registInvoice(vo, domain); // 사방넷서비스.송장등록

        return RepeatStatus.FINISHED;
    }
}
