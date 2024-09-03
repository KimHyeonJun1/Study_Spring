<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공지글 정보</h3>

<table class="table tb-row">
<colgroup>
	<col width="200px">
	<col>
	<col width="200px">
	<col width="140px">
	<col width="200px">
	<col width="100px">
</colgroup>
<tr><th>제목</th>
	<td colspan="5">${vo.title }</td>
</tr>
<tr><th>작성자</th>
	<td>${vo.name }</td>
	<th>작성일자</th>
	<td>${vo.writedate }</td>
	<th>조회수</th>
	<td>${vo.readcnt }</td>
</tr>
<tr><th>내용</th>
	<td colspan="5">${fn: replace(vo.content, crlf, "<br>") }</td>
</tr>
<tr><th>첨부파일</th>
	<td colspan="5">
	<c:if test="${! empty vo.filename }">
	<div class="d-flex">
<!-- 		물리적 파일이 존재하면 다운로드 가능 -->
		<c:if test="${file}">
		<label role="button" class="d-flex col-auto text-link gap-3 file-download">
			<span>${vo.filename }</span>
			<i class="fs-3 fa-regular fa-circle-down"></i>
		</label>
		</c:if>
<!-- 		물리적 파일이 존재하지 않으면 다운로드 불가능 -->
		<c:if test="${! file}">
			<del class="text-danger">${vo.filename}</del>
		</c:if>
	</div>
	</c:if>
	
	</td>
</tr>
</table>

<div class="btn-toolbar justify-content-center gap-2">
	<button class="btn btn-primary" id="btn-list">목록화면</button>
	
<!-- 	로그인한 사용자가 쓴 글에 대해서만 수정/삭제 가능 -->
	<c:if test="${loginInfo.userid == vo.writer}">
	<button class="btn btn-primary" id="btn-modify">정보수정</button>
	<button class="btn btn-primary" id="btn-delete">정보삭제</button>
	</c:if>
</div>

<script>
$(".file-download").on("click", function(){
	location = "<c:url value='/notice/download?id=${vo.id}'/>"
})

$("#btn-list, #btn-modify").on("click", function(){
	var id = $(this).attr("id") //btn-list, #btn-modify
	id = id.substr(id.indexOf("-")+1) // list, modify
	location= id
	+ "?id=${vo.id}&pageNo=${page.pageNo}&search=${page.search}&keyword=${page.keyword}"
})
</script>

</body>
</html>