package net.danvi.dmall.biz.batch.member.service;

import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 17.
 * 작성자     : dong
 * 설명       : 회원 관련 배치 Service
 * </pre>
 */
public interface MemberBatchService {
    public List<MemberManageVO> memDormantReader();

    public List<MemberManageVO> memDormantAlamReader();

    public ResultModel<MemberManagePO> memDormantWriter(MemberManageVO vo)
            throws AddressException, MessagingException, Exception;

    public ResultModel<MemberManagePO> memDormantAlamWriter(MemberManageVO vo)
            throws AddressException, MessagingException, Exception;

    public List<MemberManageVO> selectWithdrawalMemTargetBbs();

    public void deleteMemberNoRelationBbsInfo(MemberManageVO po);

    public List<MemberManageVO> selectWithdrawalMemTargetOrd();

    public void deleteMemberNoRelationOrdInfo(MemberManageVO po);

    public List<MemberLevelVO> selectMemGradeRearrangeList();

    public List<MemberLevelVO> selectMemGradeList(MemberLevelSO so);

    public void updateMemGradeRearrange(MemberLevelPO po);

    public void updateMailSendResult(EmailSendPO po);
    
    public void interfaceMemberGrade() throws Exception;
    
    public List<VisitVO> selectMemVisitRsvList();
    
    public ResultModel<VisitVO> visitRsvAlamWriter(VisitVO vo)
            throws AddressException, MessagingException, Exception;
    
}
