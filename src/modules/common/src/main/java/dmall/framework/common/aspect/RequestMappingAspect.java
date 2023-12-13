package dmall.framework.common.aspect;

import java.util.Map;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.LucyUtil;

/**
 * Bo RequestMapping Aspect
 * 
 * @author snw
 * @since 2015.06.13
 */
@Component
@Aspect
@Slf4j
@Order(1)
public class RequestMappingAspect {

    @Pointcut("within(@org.springframework.stereotype.Controller *) && @annotation(requestMapping) && execution(* *(..))")
    private void requestMappingTarget(RequestMapping requestMapping) {
    }

    @Before("requestMappingTarget(requestMapping)")
    public void beforeLogging(JoinPoint joinPoint, RequestMapping requestMapping) throws Exception {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getName();
        log.debug("=======================================================================");
        log.debug("= {} : {}", "RequestMapping URL", requestMapping.value());
        log.debug("= {} {} {}", className, methodName, "Start");
        log.debug("=======================================================================");

        log.debug("=======================================================================");
        log.debug("= {}", "파라미터 Start");
        log.debug("=======================================================================");

        log.debug("URI {}", HttpUtil.getHttpServletRequest().getRequestURI());

        for (Object args : joinPoint.getArgs()) {
            // 콘트롤러의 메소드 실행인자중 BaseModel 객체만 루시 필터 처리
           if(args instanceof BaseModel || args instanceof String || args instanceof Map) {
//               log.debug(ToStringBuilder.reflectionToString(args, ToStringStyle.MULTI_LINE_STYLE));
                LucyUtil.filter(HttpUtil.getHttpServletRequest().getRequestURI(), args);
            }

        }
        log.debug("=======================================================================");
        log.debug("= {}", "파라미터 End");
        log.debug("=======================================================================");
        log.debug("beforeLogging Exception : {}");
    }

    @AfterReturning("requestMappingTarget(requestMapping)")
    public void returningLogging(JoinPoint joinPoint, RequestMapping requestMapping) throws Exception {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getName();
        log.debug("=======================================================================");
        log.debug("= {} : {}", "RequestMapping URL", requestMapping.value());
        log.debug("= {} {} {}", className, methodName, "End");
        log.debug("=======================================================================");
    }

    @AfterThrowing("requestMappingTarget(requestMapping)")
    public void throwingLogging(JoinPoint joinPoint, RequestMapping requestMapping) throws Exception {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getName();
        log.debug("=======================================================================");
        log.debug("= {} : {}", "RequestMapping URL", requestMapping.value());
        log.debug("= {} {} {}", className, methodName, "Throwing");
        log.debug("=======================================================================");
    }
}
