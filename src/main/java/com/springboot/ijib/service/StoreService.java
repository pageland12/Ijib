package com.springboot.ijib.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMenuDAO;
import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.MenuDTO;
import com.springboot.ijib.dto.StoreDTO;

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
    public void storeUpdate(StoreDTO dto, List<MenuDTO> menuList) {

        dao.storeUpdate(dto);

        for(MenuDTO menu : menuList) {
            menu.setSno(dto.getSno());
            mnDao.menuUpdate(menu);
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

}