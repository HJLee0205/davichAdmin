<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-10
  Time: 오전 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>
    var prtc=(document.location.protocol=="https:")?"https://":"http://";
    var smsemailServer = '<spring:eval expression="@core['system.smsemail.url']"/>';
    var Constant = {
        file : {
            maxSize : <spring:eval expression="@back['system.upload.file.size']"/>
        },
        smsemailServer : smsemailServer.replace("http://",prtc)
    }
    var _IMAGE_DOMAIN = '${_IMAGE_DOMAIN}';
</script>