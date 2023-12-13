package net.danvi.dmall.biz.app.setup.personcertify.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 22.
 * 작성자     : dong
 * 설명       : 본인 확인 인증 VO 목록 처리를 위한 Wrapper 클래스
 * </pre>
 */
public class PersonCertifyConfigPOListWrapper extends BaseModel<PersonCertifyConfigPOListWrapper> {
    @Valid
    private List<PersonCertifyConfigPO> list;

    public PersonCertifyConfigPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<PersonCertifyConfigPO> getList() {
        return list;
    }

    public void setList(List<PersonCertifyConfigPO> list) {
        this.list = list;
    }
}
