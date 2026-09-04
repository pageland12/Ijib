package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.ijib.dto.BookmarkDTO;

@Mapper
public interface IBookmarkDAO {
	public List<BookmarkDTO> bookmarkList(int mno);
	public int bookmarkInsert(BookmarkDTO dto);
	public int bookmarkDelete(int bmno);
	public int bookmarkCheck(@Param("mno") int mno,@Param("sno") int sno);
}
