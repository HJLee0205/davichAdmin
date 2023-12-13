package net.danvi.dmall.admin.web.view.setup.controller;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPO;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPOListWrapper;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.app.setup.personcertify.service.PersonCertifyConfigService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * 본인 인증 확인 설정 정보 Controller
 * 
 * @author dong
 * @since 2016.05.04
 */
/**
 * 네이밍 룰
 * View 화면
 * Grid 그리드
 * Tree 트리
 * Ajax Ajax
 * Insert 입력
 * Update 수정
 * Delete 삭제
 * Save 입력 / 수정
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/personcertify")
public class PersonCertifyConfigController {

    @Resource(name = "personCertifyConfigService")
    private PersonCertifyConfigService personCertifyConfigService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 본인 인증 확인 설정화면을 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/certify-config")
    public ModelAndView viewtPersonCertifyConfig() {
        ModelAndView mav = new ModelAndView("/admin/setup/personCertifyConfig");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 본인 인증 확인 설정 정보 목록을 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/personcertify-config-list")
    public @ResponseBody ResultListModel<PersonCertifyConfigVO> selectPersonCertifyConfigList() {
        ResultListModel<PersonCertifyConfigVO> result = new ResultListModel<>();

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(siteNo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 본인 인증 확인 설정 정보를 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/personcertify-config")
    public @ResponseBody ResultModel<PersonCertifyConfigVO> selectPersonCertifyConfig(
            @Validated PersonCertifyConfigVO vo, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트의 성인 인증 설정 여부를 json 형태로 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/adultcertify-config-check")
    public @ResponseBody ResultModel<PersonCertifyConfigVO> checkAdultCertifyConfig(@Validated PersonCertifyConfigVO vo,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        String result = personCertifyConfigService.checkAdultCertifyConfig(vo);
        vo.setCheckExistAdultCertifyYn(result);
        return new ResultModel<PersonCertifyConfigVO>(vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 본인 인증 확인 설정 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/personcertify-config-update")
    public @ResponseBody ResultModel<PersonCertifyConfigPO> updatePersonCertifyConfig(
            @Validated(UpdateGroup.class) PersonCertifyConfigPOListWrapper po, BindingResult bindingResult)
            throws Exception {

        PersonCertifyConfigPOListWrapperValidator validator = new PersonCertifyConfigPOListWrapperValidator();
        validator.validate(po, bindingResult);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }
        ResultModel<PersonCertifyConfigPO> result = personCertifyConfigService.updatePersonCertifyConfig(po);
        return result;
    }

    /**
     * <pre>
     * 프로젝트명 : 41.admin.web
     * 작성일     : 2016. 9. 22.
     * 작성자     : dong
     * 설명       : 입력받은 인자값의 유효성을 확인한다. 
     *              (사용여부 "Y"일 경우만 유효성 체크 적용)
     * </pre>
     */
    class PersonCertifyConfigPOListWrapperValidator implements Validator {

        @Override
        public boolean supports(Class clazz) {
            return PersonCertifyConfigPOListWrapper.class.equals(clazz);
        }

        @Override
        public void validate(Object target, Errors errors) {
            PersonCertifyConfigPOListWrapper poWrapper = (PersonCertifyConfigPOListWrapper) target;

            if (poWrapper.getList() != null) {
                List<PersonCertifyConfigPO> poList = poWrapper.getList();
                PersonCertifyConfigPO po = null;
                for (int i = 0; i < poList.size(); i++) {
                    po = poList.get(i);
                    if ("Y".equals(po.getUseYn())) {
                        if (StringUtils.isEmpty(po.getSiteCd())) {
                            errors.rejectValue("list[" + i + "].siteCd", "사이트 코드 값을 입력해 주십시요.");
                        }
                        if (StringUtils.isEmpty(po.getSitePw())) {
                            errors.rejectValue("list[" + i + "].sitePw", "사이트 패스워드 값을 입력해 주십시요.");
                        }
                    }
                }
            }

        }

    }

}