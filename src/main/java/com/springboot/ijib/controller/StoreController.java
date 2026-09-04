package com.springboot.ijib.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dto.MenuDTO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.service.StoreService;

@Controller
public class StoreController {

    @Autowired
    private StoreService service;

    @RequestMapping("/guest/storeList")
    public String storeList(Model model) {
        model.addAttribute("list", service.storeList());

        return "guest/storeList";
    }

    @RequestMapping("/admin/storeWriteForm")
    public String storeWriteForm() {
        return "admin/storeWriteForm";
    }

    @RequestMapping("/admin/storeWrite")
    public String storeWrite(StoreDTO dto,
            @RequestParam(value = "mnname", required = false) List<String> mnname,
            @RequestParam(value = "mnprice", required = false) List<Integer> mnprice,
            @RequestParam(value = "skeyword", required = false) String[] skeyword) {

        if(skeyword != null) {
            dto.setSkeyword(String.join(",", skeyword));
        }

        List<MenuDTO> menuList = new ArrayList<>();

        if(mnname != null) {
            for(int i = 0; i < mnname.size(); i++) {

                if(mnname.get(i) != null && !mnname.get(i).trim().isEmpty()) {

                    MenuDTO menu = new MenuDTO();

                    menu.setMnname(mnname.get(i));
                    menu.setMnprice(mnprice.get(i));

                    menuList.add(menu);
                }
            }
        }

        service.storeWrite(dto, menuList);

        return "redirect:/guest/storeList";
    }

    @RequestMapping("/guest/storeView")
    public String storeView(@RequestParam("sno") int sno, Model model) {
        model.addAttribute("view", service.storeView(sno));
        model.addAttribute("menu", service.menuList(sno));

        return "guest/storeView";
    }

    @RequestMapping("/admin/storeUpdateForm")
    public String storeUpdateForm(@RequestParam("sno") int sno, Model model) {
        model.addAttribute("update", service.storeView(sno));
        model.addAttribute("menu", service.menuList(sno));

        return "admin/storeUpdateForm";
    }

    @RequestMapping("/admin/storeUpdate")
    public String storeUpdate(
            StoreDTO dto,

            @RequestParam(value = "deleteMnno", required = false)
            String deleteMnno,

            @RequestParam(value = "mnno", required = false)
            List<Integer> mnno,

            @RequestParam(value = "mnname", required = false)
            List<String> mnname,

            @RequestParam(value = "mnprice", required = false)
            List<Integer> mnprice,

            @RequestParam(value = "skeyword", required = false)
            String[] skeyword) {

        // 키워드 처리
        if (skeyword != null) {
            dto.setSkeyword(String.join(",", skeyword));
        }

        // 메뉴 리스트 만들기
        List<MenuDTO> menuList = new ArrayList<>();

        if (mnname != null) {

            for (int i = 0; i < mnname.size(); i++) {

                if (mnname.get(i) != null &&
                    !mnname.get(i).trim().isEmpty()) {

                    MenuDTO menu = new MenuDTO();

                    if (mnno != null && i < mnno.size()) {
                        menu.setMnno(mnno.get(i));
                    }

                    menu.setMnname(mnname.get(i));
                    menu.setMnprice(mnprice.get(i));

                    menuList.add(menu);
                }
            }
        }

        service.storeUpdate(dto, menuList, deleteMnno);

        return "redirect:/guest/storeView?sno=" + dto.getSno();
    }
    
    @RequestMapping("/admin/storeDelete")
    public String storeDelete(@RequestParam("sno") int sno) {

        service.storeDelete(sno);

        return "redirect:/guest/storeList";
    }

}