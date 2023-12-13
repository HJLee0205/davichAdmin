package net.danvi.dmall.smsemail.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository("JtaDao")
public class JtaDao extends BaseDao {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

//    @Resource(name = "sqlSessionTemplateMainXA")
//    private SqlSessionTemplate sqlSessionTemplateMainXA;
//    @Resource(name = "sqlSessionTemplateSmsXA")
//    private SqlSessionTemplate sqlSessionTemplateSmsXA;
//    @Resource(name = "sqlSessionTemplateEmailXA")
//    private SqlSessionTemplate sqlSessionTemplateEmailXA;
    
    @Resource(name = "sqlSessionTemplate")
    private SqlSessionTemplate sqlSessionTemplate;
    

    public SqlSessionTemplate getMainXA() {
        //return sqlSessionTemplateMainXA;
    	return sqlSessionTemplate;
    }

//    public SqlSessionTemplate getSmsXA() {
//        return sqlSessionTemplateSmsXA;
//    }

    public SqlSessionTemplate getEmailXA() {
        //return sqlSessionTemplateEmailXA;
    	return sqlSessionTemplate;
    }

    public <T> T selectOne(SqlSessionTemplate sqlSessionTemplate, String statement) {
        log(statement);
        return sqlSessionTemplate.selectOne(statement);
    }

    public <T> T selectOne(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter) {
        log(statement, parameter);
        return sqlSessionTemplate.selectOne(statement, parameter);
    }

    public <K, V> Map<K, V> selectMap(SqlSessionTemplate sqlSessionTemplate, String statement, String mapKey) {
        log(statement, mapKey);
        return sqlSessionTemplate.selectMap(statement, mapKey);
    }

    public <E> List<E> selectList(SqlSessionTemplate sqlSessionTemplate, String statement) {
        log(statement);
        return sqlSessionTemplate.selectList(statement);
    }

    public <E> List<E> selectList(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter) {
        log(statement, parameter);
        return sqlSessionTemplate.selectList(statement, parameter);
    }

    public <E> List<E> selectList(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter,
            RowBounds rowBounds) {
        log(statement, parameter);
        return sqlSessionTemplate.selectList(statement, parameter, rowBounds);
    }

    public void select(SqlSessionTemplate sqlSessionTemplate, String statement, ResultHandler<?> handler) {
        log(statement);
        sqlSessionTemplate.select(statement, handler);
    }

    public void select(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter,
            ResultHandler<?> handler) {
        log(statement);
        sqlSessionTemplate.select(statement, parameter, handler);
    }

    public void select(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter, RowBounds rowBounds,
            ResultHandler<?> handler) {
        log(statement, parameter);
        sqlSessionTemplate.select(statement, parameter, rowBounds, handler);
    }

    public int insert(SqlSessionTemplate sqlSessionTemplate, String statement) {
        log(statement);
        return sqlSessionTemplate.insert(statement);
    }

    public int insert(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter) {
        log(statement, parameter);
        return sqlSessionTemplate.insert(statement, parameter);
    }

    public int update(SqlSessionTemplate sqlSessionTemplate, String statement) {
        log(statement);
        return sqlSessionTemplate.update(statement);
    }

    public int update(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter) {
        log(statement, parameter);
        return sqlSessionTemplate.update(statement, parameter);
    }

    public int delete(SqlSessionTemplate sqlSessionTemplate, String statement) {
        log(statement);
        return sqlSessionTemplate.delete(statement);
    }

    public int delete(SqlSessionTemplate sqlSessionTemplate, String statement, Object parameter) {
        log(statement, parameter);
        return sqlSessionTemplate.delete(statement, parameter);
    }
}
