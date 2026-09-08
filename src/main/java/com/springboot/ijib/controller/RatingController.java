package com.springboot.ijib.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IRatingDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.RatingDTO;

@Controller
public class RatingController {
	@Autowired
	private IRatingDAO rdao;
	
	@Autowired
	private IMemberDAO mdao;
		
	// 후기 작성 폼
	@RequestMapping("/board/ratingWriteForm")
	public String ratingWriteForm(@RequestParam("sno") int sno, Model model) {
		model.addAttribute("sno", sno);
		return "board/ratingWriteForm";
	}
	
	// 후기 작성
	@RequestMapping("/board/ratingWrite")
	public String ratingWrite(RatingDTO rdto, Principal principal) {
		MemberDTO mdto = mdao.findByEmail(principal.getName());
		rdto.setMno(mdto.getMno());
		rdao.ratingWrite(rdto);
		return "redirect:/guest/storeView?sno=" + rdto.getSno();
	}
	
	// 수정 폼
	@RequestMapping("/board/ratingUpdateForm")
	public String ratingUpdateForm(@RequestParam("rno") int rno, Model model) {
		model.addAttribute("update", rdao.ratingView(rno));
		return "board/ratingUpdateForm";
	}
	
	// 수정
	@RequestMapping("/board/ratingUpdate")
	public String ratingUpdate(RatingDTO rdto) {
	    rdao.ratingUpdate(rdto);
	    return "redirect:/member/myboard";
	}
	
	// 삭제
	@RequestMapping("/board/ratingDelete")
	public String ratingDelete(@RequestParam("rno") int rno) {
	    rdao.ratingDelete(rno);
	    return "redirect:/member/myboard";
	}
}
