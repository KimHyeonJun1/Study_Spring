<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">faq정보</h3>

<table class="table tb-row">
<colgroup>
	<col width="200px">
	<col>
</colgroup>
<tr><th>질문</th>
	<td>${vo.question}</td>
</tr>
<tr><th>답변</th>
	<td>${vo.answer}</td>

</table>
<div class="btn-toolbar gap-3 justify-content-center">
	<button class="btn btn-primary" onclick="location='list'">faq목록</button>
	<button class="btn btn-primary" onclick="location='modify?id=${vo.id}'">faq정보수정</button>
	<button class="btn btn-primary" id="btn-delete">faq정보삭제</button>
</div>



<script>
$("#btn-delete").on("click", function(){
	if(confirm("[${vo.id}] 정보를 삭제하시겠습니가?")){
				location = "delete?id=${vo.id}";										
				}	
});

</script>
</body>
</html>





