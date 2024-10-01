//공통처리함수


"use strict"

$(function() {
	var today = new Date();
	var range = today.getFullYear() - 100 + ":" + today.getFullYear(); //년도선택범위
	$.datepicker.setDefaults({
		dateFormat: "yy-mm-dd",
		changeYear: true,
		changeMonth: true,
		showMonthAfterYear: true,
		monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월"
			, "7월", "8월", "9월", "10월", "11월", "12월"],
		dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
		maxDate: today, //쵀대선택가능날짜
		yearRange: range,
	})

	$(".date").attr("readonly", true); //날짜 입력불가(달력선택만 가능)
	$(".date").datepicker();

	$(".date").on("change", function() {
		$(this).next(".date-remove").removeClass("d-none")
	})

	//-------------------------------------------------------------------------------------


	// 단일파일 선택 처리 ----------------------------------------------------------------------
	$(".file-single").on("change", function() {
		//console.log($(this.files[0]))
		console.log('attached>', this.files[0])

		var preview = $(this).closest(".file-info").find(".file-preview")
		var remove = $(this).closest(".file-info").find(".file-remove");
		var filename = $(this).closest(".file-info").find(".file-name");

		var attached = this.files[0];
		if (attached) {//선택 파일 있는 경우
			//파일크기제한하는 경우
			if( fileSizeOver(attached, $(this)) ) return;
			
			remove.removeClass("d-none")   //삭제버튼 보이게
			filename.text( attached.name )   //선택한 파일명 보이게

			//이미지만 첨부해야만 하는 경우 
			if ($(this).hasClass("image-only")) {
				//실제 선택한 파일이 이미지인 경우
				if (attached.type.includes("image")) {
					singleFile = attached; //선택한 파일정보 담기

					preview.html("<img>")

					//선택한 파일정보를 읽어서 img태그에 src로 지정
					var reader = new FileReader();
					reader.readAsDataURL(attached);
					reader.onload = function() {
						preview.children("img").attr("src", this.result)
					}



				} else { // 선택파일이 이미지가 아닌 경우
					alert("이미지만 선택할 수 있습니다")
					setFileInfo($(this));

				}

			} else { //모든 파일 첨부가능한 경우
				singleFile = attached; //선택한 파일정보 담기


			}

		} else { //선택 파일 없는 경우 (undefined)
			setFileInfo($(this))
		}

		//	console.log("파일>", $(this).val())

	}) //end of filechange
	//----------------------------------------------------------------------------------------------------------

	$("body").on("dragover drop", function(e) {
		e.preventDefault(); //파일에 대한 링크열기 와 같은 기본 동작 취소
	})
	$(".file-drag") //--태그임
	.on("dragover",function(){ //--칸에 가져갔다가 다른곳에서 드랍
		$(this).addClass("drag-over");
	}).on("dragleave drop",function(){ //--아예 다른곳에 드랍
		$(this).removeClass("drag-over");
	}).on("drop",function(e){ //--칸에 드랍
		//console.log( e.originalEvent.dataTransfer.files )
		//디렉토리를 걸러내고 파일만 배열로 만들기
		var files = [];
		var isDirectory = false;
		for( var item of e.originalEvent.dataTransfer.items){
			//console.log(item.webkitGetAsEntry() )
			if(item.webkitGetAsEntry().isFile ){
				files.push( item.getAsFile() )
			}else{
				isDirectory = true;
			}
			
		}
		if(isDirectory)
			alert("폴더는 첨부 할 수 없습니다!!")
		
		
		Files.setter(files)
		//Files.setter(Object.values( e.originalEvent.dataTransfer.files ) )
		console.log('drop>', Files.files) 
	})
	
	$(".file-multiple").on("change", function(){
		Files.setter( Object.values(this.files) )
		console.log('multiple>', Files.files) 
	})

}); //end of $(function() {})


