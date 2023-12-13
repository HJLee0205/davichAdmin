package net.danvi.dmall.biz.batch.order.job;

import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.batch.MyBatisCursorItemReader;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 31.
 * 작성자     : KNG
 * 설명       : 
 * </pre>
 */
@Slf4j
public class DmallCursorItemReader<T> extends MyBatisCursorItemReader<T> {

    public DmallCursorItemReader() {
        super();
        log.debug("===== BellCursorItemReader === BellCursorItemReader()");
    }

    @Override
    protected T doRead() throws Exception {
        log.debug("===== BellCursorItemReader === doRead()");
        return super.doRead();
    }

    @Override
    protected void doOpen() throws Exception {
        log.debug("===== BellCursorItemReader === doOpen()");
        super.doOpen();
    }

    @Override
    protected void doClose() throws Exception {
        log.debug("===== BellCursorItemReader === doClose()");
        super.doClose();
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        log.debug("===== BellCursorItemReader === afterPropertiesSet()");
        super.afterPropertiesSet();
    }

    @Override
    public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        log.debug("===== BellCursorItemReader === setSqlSessionFactory()");
        super.setSqlSessionFactory(sqlSessionFactory);
    }

    @Override
    public void setQueryId(String queryId) {
        log.debug("===== BellCursorItemReader === setQueryId(" + queryId + ")");
        super.setQueryId(queryId);
    }

    @Override
    public void setParameterValues(Map<String, Object> parameterValues) {
        log.debug("===== BellCursorItemReader === setParameterValues(" +  parameterValues + ")");
        super.setParameterValues(parameterValues);
    }    
    
}
