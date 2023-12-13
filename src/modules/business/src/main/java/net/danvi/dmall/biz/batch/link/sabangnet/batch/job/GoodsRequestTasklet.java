/*
package net.danvi.dmall.biz.batch.link.sabangnet.batch.job;

import dmall.framework.common.constants.CommonConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.link.sabangnet.SabangnetConstant;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.service.SabangnetService;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;

import javax.annotation.Resource;

*/
/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 15.
 * 작성자     : dong
 * 설명       : 상품 정보 수집 Tasklet
 * </pre>
 *//*

@Slf4j
public class GoodsRequestTasklet implements Tasklet {

    @Resource(name = "sabangnetService")
    private SabangnetService sabangnetService;

    @Override
    public RepeatStatus execute(StepContribution stepContribution, ChunkContext chunkContext) throws Exception {
        JobParameters param = chunkContext.getStepContext().getStepExecution().getJobParameters();

        ProcRunnerVO vo = new ProcRunnerVO();
        vo.setSendCompaynyId(param.getString(SabangnetConstant.SEND_COMPAYNY_ID));
        vo.setSendAuthKey(param.getString(SabangnetConstant.SEND_AUTH_KEY));
        vo.setSendDate(param.getString(SabangnetConstant.SEND_DATE));
        vo.setSiteNo(param.getLong(SabangnetConstant.SITE_NO));
        vo.setSiteId(param.getString(SabangnetConstant.SITE_ID));
        vo.setSiteNm(param.getString(SabangnetConstant.SITE_NM));

        vo.setOrdField(SabangnetConstant.GOODS_PRT_FIELD); // 출력필드
        vo.setIfId(SabangnetConstant.IF_ID_GOODS_READ);
        vo.setIfPgmId(SabangnetConstant.IF_PGM_ID_GOODS_READ);
        vo.setIfPgmNm(SabangnetConstant.IF_PGM_NM_GOODS_READ);
        vo.setIfGbCd(SabangnetConstant.IF_GB_CD);
        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 등록자 번호
        vo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SBN); // 수정자 번호
        vo.setLang(param.getString(SabangnetConstant.LANG)); // 인코딩타입
        String domain = param.getString(SabangnetConstant.DOMAIN);

        // 잡 파라미터 조회 : 파일명
        String fileName = chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().getString("fileName");
        log.debug("8.0.상품수집 Tasklet fileName : {}", fileName);

        sabangnetService.getherGoods(domain, fileName, vo); // 사방넷서비스.상품수집

        return null;
    }
}
*/
