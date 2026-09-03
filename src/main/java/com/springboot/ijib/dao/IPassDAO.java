package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.PassDTO;

@Mapper
public interface IPassDAO {
	public List<PassDTO> passList();
	public PassDTO passView(int pno);
	public int passWrite(PassDTO dto);
	public int passUpdate(PassDTO dto);
	public int passDelete(int pno);
}
