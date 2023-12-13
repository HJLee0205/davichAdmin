package dmall.framework.common.handler;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;

import javax.annotation.PostConstruct;

public class CacheHandler {

    private CacheManager cacheManager;

    private Ehcache cache;

    private String cacheName;

    public boolean put(String key, Object value) {
        Element element = new Element(key, value);
        try {
            cache.put(element);
        } catch (Exception ex) {
            throw new CustomException(ExceptionConstants.ERROR_CACHE);
        }
        return true;
    }

    public Element getElement(String key) {
        return cache.get(key);
    }

    public Object getValue(String key) {
        Element element = cache.get(key);
        if (element == null) {
            return null;
        }
        return element.getObjectValue();
    }

    public boolean replace(String key, Object value) {
        Element element = new Element(key, value);
        cache.replace(element);
        return true;
    }

    public Ehcache getCache() {
        return cache;
    }

    /**
     * 의존성 주입 완료 후 cacheName으로 cache 객체 조회해서 참조
     */
    @PostConstruct
    public void setCache() {
        try {
            cache = cacheManager.getEhcache(cacheName);
        } catch (Exception ex) {
            throw new CustomException(ExceptionConstants.ERROR_CACHE);
        }
    }

    public void setCacheManager(CacheManager cacheManager) {
        this.cacheManager = cacheManager;
    }

    public void setCacheName(String cacheName) {
        this.cacheName = cacheName;
    }
}
