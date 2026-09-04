package com.springboot.ijib.dao;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.springboot.ijib.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
		// 회원 목록 (관리자)
		public List<MemberDTO> memberList();
		
		// 이메일로 회원 찾기
		public MemberDTO findByEmail(String memail);
		
		//회원정보상세보기, 수정폼
		public MemberDTO memberView(int mno);
			
		// 회원 등록
		public int memberInsert(MemberDTO dto);
		
		// 회원정보 수정 -> 회원 본인이 수정하는 것
		public int memberUpdate(MemberDTO dto);
		
		// 회원 삭제
		public int memberDelete(int mno);
		
		// 관리자가 회원 수정
		public int adminUpdate(MemberDTO dto);
		
		// 관리자가 회원 삭제
		public int adminDelete(int mno);
}



