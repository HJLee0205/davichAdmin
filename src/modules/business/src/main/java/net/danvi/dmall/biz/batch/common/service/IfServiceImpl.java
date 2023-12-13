package net.danvi.dmall.biz.batch.common.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.common.model.IfExecLogVO;
import net.danvi.dmall.biz.batch.common.model.IfLogVO;
import dmall.framework.common.BaseService;
// import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 21.
 * 작성자     : 
 * 설명       :
 * </pre>
 */
@Service("ifService")
@Slf4j
public class IfServiceImpl extends BaseService implements IfService {

    /*
     * 연계 번호 채번
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public String getIfNo(IfLogVO vo) {

        String ifNo = proxyDao.selectOne("system.link.ifLog.selectIfNo", vo);
        log.debug("{} ======== 연계 번호 채번 : 연계번호 = {}", vo.getIfPgmNm(), ifNo);
        return ifNo;
    }

    /*
     * 연계 일련번호 채번
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public String getIfSno(IfExecLogVO execVo) {

        String ifSno = proxyDao.selectOne("system.link.ifLog.selectIfSno", execVo);
        log.debug("0-1.1.======== 연계 일련번호 채번 : 연계일련번호 = {}", ifSno);
        return ifSno;
    }

    /*
     * 연계 로그 등록
     * 
     * (non-Javadoc)
     * 
     * @see
     * IfService#insertIfLog(net.
     * danvi.dmall.biz.batch.common.model.IfLogVO)
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void insertIfLog(IfLogVO vo) throws Exception {
        // 연계번호 채번
        String ifNo = getIfNo(vo);

        // IfLogVO 에 연계 번호 셋팅
        vo.setIfNo(ifNo);
        log.debug("{} 연계로그 등록 : 연계번호 = {}, {}", vo.getIfPgmNm(), ifNo, vo);
        insertIfLogNew(vo);
        return;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    private void insertIfLogNew(IfLogVO vo) throws Exception {
        ResultModel<String> result = new ResultModel<>();
        try {
            proxyDao.insert("system.link.ifLog.insertIfLog", vo);
        } catch (Exception e) {
            log.error(e.toString());
            result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
        return;
    }

    /*
     * 연계 로그 수정
     * 
     * (non-Javadoc)
     * 
     * @see
     * IfService#insertIfLog(net.
     * danvi.dmall.biz.batch.common.model.IfLogVO)
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public void updateIfLog(IfLogVO vo) throws Exception {
        ResultModel<String> result = new ResultModel<>();

        log.debug("{} 연계로그 수정 : 연계번호 = {}", vo.getIfPgmNm(), vo.getIfNo());
        try {
            proxyDao.update("system.link.ifLog.updateIfLog", vo);

        } catch (Exception e) {
            log.error(e.toString());
            result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
        return;
    }

    /*
     * 연계 실행로그 등록
     * 
     * (non-Javadoc)
     * 
     * @see
     * IfService#insertIfLog(net.
     * danvi.dmall.biz.batch.common.model.IfExecLogVO)
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void insertIfExecLog(IfExecLogVO execVo) throws Exception {
        ResultModel<String> result = new ResultModel<>();

        // 연계 일련번호 채번
        String ifSno = getIfSno(execVo);
        log.debug("0-3. 연계실행로그 등록 : 연계일련번호 = {}", ifSno);

        // IfExecLogVO 에 연계 일련번호 셋팅
        execVo.setIfSno(ifSno);

        insertIfExecLogNew(execVo);
        return;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    private void insertIfExecLogNew(IfExecLogVO execVo) throws Exception {
        ResultModel<String> result = new ResultModel<>();
        try {
            proxyDao.insert("system.link.ifLog." + "insertIfExecLog", execVo);

        } catch (Exception e) {
            log.error(e.toString());
            result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
        return;
    }

    /*
     * 연계 실행로그 수정
     * 
     * (non-Javadoc)
     * 
     * @see
     * IfService#insertIfLog(net.
     * danvi.dmall.biz.batch.common.model.IfExecLogVO)
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public void updateIfExecLog(IfExecLogVO execVo) throws Exception {
        ResultModel<String> result = new ResultModel<>();

        log.debug("0-4. 연계실행로그 수정 : 연계일련번호 = {}", execVo.getIfSno());
        try {
            proxyDao.update("system.link.ifLog." + "updateIfExecLog", execVo);

        } catch (Exception e) {
            log.error(e.toString());
            result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
        return;
    }

    /*
     * execKey = srchKey 조건으로 연계 실행 로그 수정
     * 
     * (non-Javadoc)
     * 
     * @see
     * IfService#insertIfLog(net.
     * danvi.dmall.biz.batch.common.model.IfExecLogVO)
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public void updateIfExecLogBySrchKey(IfExecLogVO execVo) throws Exception {
        ResultModel<String> result = new ResultModel<>();

        log.debug("0-5. execKey = srchKey 조건으로 연계실행로그 수정 : 조회키 = {}", execVo.getSrchKey());
        try {
            proxyDao.update("system.link.ifLog." + "updateIfExecLogBySrchKey", execVo);

        } catch (Exception e) {
            log.error(e.toString());
            result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
        return;
    }

}