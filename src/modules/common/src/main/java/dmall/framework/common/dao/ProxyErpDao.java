package dmall.framework.common.dao;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.BeanUtils;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
public class ProxyErpDao {

    private static final String SUFFIX_COUNT_QUERY = "Count";
    private static final String SUFFIX_TOTAL_COUNT_QUERY = "TotalCount";

    // private static final int XA1 = 1;
    // private static final int XA2 = 2;

    @Resource(name = "sqlSessionTemplateErp")
    private SqlSessionTemplate sqlSessionTemplateErp;

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
    public <E> ResultListModel<E> selectListPage(String statement, BaseSearchVO<?> baseSearchVO) {
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
    public <E> ResultListModel<E> selectListPageWoTotal(String statement, BaseSearchVO<?> baseSearchVO) {
        log(statement, baseSearchVO);
        // 현재 페이지 번호 초기화
        if (baseSearchVO.getPage() == 0) {
            baseSearchVO.setPage(1);
        }

        // 검색결과 카운트 조회
        int filterdRows = countByParam(statement + SUFFIX_COUNT_QUERY, baseSearchVO);
        int totalRows = filterdRows;

        return getResult(statement, baseSearchVO, filterdRows, totalRows);
    }

    private <E> ResultListModel<E> getResult(String statement, BaseSearchVO<?> baseSearchVO, int filterdRows,
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

        List<E> list = this.sqlSessionTemplateErp.selectList(statement, baseSearchVO);

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
        Object resultObj = this.sqlSessionTemplateErp.selectOne(statement);
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
    private int countByParam(String statement, BaseSearchVO<?> baseSearchVO) {
        Object resultObj = this.sqlSessionTemplateErp.selectOne(statement, baseSearchVO);
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
        return decodeModel((T)this.sqlSessionTemplateErp.selectOne(statement));
    }

    public <T> T selectOne(String statement, Object parameter) {
        log(statement, parameter);
        T result = this.sqlSessionTemplateErp.selectOne(statement, parameter);
        return decodeModel(result);
    }

//    public <K, V> Map<K, V> selectMap(String statement, String mapKey) {
//        log(statement, mapKey);
//        return this.sqlSessionTemplateErp.selectMap(statement, mapKey);
//    }

    public <E> List<E> selectList(String statement) {
        log(statement);
        return (List<E>) decodeList(this.sqlSessionTemplateErp.selectList(statement));
    }

    public <E> List<E> selectList(String statement, Object parameter) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplateErp.selectList(statement, parameter));
    }

    public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplateErp.selectList(statement, parameter, rowBounds));
    }

//    public void select(String statement, ResultHandler<?> handler) {
//        log(statement);
//        this.sqlSessionTemplateErp.select(statement, handler);
//    }

//    public void select(String statement, Object parameter, ResultHandler<?> handler) {
//        log(statement);
//        this.sqlSessionTemplateErp.select(statement, parameter, handler);
//    }

