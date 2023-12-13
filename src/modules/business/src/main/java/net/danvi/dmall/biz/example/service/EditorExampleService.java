package net.danvi.dmall.biz.example.service;

import net.danvi.dmall.biz.example.model.EditorPO;
import net.danvi.dmall.biz.example.model.EditorVO;
import net.danvi.dmall.biz.example.model.MultiEditorPO;
import net.danvi.dmall.biz.example.model.MultiEditorVO;
import dmall.framework.common.model.ResultModel;

/**
 * Created by dong on 2016-05-25.
 */
public interface EditorExampleService {

    public ResultModel saveEditor(EditorPO po) throws Exception;

    public ResultModel saveMultiEditor(MultiEditorPO po) throws Exception;

    public ResultModel selectEditor(EditorVO vo) throws Exception;

    public ResultModel selectMultiEditor(MultiEditorVO vo) throws Exception;
}
