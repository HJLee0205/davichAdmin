package net.danvi.dmall.biz.system.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import net.danvi.dmall.biz.system.model.WebLogPO;
import net.danvi.dmall.biz.system.remote.homepage.model.HomepageIfLogPO;
import net.danvi.dmall.biz.system.remote.maru.model.MaruResult;

/**
 * Created by dong on 2016-07-13.
 */
public interface LoggerService {
    public void insert(WebLogPO po);

    public void insertHomepageIf(HomepageIfLogPO po);

    public void insertMaruResultIf(MaruResult result) throws JsonProcessingException;
}
