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
 * 설명       : 상품 등록 Tasklet
 * </pre>
 */
public class GoodsRegiTasklet implements Tasklet {

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

        vo.setSendGoodsCdRt(SabangnetConstant.SEND_GOODS_CD_RT); // 상품정보반환여부
        vo.setIfId(SabangnetConstant.IF_ID_GOODS);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_GOODS);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_GOODS);
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
        vo.setSendInvEditYn("");
        vo.setCsStatus("");

        String domain = param.getString(SabangnetConstant.DOMAIN);

        sabangnetService.registGoods(vo, domain); // 사방넷서비스.상품등록

        return RepeatStatus.FINISHED;
    }
}
