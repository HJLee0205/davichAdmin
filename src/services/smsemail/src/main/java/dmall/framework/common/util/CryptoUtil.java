package dmall.framework.common.util;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

/**
 * 암호화/복호화 Util 클래스
 * CHIPER_AES 알고리즘 / CBC 운영모드
 * 
 * @author dong
 *
 */
@Component
public class CryptoUtil {

    private static final Logger logger = org.slf4j.LoggerFactory.getLogger(CryptoUtil.class);

    // 알고리즘 상수
    public static final String MD_SHA1 = "MD_SHA1";
    public static final String MD_SHA256 = "SHA-256";
    public static final String MD_SHA512 = "SHA-512";
    public static final String MD_MD5 = "MD_MD5";

    public static final String CHIPER_DES = "DES";
    public static final String CHIPER_DES3 = "DESede";
    public static final String CHIPER_AES = "AES";

    // TYPE 상수
    public static final String MD = "MD";
    public static final String CHIPER = "CHIPER";

    private static final int KEY_SIZE_128 = 128;

    /**
     * CHIPER_AES 암호화 키
     * 18byte
     */
    @Value("#{enc['core.encryption.aes.key']}")
    private String aesKey;

    private static String aes_key;

    @Value("#{enc['core.encryption.aes.iv']}")
    private String aesIv;

    private static String aes_iv;

    /**
     * CHIPER_DES 암호화 키
     * 임의 가능
     */
    @Value("#{enc['core.encryption.des.key']}")
    private String desKey;

    private static String des_key;

    /**
     * DESede 암호화 키
     * 임의 가능
     */
    @Value("#{enc['core.encryption.desede.key']}")
    private String desedeKey;

    private static String desede_key;

    @PostConstruct
    public void init() {
        CryptoUtil.aes_key = this.aesKey;
        CryptoUtil.aes_iv = this.aesIv;
        CryptoUtil.des_key = this.desKey;
        CryptoUtil.desede_key = this.desedeKey;
    }

    /**
     * CHIPER_DES 방식의 암호화
     * 대칭형
     * 
     * @param str
     *            : 비밀키 암호화를 희망하는 문자열
     * @return
     * @exception Exception
     */
    public static String encryptDES(String str) throws Exception {
        return encryptChiper(CHIPER_DES, str);
    }

    /**
     * CHIPER_DES 방식의 복호화
     * 대칭형
     * 
     * @param str
     *            : 비밀키 복호화를 희망하는 문자열
     * @return
     * @exception Exception
     */
    public static String decryptDES(String str) throws Exception {
        return decryptChiper(CHIPER_DES, str);
    }

    /**
     * CHIPER_DES3(Triple) 방식의 암호화
     * 대칭형
     * 
     * @param str
     *            : 비밀키 암호화를 희망하는 문자열
     * @return
     * @exception Exception
     */
    public static String encryptDES3(String str) throws Exception {
        return encryptChiper(CHIPER_DES3, str);
    }

    /**
     * CHIPER_DES3(Triple) 방식의 복호화
     * 대칭형
     * 
     * @param encrypted
     *            : 비밀키 복호화를 희망하는 문자열
     * @return
     * @exception Exception
     */
    public static String decryptDES3(String encrypted) throws Exception {
        return decryptChiper(CHIPER_DES3, encrypted);
    }

    /**
     * CHIPER_AES 방식의 암호화
     * 
     * @param encrypted
     *            : 비밀키 암호화를 희망하는 문자열
     * @return
     * @throws Exception
     */
    public static String encryptAES(String encrypted) throws Exception {
        return encryptChiper(CHIPER_AES, encrypted);
    }

    /**
     * CHIPER_AES 방식의 복호화
     * 
     * @param encrypted
     *            : 비밀키 복호화를 희망하는 문자열
     * @return
     * @throws Exception
     */
    public static String decryptAES(String encrypted) throws Exception {
        return decryptChiper(CHIPER_AES, encrypted);
    }

    /** 고정키 정보 **/
    private static String key(String algorithm) {
        String key = "";
        if (CHIPER_AES.equals(algorithm)) {
            key = aes_key;
        } else if (CHIPER_DES.equals(algorithm)) {
            key = des_key;
        } else if (CHIPER_DES3.equals(algorithm)) {
            key = desede_key;
        }
        return key;
    }

    /**
     * Cipher의 instance 생성시 사용될 값
     * 
     * @return String CHIPER_DES, TripleDES 구분
     * @throws Exception
     */
    private static String getInstance(String algorithm) throws Exception {
        String result = null;

        if (CHIPER_AES.equals(algorithm)) {
            result = "AES/CBC/PKCS5Padding";
        } else if (CHIPER_DES.equals(algorithm)) {
            result = "DES/CBC/PKCS5Padding";
        } else if (CHIPER_DES3.equals(algorithm)) {
            result = "DESede/CBC/PKCS5Padding";
        }

        return result;
    }

