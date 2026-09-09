package com.springboot.ijib.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dto.StoreSearchDTO;
import com.springboot.ijib.service.StoreSearchService;

@Controller
public class StoreSearchController {

    @Autowired
    private StoreSearchService storeSearchService;

    // 음식점 통합검색
    @RequestMapping("/guest/storeSearch")
    public String storeSearch(

            @RequestParam(value = "keyword", required = false, defaultValue = "")
            String keyword,

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

            result = storeSearchService.search(searchDTO);
        }

        // JSP에 전달
        model.addAttribute("keyword", keyword);
        model.addAttribute("scategory", scategory);
        model.addAttribute("skeyword", skeyword);
        model.addAttribute("ssido", ssido);
        model.addAttribute("ssigungu", ssigungu);
        model.addAttribute("sinfo", sinfo);
        model.addAttribute("result", result);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sparking", sparking);

        return "guest/storeSearch";
    }
}