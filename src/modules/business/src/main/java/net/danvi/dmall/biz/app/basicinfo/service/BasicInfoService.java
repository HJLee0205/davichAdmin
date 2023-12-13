package net.danvi.dmall.biz.app.basicinfo.service;

import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface BasicInfoService {

    /** 사이트 공통정보 조회 (GNB,BOTTOM INFO) **/
    public ResultListModel<BasicInfoVO> selectBasicInfo(long siteNo) throws Exception;

}
