package kr.co.smart.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.smart.common.CommonUtility;
import kr.co.smart.member.MemberMapper;
import kr.co.smart.member.MemberVO;
import lombok.AllArgsConstructor;

@Controller @AllArgsConstructor @RequestMapping("/member")
public class MemberController {
	private CommonUtility common;
	private MemberMapper mapper;
	private PasswordEncoder password;
	
	//임시 비밀번호를 발급해주는 처리를 요청
	public void tempPassword(MemberVO vo) {
		//화면에서 입력한 아이디와 이메일이 일치하는 회원에게
		vo = mapper.getOneMemberByUseridAndEmail(vo);
		StringBuffer msg = new StringBuffer("<script>");
		if(vo == null) {
			msg.append("alert('아이디나 이메일이 맞지 않습니다. \\n다시 확인하세요')");
			msg.append("location='findPassword'");
		}
		//임시비번을 생성한 후 회원정보에 변경저장, 임시비번을 이메일로 알려주기
		
		msg.append("</script>");
	}
	
	//비밀번호찾기 화면 요청
	@RequestMapping("/findPassword")
	public String findPassword(HttpSession session) {
		session.setAttribute("category", "find");
		return "default/member/find";
	}
	
	@RequestMapping("/logout")
	//로그아웃 처리 요청
	public String logout(HttpSession session) {
		//세션의 로그인정보를 삭제하기
		session.removeAttribute("loginInfo");
		//응답화면-웰컴화면
		return "redirect:/";
	}
	
	//로그인 처리 요청
	@ResponseBody @RequestMapping("/smartLogin")
	public String login(String userid, String userpw
			, HttpServletRequest request, HttpSession session) {
		//화면에서 입력한 아이디/비번이 일치하는 회원정보 조회하기
		MemberVO vo =  mapper.getOneMember(userid);
		boolean match = false;
		if(vo != null) {
			//해당 아이디의 회원정보가 있는 경우만 입력비번과 DB의 암호화된 비번의 일치여부 확인
			match = password.matches(userpw, vo.getUserpw());
		}
		
		StringBuffer msg = new StringBuffer("<script>");
		//로그인된 경우- 웰컴페이지로 연결
//		return "redirect:/";
		if(match) {
		msg.append("location='").append(common.appURL(request)).append("'");
		//로그인정보를 session에 저장하기
		session.setAttribute("loginInfo", vo);
		}else {
			
		
//		StringBuffer msg = new StringBuffer("<script>");
			//로그인되지 않은 경우- 로그인페이지로 연결
//		return "redirect:login";
		msg.append("alert('아이디나 비번이 일치하지 않습니다');");
		msg.append("location='login'");
		}
		msg.append("</script>");
		
		return msg.toString();
		
	}
	
	//로그인
	@RequestMapping("/login")
	public String login(HttpSession session) {
		session.setAttribute("category", "login");
		return "default/member/login";
	}
}
