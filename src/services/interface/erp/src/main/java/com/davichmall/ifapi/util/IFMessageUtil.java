package com.davichmall.ifapi.util;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;

/**
 * Created by dong on 2016-04-14.
 */
@Component
public class IFMessageUtil {

    private static MessageSourceAccessor message;

    @Resource(name = "message_if")
    private MessageSourceAccessor messageSourceAccessor;

    @PostConstruct
    public void init() {
        IFMessageUtil.message = messageSourceAccessor;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @return 메시지 문자열
     */
    public static String getMessage(String code) {
        try {
            return message.getMessage(code);
        } catch (Exception e) {
            return code;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지 반환
     *          없으면 기본 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @param defaultMesssage
     *            기본 메시지
     * @return 메시지 문자열
     */
    public static String getMessage(String code, String defaultMesssage) {
        return message.getMessage(code, defaultMesssage);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지에 인자를 매핑하여 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            코드 메시지
     * @param args
     *            메시지 인자
     * @return 메시지 문자열
     */
    public static String getMessage(String code, Object[] args) {
        return message.getMessage(code, args);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지에 인자를 매핑하여 반환
     *          없으면 기본 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @param args
     *            인자
     * @param defaultMesssage
     * @return 메시지 문자열
     */
    public static String getMessage(String code, Object[] args, String defaultMesssage) {
        return message.getMessage(code, args, defaultMesssage);
    }
}
