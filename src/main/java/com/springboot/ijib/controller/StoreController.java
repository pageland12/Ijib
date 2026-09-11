package com.springboot.ijib.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.ijib.dao.IRatingDAO;
import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.MenuDTO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.dto.StoreESDTO;
import com.springboot.ijib.service.StoreESService;
import com.springboot.ijib.service.StoreService;

@Controller
public class StoreController {

    // 한 페이지에 보여줄 음식점 수 (4열 x 6행)
    private static final int PAGE_SIZE = 24;

    @Autowired
    private StoreService service;
    
    @Autowired
    private StoreESService esService;
    
    @Autowired
    private IRatingDAO rdao;
    
	@Autowired
	private IStoreDAO sdao;
    
    @RequestMapping("/guest/storeList")
    public String storeList(
            @RequestParam(value = "page", required = false, defaultValue = "1")
            int page,

            Model model) {

        List<StoreDTO> fullList = sdao.storeList();

        int totalCount = fullList.size();
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

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

        List<StoreDTO> pageList;

        if (fromIndex >= totalCount) {
            pageList = new ArrayList<>();
        } else {
            pageList = fullList.subList(fromIndex, toIndex);
        }

        model.addAttribute("list", pageList);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);

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

        try {
            StoreESDTO esDto = service.storeESData(dto.getSno());
            esService.storeSave(esDto);
        } catch (Exception e) {
        	System.out.println("===== Elasticsearch 저장 실패 =====");
            e.printStackTrace();
        }

        return "redirect:/guest/storeList";
    }

    @RequestMapping("/guest/storeView")
    public String storeView(@RequestParam("sno") int sno, Model model) {
        model.addAttribute("view", service.storeView(sno));
        model.addAttribute("menu", service.menuList(sno));
        
        model.addAttribute("preview", rdao.ratingPreview(sno));
        model.addAttribute("list", rdao.ratingList(sno));
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

        try {
            StoreESDTO esDto = service.storeESData(dto.getSno());
            esService.storeSave(esDto);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/guest/storeView?sno=" + dto.getSno();
    }
    
    @RequestMapping("/admin/storeDelete")
    public String storeDelete(@RequestParam("sno") int sno) {

    	service.storeDelete(sno);

        try {
            esService.storeDelete(sno);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/guest/storeList";
    }
    
 // 오라클에 있는 모든 가게를 Elasticsearch에 재색인 (검색 결과 없음 문제 해결용, 1회성)
    @RequestMapping("/admin/storeReindex")
    public String storeReindex(Model model) {

        List<StoreDTO> all = sdao.storeList();

        int successCount = 0;
        int failCount = 0;

        for (StoreDTO store : all) {

            try {
                StoreESDTO esDto = service.storeESData(store.getSno());
                esService.storeSave(esDto);
                successCount++;

            } catch (Exception e) {
                failCount++;
                System.out.println("===== 재색인 실패 sno = " + store.getSno() + " =====");
                e.printStackTrace();
            }
        }

        System.out.println("===== 재색인 완료 : 성공 " + successCount + "건 / 실패 " + failCount + "건 =====");

        return "redirect:/guest/storeList";
    }
    
    @RequestMapping("/guest/nearby")
    public String nearby(
            @RequestParam("lat") double lat,
            @RequestParam("lon") double lon,
            Model model) {

        try {
            // Elasticsearch에서 현재 위치 반경 5km 음식점 sno 검색
            List<Integer> snoList =
                    esService.nearbyStoreSnoList(lat, lon, 5);

            // 검색 결과가 없으면 빈 목록
            if (snoList.isEmpty()) {
                model.addAttribute("list", new ArrayList<StoreDTO>());
            } else {
                // sno를 이용해서 Oracle에서 실제 음식점 정보 조회
                List<StoreDTO> list =
                        sdao.storeListBySno(snoList);

                model.addAttribute("list", list);
            }

        } catch (Exception e) {
            e.printStackTrace();

            // 오류가 발생해도 JSP는 정상적으로 열리도록
            model.addAttribute("list", new ArrayList<StoreDTO>());
        }

        return "guest/storeListPage";
    }

}
