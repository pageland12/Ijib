package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.StoreDTO;

@Mapper
public interface IStoreDAO {
	public List<StoreDTO> storeList();
	public StoreDTO storeView(int sno);
	public int storeWrite(StoreDTO dto);
	public int storeUpdate(StoreDTO dto);
	public int storeDelete(int sno);
}
