<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
 <t:putAttribute name="title">홈 &gt; 설정 &gt; 회원정보 변경 관리 &gt; 비밀번호 변경 안내 설정</t:putAttribute>
 <t:putAttribute name="script">
  <script type="text/javascript">
      $(document).ready(function() {
          MemberInfoUtil.init();
          MemberInfoUtil.render();

          jQuery('#btn_save').off('click').on('click', function(e) {
              Dmall.EventUtil.stopAnchorAction(e);
              MemberInfoUtil.save();
          });

          Dmall.validate.set('form_member_info');
      });

      var MemberInfoUtil = {
          init : function() {
              $('label.chack').off('click').on('click', function(e) {
                  Dmall.EventUtil.stopAnchorAction(e);
                  var $this = jQuery(this), $input = jQuery("#" + $this.attr("for")), checked = !($input
                          .prop('checked'));
                  $input.prop('checked', checked);
                  $this.toggleClass('on');
              });
          }
          , setPwChgGuideYn:function(data, obj, bindName, target, area, row) {
              var bindValue = obj.data("bind-value")
                  , value = data[bindValue];
    
              $("input:radio[name=pwChgGuideYn][value=" + value + "]").trigger('click');
          }
          , setDormantMemberCancelMethod:function(data, obj, bindName, target, area, row) {
              var bindValue = obj.data("bind-value")
                  , value = data[bindValue];
    
              $("input:radio[name=dormantMemberCancelMethod][value=" + value + "]").trigger('click');
          }
          , render : function() {
              var url = '/admin/setup/config/memberinfo/memberinfo-change-info',
              dfd = jQuery.Deferred();
              
              Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                  if (result == null || result.success != true) {
                      return;
                  }
                  
                  MemberInfoUtil.bind(result.data);
                  dfd.resolve(result.data);
              });
              return dfd.promise();
          }
          , bind : function(data) {
              //회원정보 변경관리 페이지에 접속시 변경안내주기와 다음에변경 안내설정 항목의 기본값이 없다면 최초 자동 등록
              //pwChgGuideCycle: 6, pwChgNextChgDcnt: 15
              if(data.pwChgGuideCycle === null || data.pwChgGuideCycle === '' 
                      || data.pwChgNextChgDcnt === null || data.pwChgNextChgDcnt === '') {
                  MemberInfoUtil.initSave();
              }
              $('[data-find="member_info"]').DataBinder(data);
          }
          , initSave : function() {
              if(Dmall.validate.isValid('form_member_info')) {
                  var url = '/admin/setup/config/memberinfo/passwordchange-config-update',
                      param = {'pwChgGuideYn':'N', 'pwChgGuideCycle':'6', 'pwChgNextChgDcnt':'15'};
                  
                  Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                      Dmall.validate.viewExceptionMessage(result, 'form_member_info');
                      
                      if (result == null || result.success != true) {
                          return;
                      } else {
                          MemberInfoUtil.render();
                      }
                  });
              }
              return false;
          }
          , save : function() {
              if(Dmall.validate.isValid('form_member_info')) {
                  var url = '/admin/setup/config/memberinfo/passwordchange-config-update',
                      param = jQuery('#form_member_info').serialize();
                  
                  Dmall.AjaxUtil.getJSON(url, param, function(result) {
                      Dmall.validate.viewExceptionMessage(result, 'form_member_info');
                      
                      if (result == null || result.success != true) {
                          return;
                      } else {
                          MemberInfoUtil.render();
                      }
                  });
              }
              return false;
          }
      };
    </script>
 </t:putAttribute>

 <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">회원정보 변경 관리</h2>
                <!-- <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
                </div> -->
        </div>

       <form id="form_member_info">
           <!-- line_box -->
           <div class="line_box fri">
               <h3 class="tlth3">비밀번호 변경 안내 설정</h3>
               <!-- tblw -->
               <div class="tblw tblmany">
                   <table summary="이표는 비밀번호 변경 안내 설정 표 입니다. 구성은 사용여부, 변경안내 주기, 다음에변경 안내설정 입니다.">
                       <caption>비밀번호 변경 안내 설정</caption>
                       <colgroup>
                           <col width="20%">
                           <col width="80%">
                       </colgroup>
                       <tbody>
                           <tr>
                               <th>사용여부</th>
                               <td id="td_pwChgGuideYn" data-find="member_info" data-bind-value="pwChgGuideYn" data-bind-type="function" data-bind-function="MemberInfoUtil.setPwChgGuideYn">
                                   <label for="rdo_pwChgGuidYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="pwChgGuideYn" id="rdo_pwChgGuidYn_Y" value="Y"></span> 사용</label> 
                                   <label for="rdo_pwChgGuidYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="pwChgGuideYn" id="rdo_pwChgGuidYn_N" value="N"></span> 사용안함</label> 
                                   <span class="br2"></span> 
                                             사용 설정시 고객이 로그인 했을 때 비밀번호 변경을 위한 페이지가 안내 되어 보여집니다.
                               </td>
                           </tr>
                           <tr>
                               <th>변경안내 주기</th>
                               <td>최종 변경일 기준 
                                   <span class="select one">
                                       <label for="sel_pwChgGuideCycle"></label>
                                       <select name="pwChgGuideCycle" id="sel_pwChgGuideCycle" data-find=member_info data-bind-type="labelselect" data-bind-value="pwChgGuideCycle">
                                           <c:forEach var="month" begin="1" end="12" step="1" varStatus="status">
                                               <option value="${month}">${month}</option>
                                           </c:forEach>
                                       </select>
                                   </span> 개월을 주기로 비밀번호 변경 시까지 안내
                               </td>
                           </tr>
                           <tr>
                               <th>‘다음에변경’<br>안내설정</th>
                               <td>
                                   <span class="select one">
                                       <label for="sel_pwChgNextChgDcnt"></label>
                                       <select name="pwChgNextChgDcnt" id="sel_pwChgNextChgDcnt" data-find=member_info data-bind-type="labelselect" data-bind-value="pwChgNextChgDcnt">
                                           <c:forEach var="day" begin="1" end="50" step="1" varStatus="status">
                                               <option value="${day}">${day}</option>
                                           </c:forEach>
                                       </select>
                                   </span> 일 동안 비밀번호 변경 안내 안함
                               </td>
                           </tr>
                       </tbody>
                   </table>
               </div>
               <!-- //tblw -->
               
               <h3 class="tlth3">휴면회원 해제 설정</h3>
               <!-- tblw -->
               <div class="tblw tblmany">
                   <table summary="이표는 휴면회원 해제 설정 표 입니다. 구성은 휴면회원 처리조건, 해제조건, 해제방법 입니다.">
                       <caption>비밀번호 변경 안내 설정</caption>
                       <colgroup>
                           <col width="20%">
                           <col width="80%">
                       </colgroup>
                       <tbody>
                           <tr>
                               <th>휴면회원 처리조건</th>
                               <td>
                                   1년 이상 로그인 기록이 없는 회원 자동으로 휴면 처리됨 
                               </td>
                           </tr>
                           <tr>
                               <th>휴면회원 고지</th>
                               <td>
                                   휴면처리 30일전에 대상자에게 고지가 필요
                                   <span class="br2"></span>
                                   설정 &gt; 운영 &gt; 이메일 자동발송 &gt; 11개월동안 로그인 없는 회원을 선택 후 발송 가능합니다.
                               </td>
                           </tr>
                           <tr>
                               <th>휴면회원 해제방법</th>
                               <td id="td_dormantMemberCancelMethod" data-find="member_info" data-bind-value="dormantMemberCancelMethod" data-bind-type="function" data-bind-function="MemberInfoUtil.setDormantMemberCancelMethod">
                                   <label for="rdo_dormantMemberCancelMethod_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="dormantMemberCancelMethod" id="rdo_dormantMemberCancelMethod_1" value="1"></span> 로그인 후 해제</label>
                                   <label for="rdo_dormantMemberCancelMethod_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="dormantMemberCancelMethod" id="rdo_dormantMemberCancelMethod_2" value="2"></span> 본인확인인증 후 해제</label>
                               </td>
                           </tr>
                       </tbody>
                   </table>
               </div>
               <!-- //tblw -->
               <p class="point_c3">
                  <strong>* 참고</strong><br/>
                            본인확인인증 후 해제는 [설정 &gt; 기본관리 &gt; 본인확인 인증서비스] 아이핀/휴대폰 인증 서비스를 사용해야만 해당 서비스 사용 가능합니다. <br/>
               </p>
           </div>
           <!-- //line_box -->
       </form>

	   <div class="btn_box txtc">
			<a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
		</div>


    </div>
   </t:putAttribute>
</t:insertDefinition>