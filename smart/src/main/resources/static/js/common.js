/**
 * 공동처리함수
 */
"use strict"
$(function(){
	var today = new Date();
	var range = today.getFullYear() - 100 + ":" + today.getFullYear();

	$.datepicker.setDefaults({
		dateFormat: "yy-mm-dd",
		changeYear: true,
		changeMonth: true,
		showMonthAfterYear: true,
		monthNamesShort: [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		dayNamesMin: [ "일", "월", "화", "수", "목", "금", "토"],				 
		maxDate: today, //최대선택가능날짜
		yearRange: range,
	});

	$(".date").attr("readonly", true); //날짜 입력 비활성화
	$(".date").datepicker();
});