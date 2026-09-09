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
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "scategory", required = false) List<String> scategory,
            Model model) throws IOException {

        System.out.println("===== 검색 Controller 진입 =====");
        System.out.println("keyword = " + keyword);
        System.out.println("scategory = " + scategory);

        List<StoreSearchDTO> result = null;

        if (!keyword.trim().isEmpty() || scategory != null) {

            StoreSearchDTO searchDTO = new StoreSearchDTO();

            searchDTO.setKeyword(keyword);
            searchDTO.setScategory(scategory);

            result = storeSearchService.search(searchDTO);
        }

        model.addAttribute("keyword", keyword);
        model.addAttribute("scategory", scategory);
        model.addAttribute("result", result);

        return "guest/storeSearch";
    }
}