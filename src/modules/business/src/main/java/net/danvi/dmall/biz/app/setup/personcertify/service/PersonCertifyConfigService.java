package net.danvi.dmall.biz.app.setup.personcertify.service;

import java.util.List;

import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPO;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigPOListWrapper;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface PersonCertifyConfigService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트의 본인 인증 확인 설정 정보 목록을 조회하여 반환한다.
     *          (관리자용 본인인증 확인 화면용) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public List<PersonCertifyConfigVO> selectPersonCertifyConfigList(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트의 특정 인증수단에 관한 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public ResultModel<PersonCertifyConfigVO> selectPersonCertifyConfig(PersonCertifyConfigVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 사이트의 특정 인증수단에 관한 설정 정보를 수정한다.  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<PersonCertifyConfigPO> updatePersonCertifyConfig(PersonCertifyConfigPOListWrapper po)
            throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 성인 인증 수단 설정 여부를 검색한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public String checkAdultCertifyConfig(PersonCertifyConfigVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 08. 10
     * 작성자 : dong
     * 설명   : 아이핀 본인인증 사용 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 10 dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public boolean ipinAuthFlag(List<PersonCertifyConfigVO> list, String typeCode);

    /**
     * <pre>
     * 작성일 : 2016. 08. 10
     * 작성자 : dong
     * 설명   : 휴대폰 본인인증 사용 여부 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 08. 10 dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public boolean mobileAuthFlag(List<PersonCertifyConfigVO> list, String typeCode);
}
