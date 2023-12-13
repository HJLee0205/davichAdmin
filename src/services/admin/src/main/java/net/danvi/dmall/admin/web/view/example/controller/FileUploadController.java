package net.danvi.dmall.admin.web.view.example.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupSO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupVO;
import net.danvi.dmall.biz.app.setup.base.service.AdminAuthConfigService;
import net.danvi.dmall.biz.example.model.EditorPO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * Created by dong on 2016-05-25.
 */
@Controller
@RequestMapping("/admin/example")
@Slf4j
public class FileUploadController {

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{system['system.upload.path']}")
    private String filePath;

    @Value("#{system['system.upload.temp.path']}")
    private String tempFilePath;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    @Resource(name = "adminAuthConfigService")
    private AdminAuthConfigService adminAuthConfigService;

    @RequestMapping("/upload-excel")
    public String excelUploadResult(Model model
            , MultipartHttpServletRequest mRequest) throws Exception {

        FileVO result = new FileVO();
        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        log.debug("excel : \n{}", list);

        model.addAttribute("file", result);
        return View.jsonView();
    }

    @RequestMapping("/download-excel")
    public String downloadExcel(Model model) throws Exception {
        ManagerGroupSO so = new ManagerGroupSO();
        so.setSiteNo(1L);

        // 엑셀로 출력할 데이터 조회
        ResultListModel<ManagerGroupVO> resultListModel = adminAuthConfigService.selectManagerGroupList(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[]{"번호", "소속인원", "권한그룹번호", "권한구분코드", "권한명", "메뉴ID", "메뉴명"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[]{"rownum", "cnt", "authGrpNo", "authGbCd", "authNm", "menuId", "menuNm"};

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME, new ExcelViewParam("test_sheet_name", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "test_excel"); // 엑셀 파일명

        return View.excelDownload();
    }

    @RequestMapping("/upload-form")
    public @ResponseBody
    ResultModel uploadForm(EditorPO po, HttpServletRequest request) {
        ResultModel result = new ResultModel();

        /**
         * 파일 정보 추출
         * 임시 폴더로 보내던 실제 서비스 폴더로 보내던, 업로드 한 파일을 filePath에 저장함
         * 여기서 임시 폴더로 filePath를 지정할 경우, 서비스 폴더로 나중에 이동시켜야 함.
         */
        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, filePath);

        // TODO: PO 정보 저장

        return result;
    }
}
