<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#legend span {width: 44px; height: 17px}
</style>
<link rel="stylesheet" href="<c:url value='/css/yearpicker.css'/>">
<script type="text/javascript" src="<c:url value='/js/yearpicker.js'/>"></script>
</head>
<body>
<h3 class="my-4">사원정보분석</h3>
	<ul class="nav nav-tabs" id="visual">
	  <li class="nav-item"> <a class="px-5 nav-link" >부서원수</a></li>
	  <li class="nav-item"> <a class="px-5 nav-link" >채용인원수</a></li>
	  <li class="nav-item"> <a class="px-5 nav-link" >기타</a> </li>
	</ul>

	<div id="tab-content" class="py-3 h-px600">
	<div class="tab text-center">
		<div class="form-check-inline">
		    <label class="form-check-label">
		  <input class="form-check-input" type="radio" name="chart" value="bar" checked>막대그래프
		  </label>
		</div>
		<div class="form-check-inline">
		<label class="form-check-label">
		  <input class="form-check-input" type="radio" name="chart" value="donut" >도넛그래프
		  </label>
		</div>
	</div>
	
	<div class="tab text-center">
		<div class="form-check-inline">
		    <label class="form-check-label">
		  <input class="form-check-input" type="checkbox" id="top3">상위3부서
		  </label>
		</div>
		<div class="form-check-inline">
		    <label class="form-check-label">
		  <input class="form-check-input" type="radio" name="unit" value="year" checked>년도별
		  </label>
		  
		  <div class="d-inline-block year-range">
		  	<div class="d-flex align-items-center gap-2">
		  	<input type="text" class="form-control w-px80" id="begin" readonly>
		  	<span>~</span>
		  	<input type="text" class="form-control w-px80" id="end" readonly>
		  	</div>
		  </div>
		  
		</div>
		<div class="form-check-inline">
		<label class="form-check-label">
		  <input class="form-check-input" type="radio" name="unit" value="month" >월별
		  </label>
		  
		</div>
	
  <canvas id="chart" class="m-auto h-100"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-autocolors"></script>
<script src="<c:url value='/js/chart.js'/>"></script>
<script>


$("#visual li").on("click", function(){
	$("#visual li a").removeClass("active fw-bold")
	$(this).children("a").addClass("active fw-bold")
	
	$("#tab-content .tab").addClass("d-none")
	
	
	var idx = $(this).index()
	$("#tab-content .tab").eq(idx).removeClass("d-none")
	if( idx==0 )		department();
	else if( idx ==1)	hirement();
	else if( idx ==2)	{}
})

function initChart(){
	$("#legend").remove()
	$("#chart").remove()
	
	$("#tab-content").append(`<canvas id="chart" class="m-auto h-100"></canvas>`)
}

//부서원수 조회
function department(){
// 	sampleChart()
	initChart()

	$.ajax({
		url: "department"
	}).done(function(response){
// 		console.log(response)
		var info = {};
		info.labels = [], info.data = []
		
		for(var item of response){
			info.labels.push(item.department_name)//['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange', 'Black']
			info.data.push( item.count) // [1, 2, 3, 4, 5, 6, 7]
		}
		console.log(info)
		if( $("[name=chart]:checked").val()=="bar")
			barChart(info); //막대차트 그리기
		else	
			donutChart(info) //도넛차트
// 		lineChart(info); //선차트 그리기
		
	})
}
$("[name=chart]").on("change", function(){
	department()
})

function donutChart(info){
	//전체사원수
	var sum = 0;
	for(var data of info.data){
		sum += data;
	}
	console.log('sum:', sum)
	info.pct = info.data.map(function(data){
		return (data / sum * 100).toFixed(1) //소수점 1자리
	})
	console.log('pct: ', info.pct)
	
	new Chart( $("#chart"), {
		type: 'doughnut',
		data: {
			labels: info.labels,
			datasets: [{
				label: '부서별 사원수',
				data: info.data,
				hoverOffset: 20,
			}] 
		},
		
		options: {
			cutout: '60%',
			plugins: {
				autocolors: { mode: 'data'},
				datalabels: {
					anchor: 'middle',
					formatter: function(value, item){
						console.log('value: ', value, 'item: ', item)
						item = `\${value}`  < 5 ? '' : `\${value}명\n(\${info.pct[item.dataIndex]}%)`
						return `\${item}`
					},
				}
			}
			
		}
	})
}


