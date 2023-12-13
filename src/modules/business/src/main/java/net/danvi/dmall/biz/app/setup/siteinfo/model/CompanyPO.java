package net.danvi.dmall.biz.app.setup.siteinfo.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-08-04.
 */
@Data
public class CompanyPO extends BaseModel<CompanyPO> {
    private String homepageId;
    /** 대표자 */
    private String ceoNm;
    /** 회사명 */
    private String companyNm;

    /** 전화번호 */
    private String telNo;
    /** 팩스 */
    private String faxNo;
    /** 주소 */
    private String addrRoadnm;
    private String addrCmnDtl;
    /** 담당자이메일 */
    private String email;
    /** 사업자등록증번호 */
    private String bizNo;
    /** 통신사업자번호 */
    private String commSaleRegistNo;
    /** 개인정보관리책임자 */
    private String privacymanager;
}
