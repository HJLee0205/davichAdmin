<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function(){
    var url = '/front/promotion/leftwing-info';
    Dmall.AjaxUtil.load(url, function(result) {
        $('#banner').html(result);
    })
});

</script>
<div id="banner"></div>
