package kr.co.test.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	return "list";
	}
}
