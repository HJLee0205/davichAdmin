package net.danvi.dmall.biz.example.model;

import lombok.Data;
import dmall.framework.common.model.MultiEditorBaseVO;

import javax.validation.constraints.NotNull;

/**
 * 에디터에 정보를 뿌려주기 위한 VO
 */
@Data
public class MultiEditorVO extends MultiEditorBaseVO<MultiEditorVO> {

    @NotNull
    private String name;

    @NotNull
    private String content1;
    private String content2;

}
