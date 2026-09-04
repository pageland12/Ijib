package com.springboot.ijib.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.INoticeDAO;
import com.springboot.ijib.dto.NoticeDTO;

@Controller
public class NoticeController {
	@Autowired
	private INoticeDAO ndao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@RequestMapping("/guest/noticeList")
	public String noticeList(Model model) {
		List<NoticeDTO> list = ndao.noticeList();
		model.addAttribute("list", list);
		return "guest/noticeList";
	}

	@RequestMapping("/admin/noticeWriteForm")
	public String noticeWriteForm() {
		return "admin/noticeWriteForm";
	}
	
	@RequestMapping("/admin/noticeWrite")
	public String noticeWrite() {
		
		return "guest/noticeList";
	}
	
	@RequestMapping("/guest/noticeView")
	public String noticeView(@RequestParam("nno") int nno, Model model) {
		ndao.noticeHit(nno);
		model.addAttribute("view", ndao.noticeView(nno));
		return "guets/noticeView";
	}
	
	@RequestMapping("/admin/noticeDelete")
	public String noticeDelete() {
		return "redirect:/guest/noticeList";
	}
	
	@RequestMapping("/admin/noticeUpdateForm")
	public String noticeUpdateForm() {
		return "admin/noticeUpdateForm";
	}
	
	@RequestMapping("noticeUpdate")
	public String noticeUpdate() {
		return "redirect:/guest/noticeView";
	}
	
}
