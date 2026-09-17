package com.springboot.ijib.controller;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IBoardDAO;
import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IRatingDAO;
import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberESDTO;
import com.springboot.ijib.dto.MemberSearchDTO;
import com.springboot.ijib.service.EmailService;
import com.springboot.ijib.service.MemberESService;
import com.springboot.ijib.service.MemberSearchService;
import com.springboot.ijib.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MemberController {
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberService memberService;

	@Autowired
	private MemberESService memberESService;
  
	@Autowired
	private IBoardDAO bdao;
	
	@Autowired
	private IRatingDAO rdao;
	
	@Autowired
	private IStoreDAO sdao;
	
	@Autowired
	private MemberSearchService memberSearchService;
	
	@Autowired
	private EmailService emailService;
	
	@RequestMapping("/")
	public String root(Model model) {
	    model.addAttribute("list", sdao.storeList());
	    return "guest/main";
	}
	
	@RequestMapping("/main")
	public String main() {
		return "redirect:/";
	}
	
	@RequestMapping("/guest/mainPopup")
	public String mainPopup() {
		return "guest/mainPopup";
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
	public String emailCheck(@RequestParam("memail") String memail, Model model) {
		// isDuplicated는 중복이라면 true, 중복이 아니라면 false
		boolean isDuplicated = (mdao.findByEmail(memail) != null);
		
		model.addAttribute("memail", memail);
		model.addAttribute("isDuplicated", isDuplicated);
		model.addAttribute("checked", true);
		
		return "guest/emailPopup";
	}
	
	@RequestMapping("/guest/write")
	public String write(MemberDTO mdto,
	                    @RequestParam("gender") String gender,
	                    @RequestParam("ageGroup") int ageGroup,
	                    @RequestParam("maddr1") String maddr1,
	                    @RequestParam("maddr2") String maddr2,
	                    @RequestParam("mzipno") String mzipno,
	                    @RequestParam("mtel1") String mtel1,
	                    @RequestParam("mtel2") String mtel2,
	                    @RequestParam("mtel3") String mtel3,
	                    @RequestParam("maccount1") String maccount1,
	                    @RequestParam("maccount2") String maccount2,
	                    @RequestParam("maccount3") String maccount3) {

	    mdto.setMgender(gender);
	    mdto.setMage(ageGroup);
	    mdto.setMaddr(maddr1 + "," + maddr2 + "," + mzipno);
	    mdto.setMtel(mtel1 + "-" + mtel2 + "-" + mtel3);
	    mdto.setMaccount(maccount1 + "," + maccount2 + "," + maccount3);
	    mdto.setMpasswd(passwordEncoder.encode(mdto.getMpasswd()));

	    // 1. Oracle 회원 등록
	    mdao.memberInsert(mdto);

	    // 2. Elasticsearch용 회원 데이터 생성
	    MemberESDTO esDto = memberService.memberESData(mdto.getMno());

	    // 3. Elasticsearch 저장
	    try {
	        memberESService.memberSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    // 4. 가입 축하 환영 이메일 발송
	    try {
	        emailService.sendWelcomeEmail(mdto.getMemail(), mdto.getMname());
	    } catch (Exception e) {
	        // 메일 발송에 실패하더라도 회원가입 흐름에 지장이 없도록 로그만 남깁니다.
	        System.err.println("환영 메일 전송 중 예외 발생: " + e.getMessage());
	    }

	    return "redirect:/main";
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
	    return "member/memberMain";
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
			else if("delete".equals(mode)) {

			    model.addAttribute("deleteMember", mdto);

			    return "member/memberDeleteConfirm";
			}
		}
		
		model.addAttribute("msg","비밀번호가 틀렸습니다.");
		model.addAttribute("mode", mode);
		return "member/passwordCheckForm";
	}
	
	@RequestMapping("/member/memberDelete")
	public String memberDelete(Authentication authentication) {

	    String memail = authentication.getName();

	    MemberDTO mdto = mdao.findByEmail(memail);

	    if (mdto != null) {

	        int mno = mdto.getMno();

	        // Oracle 회원 삭제
	        mdao.memberDelete(mno);

	        // Elasticsearch 회원 삭제
	        try {
	            memberESService.memberDelete(mno);
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }

	    return "redirect:/logout";
	}
	
	// 회원 수정폼
	@RequestMapping("/member/memberUpdateForm")
	public String memberUpdateForm(Authentication authentication, Model model) {
	    String memail = authentication.getName();
	    MemberDTO mdto = mdao.findByEmail(memail);
	    model.addAttribute("update", mdto);
	    return "member/memberUpdateForm";
	}
			
	// 회원 수정
	@RequestMapping("/member/memberUpdate")
	public String memberUpdate(
	                MemberDTO mdto,
	                @RequestParam("gender") String gender,
	                @RequestParam("ageGroup") int ageGroup,
	                @RequestParam("maddr1") String maddr1,
	                @RequestParam("maddr2") String maddr2,
	                @RequestParam("mzipno") String mzipno,
	                @RequestParam("mtel1") String mtel1,
	                @RequestParam("mtel2") String mtel2,
	                @RequestParam("mtel3") String mtel3,
	                @RequestParam("maccount1") String maccount1,
	                @RequestParam("maccount2") String maccount2,
	                @RequestParam("maccount3") String maccount3,
	                @RequestParam(value = "newPasswd", required = false) String newPasswd,
	                @RequestParam(value = "newPasswdCheck", required = false) String newPasswdCheck,
	                Model model) {

	    mdto.setMgender(gender);
	    mdto.setMage(ageGroup);
	    mdto.setMtel(mtel1 + "-" + mtel2 + "-" + mtel3);
	    mdto.setMaddr(maddr1 + "," + maddr2 + "," + mzipno);
	    mdto.setMaccount(maccount1 + "," + maccount2 + "," + maccount3);

	    // 새 비밀번호를 입력한 경우에만 비밀번호 변경
	    if (newPasswd != null && !newPasswd.isBlank()) {
	        if (!newPasswd.equals(newPasswdCheck)) {
	            model.addAttribute("update", mdao.memberView(mdto.getMno()));
	            model.addAttribute("msg", "새 비밀번호가 일치하지 않습니다.");
	            return "member/memberUpdateForm";
	        }

	        MemberDTO passwdDto = new MemberDTO();
	        passwdDto.setMno(mdto.getMno());
	        passwdDto.setMpasswd(passwordEncoder.encode(newPasswd));
	        mdao.memberPasswdUpdate(passwdDto);
	    }

	    // Oracle 회원정보 수정
	    mdao.memberUpdate(mdto);

	    // 수정된 회원정보 다시 조회
	    MemberESDTO esDto = memberService.memberESData(mdto.getMno());

	    // Elasticsearch 회원정보 수정
	    try {
	        memberESService.memberSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return "redirect:/member/memberMain";
	}
	
	// 나의 게시글
	@RequestMapping("/member/myBoard")
	public String myBoard(Authentication authentication, Model model) {
	    String memail = authentication.getName();
	    MemberDTO member = mdao.findByEmail(memail);
	    
	    model.addAttribute("view", member); // 사이드바 회원 이름 표시용
	    model.addAttribute("board", bdao.myBoardList(member.getMno()));
	    model.addAttribute("rating", rdao.myRatingList(member.getMno()));
	    
	    return "member/myBoard";
	}
	
	// 관리자페이지
	@RequestMapping("/admin/adminMain")
	public String adminMain() {
		return "admin/adminMain";
	}
	
	
	// 회원상세보기
	@RequestMapping("/admin/memberView")
	public String memberView(@RequestParam("mno") int mno,Model model) {
		model.addAttribute("view", mdao.memberView(mno));
	    return "admin/memberView";
	}
	
	// 관리자가 회원 정보 수정
	@RequestMapping("/admin/adminUpdateForm")
	public String adminUpdateForm(@RequestParam("mno") int mno, Model model) {
		model.addAttribute("update", mdao.memberView(mno));
		return "admin/adminUpdateForm";
	}
	
	@RequestMapping("/admin/adminUpdate")
	public String adminUpdate(MemberDTO mdto) {

	    // 1. Oracle 회원정보 수정
	    mdao.adminUpdate(mdto);

	    // 2. int 타입인 mno를 전달 (에러 해결)
	    MemberESDTO esDto = memberService.memberESData(mdto.getMno());

	    // 3. Elasticsearch 회원정보 수정
	    try {
	        memberESService.memberSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return "redirect:/admin/memberView?mno=" + mdto.getMno();
	}

	@RequestMapping("/guest/jusoPopup")
	public String jusoPopup() {
	    return "guest/jusoPopup";
	}
	
	@RequestMapping("/admin/memberList")
	public String memberList(
	        @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
	        Model model) {

	    List<MemberDTO> memberList = mdao.memberList();

	    int pageSize = 25;
	    int totalCount = memberList.size();
	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    if (pageNum < 1) {
	        pageNum = 1;
	    }

	    if (totalPage > 0 && pageNum > totalPage) {
	        pageNum = totalPage;
	    }

	    int startIndex = (pageNum - 1) * pageSize;
	    int endIndex = Math.min(startIndex + pageSize, totalCount);

	    List<MemberDTO> pageList =
	            memberList.subList(startIndex, endIndex);

	    int pageBlock = 5;

	    int startPage =
	            ((pageNum - 1) / pageBlock) * pageBlock + 1;

	    int endPage = startPage + pageBlock - 1;

	    if (endPage > totalPage) {
	        endPage = totalPage;
	    }

	    model.addAttribute("list", pageList);
	    model.addAttribute("pageNum", pageNum);
	    model.addAttribute("totalPage", totalPage);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);

	    return "admin/memberList";
	}
	
	@RequestMapping("/admin/memberSearch")
	public String memberSearch(
	        MemberSearchDTO searchDTO,
	        Model model) {

	    try {

	        List<MemberDTO> list =
	                memberSearchService.search(searchDTO);

	        model.addAttribute("list", list);

	    } catch (IOException e) {
	        e.printStackTrace();
	        model.addAttribute("list", new ArrayList<>());
	    }

	    model.addAttribute("search", searchDTO);

	    return "admin/memberList";
	}
	
	// ES 재등록
	@RequestMapping("/admin/memberReindex")
	public String memberReindex() {

	    try {
	        memberESService.memberReindexAll();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return "redirect:/admin/memberList";
	}
	
}
