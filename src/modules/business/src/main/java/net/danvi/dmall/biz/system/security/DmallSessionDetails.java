package net.danvi.dmall.biz.system.security;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.List;

/**
 * Created by dong on 2016-04-04.
 */
public class DmallSessionDetails implements UserDetails {
    private Session session;
    private String username;
    private String password;
    private Boolean login = false;
    private Long siteNo;

    List<SimpleGrantedAuthority> authorities = null;

    public DmallSessionDetails(){}

    public DmallSessionDetails(String username, String password, Session session, List<SimpleGrantedAuthority> authorities) {
        this.username = username;
        this.password = password;
        this.session = session;
        this.authorities = authorities;
        this.siteNo = session.getSiteNo();
        if(authorities != null && authorities.size() > 0) {
        	this.login = true;
        } else {
        	this.login = false;
        }
    }

    @Override
    public List<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(List<SimpleGrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    @JsonIgnore
    public boolean isEnabled() {
        return false;
    }

    public boolean isLogin() {
        return login;
    }

    public void setLogin(Boolean login) {
        this.login = login;
    }

    public Session getSession() {
        return session;
    }
    public void setSession(Session session) {
        this.session = session;
    }

    public Long getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(Long siteNo) {
        this.siteNo = siteNo;
    }
}
