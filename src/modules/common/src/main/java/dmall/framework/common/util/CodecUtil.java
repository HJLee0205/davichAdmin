package dmall.framework.common.util;

import java.lang.reflect.Field;

import org.apache.commons.net.util.Base64;

import lombok.extern.slf4j.Slf4j;

/**
 * 이 클래스는 Codec 관련 함수를 제공합니다.
 *
 * @author snw
 * @version 1.0
 * @since 1.0
 */
@Slf4j
public class CodecUtil {

    public static String encoder(String key, String charset) throws Exception {
        String result = "";

        if (key != null && !"".equals(key)) {
            result = new String(Base64.encodeBase64(key.getBytes()), charset);
        }
        return result;
    }

    public static String encoderUTF8(String key) throws Exception {

        return encoder(key, "UTF-8");
    }

    public static String decoder(String cipher, String charset) throws Exception {
        String result = "";

        if (cipher != null && !"".equals(cipher)) {
            result = new String(Base64.decodeBase64(cipher.getBytes()), charset);
        }
        return result;
    }

    public static String decoderUTF8(String cipher) throws Exception {

        return decoder(cipher, "UTF-8");
    }

    public static Object encoderAll(Object obj) throws Exception {

        Class<? extends Object> cls = obj.getClass();

        int objLength = 0;

        objLength = cls.getDeclaredFields().length;
        Field[] fieldList = cls.getDeclaredFields();

        for (Field field : fieldList) {

            if (field.get(obj) != null && !"".equals(field.get(obj))) {

                String fieldName = field.getName();
                String fieldValue = (String) field.get(obj);
                String newFieldValue = encoderUTF8(fieldValue);
                log.debug("fieldName =" + fieldName + ", Type=" + field.getType() + ", fieldValue=" + fieldValue
                        + ", afterValue=" + newFieldValue);

                if (field.getType() == String.class) {
                    field.set(obj, newFieldValue);
                } else if (field.getType() == Integer.class) {
                    field.set(obj, Integer.parseInt(newFieldValue));
                } else if (field.getType() == Double.class) {
                    field.set(obj, Double.parseDouble(newFieldValue));
                } else if (field.getType() == Long.class) {
                    field.set(obj, Long.parseLong(newFieldValue));
                } else if (field.getType() == Byte.class) {
                    field.set(obj, Byte.parseByte(newFieldValue));
                } else if (field.getType() == Float.class) {
                    field.set(obj, Float.parseFloat(newFieldValue));
                } else if (field.getType() == Short.class) {
                    field.set(obj, Short.parseShort(newFieldValue));
                }
            }

        }

        return obj;
    }

    public static Object decoderAll(Object obj) throws Exception {

        Class<? extends Object> cls = obj.getClass();

        int objLength = 0;

        objLength = cls.getDeclaredFields().length;
        Field[] fieldList = cls.getDeclaredFields();

        for (Field field : fieldList) {

            if (field.get(obj) != null && !"".equals(field.get(obj))) {

                String fieldName = field.getName();
                String fieldValue = (String) field.get(obj);
                String newFieldValue = decoderUTF8(fieldValue);
                log.debug("fieldName =" + fieldName + ", Type=" + field.getType() + ", fieldValue=" + fieldValue
                        + ", afterValue=" + newFieldValue);

                if (field.getType() == String.class) {
                    field.set(obj, newFieldValue);
                } else if (field.getType() == Integer.class) {
                    field.set(obj, Integer.parseInt(newFieldValue));
                } else if (field.getType() == Double.class) {
                    field.set(obj, Double.parseDouble(newFieldValue));
                } else if (field.getType() == Long.class) {
                    field.set(obj, Long.parseLong(newFieldValue));
                } else if (field.getType() == Byte.class) {
                    field.set(obj, Byte.parseByte(newFieldValue));
                } else if (field.getType() == Float.class) {
                    field.set(obj, Float.parseFloat(newFieldValue));
                } else if (field.getType() == Short.class) {
                    field.set(obj, Short.parseShort(newFieldValue));
                }
            }

        }

        return obj;
    }
}
