package kr.co.test.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;



import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import kr.co.test.faq.FaqMapper;
import kr.co.test.faq.FaqVO;
import lombok.RequiredArgsConstructor;

@Controller @RequestMapping("/faq") @RequiredArgsConstructor
public class FaqController {
	private final FaqMapper mapper;
	
	
	//Faq 목록 화면 요청
	@RequestMapping("/list")
	public String list( Model model) {
		List<FaqVO> list = mapper.getListOfFaq();
		model.addAttribute("list", list);
	return "faq/list";
	}
	
	
		//faq 등록화면 요청
			@RequestMapping("/register")
			public String register() {
				return "faq/register";
		}
		//faq 등록 저장처리 요청
		@PostMapping("/register")
		public String register(FaqVO vo,  HttpServletRequest request) {
			//화면에서 입력한 정보로 DB에 신규저장 후 목록화면으로 연결
			mapper.registerFaq(vo);
			return "redirect:list";
		}
		
		//선택한 faq 수정화면 요청
		@RequestMapping("/modify")
		public String modify(int id , Model model) {
			//해당 정보를 DB에서 조회해와 수정화면에 출력: Model객체에 담기
			FaqVO vo = mapper.getOneFaq(id);
			model.addAttribute("vo", vo );
			
			return "faq/modify";
		}
		
		//고객정보 삭제처리 요청
		@RequestMapping("/delete")
		public String delete(int id) {
			//DB에서 선택한 고객정보를 삭제
			mapper.deleteFaq(id);
			//응답화면: 고객목록 
			return "redirect:list";
		}
		
		//고객정보 수정저장처리 요청
		@PostMapping("/update")
		public String update(FaqVO vo) {
			//화면에서 변경입력한 정보로 DB에 변경저장
			mapper.updateFaq(vo);
			//응답화면: 고개정보
			return "redirect:info?id=" + vo.getId();
		}
		
		//선택한 정보화면 요청
		@RequestMapping("/info")
		public String info(int id, Model model) {
		
			//선택한 faq 글을 DB에서 조회해 정보화면에 출력할 수 있게 Model객체에 담기
			FaqVO vo = mapper.getOneFaq(id);
			model.addAttribute("vo", vo );
			return "faq/info";
		}
}
