package net.danvi.dmall.front.web.view.common.controller;

import javax.annotation.Resource;

import net.danvi.dmall.biz.common.service.FileService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

/**
 * Created by dong on 2016-05-27.
 */
@Slf4j
@Controller
@RequestMapping("/image")
public class ImageController extends net.danvi.dmall.web.ImageController {
    /** 파일 업로드 경로 */
    @Value("#{system['system.upload.path']}")
    private String realFilePath;

    @Resource(name = "fileService")
    private FileService fileService;
}
