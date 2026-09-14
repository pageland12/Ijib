package com.springboot.ijib.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
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
import com.springboot.ijib.service.StoreESService;

@Controller
public class BookmarkController {

    @Autowired
    private IBookmarkDAO dao;

    @Autowired
    private IMemberDAO mdao;

    @Autowired
    private IStoreDAO sdao;
    
    @Autowired
    private StoreESService esService;

    // URL 경로를 /guest/bookmarkInsert 로 변경하면 비로그인 유저도 컨트롤러 내부로 먼저 들어옵니다.
    @RequestMapping("/guest/bookmarkInsert")
    public String bookmarkInsert(
            @RequestParam("sno") int sno,
            @AuthenticationPrincipal User user,
            Authentication authentication,
            RedirectAttributes rttr) {

        // 1. 비로그인 사용자 체크
        if (user == null || authentication == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.\\n로그인 페이지로 이동합니다.");
            return "redirect:/loginForm";
        }

        // 2. 권한 확인 (SUBSCRIBER 또는 ADMIN 체크)
        boolean isSubscriber = authentication.getAuthorities().stream()
                .anyMatch(grantedAuthority -> 
                    grantedAuthority.getAuthority().equals("ROLE_SUBSCRIBER") ||
                    grantedAuthority.getAuthority().equals("SUBSCRIBER") ||
                    grantedAuthority.getAuthority().equals("ROLE_ADMIN") ||
                    grantedAuthority.getAuthority().equals("ADMIN")
                );

        // 3. 일반 회원(비구독자) 체크
        if (!isSubscriber) {
            rttr.addFlashAttribute("msg", "북마크 기능은 프리미엄 구독자 전용 혜택입니다.\\n구독권 구매 페이지로 이동합니다.");
            return "redirect:/guest/passList";
        }

        // 4. 구독자 정상 등록 처리
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
            @AuthenticationPrincipal User user) throws IOException {

        String memail = user.getUsername();
        int mno = mdao.findByEmail(memail).getMno();

        List<BookmarkDTO> list = dao.bookmarkList(mno);
        Map<Integer, Double> ratingMap = esService.storeRateAvg();

        for (BookmarkDTO bookmark : list) {
            Double ratingAvg = ratingMap.get(bookmark.getSno());

            if (ratingAvg != null) {
                bookmark.setRatingAvg(ratingAvg);
            }
        }

        model.addAttribute("list", list);

        return "member/bookmarkList";
    }
}