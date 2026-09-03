package com.springboot.ijib.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MemberController {
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@RequestMapping("/main")
	public String main() {
		return "redirect:/";
	}
	
	@RequestMapping("/guest/writeForm")
	public String writeForm() {
		return "guest/writeForm";
	}
	
	@RequestMapping("/guest/emailPopup")
	public String emailPopup() {
		return "guest/emailPopup";
	}
	
	@RequestMapping("/guest/emailCheck")
	public String idCheck(Model model, @RequestParam("memail") String memail) {
		// isDuplicated는 중복이라면 true, 중복이 아니라면 false
		boolean isDuplicated = (mdao.findByEmail(memail) != null);
		
		model.addAttribute("memail", memail);
		model.addAttribute("isDuplicated", isDuplicated);
		model.addAttribute("checked", true);
		
		return "guest/emailPopup";
	}
	
	@RequestMapping("/guest/write")
	public String write(MemberDTO mdto,
						@RequestParam("maddr1") String maddr1,
						@RequestParam("maddr2") String maddr2,
						@RequestParam("mzipno") String mzipno,
						@RequestParam("mtel1") String mtel1,
						@RequestParam("mtel2") String mtel2,
						@RequestParam("mtel3") String mtel3,
						@RequestParam("maccount1") String maccount1,
						@RequestParam("maccount2") String maccount2,
						@RequestParam("maccount3") String maccount3
						) {
		mdto.setMaddr(maddr1+","+maddr2+","+mzipno);
		mdto.setMtel(mtel1+"-"+mtel2+"-"+mtel3);
		mdto.setMaccount(maccount1+","+maccount2+","+maccount3);
		mdto.setMpasswd(passwordEncoder.encode(mdto.getMpasswd()));
		
		mdao.memberInsert(mdto);
		return "redirect:/main";
	}
	
	@RequestMapping("/guest/jusoPopup")
	public String jusoPopup() {
		return "guest/jusoPopup";
	}
	
	@RequestMapping("/loginForm")
	public String loginForm() {
		return "guest/loginForm";
	}
	
	@RequestMapping("/loginError")
	public String loginError(Model model) {
		model.addAttribute("msg", "이메일과 비밀번호를 확인해주세요.");
	    return "guest/loginForm"; // 바로 loginForm.jsp를 뿌려줌
	}
	
	@RequestMapping("/logout")
	public String logout() {
		return "logout";
	}	
	
	// 마이페이지:
	@RequestMapping("/member/memberMain")
	public String membermain(Authentication authentication, Model model) {
	    model.addAttribute("view", mdao.findByEmail(authentication.getName()));	   
	    return "redirect:/member/myBookList";
	}
	
	// 비밀번호 확인폼 (수정/탈퇴 공용)
	@RequestMapping("/member/passwordCheckForm")
	public String passwordCheckForm(Authentication authentication,HttpServletRequest request,Model model) {
		String mode = request.getParameter("mode");
		model.addAttribute("mode", mode);			
		return "member/passwordCheckForm";
	}
	
	// 비밀번호 확인 처리 (수정/탈퇴 공용)
	@RequestMapping("/member/passwordCheck")
	public String passwordCheck(Authentication authentication,HttpServletRequest request,Model model) {
		String mode = request.getParameter("mode"); // update, delete
		String mpasswd = request.getParameter("mpasswd");
		
		String memail = authentication.getName();
		MemberDTO mdto = mdao.findByEmail(memail);
		
		if(mdto != null && passwordEncoder.matches(mpasswd, mdto.getMpasswd())) {
			if("update".equals(mode)) {      // 비밀번호 확인 시 회원수정
				model.addAttribute("update",mdto);
				return "member/memberUpdateForm";
			}
			else if("delete".equals(mode)) { // 비밀번호 확인 시 회원탈퇴
				mdao.memberDelete(mdto.getMno());
				return "redirect:/logout";
			}
		}
		
		model.addAttribute("msg","비밀번호가 틀렸습니다.");
		model.addAttribute("mode", mode);
		return "member/passwordCheckForm";
	}
	
	// 회원 수정폼
	@RequestMapping("/member/memberUpdateForm")
	public String memberUpdateForm(@RequestParam("mno") int mno, Model model) {
		model.addAttribute("update", mdao.memberView(mno));
		return "member/memberUpdateForm";
	}
	
			
	// 회원 수정
	@RequestMapping("/member/memberUpdate")
	public String memberUpdate(MemberDTO mdto,
						@RequestParam("maddr1") String maddr1,
						@RequestParam("maddr2") String maddr2,
						@RequestParam("mzipno") String mzipno,
						@RequestParam("mtel1") String mtel1,
						@RequestParam("mtel2") String mtel2,
						@RequestParam("mtel3") String mtel3,
						@RequestParam("maccount1") String maccount1,
						@RequestParam("maccount2") String maccount2,
						@RequestParam("maccount3") String maccount3
						) {
		mdto.setMtel(mtel1+"-"+mtel2+"-"+mtel3);
		mdto.setMaddr(maddr1+","+maddr2+","+mzipno);
		mdto.setMaccount(maccount1+","+maccount2+","+maccount3);
		
		mdao.memberUpdate(mdto);
		return "redirect:/member/memberMain";
	}
	
	// 관리자페이지
	@RequestMapping("/admin/adminMain")
	public String adminMain() {
		return "admin/adminMain";
	}
	
	// 모든 회원관리
	@RequestMapping("/admin/memberList")
	public String memberList(Model model, @RequestParam(value = "pageNum", defaultValue = "1") int pageNum) {
		int amount = 10; // 한 페이지당 보여줄 개수
	      
		int startRow = (pageNum - 1) * amount + 1;
		int endRow = pageNum * amount;
	      
		// DAO를 통해 페이징된 회원 목록과 전체 개수 가져오기
		List<MemberDTO> members = mdao.memberListPaging(startRow, endRow);
		int total = mdao.getTotalMemberCount();
		int totalPages = (int) Math.ceil((double) total / amount);
	      
		// 5개 단위 페이징 계산
		int navSize = 5;
		int startPage = ((pageNum - 1) / navSize) * navSize + 1;
		int endPage = startPage + navSize - 1;
	      
		if (endPage > totalPages) {
			endPage = totalPages;
		}
	      
		// JSP로 데이터 전달
		model.addAttribute("lists", members);
		model.addAttribute("totalCount", total); // 👈 이 부분을 추가해 주어야 전체 회원 수가 정상적으로 표시됩니다!
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("totalPages", totalPages);
	      
		return "admin/memberList";
	}
	
	// 회원상세보기
	@RequestMapping("/admin/memberView")
	public String memberView(@RequestParam("mno") int mno,Model model) {
		model.addAttribute("view", mdao.memberView(mno));
	    return "admin/memberView";
	}
	
	// 관리자 비밀번호 확인폼 (수정/탈퇴 공용)
	@RequestMapping("/admin/passwordCheckForm")
	public String adminPasswordCheckForm(Authentication authentication,HttpServletRequest request,Model model) {
		String mode = request.getParameter("mode");
		String mno = request.getParameter("mno");
		model.addAttribute("mode", mode);
		model.addAttribute("mno",mno);
		return "admin/passwordCheckForm";
	}
	
	// 관리자 비밀번호 확인 처리 (수정/탈퇴 공용)
	@RequestMapping("/admin/passwordCheck")
	public String adminPasswordCheck(Authentication authentication,HttpServletRequest request,Model model) {
		String mode = request.getParameter("mode"); // update, delete
		String mpasswd = request.getParameter("mpasswd");
		int mno = Integer.parseInt(request.getParameter("mno"));
		
		String memail = authentication.getName();
		MemberDTO mdto = mdao.findByEmail(memail);
		
		if(mdto != null && passwordEncoder.matches(mpasswd, mdto.getMpasswd())) {
			if("update".equals(mode)) {      // 비밀번호 확인 시 회원수정
				MemberDTO targetmno = mdao.memberView(mno);
				model.addAttribute("update",targetmno);
				return "admin/adminUpdateForm";
			}
			else if("delete".equals(mode)) { // 비밀번호 확인 시 회원탈퇴
				mdao.adminDelete(mno);
				return "redirect:/admin/memberList";
			}
		}
		
		model.addAttribute("msg","비밀번호가 틀렸습니다.");
		model.addAttribute("mode", mode);
		model.addAttribute("mno", mno); // 실패 후 재시도를 위해 mno 유지
		return "admin/passwordCheckForm";
	}
	
	// 관리자가 회원 정보 수정
	@RequestMapping("/admin/adminUpdateForm")
	public String adminUpdateForm(@RequestParam("mno") int mno, Model model) {
		model.addAttribute("update", mdao.memberView(mno));
		return "admin/adminUpdateForm";
	}
	
	@RequestMapping("/admin/adminUpdate")
	public String adminUpdate(MemberDTO mdto) {		
		mdao.adminUpdate(mdto);
		return "redirect:/admin/memberView?mno=" + mdto.getMno();
	}
}



