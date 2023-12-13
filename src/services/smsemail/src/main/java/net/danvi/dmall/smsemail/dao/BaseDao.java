package net.danvi.dmall.smsemail.dao;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class BaseDao {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

    protected static final String SUFFIX_COUNT_QUERY = "Count";
    protected static final String SUFFIX_TOTAL_COUNT_QUERY = "TotalCount";

    protected void log(String statement) {
        log.info("======================================");
        log.info("= Transaction Name : {}", TransactionSynchronizationManager.getCurrentTransactionName());
        log.info("= {}", statement);
        log.info("======================================");
    }

    protected void log(String statement, Object parameter) {
        log.info("======================================");
        log.info("= Transaction Name : {}", TransactionSynchronizationManager.getCurrentTransactionName());
        log.info("= {}", statement);
        if (parameter != null) {
            log.info("= {}", ToStringBuilder.reflectionToString(parameter, ToStringStyle.MULTI_LINE_STYLE));

            Class<? extends Object> cls = parameter.getClass();

            if(parameter instanceof List) {
                // 파라미터가 리스트이면
                for(Object element : (List) parameter) {
                    cls = element.getClass();
                    setEncryptClass(cls, element);
                }
            } else {
                setEncryptClass(cls, parameter);
            }
        }
        log.info("======================================");
    }

    private void setEncryptClass(Class<? extends Object> cls, Object element) {
        for (Field field : cls.getDeclaredFields()) {
            // 암호화 필드 암호화
            try {
                processEncryptAnnotation(element, field);
            } catch (Exception e) {
                log.error("필드 암호화 오류", e);
            }
        }
    }

    protected void processEncryptAnnotation(Object args, Field field) throws Exception {
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

    protected String encode(String type, String algorithm, Object value) throws Exception {
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
                log.info("해당 메소드가 존재하지 않습니다.");
            }
        }

        return result;
    }

    protected <T> T decodeModel(Object result) {
        if (result != null) {
            log.info("= {}", result.toString());

            Class<? extends Object> cls = result.getClass();

            for (Field field : cls.getDeclaredFields()) {
                // 암호화 필드 복호화
                try {
                    processDecryptAnnotation(result, field);
                } catch (Exception e) {
                    log.error("필드 복호화 오류", e);
                }
            }
        }

        return (T) result;
    }

    protected void processDecryptAnnotation(Object args, Field field) throws Exception {
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

    protected String decode(String type, String algorithm, Object value) throws Exception {
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
                log.info("해당 메소드가 존재하지 않습니다.");
            }
        }

        return result;
    }

    protected <E> List<E> decodeList(List<E> list) {
        List<E> decodedList = new ArrayList<>();

        for (E obj : list) {
            Class cls = obj.getClass();

            for (Field field : cls.getDeclaredFields()) {
                // 암호화 필드 복호화
                try {
                    processDecryptAnnotation(obj, field);
                } catch (Exception e) {
                    log.error("필드 복호화 오류", e);
                }
            }

            decodedList.add(obj);
        }

        return decodedList;
    }
}
