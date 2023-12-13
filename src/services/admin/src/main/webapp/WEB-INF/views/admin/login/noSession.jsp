<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script language="javascript">
	alert('${resultMsg}');
	if(opener) {
		opener.document.location.href='${adminConstants.LOGIN_URL}';
	} else {
		document.location.href='${adminConstants.LOGIN_URL}';
	}
</script>
