package net.danvi.dmall.biz.app.member.level.service;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 등급 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("memberLevelService")
@Transactional(rollbackFor = Exception.class)
public class MemberLevelServiceImpl extends BaseService implements MemberLevelService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberLevelVO> viewMemGradeList(MemberLevelSO so) {

        return proxyDao.selectListPage(MapperConstants.MEMBER_LEVEL + "viewMemGradeList", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberLevelVO> selectGradeGetList() {
        MemberLevelSO so = new MemberLevelSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        return proxyDao.selectListPage(MapperConstants.MEMBER_LEVEL + "selectGradeGetList", so);
    }

    @Override
    public ResultModel<MemberLevelPO> deleteMemGrade(MemberLevelPO po) {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            po.setDelYn("Y");
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "deleteMemGrade", po);

            // 삭제되는 회원등급을 가지고 있는 회원의 회원 등급 변경
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "deleteMemGradeFromMem", po);
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
            
            // 구매혜택 데이터 삭제
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "deleteMemGradeBnf", po);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> updateMemGradeManageCfg(MemberLevelPO po) throws CustomException {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateMemGradeManageCfg", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> updateMemGradeAsbConfig(MemberLevelPO po) throws CustomException {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateMemGradeAsbConfig", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> updateMemGradeConfig(MemberLevelPO po) throws CustomException {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateMemGradeConfig", po);
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateSignupBnf", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> insertMemGrade(MemberLevelPO po) {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            Long memberGradeNo = bizService.getSequence("MEMBER_GRADE_NO", po.getSiteNo());
            po.setMemberGradeNo(String.valueOf(memberGradeNo));
            po.setDelYn("N");
            proxyDao.insert(MapperConstants.MEMBER_LEVEL + "insertMemGrade", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberLevelVO> getMemGradeBenefitGrpList(MemberLevelSO so) {
        List<MemberLevelVO> result = proxyDao.selectList(MapperConstants.MEMBER_LEVEL + "getMemGradeBenefitGrpList",
                so);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberLevelVO> viewMemGradeBenefitList(MemberLevelSO so) {

        return proxyDao.selectList(MapperConstants.MEMBER_LEVEL + "viewMemGradeBenefitList", so);
    }

    @Override
    public ResultModel<MemberLevelPO> insertMemGradeBenefit(MemberLevelPO po) throws Exception {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "insertMemGradeBenefit", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> updateMemGradeBenefit(MemberLevelPO po) throws Exception {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateMemGradeBenefit", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> deleteMemGradeBenefit(MemberLevelPO po) throws Exception {
        ResultModel<MemberLevelPO> result = new ResultModel<>();

        try {
            po.setDelYn("Y");
            proxyDao.update(MapperConstants.MEMBER_LEVEL + "deleteMemGradeBenefit", po);
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public ResultModel<MemberLevelPO> updateUseYn(MemberLevelPO po) throws Exception {
        ResultModel<MemberLevelPO> result = new ResultModel<>();
        long memberGradeBnfNo = po.getMemberGradeBnfNo();
        long init = 0;
        try {
            po.setUseYn("N");
            po.setMemberGradeBnfNo(init);
            int chk = proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateUseYn", po);
            po.setUseYn("Y");
            po.setMemberGradeBnfNo(memberGradeBnfNo);
            if (chk > 0) {
                proxyDao.update(MapperConstants.MEMBER_LEVEL + "updateUseYn", po);
            } else {

            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberLevelVO> selectMemGradeAsbConfig(MemberLevelSO so) {
        MemberLevelVO vo = new MemberLevelVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_LEVEL + "selectMemGradeAsbConfig", so);
        return new ResultModel<>(vo);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberLevelVO> viewMemGradeUpdate(MemberLevelSO so) {
        MemberLevelVO vo = new MemberLevelVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_LEVEL + "viewMemGradeUpdate", so);
        return new ResultModel<>(vo);
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectMemGradeLevelCnt(MemberLevelSO so) {
        return proxyDao.selectOne(MapperConstants.MEMBER_LEVEL + "selectMemGradeLevelCnt", so);
    }

    @Override
    public ResultModel<MemberLevelVO> viewSignupBnf(MemberLevelSO so) {
        MemberLevelVO vo = proxyDao.selectOne(MapperConstants.MEMBER_LEVEL + "selectSignupBnf", so);
        return new ResultModel<>(vo);
    }
}
