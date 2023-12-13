package net.danvi.dmall.biz.app.operation.service;

import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.operation.model.PushSendPO;
import net.danvi.dmall.biz.app.operation.model.PushSendSO;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface AppPushService {

    /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : push 발송내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<PushSendVO> selectPushHstPaging(PushSendSO so);
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : push 발송내역 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<PushSendVO> insertPush(PushSendVO vo, HttpServletRequest request)  throws Exception;
    
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 17.
     * 작성자 : khy
     * 설명   : push 발송조건을 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */    
    public List<PushSendPO> selectPushCondition(PushSendVO vo) ;
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 17.
     * 작성자 : khy
     * 설명   : push 관리 내역 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */    
    public PushSendVO selectPushManagerInfo(PushSendSO so) ;
    

    /**
     * <pre>
     * 작성일 : 2018. 8. 21.
     * 작성자 : khy
     * 설명   : push 발송내역 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 21. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<PushSendVO> updatePushManager(PushSendVO vo)  throws Exception;
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 21.
     * 작성자 : khy
     * 설명   : push 발송내역 취소
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 21. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<PushSendVO> updatePushCancel(PushSendVO vo)  throws Exception;    
    
    
    public String selectPushNo() ;
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 21.
     * 작성자 : khy
     * 설명   : push 발송내역 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 4. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */    
    public void deletePush(PushSendVO vo) throws Exception ;    

}
