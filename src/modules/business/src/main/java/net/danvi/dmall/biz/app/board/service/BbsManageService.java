package net.danvi.dmall.biz.app.board.service;

import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.model.EditorBasePO;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.board.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.board.model.BbsManagePO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.model.BbsManageVO;
import net.danvi.dmall.biz.app.board.model.BbsTitleManagePO;
import net.danvi.dmall.biz.common.model.FileDownloadSO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface BbsManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 게시판 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<BbsManageVO> selectBbsListPaging(BbsManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 정보을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<BbsManageVO> selectBbsDtl(BbsManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsManagePO> insertBbs(BbsManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsManagePO> updateBbs(BbsManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판별 글 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<BbsLettManageVO> selectBbsLettPaging(BbsLettManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 상세 정보를 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<BbsLettManageVO> selectBbsLettDtl(BbsLettManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> insertBbsLett(BbsLettManagePO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> updateBbsLett(BbsLettManagePO po, HttpServletRequest request) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> deleteBbsLett(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 노출/비노출 설정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> updateBbsLettExpsYn(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 상세 정보를 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    String selectBbsLettLvl(BbsLettManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 조회수 업데이트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> updateInqCnt(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 nextBbsLettNo 가져오기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<BbsLettManageVO> nextBbsLettNo(BbsLettManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 정보을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<BbsLettManageVO> preBbsLettNo(BbsLettManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> insertBbsReply(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> updateBbsReply(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManagePO> deleteBbsReply(BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 게시판 댓글 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<BbsCmntManageVO> selectBbsCmntList(BbsCmntManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 댓글을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsCmntManagePO> insertBbsComment(BbsCmntManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 댓글을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsCmntManagePO> deleteBbsComment(BbsCmntManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<BbsManageVO> selectBbsTitleList(BbsManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리를 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsManagePO> insertBbsTitle(BbsManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리를 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<BbsTitleManagePO> deleteBbsTitle(BbsTitleManagePO po) throws Exception;

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 상품 게시판 관련 건수 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    ResultModel<BbsLettManageVO> goodsBbsInfo(BbsLettManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 디비에 접근하는 xml 파일 명을 가져온다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param bbsId
     * @return
     */
    String getLettXmlName(String bbsId);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 어떤 게시글 DB 확인 하는 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param bbsId
     * @return
     */
    String getLettDbName(String bbsId);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 에디터에서 등록하는 이미지 파일 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param refNo
     * @param fileGb
     * @return
     * @throws Exception
     */
    ResultModel<AtchFilePO> insertCmnAtchFile(EditorBasePO<? extends EditorBasePO> po, String refNo,
                                              String fileGb) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 파일 첨부를 하는 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param po
     * @return
     */
    ResultModel<AtchFilePO> insertAtchFile(HttpServletRequest request, BbsLettManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 첨부 파일 정보를 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    FileVO selectAtchFileDtl(AtchFilePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 파일 삭제를 하는 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param po
     * @return
     */
    ResultModel<AtchFilePO> deleteAtchFile(AtchFilePO po) throws Exception;

    /**
     * 
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : dong
     * 설명   : 파일 사이즈 체크
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. dong - 최초생성
     * </pre>
     *
     * @param request
     * @return
     */
    int fileSizeCheck(HttpServletRequest request);
    
    
    /**
     * <pre>
     * 작성일 : 2019. 2. 18.
     * 작성자 : khy
     * 설명   : 상품후기 적립금 지급여부 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 2. 18. khy - 최초생성
     * </pre>
     *
     * @param bbsId
     * @return
     */
    public BbsLettManageVO getSvmnPay(BbsLettManagePO po);

    public String selectNewLettNo(String bbsId);
}
