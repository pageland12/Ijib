package com.springboot.ijib.controller;

import java.io.File;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.INoticeDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.NoticeDTO;

@Controller
public class NoticeController {
	@Autowired
	private INoticeDAO ndao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@RequestMapping("/guest/noticeList")
	public String noticeList(Model model) {
		List<NoticeDTO> noticeList = ndao.noticeList();
		model.addAttribute("list", noticeList);
		return "guest/noticeList";
	}

	@RequestMapping("/admin/noticeWriteForm")
	public String noticeWriteForm() {
		return "admin/noticeWriteForm";
	}
	
	@RequestMapping("/admin/noticeWrite")
	public String noticeWrite(@RequestParam(value="nupload", required=false) MultipartFile nupload, Principal principal, NoticeDTO ndto) throws Exception {
		String memail = principal.getName();
		MemberDTO mdto = mdao.findByEmail(memail);
		ndto.setMno(mdto.getMno());
		
		if(nupload != null && !nupload.isEmpty()) {
			String nfiles = nupload.getOriginalFilename();
			
			File uploadDir = new File("C:\\ijib_images\\");
			if(!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			nupload.transferTo(new File(uploadDir, nfiles));
			ndto.setNfiles(nfiles);
		}
		
		ndao.noticeWrite(ndto);
		return "redirect:/guest/noticeList";
	}
	
	@RequestMapping("/guest/noticeView")
	public String noticeView(@RequestParam("nno") int nno, Model model) {
		ndao.noticeHit(nno);
		model.addAttribute("view", ndao.noticeView(nno));
		return "guest/noticeView";
	}
	
	@RequestMapping("/admin/noticeDelete")
	public String noticeDelete(@RequestParam("nno") int nno) {
		NoticeDTO ndto = ndao.noticeView(nno);		
		ndao.noticeDelete(nno);
		return "redirect:/guest/noticeList";
	}
	
	@RequestMapping("/admin/noticeUpdateForm")
	public String noticeUpdateForm(@RequestParam("nno") int nno, Model model) {
		model.addAttribute("view", ndao.noticeView(nno));
		return "admin/noticeUpdateForm";
	}
	
	@RequestMapping("/admin/noticeUpdate")
	public String noticeUpdate(@RequestParam(value="nupload", required=false) MultipartFile nupload, Principal principal, NoticeDTO ndto) throws Exception {		
		if(nupload != null && !nupload.isEmpty()) {
			String nfiles = nupload.getOriginalFilename();
			
			File uploadDir = new File("C:\\ijib_images\\");
			if(!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			nupload.transferTo(new File(uploadDir, nfiles));
			ndto.setNfiles(nfiles);
		}
		
		ndao.noticeUpdate(ndto);		
		return "redirect:/guest/noticeView";
	}
	
}
