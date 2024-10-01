/**
 * 공동처리함수
 */

//필수입력항목 입력여부 확인
function isNotEmpty(){
	var ok = true;
	
	$(".check-empty").each(function(){
		if($(this).val()==""){
			alert($(this).attr("title") + " 입력하세요ㅎㅎ")
			$(this).focus()
			ok = false;
			return ok;
		}
	})
	return ok;
}