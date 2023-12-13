package net.danvi.dmall.biz.ifapi.mem.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.ifapi.mem.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   ErpMemberService
 * 작성자:   gh.jo
 * 작성일:   2022/12/02
 * 설명:
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2022/12/02 gh.jo  최초 생성
 */

public interface ErpMemberService {

    /**
     * 회원 통합 정보 저장(ERP)
     * @param param
     * @return
     * @throws Exception
     */
    int insertMemberCombineInfoToErp(MemberCombineReqDTO param) throws Exception;

    /**
     * 회원통합 정보 회원분리(쇼핑몰)
     * @param param
     * @return
     * @throws Exception
     */
    int deleteMemberCombineInfoFromMall(MemberCombineReqDTO param) throws Exception;

    /**
     * 회원통합 정보 삭제(쇼핑몰)
     * @param param
     * @return
     * @throws Exception
     */
    int deleteMemberFromMall(MemberCombineReqDTO param) throws Exception;

    /**
     * 다비젼에서 회원통합
     * @param param
     * @return
     * @throws Exception
     */
    public int combineMemberFromErp(MemberCombineReqDTO param) throws Exception;

    /**
     * 오프라인 회원 조회
     * @param param
     * @return
     * @throws Exception
     */
    List<OfflineMemberVO> getOfflineMemberInfo(OfflineMemberSO param) throws Exception;

    /**
     * 온라인 카드번호와 중복되는 오프라인 카드번호가 존재 하는지 확인
     * @param param
     * @return
     * @throws Exception
     */
    String onlineCardNoDupCheckWithOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception;

    @Transactional(readOnly = true)
    ResultModel<MemberManageVO> selectMemberErpLeave(MemberManageSO so);

    OfflineShopMemberVO getShopMemberInfo(OfflineShopMemberVO so);

    List<OnlineMemSearchResDTO.OnlineMemInfo> getOnlineMemberCardInfo(OnlineMemSearchReqDTO param);

    List<OnlineMemSearchResDTO.OnlineMemInfo> getOnlineMemberInfo(OnlineMemSearchReqDTO param);

    void updateErpMemberLvl();

    String memberJoinFromStore(StoreMemberJoinReqDTO param) throws Exception;


//    /**
//     * 오프라인 포인트 조회
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    int getOfflineAvailPoint(String f_sCdCust) throws Exception;


    /**
     * 오프라인 포인트 증감내역 조회
     * @param param
     * @return
     * @throws Exception
     */
    List<OffPointHistorySearchResDTO.PointHistoryDTO> getOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception;


    /**
     * 오프라인 가능 스탬프 조회
     * @param param
     * @return
     * @throws Exception
     */
    int getOfflineAvailStamp(OffPointSearchReqDTO param) throws Exception;

    /**
     * 오프라인 스탬프 증감내역 조회
     * @param so
     * @return
     */
    ResultListModel<StampHistoryDto> getOfflineStampHistory(OfflineStampHistorySearchDto so);


    /**
     * 2023-05-12 210
     * 회원 톱합 시키기
     * **/
    Map setErpIntergratedMember(OfflineMemberVO memberVO) throws Exception;

    /**
     * 2023-05-19 210
     * 회원탈퇴 할때 이알피쪽 탈퇴디비 맥스 시퀀스 가져오기
     * **/
    public Integer selectOfflineLeaveMemberSeq(Map param) throws Exception;
    /**
     * 2023-05-19 210
     * 이알피 회원탈퇴 입력
     * **/
    public Integer insertOfflineLeaveMember(Map param) throws Exception;

}
