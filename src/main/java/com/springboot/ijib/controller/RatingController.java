package com.springboot.ijib.controller;

import java.io.IOException;
import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IRatingDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.RatingDTO;
import com.springboot.ijib.dto.StoreESDTO;
import com.springboot.ijib.service.StoreESService;
import com.springboot.ijib.service.StoreService;

@Controller
public class RatingController {
	@Autowired
	private IRatingDAO rdao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private StoreService storeService;

	@Autowired
	private StoreESService storeESService;
		
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

	    // 1. Oracle에 리뷰 저장
	    rdao.ratingWrite(rdto);

	    // 2. 해당 음식점 데이터를 다시 조회
	    StoreESDTO esDto = storeService.storeESData(rdto.getSno());

	    // 3. Elasticsearch에 음식점 전체 정보 갱신
	    try {
	        storeESService.storeSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

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

	    // 1. Oracle 리뷰 수정
	    rdao.ratingUpdate(rdto);

	    // 2. 해당 음식점의 전체 데이터 다시 조회
	    StoreESDTO esDto = storeService.storeESData(rdto.getSno());

	    // 3. Elasticsearch 음식점 전체 정보 갱신
	    try {
	        storeESService.storeSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return "redirect:/member/myBoard";
	}
	
	// 삭제
	@RequestMapping("/board/ratingDelete")
	public String ratingDelete(@RequestParam("rno") int rno) {

	    // 1. 삭제 전에 리뷰 정보 조회
	    RatingDTO rating = rdao.ratingView(rno);

	    // 2. Oracle 리뷰 삭제
	    rdao.ratingDelete(rno);

	    // 3. 해당 음식점의 전체 데이터 다시 조회
	    StoreESDTO esDto = storeService.storeESData(rating.getSno());

	    // 4. Elasticsearch 음식점 전체 정보 갱신
	    try {
	        storeESService.storeSave(esDto);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }

	    return "redirect:/member/myBoard";
	}
}
