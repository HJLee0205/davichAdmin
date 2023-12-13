package net.danvi.dmall.biz.app.setup.term.service;

import java.util.List;

import dmall.framework.common.model.ResultListModel;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigListVO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigPO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigVO;
import dmall.framework.common.model.ResultModel;
import org.springframework.validation.BindingResult;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface TermConfigService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 약관 개인정보 설정 정보 리스트를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultListModel<TermConfigListVO> selectTermConfigList(TermConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 약관 개인정보 설정 정보를 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<TermConfigVO> selectTermConfig(TermConfigSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 06.
     * 작성자 : dong
     * 설명   : 표준약관 설정 정보를 파일로 부터 조회한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 06. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<TermConfigVO> selectDefaultTermConfig(TermConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 약관 개인정보 설정 값을 수정한다.  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<TermConfigPO> updateTermConfig(TermConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 약관 개인정보 설정 값을 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<TermConfigPO> insertTermConfig(TermConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 이미 동의했는지 체크
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public int selectTermApplyInfo(TermConfigSO so) throws Exception;
    
    
    /**
     * <pre>
     * 작성일 : 2021. 5. 12.
     * 작성자 : dong
     * 설명   : 약관동의 사인 이미지 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2021. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    public TermConfigVO selectTermApplySingInfo(TermConfigSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2022. 09. 22.
     * 작성자 : slims
     * 설명   : 약관/개인정보 설정 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 09. 22. slims - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    ResultModel<TermConfigPO> deleteTermConfig(TermConfigPO po);
}
