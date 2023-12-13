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
public class ProxyStorePushDao {

    private static final String SUFFIX_COUNT_QUERY = "Count";
    private static final String SUFFIX_TOTAL_COUNT_QUERY = "TotalCount";

    // private static final int XA1 = 1;
    // private static final int XA2 = 2;

    @Resource(name = "sqlSessionTemplatePushSt")
    private SqlSessionTemplate sqlSessionTemplatePushSt;

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

        List<E> list = this.sqlSessionTemplatePushSt.selectList(statement, baseSearchVO);

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
        Object resultObj = this.sqlSessionTemplatePushSt.selectOne(statement);
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
        Object resultObj = this.sqlSessionTemplatePushSt.selectOne(statement, baseSearchVO);
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
        return decodeModel((T)this.sqlSessionTemplatePushSt.selectOne(statement));
    }

    public <T> T selectOne(String statement, Object parameter) {
        log(statement, parameter);
        T result = this.sqlSessionTemplatePushSt.selectOne(statement, parameter);
        return decodeModel(result);
    }

//    public <K, V> Map<K, V> selectMap(String statement, String mapKey) {
//        log(statement, mapKey);
//        return this.sqlSessionTemplatePushSt.selectMap(statement, mapKey);
//    }

    public <E> List<E> selectList(String statement) {
        log(statement);
        return (List<E>) decodeList(this.sqlSessionTemplatePushSt.selectList(statement));
    }

    public <E> List<E> selectList(String statement, Object parameter) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplatePushSt.selectList(statement, parameter));
    }

    public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
        log(statement, parameter);
        return (List<E>) decodeList(this.sqlSessionTemplatePushSt.selectList(statement, parameter, rowBounds));
    }

//    public void select(String statement, ResultHandler<?> handler) {
//        log(statement);
//        this.sqlSessionTemplatePushSt.select(statement, handler);
//    }

//    public void select(String statement, Object parameter, ResultHandler<?> handler) {
//        log(statement);
//        this.sqlSessionTemplatePushSt.select(statement, parameter, handler);
//    }

//    public void select(String statement, Object parameter, RowBounds rowBounds, ResultHandler<?> handler) {
//        log(statement, parameter);
//        this.sqlSessionTemplatePushSt.select(statement, parameter, rowBounds, handler);
//    }

    public int insert(String statement) {
        log(statement);
        return this.sqlSessionTemplatePushSt.insert(statement);
    }

    public int insert(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplatePushSt.insert(statement, parameter);
    }

    public int update(String statement) {
        log(statement);
        return this.sqlSessionTemplatePushSt.update(statement);
    }

    public int update(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplatePushSt.update(statement, parameter);
    }

    public int delete(String statement) {
        log(statement);
        return this.sqlSessionTemplatePushSt.delete(statement);
    }

    public int delete(String statement, Object parameter) {
        log(statement, parameter);
        return this.sqlSessionTemplatePushSt.delete(statement, parameter);
    }

    // public <T> T selectOne(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement) {
    // log(statement);
    // return sqlSessionTemplatePushSt.selectOne(statement);
    // }
    //
    // public <T> T selectOne(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.selectOne(statement, parameter);
    // }
    //
    // public <K, V> Map<K, V> selectMap(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, String mapKey) {
    // log(statement, mapKey);
    // return sqlSessionTemplatePushSt.selectMap(statement, mapKey);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement) {
    // log(statement);
    // return sqlSessionTemplatePushSt.selectList(statement);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.selectList(statement, parameter);
    // }
    //
    // public <E> List<E> selectList(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter,
    // RowBounds rowBounds) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.selectList(statement, parameter, rowBounds);
    // }
    //
    // public void select(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, ResultHandler<?> handler) {
    // log(statement);
    // sqlSessionTemplatePushSt.select(statement, handler);
    // }
    //
    // public void select(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter,
    // ResultHandler<?> handler) {
    // log(statement);
    // sqlSessionTemplatePushSt.select(statement, parameter, handler);
    // }
    //
    // public void select(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter, RowBounds
    // rowBounds,
    // ResultHandler<?> handler) {
    // log(statement, parameter);
    // sqlSessionTemplatePushSt.select(statement, parameter, rowBounds, handler);
    // }
    //
    // public int insert(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement) {
    // log(statement);
    // return sqlSessionTemplatePushSt.insert(statement);
    // }
    //
    // public int insert(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.insert(statement, parameter);
    // }
    //
    // public int update(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement) {
    // log(statement);
    // return sqlSessionTemplatePushSt.update(statement);
    // }
    //
    // public int update(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.update(statement, parameter);
    // }
    //
    // public int delete(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement) {
    // log(statement);
    // return sqlSessionTemplatePushSt.delete(statement);
    // }
    //
    // public int delete(sqlSessionTemplatePushSt sqlSessionTemplatePushSt, String statement, Object parameter) {
    // log(statement, parameter);
    // return sqlSessionTemplatePushSt.delete(statement, parameter);
    // }
    //
    // public <T> T selectOne(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplatePushSt(key).selectOne(statement);
    // }
    //
    // public <T> T selectOne(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).selectOne(statement, parameter);
    // }
    //
    // public <K, V> Map<K, V> selectMap(int key, String statement, String mapKey) {
    // log(statement, mapKey);
    // return getsqlSessionTemplatePushSt(key).selectMap(statement, mapKey);
    // }
    //
    // public <E> List<E> selectList(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplatePushSt(key).selectList(statement);
    // }
    //
    // public <E> List<E> selectList(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).selectList(statement, parameter);
    // }
    //
    // public <E> List<E> selectList(int key, String statement, Object parameter, RowBounds rowBounds) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).selectList(statement, parameter, rowBounds);
    // }
    //
    // public void select(int key, String statement, ResultHandler<?> handler) {
    // log(statement);
    // getsqlSessionTemplatePushSt(key).select(statement, handler);
    // }
    //
    // public void select(int key, String statement, Object parameter, ResultHandler<?> handler) {
    // log(statement);
    // getsqlSessionTemplatePushSt(key).select(statement, parameter, handler);
    // }
    //
    // public void select(int key, String statement, Object parameter, RowBounds rowBounds, ResultHandler<?> handler) {
    // log(statement, parameter);
    // getsqlSessionTemplatePushSt(key).select(statement, parameter, rowBounds, handler);
    // }
    //
    // public int insert(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplatePushSt(key).insert(statement);
    // }
    //
    // public int insert(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).insert(statement, parameter);
    // }
    //
    // public int update(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplatePushSt(key).update(statement);
    // }
    //
    // public int update(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).update(statement, parameter);
    // }
    //
    // public int delete(int key, String statement) {
    // log(statement);
    // return getsqlSessionTemplatePushSt(key).delete(statement);
    // }
    //
    // public int delete(int key, String statement, Object parameter) {
    // log(statement, parameter);
    // return getsqlSessionTemplatePushSt(key).delete(statement, parameter);
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
