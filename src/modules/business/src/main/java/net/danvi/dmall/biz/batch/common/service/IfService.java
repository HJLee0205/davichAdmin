package net.danvi.dmall.biz.batch.common.service;

import net.danvi.dmall.biz.batch.common.model.IfExecLogVO;
import net.danvi.dmall.biz.batch.common.model.IfLogVO;

/**
 * Web service
 * 
 * @author snw
 * @since 2013.09.02
 */

public interface IfService {

    /**
     * 연계 번호 채번
     * 
     * @param IfLogVO
     * @return Integer
     * @throws Exception
     */
    public String getIfNo(IfLogVO vo) throws Exception;

    /**
     * 연계 일련번호 채번
     * 
     * @param IfExecLogVO
     * @return Integer
     * @throws Exception
     */
    public String getIfSno(IfExecLogVO vo) throws Exception;

    /**
     * 연계 로그 등록
     * 
     * @param IfLogVO
     * @return Integer
     * @throws Exception
     */
    public void insertIfLog(IfLogVO vo) throws Exception;

    /**
     * 연계 로그 수정
     * 
     * @param IfLogVO
     * @return Integer
     * @throws Exception
     */
    public void updateIfLog(IfLogVO vo) throws Exception;

    /**
     * 연계 실행로그 등록
     * 
     * @param IfExecLogVO
     * @return Integer
     * @throws Exception
     */
    public void insertIfExecLog(IfExecLogVO vo) throws Exception;

    /**
     * 연계 실행로그 수정
     * 
     * @param IfExecLogVO
     * @return Integer
     * @throws Exception
     */
    public void updateIfExecLog(IfExecLogVO vo) throws Exception;

    /**
     * execKey = srchKey 조건으로 연계 실행 로그 수정
     * 
     * @param IfExecLogVO
     * @return Integer
     * @throws Exception
     */
    public void updateIfExecLogBySrchKey(IfExecLogVO vo) throws Exception;
}