package net.danvi.dmall.biz.system.security;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Created by dong on 2016-04-05.
 */
public abstract class SimpleGrantedAuthorityMixin {

    @JsonCreator
    public SimpleGrantedAuthorityMixin(
        @JsonProperty("authority") String role
    ){}
}
