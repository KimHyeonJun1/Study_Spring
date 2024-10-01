<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">faq정보수정</h3>

<form method="post" action="update">
<input type="hidden" name="id" value="${vo.id }">
<table class="table tb-row">
<colgroup>
	<col width="200px">
	<col>
</colgroup>
<tr><th>질문</th>
	<td>
		<div class="row">
			<div class="col-auto">
				<input type="text" name="question" value="${vo.question }" class="form-control">
			</div>
		</div>
	</td>
</tr>
<tr><th>답변</th>
	<td>
		<div class="row">
			<div class="col-auto">
				<input type="text" name="answer" value="${vo.answer }" class="form-control">
			</div>
		</div>
	</td>
</tr>
</table>
</form>

<div class="btn-toolbar gap-3 justify-content-center">
	<button class="btn btn-primary px-4" id="btn-save">저장하기</button>
	<button class="btn btn-outline-primary px-4" id="btn-cancel">취소하기</button>
</div>
<script>

$("#btn-save").on("click", function(){
	$("form").submit();
})

$("#btn-cancel").on("click", function(){
	location='info?id=${vo.id}';
})
</script>
</body>
</html>





