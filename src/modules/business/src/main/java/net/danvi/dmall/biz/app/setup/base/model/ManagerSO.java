package net.danvi.dmall.biz.app.setup.base.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-05-03.
 */
@Data
public class ManagerSO extends BaseSearchVO<ManagerSO> {
    private String type;

    private String keyword;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String encKeyword;
}
