package com.springboot.ijib.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
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

    // 한 페이지에 보여줄 음식점 수 (4열 x 6행)
    private static final int PAGE_SIZE = 24;

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

            // 페이지네이션 (기본 1페이지, 24개씩)
            @RequestParam(value = "page", required = false, defaultValue = "1")
            int page,

            Principal principal,

            Model model) throws IOException {

        // [개선 1] null 예외 방지를 위해 빈 ArrayList로 초기화
        List<StoreSearchDTO> result = new ArrayList<>();
        int totalPages = 1;
        int totalCount = 0;

        // [개선 2] StringUtils.hasText() 사용하여 null 및 공백문자 안전 검사
        boolean hasKeyword = StringUtils.hasText(keyword);
        boolean hasCategory = scategory != null && !scategory.isEmpty();
        boolean hasSkeyword = skeyword != null && !skeyword.isEmpty();
        boolean hasSsido = StringUtils.hasText(ssido);
        boolean hasSsigungu = ssigungu != null && !ssigungu.isEmpty();
        boolean hasSinfo = sinfo != null && !sinfo.isEmpty();
        boolean hasParking = StringUtils.hasText(sparking);
        boolean hasSstatus = StringUtils.hasText(sstatus);

        // 검색어 또는 필터가 하나라도 제공되었을 때 검색 수행
        if (hasKeyword || hasCategory || hasSkeyword || hasSsido || hasSsigungu 
                || hasSinfo || minPrice != null || maxPrice != null 
                || minRating != null || hasParking || hasSstatus) {

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

            // 1. 음식점 검색 (서비스 연동)
            List<StoreSearchDTO> searchList = storeSearchService.search(searchDTO, searchType);

            if (searchList != null) {
                // 1-1. 페이지네이션 처리 (24개씩, 숫자 페이지)
                totalCount = searchList.size();
                totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

                if (totalPages < 1) {
                    totalPages = 1;
                }

                if (page < 1) {
                    page = 1;
                } else if (page > totalPages) {
                    page = totalPages;
                }

                int fromIndex = (page - 1) * PAGE_SIZE;
                int toIndex = Math.min(fromIndex + PAGE_SIZE, totalCount);

                if (fromIndex < totalCount) {
                    result = searchList.subList(fromIndex, toIndex);
                }
            }

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

            // 4. 검색 기록 엘라스틱서치(ES) 저장
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

        // JSP 전달 (JSP 헤더/필터에서 다시 보여주기 위한 모델 바인딩)
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

        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

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