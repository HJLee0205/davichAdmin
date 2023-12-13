package net.danvi.dmall.biz.system.remote.homepage.service;

import com.ckd.common.remote.base.HelloFiveInterface;
import com.ckd.common.reqInterface.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.remoting.httpinvoker.HttpInvokerProxyFactoryBean;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * Created by dong on 2016-08-03.
 */
@Slf4j
@Service("homepageRemoteDelegateService")
public class HomepageRemoteDelegateServiceImpl implements HomepageRemoteDelegateService {

    @Value("#{core['system.homepage.remote.server']}")
    private String server;

    @Value("#{core['system.homepage.remote.path']}")
    private String path;

    public HelloFiveInterface getService() {
        HttpInvokerProxyFactoryBean httpInvokerProxyFactoryBean = new HttpInvokerProxyFactoryBean();
        httpInvokerProxyFactoryBean.setServiceInterface(HelloFiveInterface.class);
        httpInvokerProxyFactoryBean.setServiceUrl(server + path);
        httpInvokerProxyFactoryBean.afterPropertiesSet();

        log.debug("TARGET URL : {}", server + path);
        return (HelloFiveInterface) httpInvokerProxyFactoryBean.getObject();
    }

    @Override
    public CreateMallResult setCreateMallResult(CreateMallResult createMallResult) {
        // 쇼핑몰 생성 결과 전송
        CreateMallResult result = getService().reqCreateMallResult(createMallResult);
        log.debug("쇼핑몰 생성 결과 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public ChangeStatusResult setChangeStatusResult(ChangeStatusResult changeStatusResult) {
        // 쇼핑몰 상태 변경 결과 전송
        ChangeStatusResult result = getService().reqChangeStatusResult(changeStatusResult);
        log.debug("쇼핑몰 상태 변경 결과 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public RemoteVO reqImageHostingResult(ImageHostingResult imageHostingResult) {
        RemoteVO result = getService().reqImageHostingResult(imageHostingResult);
        log.debug("쇼핑몰 이미지 호스팅 생성 결과 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public RemoteVO reqDiskTrafficResult(DiskTrafficResult diskTrafficResult) {
        RemoteVO result =  getService().reqDiskTrafficResult(diskTrafficResult);
        log.debug("쇼핑몰 디스크/트래픽 변경 결과 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public RemoteVO reqDomainLinkInfoResult(DomainLinkResult domainLinkResult) {
        RemoteVO result =  getService().reqDomainLinkInfoResult(domainLinkResult);
        log.debug("쇼핑몰 도메인 연결 정보 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public RemoteVO reqPGActiveInfo(PGActiveResult pgActiveResult) {
        RemoteVO result =  getService().reqPGActiveInfo(pgActiveResult);
        log.debug("쇼핑몰 PG 활성화 정보 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    @Async
    public RemoteVO reqSolutionAdminLoginHistoryInfo(SolutionResult solutionResult) {
        RemoteVO result = getService().reqSolutionAdminLoginHistoryInfo(solutionResult);
        log.debug("쇼핑몰 로그인 이력 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }

    @Override
    public RemoteVO reqShoppingMallAdminPasswordChangeResult(ShoppingMallAdminResult shoppingMallAdminResult) {
        RemoteVO result =  getService().reqShoppingMallAdminPasswordChangeResult(shoppingMallAdminResult);
        log.debug("쇼핑몰 관리자 비밀번호 변경 결과 전송 : {}", ToStringBuilder.reflectionToString(result, ToStringStyle.MULTI_LINE_STYLE));
        return result;
    }
}
