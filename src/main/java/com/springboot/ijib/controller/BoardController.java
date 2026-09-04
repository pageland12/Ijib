package com.springboot.ijib.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IBoardDAO;
import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.BoardDTO;
import com.springboot.ijib.dto.MemberDTO;

@Controller
public class BoardController {
	@Autowired
	private IBoardDAO bdao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@RequestMapping("/guest/boardList")
	public String boardList(Model model) {
		List<BoardDTO> boardList = bdao.boardList();
		model.addAttribute("list", boardList);
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
		bdao.boardView(bno);
		model.addAttribute("view", bdao.boardView(bno));
		return "guest/boardView";
	}
	
	@RequestMapping("/board/boardDelete")
	public String boardDelete(@RequestParam("bno") int bno) {
		bdao.boardDelete(bno);
		return "redirect:/guest/boardList";
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
		return "redirect:/guest/boardView?bno=" + bdto.getBno();
	}
}
