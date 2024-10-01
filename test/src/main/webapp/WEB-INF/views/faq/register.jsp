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
<body>
<h3 class="my-4 ">질문 등록</h3>
<form method="post" action="register" enctype="multipart/form-data">
<table class="table tb-row">
<colgroup>
	<col width=200px>
	<col>
</colgroup>
<tr><th>질문</th>
	<td><input type="text" name="question" title="질문"  class="check-empty form-control"></td>
</tr>
<tr><th>답변</th>
	<td><textarea name="answer" title="답변"  class="check-empty form-control"></textarea></td>
</tr>

</table>
<div class="btn-toolbar justify-content-center gap-2">
	<button class="btn btn-primary px-4" id="btn-save">저장</button>
	<button class="btn btn-outline-primary px-4" id="btn-cancel">취소</button>
</div>
</form>


<script>
$("#btn-save").on("click", function(){
	if(isNotEmpty()) 
		$("form").submit()
})
$("#btn-cancel").on("click", function(){
	location = "list"
})
</script>
</body>
</html>