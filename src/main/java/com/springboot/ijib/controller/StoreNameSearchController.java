package com.springboot.ijib.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.StoreSearchDTO;
import com.springboot.ijib.service.SearchLogESService;
import com.springboot.ijib.service.StoreNameSearchService;

@Controller
public class StoreNameSearchController {

    @Autowired
    private StoreNameSearchService storeNameSearchService;

    @Autowired
    private SearchLogESService searchLogESService;

    @Autowired
    private IMemberDAO mdao;


    // 식당명 검색
    @RequestMapping("/guest/storeNameSearch")
    public String storeNameSearch(

            @RequestParam(value = "keyword", required = false, defaultValue = "")
            String keyword,

            Principal principal,

            Model model) throws IOException {


        List<StoreSearchDTO> result = null;


        // 검색어가 있을 때만 검색
        if (!keyword.trim().isEmpty()) {

            // 1. 식당명 검색
            result = storeNameSearchService.search(keyword);


            // 2. 회원 정보
            Integer mno = null;
            Integer age = null;
            String gender = null;

            // 로그인 상태
            if (principal != null) {

                MemberDTO member = mdao.findByEmail(principal.getName());

                if (member != null) {

                    mno = member.getMno();
                    age = member.getMage();
                    gender = member.getMgender();
                }
            }


            // 3. 식당명 검색 로그 저장
            searchLogESService.searchLogSave(

                    keyword,

                    "store",

                    null,

                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,

                    gender,
                    age,
                    mno
            );
        }


        // JSP 전달
        model.addAttribute("keyword", keyword);
        model.addAttribute("result", result);


        return "guest/storeNameSearch";
    }
    
}
