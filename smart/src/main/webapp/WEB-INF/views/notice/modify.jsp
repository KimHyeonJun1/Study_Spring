<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-t">${vo.indent==0? '공지글' : '답글' } 수정</h3>
<form method="post" action="modify" enctype="multipart/form-data" >
<table class="table tb-row">
<colgroup>
	<col width=200px>
</colgroup>
<tr><th>제목</th>
	<td><input type="text" name="title" value="${fn: escapeXml(vo.title) }" title="제목" class="check-empty form-control"> </td>
</tr>
<tr><th>내용</th>
	<td><textarea name="content" title="내용" 
				class="check-empty form-control">${vo.content}</textarea></td>
</tr>
<tr><th>첨부파일</th>
	<td><div class="row">
			<div class="d-flex align-itmes-center gap-3 file-info">
				<label>
					<a class="btn btn-outline-primary">파일선택</a>
					<input type="file" name="file" 
						class="d-none form-control file-single">
				</label>
				<span class="file-name">${vo.filename }</span>
				<i role="button"
					class="fs-3 fa-solid fa-xmark text-danger file-remove ${empty vo.filename ? 'd-none' : ''}"></i>
				</div>
			</div>
	</td>
</tr>
</table>
</form>

<div class="btn-toolbar justify-content-center gap-2">
	<button class="btn btn-primary px-4" id="btn-save">저장</button>
	<button class="btn btn-outline-primary px-4" id="btn-cancel">취소</button>
</div>

<script>
$(function() {
	//물리적파일이 존재하지 않는 경우 삭제태그표시하기
	if( ${! file} ){
	   $(".file-name").html("<del class='text-danger'>${vo.filename}</del>")
	}
})


$("#btn-save").on("click", function() {
	var filename = $(".file-name").text()
	if( isNotEmpty() ) 
		$("form").append(`<input type="hidden" name="id" value="${vo.id}">`)
				 .append(`<input type="hidden" name="_method" value="put">` )
				 .append(`<input type="hidden" name="pageNo" value="${page.pageNo}">` )
				 .append(`<input type="hidden" name="search" value="${page.search}">` )
				 .append(`<input type="hidden" name="keyword" value="${page.keyword}">` )
				 .append(`<input type="hidden" name="filename" value="\${filename}">` )
				 .submit()
})
$("#btn-cancel").on("click",function(){
	location = "info?id=${vo.id}&pageNo=${page.pageNo}&search=${page.search}$keyword=${page.keyword}"
})



</script>




</body>
</html>