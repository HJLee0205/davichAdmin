package net.danvi.dmall.admin.web.common.util;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.util.image.ImageSizeCheck;
import dmall.framework.common.util.image.ImageValid;

@Slf4j
@Component("goodsImageHandler")
public class GoodsImageHandler {
    /** validation check list */
    private final List<ImageValid> validCheckList;

    /**
     * constructor
     */
    public GoodsImageHandler() {
        validCheckList = new ArrayList<ImageValid>();
        validCheckList.add(new ImageSizeCheck());
    }

    /**
     * <pre>
     * job
     * 이미지 resize handle
     * 
     * <pre>
     * 
     * @param data
     * @return
     */
    public boolean job(GoodsImageInfoData data) {
        boolean isSuccess = false;
        try {
            // 이미지 resize
            GoodsImageResizer resizer = new GoodsImageResizer(data);
            resizer.process();

        } catch (Exception ex) {
            log.debug("##job## (exception failed) data={}", data, ex);

            isSuccess = false;
        }

        return isSuccess;
    }
}
