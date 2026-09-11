package com.springboot.ijib.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IBoardDAO;
import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.BoardDTO;
import com.springboot.ijib.dto.MemberDTO;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {
	@Autowired
	private IBoardDAO bdao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@RequestMapping("/guest/boardList")
	public String boardList(
	        @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
	        Model model) {

	    List<BoardDTO> boardList = bdao.boardList();

	    int pageSize = 10;

	    int totalCount = boardList.size();

	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    if (pageNum < 1) {
	        pageNum = 1;
	    }

	    if (totalPage > 0 && pageNum > totalPage) {
	        pageNum = totalPage;
	    }

	    int startIndex = (pageNum - 1) * pageSize;
	    int endIndex = Math.min(startIndex + pageSize, totalCount);

	    List<BoardDTO> pageList =
	            boardList.subList(startIndex, endIndex);

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

	    return "guest/boardList";
	}
	
	@RequestMapping("/board/boardWriteForm")
	public String boardWriteForm() {
		return "board/boardWriteForm";
	}
	
	@RequestMapping("/board/boardWrite")
	public String boardWrite(BoardDTO bdto, Principal principal, Model model) {
		MemberDTO mdto = mdao.findByEmail(principal.getName());
		bdto.setMno(mdto.getMno());
		bdao.boardWrite(bdto);
		return "redirect:/guest/boardList";
	}
	
	@RequestMapping("/guest/boardView")
	public String boardView(@RequestParam("bno") int bno, Model model) {
		bdao.boardHit(bno);
		model.addAttribute("view", bdao.boardView(bno));
		return "guest/boardView";
	}
	
	@RequestMapping("/guest/passwordCheckForm")
	public String passwordCheckForm(@RequestParam("bno") int bno, Model model) {
		model.addAttribute("bno", bno);
		return "guest/passwordCheckForm";
	}
	
	@RequestMapping("/guest/passwordCheck")
	public String passwordCheck(
	        @RequestParam("bno") int bno,
	        @RequestParam("mpasswd") String mpasswd,
	        HttpSession session,
	        Model model) {		
		BoardDTO board = bdao.boardView(bno);
		int mno = board.getMno();
		MemberDTO member = mdao.memberView(mno);
		if (passwordEncoder.matches(mpasswd, member.getMpasswd())) {

	        // 비밀번호 확인 성공
	        session.setAttribute("secretBoard_" + bno, true);

	        return "redirect:/guest/boardView?bno=" + bno;
	    }
	    model.addAttribute("bno", bno);
	    model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
	    return "guest/passwordCheckForm";
	}
	
	@RequestMapping("/board/boardDelete")
	public String boardDelete(@RequestParam("bno") int bno) {
		bdao.boardDelete(bno);
		return "redirect:/member/myBoard";
	}
	
	@RequestMapping("/board/boardUpdateForm")
	public String boardUpdateForm(@RequestParam("bno") int bno, Model model) {
		BoardDTO bdto = bdao.boardView(bno);
		model.addAttribute("view", bdto);
		return "board/boardUpdateForm";
	}
	
	@RequestMapping("/board/boardUpdate")
	public String boardUpdate(BoardDTO bdto) {
		bdao.boardUpdate(bdto);
		return "redirect:/member/myBoard";
	}
}
