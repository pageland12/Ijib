package com.springboot.ijib.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dto.OrdersDTO;
import com.springboot.ijib.dto.PassDTO;

@Service
public class PassOrderESService {
	@Autowired
	private RestHighLevelClient client;
	
	public void save(OrdersDTO odto, PassDTO pdto) {
		try {
			// 0. 주문이 제대로 됐는지, 주문 내역이 제대로 들어왔는지 확인
			if (odto.getOno() == null) {
                throw new IllegalStateException("주문 번호(ono)가 null입니다.");
            }
			
			// 1. 인덱스 매핑의 yyyy-MM-dd HH:mm:ss 포맷에 맞춤
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String odate = LocalDateTime.now().format(formatter);

            // 2. ES에 저장할 Map 생성
            Map<String, Object> map = new HashMap<>();
            map.put("pno", pdto.getPno());
            map.put("pname", pdto.getPname());
            map.put("pprice", odto.getOprice());
            map.put("mno", odto.getMno());
            map.put("odate", odate);

            // 인덱스명은 "pass", 도큐먼트 ID는 주문 고유 번호(ono)
            IndexRequest request = new IndexRequest("pass")
                    .id(odto.getOno())
                    .source(map);

            client.index(request, RequestOptions.DEFAULT);

            // 로그
    		System.out.println("주문 번호: " + odto.getOno());
    		System.out.println("주문 상품: " + pdto.getPname());
    		System.out.println("주문 일시: " + odate);

        } catch (Exception e) {
            // DB 결제는 이미 성공했으므로 ES 색인 실패 시 로그만 남김
            System.err.println("Elasticsearch 색인 실패: " + e.getMessage());
            e.printStackTrace();
        }
	}
}
