package com.springboot.ijib.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberESDTO;

@Service
public class MemberService {

    @Autowired
    private IMemberDAO mdao;

    // Elasticsearch용 회원 데이터 생성
    public MemberESDTO memberESData(int mno) {

        MemberDTO member = mdao.memberView(mno);

        MemberESDTO esDto = new MemberESDTO();

        esDto.setMno(member.getMno());
        esDto.setMemail(member.getMemail());
        esDto.setMname(member.getMname());
        esDto.setMgender(member.getMgender());
        esDto.setMage(member.getMage());
        esDto.setMaddr(member.getMaddr());
        esDto.setMtel(member.getMtel());
        esDto.setMauth(member.getMauth());
        esDto.setMdate(member.getMdate());

        return esDto;
    }
}