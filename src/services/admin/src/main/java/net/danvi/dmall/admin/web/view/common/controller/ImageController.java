package net.danvi.dmall.admin.web.view.common.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.FileService;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 27.
 * 작성자     : dong
 * 설명       : 이미지 출력 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/image")
public class ImageController extends net.danvi.dmall.web.ImageController {
    /** 파일 업로드 경로 */
    // @Value("#{system['system.upload.path']}")
    // private String realFilePath;

    @Resource(name = "fileService")
    private FileService fileService;

}
