package net.danvi.dmall.biz.app.main.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-07-11.
 */
@Data
public class AdminMainSO extends BaseModel<AdminMainSO> {
    private String firstDayOfWeek;
    
    private Long sellerNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sellerId;
    private String sellerNm;
    private String stDate;
    private String endDate;
    
}
