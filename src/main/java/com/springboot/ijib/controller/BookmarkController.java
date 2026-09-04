package com.springboot.ijib.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.ijib.dao.IBookmarkDAO;
import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.BookmarkDTO;

@Controller
public class BookmarkController {

    @Autowired
    private IBookmarkDAO dao;

    @Autowired
    private IMemberDAO mdao;

    @Autowired
    private IStoreDAO sdao;


    @RequestMapping("/member/bookmarkInsert")
    public String bookmarkInsert(
            @RequestParam("sno") int sno,
            @AuthenticationPrincipal User user,
            RedirectAttributes rttr) {

        String memail = user.getUsername();
        int mno = mdao.findByEmail(memail).getMno();

        BookmarkDTO dto = new BookmarkDTO();
        dto.setMno(mno);
        dto.setSno(sno);

        if (dao.bookmarkCheck(mno, sno) == 0) {
            dao.bookmarkInsert(dto);
            rttr.addFlashAttribute("msg", "북마크에 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "이미 북마크에 등록된 음식점입니다.");
        }

        return "redirect:/guest/storeView?sno=" + sno;
    }

    // 찜 취소
    @RequestMapping("/member/bookmarkDelete")
    public String bookmarkDelete(
            @RequestParam("bmno") List<Integer> bmnoList) {

        for (int bmno : bmnoList) {
            dao.bookmarkDelete(bmno);
        }

        return "redirect:/member/bookmarkList";
    }

    // 내 찜 목록
    @RequestMapping("/member/bookmarkList")
    public String bookmarkList(
            Model model,
            @AuthenticationPrincipal User user) {

        String memail = user.getUsername();
        int mno = mdao.findByEmail(memail).getMno();

        List<BookmarkDTO> list = dao.bookmarkList(mno);

        model.addAttribute("list", list);

        return "member/bookmarkList";
    }

}