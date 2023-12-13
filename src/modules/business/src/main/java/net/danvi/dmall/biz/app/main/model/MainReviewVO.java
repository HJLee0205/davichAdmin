package net.danvi.dmall.biz.app.main.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import lombok.Data;

import java.util.Date;

/**
 * Created by dong on 2016-07-12.
 */
@Data
public class MainReviewVO {
    private String recent;
    private String low;
    private String high;
    private String goodsTypeCd;
}
