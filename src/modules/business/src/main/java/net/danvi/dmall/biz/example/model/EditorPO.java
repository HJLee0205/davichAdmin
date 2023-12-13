package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.BannedWordReplace;
import dmall.framework.common.model.EditorBasePO;

import javax.validation.constraints.NotNull;

/**
 * 에디터의 정보를 저장하기 위한 PO
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class EditorPO extends EditorBasePO<EditorPO> {

    @NotNull
    private String name;

    @NotNull
    @BannedWordReplace
    private String content;

}
