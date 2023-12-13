package net.danvi.dmall.biz.example.model;

import lombok.Data;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.Length;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

import javax.validation.constraints.Digits;
import javax.validation.constraints.NotNull;

/**
 * <pre>
 * 프로젝트명 : 05.admin.web
 * 작성일     : 2016. 4. 1.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
public class ExampleVO {
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    @Length(min = 6, max = 20)
    private String id;

    @NotNull
    @Length(min = 2, max = 20)
    private String name;

    @Digits(integer = 3, fraction = 0)
//    @Min(1)
    private int age;

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String pwd;

    private String content;
}
