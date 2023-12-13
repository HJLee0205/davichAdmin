package net.danvi.dmall.biz.system.aspect;

import com.ckd.common.reqInterface.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.remote.homepage.model.HomepageIfLogPO;
import net.danvi.dmall.biz.system.remote.homepage.service.HomepageRemoteDelegateService;
import net.danvi.dmall.biz.system.remote.maru.model.MaruResult;
import net.danvi.dmall.biz.system.service.LoggerService;
import net.danvi.dmall.core.remote.homepage.model.request.RemoteBaseModel;
import net.danvi.dmall.core.remote.homepage.service.SiteRemoteService;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 홈페이지 연계 로그 등록 Aspect
 */
@Aspect
@Component
@Slf4j
public class HomepageIfLogAspect {

    @Resource(name = "loggerService")
    private LoggerService loggerService;

    @Pointcut("execution(public * *(..))")
    private void anyPublicOperation() {}

    @Pointcut("target(net.danvi.dmall.core.remote.homepage.service.SiteRemoteService) || target(net.danvi.dmall.biz.system.remote.homepage.service.HomepageRemoteDelegateService)")
    private void remoteService() {}

    @Before("anyPublicOperation() && remoteService()")
    public void before(JoinPoint joinPoint) {
        log.debug("홈페이지 연계 로그 ");
        String siteId = null;
        Long siteNo = null;
        RemoteBaseModel temp;
        RemoteVO remoteVO;

        for (Object arg : joinPoint.getArgs()) {
            log.debug(ToStringBuilder.reflectionToString(arg, ToStringStyle.MULTI_LINE_STYLE));

            if(arg instanceof RemoteBaseModel) {
                temp = (RemoteBaseModel)arg;
                siteId = temp.getSiteId();
                siteNo = temp.getSiteNo();
            } else if(arg instanceof RemoteVO) {
                remoteVO = (RemoteVO)arg;
                siteId = remoteVO.getSiteId();
                siteNo = remoteVO.getSiteNo();
            } else if(arg instanceof DiskTrafficResult) {
                siteId = ((DiskTrafficResult)arg).getSiteId();
                siteNo = ((DiskTrafficResult)arg).getSiteNo();
            } else if(arg instanceof DomainLinkResult) {
                siteId = ((DomainLinkResult)arg).getSiteId();
                siteNo = ((DomainLinkResult)arg).getSiteNo();
            } else if(arg instanceof ImageHostingResult) {
                siteId = ((ImageHostingResult)arg).getSiteId();
                siteNo = ((ImageHostingResult)arg).getSiteNo();
            } else if(arg instanceof PGActiveResult) {
                siteId = ((PGActiveResult)arg).getSiteId();
                siteNo = ((PGActiveResult)arg).getSiteNo();
            } else if(arg instanceof ShoppingMallAdminResult) {
                siteId = ((ShoppingMallAdminResult)arg).getSiteId();
                siteNo = ((ShoppingMallAdminResult)arg).getSiteNo();
            } else if(arg instanceof SolutionResult) {
                siteId = ((SolutionResult)arg).getSiteId();
                siteNo = ((SolutionResult)arg).getSiteNo();
            }
        }

        if(siteId != null) {
            ObjectMapper om = new ObjectMapper();
            String ifContent = null;
            try {
                ifContent = om.writeValueAsString(joinPoint.getArgs());
            } catch (JsonProcessingException e) {
                log.error("인터페이스 객체 매핑 처리 오류", e);
                return;
            }

            String ioGb;
            if(joinPoint.getTarget() instanceof SiteRemoteService) {
                ioGb = "I";
            } else if(joinPoint.getTarget() instanceof HomepageRemoteDelegateService) {
                ioGb = "O";
            } else {
                log.warn("정의되지 않은 인터페이스, {}", ifContent);
                return;
            }

            HomepageIfLogPO po = new HomepageIfLogPO();
            po.setSiteId(siteId);
            po.setSiteNo(siteNo);
            po.setIoGb(ioGb);

            log.debug("{}",joinPoint);
            log.debug("{}",joinPoint.getKind());
            log.debug("{}",joinPoint.getSignature().getName());
            log.debug("{}",joinPoint.getSignature().getDeclaringTypeName());

            switch (joinPoint.getSignature().getName()) {
                case "createSite":
                    po.setIfGbCd("01");
                    break;
                case "setSiteStatus":
                    po.setIfGbCd("02");
                    break;
                case "getSiteStatus":
                    po.setIfGbCd("03");
                    break;
                case "setSslInfo":
                    po.setIfGbCd("04");
                    break;
                case "setSmsSenderCertInfo":
                    po.setIfGbCd("05");
                    break;
                case "setPaymentInfo":
                    po.setIfGbCd("06");
                    break;
                case "setSiteServiceTerm":
                    po.setIfGbCd("07");
                    break;
                case "setSkinPayInfo":
                    po.setIfGbCd("08");
                    break;
                case "setAdminPassword":
                    po.setIfGbCd("09");
                    break;
                case "setDomain":
                    po.setIfGbCd("10");
                    break;
                case "setImageHosting":
                    po.setIfGbCd("11");
                    break;
                case "setHostingInfo":
                    po.setIfGbCd("12");
                    break;
                case "setCreateMallResult":
                    po.setIfGbCd("51");
                    break;
                case "setChangeStatusResult":
                    po.setIfGbCd("52");
                    break;
                case "reqImageHostingResult":
                    po.setIfGbCd("53");
                    break;
                case "reqDiskTrafficResult":
                    po.setIfGbCd("54");
                    break;
                case "reqDomainLinkInfoResult":
                    po.setIfGbCd("55");
                    break;
                case "reqPGActiveInfo":
                    po.setIfGbCd("56");
                    break;
                case "reqSolutionAdminLoginHistoryInfo":
                    po.setIfGbCd("57");
                    break;
                case "reqShoppingMallAdminPasswordChangeResult":
                    po.setIfGbCd("58");
                    break;
                default:
                    log.warn("정의되지 않은 인터페이스 {}", joinPoint);
            }

            po.setIfContent(ifContent);
            log.debug("{}", po);

            loggerService.insertHomepageIf(po);
        } else {
            log.warn("정의되지 않은 인터페이스, 사이트ID 존재하지 않음. {}", joinPoint);
        }
    }

    @Pointcut("within(@org.springframework.stereotype.Controller *) && execution(* maru(..))")
    private void maruResultControllerTarget() {}

    @Before("maruResultControllerTarget()")
    public void beforeMaru(JoinPoint joinPoint) throws JsonProcessingException {
        log.debug("마루 결과값 연계 로그 ");

        MaruResult result = null;

        for (Object arg : joinPoint.getArgs()) {
            log.debug(ToStringBuilder.reflectionToString(arg, ToStringStyle.MULTI_LINE_STYLE));

            if(arg instanceof MaruResult) {
                result = (MaruResult)arg;
            }
        }
        if(result != null) {
            loggerService.insertMaruResultIf(result);
        }
    }
}
