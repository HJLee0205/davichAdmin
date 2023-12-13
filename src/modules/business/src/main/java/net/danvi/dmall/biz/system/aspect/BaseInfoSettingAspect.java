package net.danvi.dmall.biz.system.aspect;

import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.formula.functions.T;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.annotation.Order;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import eu.bitwalker.useragentutils.DeviceType;
import eu.bitwalker.useragentutils.OperatingSystem;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.model.parcel.ParcelModel;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.HttpUtil;

/**
 * 사용자 번호를 모델에 넣어주는 Aspect
 */
@Component
@Aspect
@Slf4j
@Order(0)
public class BaseInfoSettingAspect {

    @Resource(name = "siteService")
    private SiteService siteService;

    // 결제인터페이스 시스템변수 셋팅 처리
    @Value("#{system['system.solution.payment.realserviceyn']}")
    private String realServiceYn; // = N; PG실서비스여부 - PG거래를 위한 00.테스트, 01.실서비스 모드 설정 (예: LguPO.CST_PLATFORM )
    @Value("#{core['core.payment.common.approverollbackyn']}")
    private String paymentApproveRollBackYn; // = N; 결제승인결과RollBack여부, 승인성공에 대한 DB처리 실패시 재요청하여 매입전취소로 처리여부

    @Pointcut("within(@org.springframework.stereotype.Controller *) && @annotation(requestMapping) && execution(* *(..))")
    private void requestMappingTarget(RequestMapping requestMapping) {
    }

    @Before("requestMappingTarget(requestMapping)")
    public void before(JoinPoint joinPoint, RequestMapping requestMapping) throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getDetails() == null) return;
        if (authentication.getDetails() instanceof WebAuthenticationDetails) return;
        DmallSessionDetails dmallSessionDetails = (DmallSessionDetails) authentication.getDetails();
        Session session = dmallSessionDetails.getSession();
        HttpServletRequest request;
        UserAgent ua;
        StringTokenizer token;

        for (Object args : joinPoint.getArgs()) {
            if (args instanceof BaseModel || args instanceof PaymentModel) {
                ((BaseModel<?>) args).setSiteNo(session.getSiteNo());
                ((BaseModel<?>) args).setRegrNo(session.getMemberNo());
                ((BaseModel<?>) args).setUpdrNo(session.getMemberNo());
                ((BaseModel<?>) args).setDelrNo(session.getMemberNo());

                // PaymentModel extends BaseModel
                if (args instanceof PaymentModel || args instanceof ParcelModel) {
                    request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
                    ua = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
                    log.debug("UserAgent : {}", ua);
                    log.debug("OS : {}", ua.getOperatingSystem());
                    log.debug("OS.name : {}", ua.getOperatingSystem().getName());
                    log.debug("DeviceType : {}", ua.getOperatingSystem().getDeviceType());
                    log.debug("DeviceType.name : {}", ua.getOperatingSystem().getDeviceType().getName());

                    if (args instanceof PaymentModel) {
                        // 결제미디어코드 , 결제모바일OS코드
                        if (ua.getOperatingSystem().getDeviceType() == DeviceType.COMPUTER) {
                            ((PaymentModel<?>) args).setMediaCd(CommonConstants.MEDIA_CD_PC); // 결제미디어코드 - 01.PC 02.모바일
                            ((PaymentModel<?>) args).setMobileOsCd(""); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                        } else {
                            if(ua.getOperatingSystem().getDeviceType() == DeviceType.UNKNOWN){
                            ((PaymentModel<?>) args).setMediaCd(CommonConstants.MEDIA_CD_PC);

                            }else {
                                ((PaymentModel<?>) args).setMediaCd(CommonConstants.MEDIA_CD_MOBILE); // 결제미디어코드 - 01.PC 02.모바일
                            }

                            if (ua.getOperatingSystem().getGroup() == OperatingSystem.ANDROID) {
                                ((PaymentModel<?>) args).setMobileOsCd(CommonConstants.MOBILE_OS_ANDROID); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                            } else {
                                ((PaymentModel<?>) args).setMobileOsCd(CommonConstants.MOBILE_OS_IOS); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                            }
                        }
                        // 결제PG주체코드
                        if (request.getRequestURI().startsWith("/admin")) {
                            ((PaymentModel<?>) args).setMainCd(CommonConstants.SERVER_CD_BO); // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우), 03.DMALL(BO일경우)
                        } else {
                            ((PaymentModel<?>) args).setMainCd(CommonConstants.SERVER_CD_FO); // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우), 03.DMALL(BO일경우)
                        }
                        // 주문자IP
                        ((PaymentModel<?>) args).setOrdrIp(HttpUtil.getClientIp(request)); // 주문자IP
                    } else if (args instanceof ParcelModel) {
                        // 결제미디어코드 , 결제모바일OS코드
                        if (ua.getOperatingSystem().getDeviceType() == DeviceType.COMPUTER) {
                            ((ParcelModel<?>) args).setMediaCd(CommonConstants.MEDIA_CD_PC); // 결제미디어코드 - 01.PC 02.모바일
                            ((ParcelModel<?>) args).setMobileOsCd(""); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                        } else {
                            ((ParcelModel<?>) args).setMediaCd(CommonConstants.MEDIA_CD_MOBILE); // 결제미디어코드 - 01.PC 02.모바일

                            if (ua.getOperatingSystem().getGroup() == OperatingSystem.ANDROID) {
                                ((ParcelModel<?>) args).setMobileOsCd(CommonConstants.MOBILE_OS_ANDROID); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                            } else {
                                ((ParcelModel<?>) args).setMobileOsCd(CommonConstants.MOBILE_OS_IOS); // 결제모바일OS코드 - 01.안드로이드 02.IOS
                            }
                        }
                        // 결제PG주체코드
                        if (request.getRequestURI().startsWith("/admin")) {
                            ((ParcelModel<?>) args).setMainCd(CommonConstants.SERVER_CD_BO); // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우), 03.DMALL(BO일경우)
                        } else {
                            ((ParcelModel<?>) args).setMainCd(CommonConstants.SERVER_CD_FO); // 결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우), 03.DMALL(BO일경우)
                        }
                    }
                }
            } else if (args instanceof BaseSearchVO) {
                // 검색조건 VO에 대한 기본 데이터 세팅
                token = new StringTokenizer(((BaseSearchVO<T>) args).getSort(), " ");

                ((BaseSearchVO<?>) args).setSiteNo(session.getSiteNo());

                if (token.countTokens() == 2) {
                    ((BaseSearchVO<?>) args).setSidx(token.nextToken());
                    ((BaseSearchVO<?>) args).setSord(token.nextToken());
                } else if (token.countTokens() == 1) {
                    ((BaseSearchVO<?>) args).setSidx(token.nextToken());
                }
            }
        }
    }
}
