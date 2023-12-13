package net.danvi.dmall.smsemail.dao;

import net.danvi.dmall.smsemail.model.RemoteSearchBaseVO;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.StringUtil;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository("proxyDao")
public class ProxyDao extends BaseDao {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "sqlSessionTemplate")
    private SqlSessionTemplate sqlSessionTemplate;

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 페이징 쿼리 실행
     *          전체 카운트, 검색 결과 카운트, 검색 쿼리 의 3가지 쿼리가 필요
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param statement
     * @param baseSearchVO
     * @return
     */
    public <E> ResultListModel<E> selectListPage(String statement, RemoteSearchBaseVO<?> baseSearchVO) {
        log(statement, baseSearchVO);
        // 현재 페이지 번호 초기화
        if (baseSearchVO.getPage() == 0) {
            baseSearchVO.setPage(1);
        }

        // 전체 카운트 조회
        int totalRows = countByParam(statement + SUFFIX_TOTAL_COUNT_QUERY, baseSearchVO);
        if (totalRows < 1) {
            ResultListModel<E> result = new ResultListModel<>();
            result.setTotalRows(0);
            result.setFilterdRows(0);
            result.setPage(baseSearchVO.getPage());
            result.setRows(baseSearchVO.getRows());
            return result;
        }

        // 검색결과 카운트 조회
        int filterdRows = countByParam(statement + SUFFIX_COUNT_QUERY, baseSearchVO);

        return getResult(statement, baseSearchVO, filterdRows, totalRows);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 페이징 쿼리 실행
     *          검색 결과 카운트, 검색 쿼리의 2가지 쿼리가 필요
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param statement
     * @param baseSearchVO
     * @return
     */
    public <E> ResultListModel<E> selectListPageWoTotal(String statement, RemoteSearchBaseVO<?> baseSearchVO) {
        log(statement, baseSearchVO);
        // 현재 페이지 번호 초기화
        if (baseSearchVO.getPage() == 0) {
            baseSearchVO.setPage(1);
        }

        if(baseSearchVO.getSidx() != null) {
            baseSearchVO.setSidx(StringUtil.replaceFileNm(baseSearchVO.getSidx()));
        }

        if(baseSearchVO.getSord() != null) {
            baseSearchVO.setSord(StringUtil.replaceFileNm(baseSearchVO.getSord()));
        }

        // 검색결과 카운트 조회
        int filterdRows = countByParam(statement + SUFFIX_COUNT_QUERY, baseSearchVO);
        int totalRows = filterdRows;

        return getResult(statement, baseSearchVO, filterdRows, totalRows);
    }

    private <E> ResultListModel<E> getResult(String statement, RemoteSearchBaseVO<?> baseSearchVO, int filterdRows,
            int totalRows) {
        ResultListModel<E> result = new ResultListModel<>();

        if (filterdRows < 1) {
            result.setTotalRows(totalRows);
            result.setFilterdRows(0);
            result.setPage(baseSearchVO.getPage());
            result.setRows(baseSearchVO.getRows());
            return result;
        }

        baseSearchVO.setTotalCount(filterdRows);

        baseSearchVO.setLimit((baseSearchVO.getPage() - 1) * baseSearchVO.getRows());
        baseSearchVO.setOffset(baseSearchVO.getRows());

        baseSearchVO.setStartIndex(((baseSearchVO.getPage() - 1) * baseSearchVO.getRows()) + 1);
        baseSearchVO.setEndIndex(((baseSearchVO.getPage() - 1) * baseSearchVO.getRows()) + baseSearchVO.getRows());

        if (StringUtil.isNotBlank(baseSearchVO.getSidx())) {
            baseSearchVO.setSidx(StringUtil.toUnCamelCase(baseSearchVO.getSidx()).toUpperCase());
        }

        List<E> list = this.sqlSessionTemplate.selectList(statement, baseSearchVO);

        if (filterdRows > 0 && filterdRows % baseSearchVO.getRows() == 0) {
            result.setTotalPages(filterdRows / baseSearchVO.getRows());
        } else {
            result.setTotalPages(filterdRows / baseSearchVO.getRows() + 1);
        }
        result.setTotalRows(totalRows);
        result.setFilterdRows(filterdRows);
        result.setPage(baseSearchVO.getPage());
        result.setRows(baseSearchVO.getRows());
        result.setResultList(decodeList(list));

        return result;
    }

    /**
     * <pre>
     * 설명     : 페이징에 필요한 카운트 쿼리 조회
     * &#64;param statement
     * &#64;return
     * </pre>
     */
    private int count(String statement) {
        Object resultObj = this.sqlSessionTemplate.selectOne(statement);
        if (resultObj instanceof Number) {
            Number number = (Number) resultObj;
            return number.intValue();
        } else {
            throw new IllegalArgumentException(String.format(
                    "Wrong resultClass type(%s) with queryId:%s, resultClass must be subclass of java.lang.Number",
                    resultObj.getClass().getName(), statement));
        }
    }

    /**
     * <pre>
     * 설명     : 페이징에 필요한 카운트 쿼리 조회
     * &#64;param statement
     * &#64;param baseSearchVO
     * &#64;return
     * </pre>
     */
    private int countByParam(String statement, RemoteSearchBaseVO<?> baseSearchVO) {
        Object resultObj = this.sqlSessionTemplate.selectOne(statement, baseSearchVO);
        if (resultObj instanceof Number) {
            Number number = (Number) resultObj;
            return number.intValue();
        } else {
            throw new IllegalArgumentException(String.format(
                    "Wrong resultClass type(%s) with queryId:%s, resultClass must be subclass of java.lang.Number",
                    resultObj.getClass().getName(), statement));
        }
    }

    public <T> T selectOne(String statement) {
        log(statement);
        return decodeModel(this.sqlSessionTemplate.selectOne(statement));
    }

    public <T> T selectOne(String statement, Object parameter) {
        log(statement, parameter);
        return decodeModel(this.sqlSessionTemplate.selectOne(statement, parameter));
    }

    public <K, V> Map<K, V> selectMap(String statement, String mapKey) {
        log(statement, mapKey);
        return this.sqlSessionTemplate.selectMap(statement, mapKey);
    }

    public <E> List<E> selectList(String statement) {
        log(statement);
        return (List<E>) decodeList(this.sqlSessionTemplate.selectList(statement));
    }

    public <E> List<E> selectList(String statement, Object parameter) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplate.selectList(statement, parameter));
    }

    public <E> List<E> selectListNolog(String statement, Object parameter) {
        return (List<E>) decodeList(this.sqlSessionTemplate.selectList(statement, parameter));
    }

    public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplate.selectList(statement, parameter, rowBounds));
    }

    public void select(String statement, ResultHandler<?> handler) {
        log(statement);
        this.sqlSessionTemplate.select(statement, handler);
    }

    public void select(String statement, Object parameter, ResultHandler<?> handler) {
        log(statement);
        this.sqlSessionTemplate.select(statement, parameter, handler);
    }

    public void select(String statement, Object parameter, RowBounds rowBounds, ResultHandler<?> handler) {
        log(statement, parameter);
        this.sqlSessionTemplate.select(statement, parameter, rowBounds, handler);
    }

    public int insert(String statement) {
        log(statement);
        return this.sqlSessionTemplate.insert(statement);
    }

    public int insert(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplate.insert(statement, parameter);
    }

    public int update(String statement) {
        log(statement);
        return this.sqlSessionTemplate.update(statement);
    }

    public int update(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplate.update(statement, parameter);
    }

    public int delete(String statement) {
        log(statement);
        return this.sqlSessionTemplate.delete(statement);
    }

    public int delete(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplate.delete(statement, parameter);
    }


}
