package com.springboot.ijib.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMenuDAO;
import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.MenuDTO;
import com.springboot.ijib.dto.MenuESDTO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.dto.StoreESDTO;

@Service
public class StoreService {

    @Autowired
    private IStoreDAO dao;

    @Autowired
    private IMenuDAO mnDao;


    // 음식점 목록	
    public List<StoreDTO> storeList() {
        return dao.storeList();
    }


    // 음식점 상세
    public StoreDTO storeView(int sno) {
        return dao.storeView(sno);
    }


    // 음식점 등록
    public void storeWrite(StoreDTO dto, List<MenuDTO> menuList) {
        dao.storeWrite(dto);

        for(MenuDTO menu : menuList) {
            menu.setSno(dto.getSno());
            mnDao.menuWrite(menu);
        }
    }


    // 음식점 수정
    public void storeUpdate(
            StoreDTO dto,
            List<MenuDTO> menuList,
            String deleteMnno) {

        // 음식점 정보 수정
        dao.storeUpdate(dto);


        // 삭제한 메뉴 삭제
        if(deleteMnno != null && !deleteMnno.isEmpty()) {

            String[] mnnoList = deleteMnno.split(",");

            for(String mnno : mnnoList) {
                mnDao.menuDelete(Integer.parseInt(mnno));
            }
        }


        // 기존 메뉴 수정 + 새 메뉴 추가
        if(menuList != null) {

            for(MenuDTO menu : menuList) {

                menu.setSno(dto.getSno());

                if(menu.getMnno() == 0) {

                    // 새로 추가한 메뉴
                    mnDao.menuWrite(menu);

                } else {

                    // 기존 메뉴 수정
                    mnDao.menuUpdate(menu);
                }
            }
        }
    }

    // 음식점 삭제
    public int storeDelete(int sno) {
        return dao.storeDelete(sno);
    }


    // 메뉴 목록
    public List<MenuDTO> menuList(int sno) {
        return mnDao.menuList(sno);
    }
    
 // Elasticsearch용 음식점 데이터 생성
    public StoreESDTO storeESData(int sno) {

        StoreDTO store = dao.storeView(sno);
        List<MenuDTO> menuList = mnDao.menuList(sno);

        StoreESDTO esDto = new StoreESDTO();

        esDto.setSno(store.getSno());
        esDto.setSname(store.getSname());
        esDto.setScategory(store.getScategory());
        esDto.setSkeyword(store.getSkeyword());
        esDto.setScontent(store.getScontent());
        esDto.setSaddr(store.getSaddr());
        esDto.setSsido(store.getSsido());
        esDto.setSsigungu(store.getSsigungu());
        esDto.setSlat(store.getSlat());
        esDto.setSlong(store.getSlong());
        esDto.setSinfo(store.getSinfo());
        esDto.setSparking(store.getSparking());
        esDto.setSstatus(store.getSstatus());

        List<MenuESDTO> menuESList = new ArrayList<>();

        for(MenuDTO menu : menuList) {

            MenuESDTO menuES = new MenuESDTO();

            menuES.setMnname(menu.getMnname());
            menuES.setMnprice(menu.getMnprice());

            menuESList.add(menuES);
        }

        esDto.setMenu(menuESList);

        return esDto;
    }

}