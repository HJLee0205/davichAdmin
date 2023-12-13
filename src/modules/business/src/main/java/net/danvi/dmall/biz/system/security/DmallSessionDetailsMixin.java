package net.danvi.dmall.biz.system.security;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import net.danvi.dmall.biz.system.model.LoginVO;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.List;

/**
 * Created by dong on 2016-04-05.
 */
public abstract class DmallSessionDetailsMixin {

    @JsonCreator
    public DmallSessionDetailsMixin(
        @JsonProperty("username") String username,
        @JsonProperty("pswd") String password,
        @JsonProperty("user") LoginVO user,
        @JsonProperty("authorities") List<SimpleGrantedAuthority> authorities
    ){}
}