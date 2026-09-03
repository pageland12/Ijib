package com.springboot.ijib.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.ijib.dao.IPassDAO;
import com.springboot.ijib.dto.PassDTO;

@Controller
public class PassController {
	@Autowired
	private IPassDAO dao;
	
	@RequestMapping("/guest/passList")
	public String passList(Model model) {
		model.addAttribute("pass", dao.passList());
		
		return "guest/passList";
	}
	
	@RequestMapping("/admin/adminPassList")
	public String adminPassList(Model model) {
		model.addAttribute("pass", dao.passList());
		
		return "admin/adminPassList";
	}
	
	@RequestMapping("/admin/passWriteForm")
	public String passWriteForm() {
		return "admin/passWriteForm";
	}
	
	@RequestMapping("/admin/passWrite")
	public String passWrite(PassDTO dto, @RequestParam("pupload") MultipartFile pupload) throws Exception {
		if (pupload != null && !pupload.isEmpty()) {
	        String pimg = pupload.getOriginalFilename();
	        pupload.transferTo(new File("C:\\ijib\\src\\main\\resources\\static\\images\\" + pimg));
	        dto.setPimg(pimg);
	    }
			
		dao.passWrite(dto);
		
		return "redirect:/admin/adminPassList";
	}
	
	@RequestMapping("/admin/passView")
	public String passView(@RequestParam("pno") int pno, Model model) {
		model.addAttribute("view", dao.passView(pno));
		
		return "admin/passView";
	}
	
	@RequestMapping("/admin/passDelete")
	public String passDelete(@RequestParam("pno") int pno) {
		dao.passDelete(pno);
		
		return "redirect:/admin/adminPassList";
	}
	
	@RequestMapping("/admin/passUpdateForm")
	public String passUpdateForm(@RequestParam("pno") int pno, Model model) {
		model.addAttribute("update", dao.passView(pno));
		
		return "admin/passUpdateForm";
	}
	
	@RequestMapping("/admin/passUpdate")
	public String passUpdate(PassDTO dto, @RequestParam("pupload") MultipartFile pupload) throws IOException {
		if (pupload != null && !pupload.isEmpty()) {
	        String pimg = pupload.getOriginalFilename();
	        pupload.transferTo(new File("C:\\ijib\\src\\main\\resources\\static\\images\\" + pimg));
	        dto.setPimg(pimg);
	    }
		
		dao.passUpdate(dto);
		
		return "redirect:/admin/adminPassList";
	}
}
