package net.danvi.dmall.biz.common.dao;

import net.danvi.dmall.biz.system.model.CmnCdGrpVO;
import org.springframework.stereotype.Repository;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.dao.ProxyDao;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명	: 03.business
 * 작성일		: 2016. 3. 22.
 * 작성자		: dong
 * 설명			: Common Mapper
 * </pre>
 */
@Repository("commonDao")
public class CommonDao extends ProxyDao {

	/**
	 * <pre>
	 * 작성일	: 2016. 3. 22.
	 * 작성자	: dong
	 * 설명		: 시퀀스 번호 생성
	 * 
	 * 수정일		수정자	수정내용
	 * -----------------------------------------------------------------
	 * </pre>
	 *
	 * @param param
	 * @return
	 */
	public Integer getSequence(Map param) {
		return selectOne(MapperConstants.COMMON + "getSequence", param);
	}

	public List<CmnCdGrpVO> listCodeAll(){
		return selectList(MapperConstants.COMMON  + "listCodeAll");
	}

}
