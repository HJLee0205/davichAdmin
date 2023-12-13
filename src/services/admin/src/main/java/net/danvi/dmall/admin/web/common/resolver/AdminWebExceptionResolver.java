package net.danvi.dmall.admin.web.common.resolver;

import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.common.model.ValidationErrorInfo;
import org.apache.commons.fileupload.FileUploadBase;
import org.springframework.context.NoSuchMessageException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.*;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@Slf4j
public class AdminWebExceptionResolver implements HandlerExceptionResolver {


    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object paramObject,
            Exception ex) {

        ModelAndView mav = new ModelAndView();

        String exCode = ExceptionConstants.ERROR_CODE_DEFAULT;
        String viewName;
        String msgKey = "exMsg";

        if (HttpUtil.isAjax(request)) {
            log.debug("=========================================================");
            log.debug("= Ajax Error");
            log.debug("=========================================================");
            viewName = View.jsonView();
            msgKey = "message";
            mav.addObject("success", false);
        } else {
            log.debug("=========================================================");
            log.debug("= No Ajax Error");
            log.debug("=========================================================");
            viewName = View.errorView();
        }

        log.info("resolveException : ", ex);

        try {
            if (ex instanceof CustomException) {
                CustomException customEx = (CustomException) ex;
                exCode = customEx.getExCode();
                if (customEx.getArgs() != null) {
                    mav.addObject(msgKey, MessageUtil.getMessage(exCode, customEx.getArgs()));
                } else {
                    mav.addObject(msgKey, MessageUtil.getMessage(exCode));
                }
            } else if (ex instanceof DiskFullException) {
                // 업로드 파일 사이즈 예외
                if(request.getHeader("user-agent").contains("MSIE 8.0")) {
                    // IE8 에선 jQuery.form 의 ajaxSubmit() 으로 파일업로드시에 x-requested-with 값이 안 넘어와서 ajax 요청인지 체크할 수 없음
                    // 폼서브밋 업로드가 없으니 업로드 파일사이즈 오류 발생시 강제로 jsonview로 만듬
                    msgKey = "message";
                    viewName = View.jsonView();
                    mav.addObject("success", false);
                }
                mav.addObject(msgKey, ex.getMessage());
            } else if (ex instanceof MaxUploadSizeExceededException || ex.getCause() instanceof FileUploadBase.FileSizeLimitExceededException) {
                // 업로드 파일 사이즈 예외
                if(request.getHeader("user-agent").contains("MSIE 8.0")) {
                    // IE8 에선 jQuery.form 의 ajaxSubmit() 으로 파일업로드시에 x-requested-with 값이 안 넘어와서 ajax 요청인지 체크할 수 없음
                    // 폼서브밋 업로드가 없으니 업로드 파일사이즈 오류 발생시 강제로 jsonview로 만듬
                    msgKey = "message";
                    viewName = View.jsonView();
                    mav.addObject("success", false);
                }
                mav.addObject(msgKey, "업로드할 수 있는 파일 크기보다 업로드한 파일의 크기가 큽니다.");
            } else if (ex instanceof BadCredentialsException) {
                // 로그인 관련 예외
                mav.addObject(msgKey, "로그인 또는 권한 오류");
            } else if (ex instanceof JsonValidationException) {
                // 모델 데이터 검증 예외
                addJsonValidationExceptionToModelAndView(ex, mav);
                exCode = ExceptionConstants.ERROR_CODE_DEFAULT;
            } else if (ex instanceof AccessDeniedException) {
                if (ex.getMessage().contains("권한")) {
                    viewName = View.redirect("/admin/main/main-view");
                } else {
                    // 접근 권한 예외
                    if (!HttpUtil.isAjax(request)) {
                        viewName = View.redirect("/admin/login/member-login");
                    }
                }
            } else if(ex instanceof SitePrepareException) {
                // 쇼핑몰 생성 중
                log.warn("쇼핑몰 생성중", ex);
                viewName = "error/prepare";
                mav.addObject("msg", ex.getMessage());
            } else if(ex instanceof SiteNotExistException) {
                // 쇼핑몰 생성 중
                log.warn("쇼핑몰 생성중", ex);
                viewName = "error/404";
                mav.addObject("msg", ex.getMessage());
            } else if(ex instanceof SiteClosedException) {
                log.warn("정상적인 상태의 쇼핑몰 아님", ex);
                viewName = "error/closed";
                mav.addObject("msg", ex.getMessage());
            } else {
                exCode = ExceptionConstants.ERROR_CODE_DEFAULT;
                mav.addObject(msgKey, MessageUtil.getMessage(exCode));
            }
        } catch(Exception e) {
            log.info("오류", e);
            exCode = ExceptionConstants.ERROR_CODE_DEFAULT;
        }

        //mav.addObject("exception", ex.getMessage());
        mav.addObject("exCode", exCode);

        mav.setViewName(viewName);
        return mav;
    }

    /**
     * JSON 형식의 데이터 검증 오류 메시지를 ModelAndView에 추가
     * @param ex
     * @param mav
     * @return
     */
    private String addJsonValidationExceptionToModelAndView(Exception ex, ModelAndView mav) {
        JsonValidationException jve = (JsonValidationException)ex;
        Errors errors = jve.getErros();
        StringBuilder msg = new StringBuilder();
        String m;
        List<ValidationErrorInfo> list = new ArrayList<>();
        ValidationErrorInfo validationErrorInfo;

        for(ObjectError oe : errors.getAllErrors()) {
            log.debug("OE:{}", oe);
            validationErrorInfo = new ValidationErrorInfo(oe);
             m = getMessage(oe);

            validationErrorInfo.setMessage(m);
            list.add(validationErrorInfo);
            msg.append(m);
            msg.append(System.lineSeparator());
        }

        mav.addObject("exError", list);

        return msg.toString();
    }

    /**
     * Spring MessageSourceAccessor 에서 ObjectError의 Validation Code 에 해당하는 메시지를 반환
     * 없을 경우 기본 메시지를 반환
     * @param oe
     * @return
     */
    private String getMessage(ObjectError oe) {
        String m = null;

        for(String code : oe.getCodes()) {
            try {
                return MessageUtil.getMessage(code);
            } catch(NoSuchMessageException nsme) {
                m = oe.getDefaultMessage();
            }
        }

        return m;
    }



}
