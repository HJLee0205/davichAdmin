<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<!-- //네이버아디디로로그인 초기화 Script -->
<script>
    var naverClientId = "${snsConfig.data.appId}";
    var naver = new naver_id_login(naverClientId, location.origin+"${_MOBILE_PATH}/front/login/naver-login-return");
    
    // 네이버 콜백
    function naverSignInCallback() {
        var token = naver.getAccessToken();
        opener.snsLoginProcess(token, "NV"); //accessToken, path
        self.close();
    }
    
    naverSignInCallback();
</script>
