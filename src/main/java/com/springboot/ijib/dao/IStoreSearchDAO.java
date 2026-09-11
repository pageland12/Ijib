package com.springboot.ijib.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.springboot.ijib.dto.StoreSearchDTO;

@Mapper
public interface IStoreSearchDAO {
    List<StoreSearchDTO> searchStores(StoreSearchDTO searchDTO);
}