var Files = {
	files : [],
	removed: [], //DB에서 삭제할 파일들의 id
	
	setter: function( files ){
		var filtered = this.filter(files);
		if( filtered.overSize){
			alert("10MB 이상의 파일은 첨부할 수 없습니다");
		}
		this.files.push(...filtered.files); //배열에 배열의 요소를 추가 - spread operator --쩜 세개 찍으면 된다.
		this.viewer( filtered.files );
	},
	
	filter: function(files){
		var overSize = false;
		files = files.filter(function(file){
			if( file.size >= 1024*1024*1) overSize = true;			
			return file.size < 1024*1024*10;	
		})
		return { overSize: overSize, files: files };
		//return file.size < 1024*1024*10;	
//		})
	},
	
	transfer: function() {
		var transfer = new DataTransfer();
		for(var file of this.files ){
			transfer.items.add( file )
		}
		$(".file-multiple").prop("files", transfer.files)
		console.log( $(".file-multiple").val() )
	},
	
	remover: function( tag ) {
			var idx = tag.index()
			
			//새로 첨부한 경우 data속성x
			if( tag.data("id")== undefined ){
				this.files.splice( idx - $("[data-id]").length, 1 ) // --splice함수 -> 삭제처리 1은 하나만
							
			}else{
				this.removed.push( tag.data("id"))
			}
			
			tag.remove(); //--var tag에 for에 있는 tag div 처리 삭제하는거
			
			//모든 파일을 삭제시 초기화면에 형태로
			if( $(".file-drag .file-item").length==0) {
				$(".file-drag").html( `<div class="py-1 text-center"> 첨부할 파일을 마우스로 끌어 오세요</div>` )			
			}
		},
	
		
	viewer: function( files ) { // --파일꺼내옴
		var tag = "";
	//		console.log( 'length>', files.length)
		for( var file of files){
			tag +=`
				<div class="file-item d-flex gap-3 my-1">
					<a role="button" class="file-remove btn-close"></a>
					<span>${file.name}</sapn>
				</div>
				`
		}
		if( files.length==0 && $(".file-drag .file-item").length==0)
			$(".file-drag").html(`<div class="py-1 text-center"> 첨부할 파일을 마우스로 끌어 오세요</div>` );
		else if( $(".file-drag .file-item").length==0 )
			$(".file-drag").html( tag ) //--파일명 보임
		else
			$(".file-drag").append( tag ) 
		
	}
}

var singleFile = ""; //파일정보를 담을 변수

//잘못 선택시 이전선택 파일정보가 유지되게
function setFileInfo(tag) {
	var info = tag.closest(".file-info");
	if (singleFile != "") {
		//파일데이터를 전송하는 처리
		var transfer = new DataTransfer();
		transfer.items.add(singleFile)
		info.find(".file-single").prop("files", transfer.files)
	} else {
		//선택한 파일정보 삭제
		info.find(".file-single").val("");
		info.find(".file-remove").addClass("d-none") //삭제 버튼 안보이게
		info.find(".file-name").empty();  //파일명 안보이게
		
		//프로필은 기본이미지로 지정
		var preview = info.find(".file-preview")
		if (preview.hasClass("profile")) {
			preview.html(`<i class="font-profile fa-solid fa-circle-user"></i>`)
		}
	}
	console.log("파일태그값>", tag.val())
}

$(document)
.on("click", ".date + .date-remove", function() {
	//폰트이미지가 동적으로 만들어지므로 문서에 이벤트 등록
	$(this).addClass("d-none").prev(".date").val("");
})
.on("click", ".file-info .file-remove", function() {
	//파일삭제 클릭시 선택한 파일정보 삭제
	singleFile = "";
	setFileInfo($(this))
})
.on("click", ".file-drag .file-remove", function(){
	Files.remover( $(this).closest(".file-item") )
	console.log("remove>",Files.files)	
})
		
function addToForm(vo) {
	return `<input type="hidden" name="id" value="${vo.id}">
			<input type="hidden" name="pageNo" value="${vo.pageNo}">
			<input type="hidden" name="search" value="${vo.search}">
			<input type="hidden" name="keyword" value="${vo.keyword}">
			<input type="hidden" name="listSize" value="${vo.listSize}">
			`
}

		
//파일크기제한하기
function fileSizeOver(file, tag) {
		//1k=1024b, 1M=1024*1024b, 1G=1024*1024*1024b
		if(file.size > 1024*1024*10 ){ //10M
			alert("10Mb를 넘는 파일은 첨부할 수 없습니다")
			setFileInfo( tag )
			return true;
		}else{
			return false;
		}
}

//우편번호 주소찾기처리
function findPost(post, address1, address2) {
	new daum.Postcode({
		oncomplete: function(data) {
			//console.log(data)
			post.val(data.zonecode)
			var address = data.userSelectedType == "R" ? data.roadAddress : data.jibunAddress
			if (data.buildingName != "") address += "(" + data.buildingName + ")"
			address1.val(address)
			address2.val("")
		}
	}).open();
}


//필수입력항목 입력여부 확인
function isNotEmpty(){
	var ok = true;
	
	$(".check-empty").each(function() {
		if( $(this).val()==""){
			alert( $(this).attr("title") + "입력하세요!" )
			$(this).focus()
			ok = false;
			return ok;
		}
	})
	
	return ok;
}

/**
 * 
 */