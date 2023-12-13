package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.MemberSvmnVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.MemberSvmnSO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("memberSvmnAnlsService")
@Transactional(rollbackFor = Exception.class)
public class MemberSvmnAnlsServiceImpl extends BaseService implements MemberSvmnAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberSvmnVO> selectMemberSvmnList(MemberSvmnSO memberSvmnSO) {
        if (memberSvmnSO.getSidx().length() == 0) {
            memberSvmnSO.setSidx("B.MEMBER_NM DESC, A.MEMBER_ID");
            memberSvmnSO.setSord("DESC");
        }

        String searchWords = memberSvmnSO.getSearchWords();
        if ("name".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchName(searchWords);
        } else if ("id".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchId(searchWords);
        } else if ("email".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchEmail(searchWords);
        } else if ("tel".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchTel(searchWords);
        } else if ("mobile".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchMobile(searchWords);
        }

        // 회원 마켓포인트 분석결과
        ResultListModel<MemberSvmnVO> resultListModel = proxyDao
                .selectListPage(MapperConstants.MEMBER_SVMN_ANLS + "selectMemberSvmnList", memberSvmnSO);

        // 회원 마켓포인트 분석결과 총 합
        if ("name".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchName(searchWords);
        } else if ("id".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchId(searchWords);
        } else if ("email".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchEmail(searchWords);
        } else if ("tel".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchTel(searchWords);
        } else if ("mobile".equals(memberSvmnSO.getSearchType())) {
            memberSvmnSO.setSearchMobile(searchWords);
        }
        resultListModel.put("resultListSum",
                proxyDao.selectList(MapperConstants.MEMBER_SVMN_ANLS + "selectTotMemberSvmnList", memberSvmnSO));

        // 전체회원 마켓포인트 분석결과
        memberSvmnSO.setTotalSum("1");
        resultListModel.put("resultListTotalSum",
                proxyDao.selectList(MapperConstants.MEMBER_SVMN_ANLS + "selectTotMemberSvmnList", memberSvmnSO));
        return resultListModel;
    }
}
