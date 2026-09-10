package com.springboot.ijib.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.StoreSearchDTO;
import com.springboot.ijib.service.SearchLogESService;
import com.springboot.ijib.service.StoreSearchService;

@Controller
public class StoreSearchController {

    @Autowired
    private StoreSearchService storeSearchService;

    @Autowired
    private SearchLogESService searchLogESService;

    @Autowired
    private IMemberDAO mdao;


    // 음식점 검색
    @RequestMapping("/guest/storeSearch")
    public String storeSearch(

            @RequestParam(value = "keyword", required = false, defaultValue = "")
            String keyword,

            // total = 통합검색
            // store = 음식점명 검색
            @RequestParam(value = "searchType", required = false, defaultValue = "total")
            String searchType,

            @RequestParam(value = "scategory", required = false)
            List<String> scategory,

            @RequestParam(value = "skeyword", required = false)
            List<String> skeyword,

            @RequestParam(value = "ssido", required = false)
            String ssido,

            @RequestParam(value = "ssigungu", required = false)
            List<String> ssigungu,

            @RequestParam(value = "sinfo", required = false)
            List<String> sinfo,

            @RequestParam(value = "minPrice", required = false)
            Integer minPrice,

            @RequestParam(value = "maxPrice", required = false)
            Integer maxPrice,

            @RequestParam(value = "sparking", required = false)
            String sparking,

            @RequestParam(value = "minRating", required = false)
            Double minRating,

            @RequestParam(value = "sstatus", required = false)
            String sstatus,

            Principal principal,

            Model model) throws IOException {


        List<StoreSearchDTO> result = null;


        // 검색어 또는 필터가 하나라도 있으면 검색
        if (!keyword.trim().isEmpty()
                || (scategory != null && !scategory.isEmpty())
                || (skeyword != null && !skeyword.isEmpty())
                || (ssido != null && !ssido.isEmpty())
                || (ssigungu != null && !ssigungu.isEmpty())
                || (sinfo != null && !sinfo.isEmpty())
                || minPrice != null
                || maxPrice != null
                || minRating != null
                || (sparking != null && !sparking.isEmpty())
                || (sstatus != null && !sstatus.isEmpty())) {


            StoreSearchDTO searchDTO = new StoreSearchDTO();

            searchDTO.setKeyword(keyword);
            searchDTO.setScategory(scategory);
            searchDTO.setSkeyword(skeyword);
            searchDTO.setSsido(ssido);
            searchDTO.setSsigungu(ssigungu);
            searchDTO.setSinfo(sinfo);
            searchDTO.setMinPrice(minPrice);
            searchDTO.setMaxPrice(maxPrice);
            searchDTO.setSparking(sparking);
            searchDTO.setMinRating(minRating);
            searchDTO.setSstatus(sstatus);


            // 1. 음식점 검색
            result = storeSearchService.search(searchDTO, searchType);


            // 2. 회원 정보
            Integer mno = null;
            Integer age = null;
            String gender = null;

            if (principal != null) {

                MemberDTO member = mdao.findByEmail(principal.getName());

                if (member != null) {

                    mno = member.getMno();
                    age = member.getMage();
                    gender = member.getMgender();
                }
            }


            // 3. 가격 범위
            String priceRange = null;

            if (minPrice != null && maxPrice != null) {

                priceRange = minPrice + "-" + maxPrice;

            } else if (minPrice != null) {

                priceRange = minPrice + "-";

            } else if (maxPrice != null) {

                priceRange = "-" + maxPrice;
            }


            // 4. 검색 기록 저장
            searchLogESService.searchLogSave(

                    keyword,
                    searchType,
                    priceRange,

                    scategory,
                    skeyword,
                    ssido,
                    ssigungu,
                    sinfo,
                    sparking,
                    sstatus,
                    minRating,

                    gender,
                    age,
                    mno
            );
        }


        // JSP 전달
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);

        model.addAttribute("scategory", scategory);
        model.addAttribute("skeyword", skeyword);
        model.addAttribute("ssido", ssido);
        model.addAttribute("ssigungu", ssigungu);
        model.addAttribute("sinfo", sinfo);

        model.addAttribute("result", result);

        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);

        model.addAttribute("sparking", sparking);
        model.addAttribute("minRating", minRating);
        model.addAttribute("sstatus", sstatus);


        return "guest/storeSearch";
    }
    
    // 자동완성
    @RequestMapping("/guest/storeAutocomplete")
    @ResponseBody
    public List<java.util.Map<String, String>> storeAutocomplete(
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "searchType", required = false, defaultValue = "total") String searchType
    ) throws IOException {

        return storeSearchService.autocompleteHighlight(
                keyword,
                searchType
        );
    }
}
