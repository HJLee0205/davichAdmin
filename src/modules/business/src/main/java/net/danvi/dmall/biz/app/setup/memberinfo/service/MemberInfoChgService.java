package net.danvi.dmall.biz.app.setup.memberinfo.service;

import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigPO;
import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigVO;
import dmall.framework.common.model.ResultModel;

public interface MemberInfoChgService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 비밀번호 변경안내설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<PasswordChgConfigVO> selectPasswordChgConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 비밀번호 변경안내설정 정보 값을 수정한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<PasswordChgConfigPO> updatePasswordChgConfig(PasswordChgConfigPO po) throws Exception;
}
