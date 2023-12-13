package net.danvi.dmall.biz.app.setup.securitymanage.service;

import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpConfigPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.ContentsProtectionPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.SecurityManagePO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * Created by dong on 2016-06-13.
 */
public interface SecurityManageService {
    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 보안서버 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public SecurityManagePO selectSecurityConfig();

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 보안서버 정보 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param securityManagePO
     * @return
     */
    public ResultModel<SecurityManagePO> saveSecurityConfig(SecurityManagePO securityManagePO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 접속 차단 IP 설정 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public AccessBlockIpConfigPO selectAccessBlockIpConfig();

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 접속 차단 IP 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultListModel<AccessBlockIpPO> selectAccessBlockIpList(AccessBlockIpPO po);

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 접속 차단 IP 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<AccessBlockIpConfigPO> saveAccessBlockIpConfig(AccessBlockIpConfigPO po);

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 접속 차단 IP 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<AccessBlockIpConfigPO> deleteAccessBlockIpConfig(AccessBlockIpConfigPO po);

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 컨텐츠 보호 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    ContentsProtectionPO selectContentsProtection();

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 컨텐츠 보호 정보 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<ContentsProtectionPO> updateContentsProtection(ContentsProtectionPO po);
}
