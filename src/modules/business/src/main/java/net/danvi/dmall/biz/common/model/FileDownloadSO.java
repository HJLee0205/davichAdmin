package net.danvi.dmall.biz.common.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-27.
 */
@Data
public class FileDownloadSO extends BaseModel<FileDownloadSO> {

    @NotEmpty
    private String type;
    @NotEmpty
    private String id1;
    private String id2;
    private String id3;
    private String fileNo;
}
