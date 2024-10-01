<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">faq목록</h3>
<div class="row mb-3 justify-content-between">
	<div class="col-auto">
	<form method="post" action="list">
		
		</form>
	</div>

<div class="col-auto">
	<button class="btn btn-primary" onclick="location='register'">질문등록</button>
</div>
</div>

<table class="table td-list">
<colgroup>
	<col width="100px">
	<col width="100px">
	<col width="100px">
	<col width="100px">
</colgroup>
<tr><th>번호</th><th>질문</th><th>답변</th><th>작성일자</th></tr>

<c:if test="${empty list}">
    <tr>
        <td colspan="4">등록된 질문이 없습니다.</td>
    </tr>
</c:if>
<c:forEach items="${list }" var="vo">
	
<tr>
	<td>${vo.id}</td>
	<td><a class="text-link" href="info?id=${vo.id}">${vo.question }</a></td>
	<td>${vo.answer }</td>
	<td>${vo.writedate }</td>
</tr>
</c:forEach>
</table>

</body>
</html>