package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.MenuDTO;

@Mapper
public interface IMenuDAO {
	public List<MenuDTO> menuList(int sno);
	public MenuDTO menuView(int mnno);
	public int menuWrite(MenuDTO dto);
	public int menuUpdate(MenuDTO dto);
	public int menuDelete(int mnno);
}
