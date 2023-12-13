package net.danvi.dmall.biz.system.aspect;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.web.bind.annotation.RequestMapping;
import dmall.framework.common.annotation.BannedWordReplace;
import dmall.framework.common.util.StringUtil;

import javax.annotation.Resource;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.List;

/**
 * 금칙어 마스킹 Aspect
 * 
 */
@Slf4j
public class BannedWordReplaceAspect {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Pointcut("within(@org.springframework.stereotype.Controller *) && @annotation(requestMapping) && execution(* *(..))")
    protected void requestMappingTarget(RequestMapping requestMapping) {
    }

    @Before("requestMappingTarget(requestMapping)")
    public void before(JoinPoint joinPoint, RequestMapping requestMapping) throws Exception {

        Class cls;
        Annotation a;
        String replacedValue;

        Session s = SessionDetailHelper.getSession();
        if(s == null) return;

        SiteCacheVO siteCacheVO = siteService.getSiteInfo(s.getSiteNo());
        List<String> list = siteCacheVO.getBannedWordList();
        String regx = StringUtils.join(list, "|");

        for (Object args : joinPoint.getArgs()) {
//            log.debug(ToStringBuilder.reflectionToString(args, ToStringStyle.MULTI_LINE_STYLE));
            cls = args.getClass();

            for(Field field : cls.getDeclaredFields()) {
                a = field.getAnnotation(BannedWordReplace.class);

                if(a != null && a.annotationType() == BannedWordReplace.class) {
                    log.debug("필드 {}.{} 마스킹", cls.getName(), field.getName());
                    field.setAccessible(true);

                    if(field.get(args) != null) {
                        replacedValue = StringUtil.filterText((String) field.get(args), regx);
                        field.set(args, replacedValue);
                    }
                }
            }
        }
    }
}
