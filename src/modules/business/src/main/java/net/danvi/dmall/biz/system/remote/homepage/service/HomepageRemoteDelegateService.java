package net.danvi.dmall.biz.system.remote.homepage.service;


import com.ckd.common.reqInterface.*;

/**
 * Created by dong on 2016-08-03.
 */
public interface HomepageRemoteDelegateService {

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 쇼핑몰 생성 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public CreateMallResult setCreateMallResult(CreateMallResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 쇼핑몰 상태 변경 결과 반환(폐쇄)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public ChangeStatusResult setChangeStatusResult(ChangeStatusResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 이미지 호스팅 생성 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqImageHostingResult(ImageHostingResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 디스크/트래픽 변경 겨과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqDiskTrafficResult(DiskTrafficResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 도메인변경 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqDomainLinkInfoResult(DomainLinkResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : PG 활성화 정보 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqPGActiveInfo(PGActiveResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 관리자 로그인 정보 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqSolutionAdminLoginHistoryInfo(SolutionResult vo);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 쇼핑몰 관리자 패스워드 변경 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public RemoteVO reqShoppingMallAdminPasswordChangeResult(ShoppingMallAdminResult vo);
}
