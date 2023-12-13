package dmall.framework.common;

import dmall.framework.common.dao.ProxyDao;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by dong on 2016-04-11.
 */
public class BaseService {

    @Autowired
    protected ProxyDao proxyDao;
}
