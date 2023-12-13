package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.smsemail.model.CertKeyPO;

/**
 * Created by dong on 2016-10-04.
 */
public interface CertKeyService {
    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 인증키를 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    public void insertCertKey(CertKeyPO po);

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 인증키를 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    String getCertKey(Long siteNo);
}
