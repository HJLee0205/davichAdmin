package net.danvi.dmall.biz.common.model;

import lombok.Data;
import org.hibernate.validator.constraints.NotEmpty;
import dmall.framework.common.model.BaseModel;

@Data
public class ImageViewSO extends BaseModel<ImageViewSO> {

    @NotEmpty
    private String type;
    @NotEmpty
    private String id1;
    private String id2;
    private String id3;

    private String path;

}
