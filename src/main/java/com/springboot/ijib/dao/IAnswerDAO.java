package com.springboot.ijib.dao;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.springboot.ijib.dto.AnswerDTO;
@Mapper
public interface IAnswerDAO {
	public List<AnswerDTO> answerList(int bno);
	public int answerWrite(AnswerDTO dto);
	public int answerUpdate(AnswerDTO dto);
	public int answerDelete(int ano);
}
