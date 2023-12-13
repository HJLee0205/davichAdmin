package net.danvi.dmall.front.web.config.aspect;

import net.danvi.dmall.biz.system.aspect.BannedWordReplaceAspect;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * 금칙어 마스킹 Aspect
 * 
 */
@Component
@Aspect
@Order(2)
public class FrontWebBannedWordReplaceAspect extends BannedWordReplaceAspect {
}