//    public void select(String statement, Object parameter, RowBounds rowBounds, ResultHandler<?> handler) {
//        log(statement, parameter);
//        this.sqlSessionTemplateErp.select(statement, parameter, rowBounds, handler);
//    }

    public int insert(String statement) {
        log(statement);
        return this.sqlSessionTemplateErp.insert(statement);
    }

    public int insert(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplateErp.insert(statement, parameter);
    }

    public int update(String statement) {
        log(statement);
        return this.sqlSessionTemplateErp.update(statement);
    }

    public int update(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplateErp.update(statement, parameter);
    }

    public int delete(String statement) {
        log(statement);
        return this.sqlSessionTemplateErp.delete(statement);
    }

    public int delete(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplateErp.delete(statement, parameter);
    }

    // public <T> T selectOne(sqlSessionTemplateErp sqlSessionTemplateErp, String statement) {
    // log(statement);
    // return sqlSessionTemplateErp.selectOne(statement);
    // }
    //
    // public <T> T selectOne(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.selectOne(statement, parameter);
    // }
    //
    // public <K, V> Map<K, V> selectMap(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, String mapKey) {
    // log(statement, mapKey);
    // return sqlSessionTemplateErp.selectMap(statement, mapKey);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplateErp sqlSessionTemplateErp, String statement) {
    // log(statement);
    // return sqlSessionTemplateErp.selectList(statement);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.selectList(statement, parameter);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter,
    // RowBounds rowBounds) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.selectList(statement, parameter, rowBounds);
    // }
    //
    // public void select(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, ResultHandler<?> handler) {
    // log(statement);
    // sqlSessionTemplateErp.select(statement, handler);
    // }
    //
    // public void select(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter,
    // ResultHandler<?> handler) {
    // log(statement);
    // sqlSessionTemplateErp.select(statement, parameter, handler);
    // }
    //
    // public void select(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter, RowBounds
    // rowBounds,
    // ResultHandler<?> handler) {
    // log(statement, parameter);
    // sqlSessionTemplateErp.select(statement, parameter, rowBounds, handler);
    // }
    //
    // public int insert(sqlSessionTemplateErp sqlSessionTemplateErp, String statement) {
    // log(statement);
    // return sqlSessionTemplateErp.insert(statement);
    // }
    //
    // public int insert(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.insert(statement, parameter);
    // }
    //
    // public int update(sqlSessionTemplateErp sqlSessionTemplateErp, String statement) {
    // log(statement);
    // return sqlSessionTemplateErp.update(statement);
    // }
    //
    // public int update(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.update(statement, parameter);
    // }
    //
    // public int delete(sqlSessionTemplateErp sqlSessionTemplateErp, String statement) {
    // log(statement);
    // return sqlSessionTemplateErp.delete(statement);
    // }
    //
    // public int delete(sqlSessionTemplateErp sqlSessionTemplateErp, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplateErp.delete(statement, parameter);
    // }
    //
    // public <T> T selectOne(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplateErp(key).selectOne(statement);
    // }
    //
    // public <T> T selectOne(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).selectOne(statement, parameter);
    // }
    //
    // public <K, V> Map<K, V> selectMap(int key, String statement, String mapKey) {
    // log(statement, mapKey);
    // return getsqlSessionTemplateErp(key).selectMap(statement, mapKey);
    // }
    //
    // public <E> List<E> selectList(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplateErp(key).selectList(statement);
    // }
    //
    // public <E> List<E> selectList(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).selectList(statement, parameter);
    // }
    //
    // public <E> List<E> selectList(int key, String statement, Object parameter, RowBounds rowBounds) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).selectList(statement, parameter, rowBounds);
    // }
    //
    // public void select(int key, String statement, ResultHandler<?> handler) {
    // log(statement);
    // getsqlSessionTemplateErp(key).select(statement, handler);
    // }
    //
    // public void select(int key, String statement, Object parameter, ResultHandler<?> handler) {
    // log(statement);
    // getsqlSessionTemplateErp(key).select(statement, parameter, handler);
    // }
    //
    // public void select(int key, String statement, Object parameter, RowBounds rowBounds, ResultHandler<?> handler) {
    // log(statement, parameter);
    // getsqlSessionTemplateErp(key).select(statement, parameter, rowBounds, handler);
    // }
    //
    // public int insert(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplateErp(key).insert(statement);
    // }
    //
    // public int insert(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).insert(statement, parameter);
    // }
    //
    // public int update(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplateErp(key).update(statement);
    // }
    //
    // public int update(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).update(statement, parameter);
    // }
    //
    // public int delete(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplateErp(key).delete(statement);
    // }
    //
    // public int delete(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplateErp(key).delete(statement, parameter);
    // }

    private void log(String statement) {
        log.info("======================================");
        log.info("= Transaction Name : {}", TransactionSynchronizationManager.getCurrentTransactionName());
        log.info("= {}", statement);
        log.info("======================================");
    }

    private void log(String statement, Object parameter) {
        log.info("======================================");
        log.info("= Transaction Name : {}", TransactionSynchronizationManager.getCurrentTransactionName());
        log.info("= {}", statement);
        if (parameter != null) {
//            log.info("= {}", ToStringBuilder.reflectionToString(parameter, ToStringStyle.MULTI_LINE_STYLE));

            Class<? extends Object> cls = parameter.getClass();

            for (Field field : cls.getDeclaredFields()) {
                // 암호화 필드 암호화
                try {
                    processEncryptAnnotation(parameter, field);
                } catch (Exception e) {
                    log.debug("필드 암호화 에러", e);
                }
            }
        }
        log.info("======================================");
    }

    private void processEncryptAnnotation(Object args, Field field) throws Exception {
        Annotation a;
        Encrypt encrypt;
        String encryptedValue;
        a = field.getAnnotation(Encrypt.class);

        if (a != null && a.annotationType() == Encrypt.class) {
            encrypt = (Encrypt) a;
            log.debug("암호화 {} - {}", field, a);
            field.setAccessible(true);
            encryptedValue = encode(encrypt.type(), encrypt.algorithm(), field.get(args));
            field.set(args, encryptedValue);
        }
    }

    private String encode(String type, String algorithm, Object value) throws Exception {
        String result = null;
        if (value == null || "".equals(value)) return result;

        if (CryptoUtil.MD.equals(type)) {
            switch (algorithm) {
            case CryptoUtil.MD_SHA1:
                result = CryptoUtil.encryptSHA1(value.toString());
                break;
            case CryptoUtil.MD_SHA256:
                result = CryptoUtil.encryptSHA256(value.toString());
                break;
            case CryptoUtil.MD_SHA512:
                result = CryptoUtil.encryptSHA512(value.toString());
                break;
            }
        } else if (CryptoUtil.CHIPER.equals(type)) {
            switch (algorithm) {
            case CryptoUtil.CHIPER_AES:
                result = CryptoUtil.encryptAES(value.toString());
                break;
            case CryptoUtil.CHIPER_DES:
                result = CryptoUtil.encryptDES(value.toString());
                break;
            case CryptoUtil.CHIPER_DES3:
                result = CryptoUtil.encryptDES3(value.toString());
                break;
            default:
                log.info(MessageUtil.getMessage("biz.exception.system.noDefinedMethod"));
            }
        }

        return result;
    }

    private <T> T decodeModel(Object result) {

        if(result == null) return (T) result;
        if(result instanceof Number) return (T) result;
        if(result instanceof String) return (T) result;
        if(result instanceof Map) return (T) result;

        Class<? extends Object> cls = result.getClass();
        Object copiedObject = null;
        try {
            copiedObject = cls.newInstance();
        } catch (InstantiationException e) {
            log.debug("객체 복제 오류", e);
        } catch (IllegalAccessException e) {
            log.debug("객체 복제 오류", e);
        }

        BeanUtils.copyProperties(result, copiedObject);

        if (copiedObject != null) {
            log.info("= {}", result.toString());

            for (Field field : cls.getDeclaredFields()) {
                // 암호화 필드 복호화
                try {
                    processDecryptAnnotation(copiedObject, field);
                } catch (Exception e) {
                    log.debug("필드 복호화 에러", e);
                }
            }
        }

        return (T) copiedObject;
    }

    private void processDecryptAnnotation(Object args, Field field) throws Exception {
        Annotation a;
        Encrypt encrypt;
        String decryptedValue;
        a = field.getAnnotation(Encrypt.class);

        if (a != null && a.annotationType() == Encrypt.class) {
            encrypt = (Encrypt) a;
            /*log.debug("복호화 {} - {}", field, a);*/
            field.setAccessible(true);
            decryptedValue = decode(encrypt.type(), encrypt.algorithm(), field.get(args));
            field.set(args, decryptedValue);
        }
    }

    private String decode(String type, String algorithm, Object value) throws Exception {
        String result = null;
        if (value == null || "".equals(value.toString().trim())) return result;

        if (CryptoUtil.CHIPER.equals(type)) {
            switch (algorithm) {
            case CryptoUtil.CHIPER_AES:
                result = CryptoUtil.decryptAES(value.toString());
                break;
            case CryptoUtil.CHIPER_DES:
                result = CryptoUtil.decryptDES(value.toString());
                break;
            case CryptoUtil.CHIPER_DES3:
                result = CryptoUtil.decryptDES3(value.toString());
                break;
            default:
                log.info(MessageUtil.getMessage("biz.exception.system.noDefinedMethod"));
            }
        }

        return result;
    }

    private <E> List<E> decodeList(List<E> list) {
        List<E> decodedList = new ArrayList<>();

        for (E obj : list) {
            decodedList.add((E) decodeModel(obj));

        }

        return decodedList;
    }

}
