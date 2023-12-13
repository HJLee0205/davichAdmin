// 그리드 관련 유틸
Dmall.GridUtil = {
    /**
     * <pre>
     * 함수명 : appendPaging
     * 설  명 : 입력받은 조회 데이터와 ID들로 페이징 네이게이션을 생성한다.
     * 사용법 :
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 11. dong - 최초 생성
     * </pre>
     *
     * @param formId
     *            조회조건이 속한 폼의 ID
     * @param parentId
     *            페이징이 추가될 부모 엘리먼트의 ID
     * @param resultListModel
     *            JSON으로 받은 조회 데이터
     * @param pagingId
     *            생성할 페이징의 ID
     * @param callback
     *            페이징의 페이지 클릭시 실행할 함수(조회 함수)
     */
    appendPaging : function(formId, parentId, resultListModel, pagingId, callback) {
        jQuery('#' + parentId).html(Dmall.GridUtil.paging(resultListModel, pagingId));
        if(callback) {
            jQuery('#' + parentId).grid(jQuery('#' + formId), callback);
        } else {
            jQuery('#' + parentId).grid(jQuery('#' + formId));
        }
    },

    /**
     * <pre>
     * 함수명 : paging
     * 설  명 : 입력받은 조회 데이터와 ID로 페이징 네이게이션 코드를 생성한다.
     *          현재는 내부적으로 사용, 외부에서 appendPaging으로 처리가 안될 경우 따로 불러서 처리...
     * 사용법 :
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 11. dong - 최초 생성
     * </pre>
     *
     * @param resultListModel
     *            JSON으로 받은 조회 데이터
     * @param pagingId
     *            생성할 페이징의 ID
     */
    paging : function(resultListModel, id) {
        var currPageDiv = parseInt(resultListModel.page / 10 + 1, 10),
        firstOfPage = parseInt((currPageDiv - 1) * 10 + 1, 10),
        lastPage = parseInt(Math.min(currPageDiv * 10, resultListModel.totalPages), 10),
        p = '<ul class="pages">';

        if (currPageDiv > 1) {
            p += '<li class="prev"><a href="#none" class="pre ico_comm" data-page="' + (firstOfPage - 1) + '">';
            p += '<span><img src="'+MOBILE_CONTEXT_PATH+'/front/img/common/btn_prev.gif" alt="이전페이지로 이동"></span></a></li>';
        }

        for(var i = firstOfPage; i <= lastPage; i++) {
            if(resultListModel.page == i){
                p += '<li class="active"><span>'+i+'</span></li>';
            }else{
                p += '<li><a href="#none" class="num" data-page="' + i + '">'+i+'</a></li>';
            }
        }

        if(resultListModel.totalPages > currPageDiv * 10) {
            p += '<li class="prev"><a href="#none" class="nex ico_comm" data-page="' + (lastPage + 1) + '">';
            p += '<span><img src="'+MOBILE_CONTEXT_PATH+'/front/img/common/btn_next.gif" alt="이전페이지로 이동"></span></a></li>';
        }
        p +'</ul>'
        return p;
    }
};