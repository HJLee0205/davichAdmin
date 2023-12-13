package net.danvi.dmall.biz.ifapi.util;

import java.security.Key;
import java.util.Arrays;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 암호화/복호화 Util 클래스
 * CHIPER_AES 알고리즘 / CBC 운영모드
 * 
 * @author dong
 *
 */
@Component
public class IFCryptoUtil {

    public static final String CHIPER_AES = "AES";

    // TYPE 상수

    private static final int KEY_SIZE_128 = 128;

    /**
     * CHIPER_AES 암호화 키
     * 18byte
     */
//    @Value("#{enc_if['core.encryption.aes.key']}")
    private String aesKey = "davich_interface";

    private static String aes_key;

//    @Value("#{enc_if['core.encryption.aes.iv']}")
    private String aesIv = "mall_erp_interface";

    private static String aes_iv;


    @PostConstruct
    public void init() {
        IFCryptoUtil.aes_key = this.aesKey;
        IFCryptoUtil.aes_iv = this.aesIv;
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

}