function lineChart(info){
	new Chart( $("#chart"), {
		type: 'line',
		data: {
			labels: info.labels,
			datasets: [{
				label: '부서별 사원수',
				data : info.data,
				borderColor: "#0000ff",
				pointBackgroundColor: "#ff0000",
				pointRadius: 5,
				tension: 0, //꺾은선 형태
			}]
		},
		options: setOptions('부서별 사원수')
	})
}



function barChart(info){
	//배열로 새로운 배열을 만들어내는 함수: map
	info.color = info.data.map(function(data){
		return colors[ Math.ceil(data*0.1)-1 ]
	})
	new Chart( $("#chart"), {
		type: 'bar',
		data: {
			labels: info.labels,
			datasets: [{
				label: '부서별 사원수',
				data: info.data,
				borderWidth: 0,
				barPercentage: 0.5,
				backgroundColor: info.color, 
			}]
		},
		options: {
			 scales: {
			      y: {
			        title: {
			          color: '#000',
			          display: true,
			          text: '부서별 사원수'
			        }
			      }
			    },
			
			plugins: {
				legend: {
					display: false,
				},
// 				  autocolors: {
// 				        mode: 'data'
// 				      }
			}
		} 
	})
	makeLegend( Math.max(...info.data) )
}

//테스트용 샘플차트
function sampleChart(){
	  new Chart($("#chart"), {
	    type: 'bar',
	    data: {
	      labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange', 'Black'],
	      datasets: [{
	        label: '# of Votes',
	        data: [1, 2, 3, 4, 5, 6, 7],
	        borderWidth: 1
	      }]
	    },
	    options: {
	      scales: {
	        y: {
	          beginAtZero: true
	        }
	      }
	    }
	  });
}
//채용인원 수 조회
function hirement(){
	initChart()
	
	var unit = $("[name=unit]:checked").val()
	$.ajax({
		url: "hirement/" + unit,
		data: JSON.stringify( {begin: $("#begin").val(), end: $("#end").val() }),
		type: 'post',
		contentType: 'application/json',
	}).done(function(response){
		console.log(response)
		var info = {}
		info.data = [], info.labels = [], info.unit = unit;
		for( var item of response ){
			info.data.push(item.count)
			info.labels.push(item.unit)
		}
		console.log('info> ',info)
		unitChart( info)
	})
}


//상위3부서 체크여부에 따라
$("[name=unit], #top3").on("change", function(){
	if( $("[name=unit]:checked").val()=="year")
		$(".year-range").removeClass("d-none")
	else
		$(".year-range").addClass("d-none")
	
	if( $("#top3").prop("checked") ) hirement_top3()
	else 							 hirement()
})

//TOP3 부서에 대한 년도별/월별 채용인원수 조회
function hirement_top3(){
	initChart()
	
	var unit = $("[name=unit]:checked").val()
	
	$.ajax({
		url: "hirement/top3/" + unit,
		data: JSON.stringify( {begin: $("#begin").val(), end: $("#end").val() }),
		type: 'post',
		contentType: 'application/json',
	}).done(function(response){
// 		console.log('list> ', response.list)
// 		console.log('labels> ', response.labels)
		
		var info = {}
		info.data = [], info.name = [], info.unit = unit;
		info.labels = response.labels.map(function(yymm){
			return yymm + (unit=='year' ? '년' :'월')
		})
		for(var d of response.list){
			info.name.push(d.department_name);
			var data = response.labels.map(function(unit){
				return d[unit]
			})
			info.data.push(data)
		}
		console.log('info>', info)
		top3Chart(info)
	})
}

$(document)
.on("click", ".yearpicker-items", function(){
	if ( $("#begin").val() > $("#end").val() ) $("#begin").val( $("#end").val())
	
	if( $("#top3").prop("checked") ) hirement_top3()
	else 							 hirement()
})

$(function(){
	//기본년도범위 저장
	var thisYear = new Date().getFullYear();
	$("#end").yearpicker({
		endYear: thisYear,
		startYear: thisYear-100,
	})
	$("#begin").yearpicker({
		year: thisYear-9,
		endYear: thisYear,
		startYear: thisYear-100,
	})
	
	$("#visual li").eq(1).trigger("click") //부서원수 선택
})
</script>
</body>
</html>











