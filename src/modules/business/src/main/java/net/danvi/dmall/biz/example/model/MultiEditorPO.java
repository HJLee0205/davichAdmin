package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.MultiEditorBasePO;

import javax.validation.constraints.NotNull;

/**
 * 에디터의 정보를 저장하기 위한 PO
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class MultiEditorPO extends MultiEditorBasePO<MultiEditorPO> {

    @NotNull
    private String name;

    @NotNull
    private String content1;
    private String content2;

}
