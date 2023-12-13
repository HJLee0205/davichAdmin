package net.danvi.dmall.biz.app.setup.personcertify.service;

import java.util.List;

import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPO;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPOListWrapper;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("personCertifyConfigService")
@Transactional(rollbackFor = Exception.class)
public class PersonCertifyConfigServiceImpl extends BaseService implements PersonCertifyConfigService {

    /** 본인 확인 인증 설정 정보 목록 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.personcertify.service.
     * PersonCertifyConfigService#selectPersonCertifyConfigList(java.lang.Long)
     */
    @Override
    @Transactional(readOnly = true)
    public List<PersonCertifyConfigVO> selectPersonCertifyConfigList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.SETUP_PERSON_CERTIFY + "selectPersonCertifyConfigList", siteNo);
    }

    /** 본인 확인 인증 설정 정보 단건 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.personcertify.service.
     * PersonCertifyConfigService#selectPersonCertifyConfig(net.danvi.dmall.
     * biz.app.setup.personcertify.model.PersonCertifyConfigVO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<PersonCertifyConfigVO> selectPersonCertifyConfig(PersonCertifyConfigVO vo) {
        PersonCertifyConfigVO resultVO = proxyDao
                .selectOne(MapperConstants.SETUP_PERSON_CERTIFY + "selectPersonCertifyConfig", vo);
        ResultModel<PersonCertifyConfigVO> result = new ResultModel<>(resultVO);

        return result;
    }

    /** 본인 확인 인증 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.personcertify.service.
     * PersonCertifyConfigService#updatePersonCertifyConfig(net.danvi.dmall.
     * biz.app.setup.personcertify.model.PersonCertifyConfigPOListWrapper)
     */
    @Override
    public ResultModel<PersonCertifyConfigPO> updatePersonCertifyConfig(PersonCertifyConfigPOListWrapper wrapper)
            throws Exception {
        ResultModel<PersonCertifyConfigPO> resultModel = new ResultModel<>();

        for (PersonCertifyConfigPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.SETUP_PERSON_CERTIFY + "updatePersonCertifyConfig", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 성인 인증 설정 여부 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.personcertify.service.
     * PersonCertifyConfigService#selectPersonCertifyConfig(net.danvi.dmall.
     * biz.app.setup.personcertify.model.PersonCertifyConfigVO)
     */
    @Override
    @Transactional(readOnly = true)
    public String checkAdultCertifyConfig(PersonCertifyConfigVO vo) {
        String result = "N";
        int cnt = proxyDao.selectOne(MapperConstants.SETUP_PERSON_CERTIFY + "checkAdultCertifyConfig", vo);
        if (cnt > 0) {
            result = "Y";
        }
        return result;
    }

    /**
     * 아이핀 본인인증 사용 여부 반환 (CertifyTypeCd:01)
     */
    public boolean ipinAuthFlag(List<PersonCertifyConfigVO> list, String typeCode) {
        boolean ioFlag = false;

        for (int i = 0; i < list.size(); i++) {
            PersonCertifyConfigVO tempVo = list.get(i);
            // typeCode
            // 1. member: 회원가입, 개인정보수정
            // 2. find: 아이디찾기, 비밀번호찾기
            // 3. drmt: 휴면회원
            if ("01".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getMemberJoinUseYn()) && "member".equals(typeCode)) {
                ioFlag = true;
            } else if ("01".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getPwFindUseYn()) && "find".equals(typeCode)) {
                ioFlag = true;
            } else if ("01".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getDormantmemberCertifyUseYn()) && "drmt".equals(typeCode)) {
                ioFlag = true;
            }
        }

        return ioFlag;
    }

    /**
     * 휴대폰 본인인증 사용 여부 반환 (CertifyTypeCd:02)
     */
    public boolean mobileAuthFlag(List<PersonCertifyConfigVO> list, String typeCode) {
        boolean moFlag = false;

        for (int i = 0; i < list.size(); i++) {
            PersonCertifyConfigVO tempVo = list.get(i);
            // typeCode
            // 1. member: 회원가입, 개인정보수정
            // 2. find: 아이디찾기, 비밀번호찾기
            // 3. drmt: 휴면회원
            if ("02".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getMemberJoinUseYn()) && "member".equals(typeCode)) {
                moFlag = true;
            } else if ("02".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getPwFindUseYn()) && "find".equals(typeCode)) {
                moFlag = true;
            } else if ("02".equals(tempVo.getCertifyTypeCd()) && "Y".equals(tempVo.getUseYn())
                    && "Y".equals(tempVo.getDormantmemberCertifyUseYn()) && "drmt".equals(typeCode)) {
                moFlag = true;
            }
        }

        return moFlag;
    }
}
