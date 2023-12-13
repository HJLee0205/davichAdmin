<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 비전체크</t:putAttribute>
	<t:putAttribute name="script">		
		<script>
                $(".btn_list_view").click(function(){                	
                	var cnt = 0;
                	
                	// 검색 카테고리 3
                    var v_searchCtg3 = "";
                 	// 검색 카테고리 3 명칭
                    var v_searchCtg3Nm = "";
                	
                	$("input:checkbox[name='lens_check']").each(function(e){
                		if($(this).is(":checked") == true) {
                			cnt++;
                			var tmp = $(this).val().split("-");
                			v_searchCtg3 = v_searchCtg3 + tmp[0] + ",";
                			v_searchCtg3Nm = v_searchCtg3Nm + tmp[1] + ",";
                			
                		}
                	});
                	
                	if(cnt > 0){
                		$('#searchCtg3').val(v_searchCtg3.substring(0, v_searchCtg3.length-1));
                		$('#searchCtg3Nm').val(v_searchCtg3Nm.substring(0, v_searchCtg3Nm.length-1));
                		
                		var data = $('#form_id_search').serializeArray();
                        var param = {};
                        $(data).each(function(index,obj){
                            param[obj.name] = obj.value;
                        });
                        
                        Dmall.FormUtil.submit('/front/search/goods-list-search', param);
                	}else{
                		alert("상품을 선택해 주세요.");
                	}                	
					
                });
                

                $(".btn_go_recomm").click(function(){                	
                	var v_type = $("#lensType").val();
                	var v_active = $("#lensActive").val();
                	var v_age = $("#lensAge").val();
					var v_lengsName = "";
                	var v_type_nm = "";	       
                	var cnt = 0;
					
                	
					if(v_type == 'G'){         	
	                	$("input:checkbox[name='lens_check']").each(function(e){
	                		if($(this).is(":checked") == true) {
	                			cnt++;
	                			var tmp = $(this).val().split("-");
	                			v_lengsName = v_lengsName + tmp[1] + ",";	                			
	                		}
	                	});
	                	
	                	v_type_nm = "안경렌즈";
					}else if(v_type == 'C'){
						$("input:checkbox[name='lens_check']").each(function(e){
	                		if($(this).is(":checked") == true) {
	                			cnt++;
	                			var tmp = $(this).val().split("-");
	                			v_lengsName = v_lengsName + tmp[1] + ",";
	                		}
	                	});
	                	
	                	v_type_nm = "콘택트렌즈";
					}
					
					v_lengsName = v_lengsName.substring(0, v_lengsName.length-1);
					
					if(cnt > 0){
						alert(v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName);
						alert("'바로 예약하기' 준비중입니다.");
					}else{
						alert("상품을 선택해 주세요.");
					}
                });
                
                $(".btn_result_save").click(function(){ 
                	alert("준비중입니다.");
                });
                
		</script>		
	</t:putAttribute>
	<t:putAttribute name="content">
	<form:form id="form_id_search" method="post">
        <input type="hidden" name="searchCtg3" id="searchCtg3" value=""/>
        <input type="hidden" name="searchCtg3Nm" id="searchCtg3Nm" value=""/>
    </form:form>    
        <input type="hidden" name="lensType" id="lensType" value="${visionVO.lensType}"/>
        <input type="hidden" name="lensActive" id="lensActive" value="${viewActive}"/>
        <input type="hidden" name="lensAge" id="lensAge" value="${visionVO.lensAgeTxt}"/>
        
		<!--- 02.LAYOUT: 카테고리 메인 --->
	    <div class="category_middle">
			<div class="lens_head">
				<h2 class="lens_tit">렌즈추천</h2>
			</div>
			<div class="lens_info_area">
				<p class="tit">
					<c:choose>
						<c:when test="${visionVO.lensType == 'G'}">안경렌즈 추천결과</c:when>
						<c:when test="${visionVO.lensType == 'C'}">콘택트렌즈 추천결과</c:when>
					</c:choose>
				</p>			
			</div>
			<div class="lens_recomm result">
				<p class="recomm_text"><em>${viewActive}</em> 관련 활동을 많이 하시는</p>
				<p class="recomm_text"><em>${visionVO.lensAgeTxt}</em>의 <b>${userName}</b> 고객님께 추천해 드리는 
					<c:choose>
						<c:when test="${visionVO.lensType == 'G'}">안경렌즈입니다.</c:when>
						<c:when test="${visionVO.lensType == 'C'}">콘택트렌즈입니다.</c:when>
					</c:choose>
				</p>
				<button type="button" class="btn_recom_again" onclick="document.location.href='/front/vision/vision-check'">렌즈추천 다시받기<i></i></button>
			</div>
			
			<c:if test="${visionVO.lensType == 'G'}">
			<ul class="lens_result">
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'D') > -1 || fn:indexOf(viewGlass, 'F') > -1 ))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'D') > -1 ))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check01" value="11-개인맞춤형">
							<label for="lens_check01">개인맞춤형<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'F') > -1 ))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'F') > -1 ))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check02" value="31-일반">
							<label for="lens_check02">일반<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다. 간단한 텍스트 설명이 들어갑니다. 간단한 텍스트 설명이 들어갑니다. 간단한 텍스트 설명이 들어갑니다. 간단한 텍스트 설명이 들어갑니다. 간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'G') > -1 ))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'G') > -1 || fn:indexOf(viewGlass, 'H') > -1 || fn:indexOf(viewGlass, 'I') > -1 ))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'G') > -1 || fn:indexOf(viewGlass, 'H') > -1 || fn:indexOf(viewGlass, 'K') > -1 ))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check03" value="32-변색">
							<label for="lens_check03">변색<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'C') > -1 ))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'C') > -1 ))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'C') > -1 ))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check04" value="33-청광">
							<label for="lens_check04">청광<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'F') > -1 ))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'F') > -1 || fn:indexOf(viewGlass, 'H') > -1 || fn:indexOf(viewGlass, 'I') > -1 ))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'H') > -1 || fn:indexOf(viewGlass, 'K') > -1 || fn:indexOf(viewGlass, 'L') > -1 ))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check05" value="34-편광">
							<label for="lens_check05">편광<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>				
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'E') > -1))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'E') > -1))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'E') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check06" value="35-수경">
							<label for="lens_check06">수경<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'B') > -1))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'B') > -1))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'B') > -1 || fn:indexOf(viewGlass, 'K') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check07" value="37-선글라스렌즈">
							<label for="lens_check07">선글라스렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>		
				<c:if test="${(visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'J') > -1))}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check08" value="38-사무용">
							<label for="lens_check08">사무용<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'D') > -1))
								||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'D') > -1))
								||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'A') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check09" value="39-안정피로감소형">
							<label for="lens_check09">안정피로감소형<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'A') > -1 || fn:indexOf(viewGlass, 'C') > -1 || fn:indexOf(viewGlass, 'J') > -1))}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check10" value="42-누진일반">
							<label for="lens_check10">누진일반<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 3 && (fn:indexOf(viewGlass, 'B') > -1))}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check11" value="43-누진변색">
							<label for="lens_check11">누진변색<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
			</ul>	
			</c:if>
			<c:if test="${visionVO.lensType == 'C'}">
			<ul class="lens_result">		
				<c:if test="${(visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'D') > -1))}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check01" value="11-글로벌 정기교체형렌즈">
							<label for="lens_check01">글로벌 정기교체형렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check02" value="12-뜨레뷰 렌즈">
							<label for="lens_check02">뜨레뷰 렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'E') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check03" value="13-뜨레뷰 컬러렌즈">
							<label for="lens_check03">뜨레뷰 컬러렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'C') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'C') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'C') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'C') > -1 || fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check04" value="14-멀티포컬(기능성) 렌즈">
							<label for="lens_check04">멀티포컬(기능성) 렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'B') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check05" value="15-소프트 병렌즈">
							<label for="lens_check05">소프트 병렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check06" value="16-실리콘 병렌즈">
							<label for="lens_check06">실리콘 병렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'E') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check07" value="17-실리콘 병컬러렌즈">
							<label for="lens_check07">실리콘 병컬러렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'B') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check08" value="18-아이럽 난시렌즈">
							<label for="lens_check08">아이럽 난시렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'A') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'A') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check09" value="19-아이럽 렌즈">
							<label for="lens_check09">아이럽 렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check10" value="20-아이럽 실리콘 렌즈">
							<label for="lens_check10">아이럽 실리콘 렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'E') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check11" value="21-아이럽 컬러렌즈">
							<label for="lens_check11">아이럽 컬러렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>				
				<c:if test="${(visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'E') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'E') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check12" value="22-원데이 컬러렌즈">
							<label for="lens_check12">원데이 컬러렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'B') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check13" value="23-원데이 난시렌즈">
							<label for="lens_check13">원데이 난시렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'A') > -1 || fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check14" value="24-원데이 렌즈">
							<label for="lens_check14">원데이 렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'B') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check15" value="25-정기교체형 난시렌즈">
							<label for="lens_check15">정기교체형 난시렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'B') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check16" value="26-컬러 난시렌즈">
							<label for="lens_check16">컬러 난시렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>		
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'E') > -1))}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check17" value="27-특판렌즈">
							<label for="lens_check17">특판렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>			
				<c:if test="${(visionVO.lensAge == 1 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 2 && (fn:indexOf(viewContact, 'B') > -1))
							    ||
							  (visionVO.lensAge == 3 && (fn:indexOf(viewContact, 'B') > -1 || fn:indexOf(viewContact, 'D') > -1))
							    ||
							  (visionVO.lensAge == 4 && (fn:indexOf(viewContact, 'B') > -1 || fn:indexOf(viewContact, 'D') > -1))
				}">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check18" value="28-하드렌즈">
							<label for="lens_check18">하드렌즈<span></span></label>
						</p>				
						<p class="text">간단한 텍스트 설명이 들어갑니다.</p>
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:if>
			</ul>		
			</c:if>
			<div class="lens_visit_info">
				<c:if test="${visionVO.lensType == 'G'}">
				관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면<br> 
				전문 안경사의 상담  후 할인된 가격으로 나에게 꼭 맞는 안경렌즈를 구매하실 수 있습니다.<br>
				상품 목록보기를 통해 직접 맘에 드는 렌즈를 고른 다음 예약하셔도 됩니다.
				</c:if>
				<c:if test="${visionVO.lensType == 'C'}">
				관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면<br> 
				전문 안경사의 상담  후 할인된 가격으로 나에게 꼭 맞는 콘택트렌즈를 구매하실 수 있습니다.
				</c:if>
			</div>
			<div class="btn_lens_area">
				<c:if test="${visionVO.lensType == 'G'}"><button type="button" class="btn_list_view">상품 목록보기</button></c:if>
				<button type="button" class="btn_go_recomm">바로 예약하기</button>
				<c:if test="${userNo > 0}">
				<button type="button" class="btn_result_save"><i></i>결과 저장</button>
				</c:if>
			</div>
			
		</div>
	    <!---// 02.LAYOUT: 카테고리 메인 --->
	
	</t:putAttribute>
</t:insertDefinition>