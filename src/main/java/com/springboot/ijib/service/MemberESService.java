package com.springboot.ijib.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dto.MemberESDTO;

@Service
public class MemberESService {

    @Autowired
    private RestHighLevelClient client;


    // 회원 등록 / 수정
    public void memberSave(MemberESDTO dto) throws IOException {

        Map<String, Object> data = new HashMap<>();

        data.put("mname", dto.getMname());
        data.put("mgender", dto.getMgender());
        data.put("mage", dto.getMage());
        data.put("maddr", dto.getMaddr());
        data.put("mauth", dto.getMauth());
        data.put("mdate", dto.getMdate());

        IndexRequest request = new IndexRequest("member")
                .id(String.valueOf(dto.getMno()))
                .source(data);

        client.index(request, RequestOptions.DEFAULT);
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