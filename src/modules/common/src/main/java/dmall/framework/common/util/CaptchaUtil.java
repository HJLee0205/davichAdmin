package dmall.framework.common.util;

import java.awt.Color;
import java.awt.Font;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import nl.captcha.Captcha;
import nl.captcha.text.producer.DefaultTextProducer;
import nl.captcha.text.renderer.DefaultWordRenderer;

/**
 * 캡챠 이미지&번 생성 및 인증을 처리한다.
 * 
 * @auther ddakker 2014. 3. 12.
 */
public class CaptchaUtil {

    public static final String CAPTCHA_DATA = "CAPTCHA_DATA";

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : KMS
     * 설명   : 캡챠 이미지를 생성하고, 생성된 이미지의 문자열을 세션에 담는다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public static Captcha createCaptchaImgPath() throws Exception {
        return createCaptchaImg(HttpUtil.getHttpServletRequest());
    }

    public static Captcha createCaptchaImg(HttpServletRequest request) throws Exception {
        Captcha captcha = null;

        List<Color> colors = new ArrayList<Color>();
        colors.add(Color.black);

        List<Font> fonts = new ArrayList<Font>();
        fonts.add(new Font("", Font.CENTER_BASELINE, 23));
        // Answer will be 6 Chinese characters
        captcha = new Captcha.Builder(130, 26)
                .addText(new DefaultTextProducer(), new DefaultWordRenderer(colors, fonts)).addBorder().build();

        request.getSession().setAttribute(CAPTCHA_DATA, captcha.getAnswer());
        return captcha;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : KMS
     * 설명   : 입력받은 값과 세션에 담겨져 있는 값이 일치하는지 체크한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. KMS - 최초생성
     * </pre>
     *
     * @param request
     * @param inputCaptchaString
     * @return
     */
    public static boolean checkCaptchaString(HttpServletRequest request, String inputCaptchaString) {
        return StringUtils.equals(inputCaptchaString, (String) request.getSession().getAttribute(CAPTCHA_DATA));
    }

}