    /**
     * 키값 구하기
     * 
     * @return
     * @throws Exception
     */
    private static Key getKey(String algorithm) throws Exception {
        Key result = null;
        byte[] key;

        if (CHIPER_AES.equals(algorithm)) {
            key = Arrays.copyOf(key(algorithm).getBytes(), KEY_SIZE_128 / 8); // 128bit, 16byte
            result = new SecretKeySpec(key, algorithm);
        } else if (CHIPER_DES.equals(algorithm)) {
            DESKeySpec desKeySpec = new DESKeySpec(key(algorithm).getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(algorithm);
            result = keyFactory.generateSecret(desKeySpec);
        } else if (CHIPER_DES3.equals(algorithm)) {
            DESedeKeySpec desKeySpec = new DESedeKeySpec(key(algorithm).getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(algorithm);
            result = keyFactory.generateSecret(desKeySpec);
        }

        return result;
    }

    /**
     * Cipher 암호화
     * 암호화 후 BASE64Encoding
     * 
     * @param algorithm
     * @param codedStr
     * @return
     * @throws Exception
     */
    private static String encryptChiper(String algorithm, String codedStr) throws Exception {
        if (codedStr == null || codedStr.length() == 0) return "";

        Cipher cipher = Cipher.getInstance(getInstance(algorithm));
        byte[] iv = aes_iv.getBytes("UTF-8");
        // Key size 맞춤 (128bit, 16byte)
        iv = Arrays.copyOf(iv, KEY_SIZE_128 / 8);
        IvParameterSpec ips = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, getKey(algorithm), ips);

        byte[] inputBytes = codedStr.getBytes("UTF-8");
        byte[] encrypted = cipher.doFinal(inputBytes);

        Base64 base64 = new Base64();
        return base64.encodeToString(encrypted);

    }

    /**
     * Cipher 복호화
     * BASE64Decoding 후 복호화
     * 
     * @param algorithm
     * @param str
     * @return
     * @throws Exception
     */
    private static String decryptChiper(String algorithm, String str) throws Exception {
        if (str == null || str.length() == 0) return "";

        Cipher cipher = Cipher.getInstance(getInstance(algorithm));
        byte[] iv = aes_iv.getBytes("UTF-8");
        // Key size 맞춤 (128bit, 16byte)
        iv = Arrays.copyOf(iv, KEY_SIZE_128 / 8);
        IvParameterSpec ips = new IvParameterSpec(iv);
        cipher.init(Cipher.DECRYPT_MODE, getKey(algorithm), ips);

        Base64 base64 = new Base64();
        byte[] inputBytes = base64.decode(str);
        byte[] decrypted = cipher.doFinal(inputBytes);

        return new String(decrypted, "UTF-8");

    }

    /**
     * MD_SHA1 암호화
     * 단방향
     * 
     * @param value
     * @return
     */
    public static String encryptSHA1(String value) {
        return getMessageDigest(MD_SHA1, value);
    }

    /**
     * SHA-256 암호화
     * 단방향
     * 
     * @param value
     * @return
     */
    public static String encryptSHA256(String value) {
        return getMessageDigest(MD_SHA256, value);
    }

    /**
     * SHA-512 암호화
     * 단방향
     * 
     * @param value
     * @return
     */
    public static String encryptSHA512(String value) {
        return getMessageDigest(MD_SHA512, value);
    }

    /**
     * MD_MD5 암호화
     * 단방향
     * 
     * @param value
     * @return
     */
    public static String encryptMD5(String value) {
        return getMessageDigest(MD_MD5, value);
    }

    /**
     * MD 방식 암호
     * 단방향
     * 
     * @param algorithm
     * @param value
     * @return
     * @throws Exception
     */
    private static String getMessageDigest(String algorithm, String value) {

        MessageDigest digest = null;
        try {
            digest = MessageDigest.getInstance(algorithm);
        } catch (NoSuchAlgorithmException e) {
            logger.error("biz.exception.system.noSuchAlgorithm", e);
        }

        if(value == null) {
            throw new RuntimeException("암호화할 값이 없음");
        }

        digest.update(value.getBytes());

        byte[] messageDigest = digest.digest();

        StringBuffer strResult = new StringBuffer();
        for (int i = 0; i < messageDigest.length; i++) {
            strResult.append(Integer.toString((messageDigest[i] & 0xff) + 0x100, 16).substring(1));
            // strResult.append(Integer.toHexString(0xFF & messageDigest[i])));
        }

        return strResult.toString();
    }

}
