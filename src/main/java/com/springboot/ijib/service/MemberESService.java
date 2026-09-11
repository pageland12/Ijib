package com.springboot.ijib.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberESDTO;

@Service
public class MemberESService {

    @Autowired
    private RestHighLevelClient client;

    @Autowired
    private IMemberDAO mdao;


    // 회원 등록 / 수정
    public void memberSave(MemberESDTO dto) throws IOException {

        Map<String, Object> data = new HashMap<>();

        data.put("mno", dto.getMno());
        data.put("memail", dto.getMemail());
        data.put("mname", dto.getMname());
        data.put("mgender", dto.getMgender());
        data.put("mage", dto.getMage());
        data.put("maddr", dto.getMaddr());
        data.put("mtel", dto.getMtel());
        data.put("mauth", dto.getMauth());
        data.put("mdate", dto.getMdate());

        IndexRequest request = new IndexRequest("member")
                .id(String.valueOf(dto.getMno()))
                .source(data);

        client.index(request, RequestOptions.DEFAULT);
    }


    // 기존 회원 전체 ES 재등록
    public void memberReindexAll() throws IOException {

        System.out.println("===== 회원 전체 ES 재색인 시작 =====");

        // Oracle에서 회원 전체 조회
        List<MemberDTO> memberList = mdao.memberList();

        System.out.println(
            "Oracle 회원 수 = " + memberList.size()
        );

        int count = 0;

        for (MemberDTO member : memberList) {

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

            // ES 저장
            memberSave(esDto);

            count++;

            System.out.println(
                "ES 회원 등록 = "
                + count
                + " / "
                + memberList.size()
                + " : "
                + member.getMno()
            );
        }

        System.out.println(
            "===== 회원 전체 ES 재색인 완료 ====="
        );

        System.out.println(
            "총 등록 회원 수 = " + count
        );
    }


    // 회원 삭제
    public void memberDelete(int mno) throws IOException {

        DeleteRequest request = new DeleteRequest(
                "member",
                String.valueOf(mno)
        );

        client.delete(request, RequestOptions.DEFAULT);
    }
}