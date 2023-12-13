package net.danvi.dmall.biz.batch.order.job;

import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.batch.MyBatisBatchItemWriter;

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
public class DmallBatchItemWriter<T> extends MyBatisBatchItemWriter<T>{
    
    public DmallBatchItemWriter() {
        super();
        log.debug("===== DmallBatchItemWriter === DmallBatchItemWriter()");
    }
    
    @Override
    public void setAssertUpdates(boolean assertUpdates) {
        log.debug("===== DmallBatchItemWriter === setAssertUpdates(" + assertUpdates +  ")");
        super.setAssertUpdates(assertUpdates);
    }

    @Override
    public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        log.debug("===== DmallBatchItemWriter === setSqlSessionFactory(" + sqlSessionFactory +  ")");
        super.setSqlSessionFactory(sqlSessionFactory);
    }

    @Override
    public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
        log.debug("===== DmallBatchItemWriter === setSqlSessionTemplate(" + sqlSessionTemplate +  ")");
        super.setSqlSessionTemplate(sqlSessionTemplate);
    }

    public void setStatementId(String statementId) {
        log.debug("===== DmallBatchItemWriter === setStatementId(" + statementId +  ")");
        super.setStatementId(statementId);
    }

    @Override
    public void afterPropertiesSet() {
        log.debug("===== DmallBatchItemWriter === afterPropertiesSet()");
        super.afterPropertiesSet();
    }

    @Override
    public void write(List<? extends T> items) {
        log.debug("===== DmallBatchItemWriter === write(" + items +  ")");
        super.write(items);
    }    
    
}
