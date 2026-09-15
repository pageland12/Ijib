package com.springboot.ijib.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.action.update.UpdateResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.OrdersDTO;
import com.springboot.ijib.dto.PassDTO;

@Service
public class PassOrderESService {
	@Autowired
	private RestHighLevelClient client;
	
	@Autowired
	private IMemberDAO mdao;
	
	public void save(OrdersDTO odto, PassDTO pdto) throws Exception {
		// 0. 주문이 제대로 됐는지, 주문 내역이 제대로 들어왔는지 확인
		if (odto.getOno() == null) {
            throw new IllegalStateException("주문 번호(ono)가 null입니다.");
        }
		
		// 1-1. 인덱스 매핑의 yyyy-MM-dd HH:mm:ss 포맷에 맞춤
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime orderDateTime = (odto.getOdate() != null) ? odto.getOdate() : LocalDateTime.now();
        String odate = orderDateTime.now().format(formatter);

        // 1-2. member 정보 들고오기
        MemberDTO member = mdao.memberView(odto.getMno());
        
        // 2. ES에 저장할 Map 생성
        Map<String, Object> map = new HashMap<>();
        map.put("pno", pdto.getPno());
        map.put("pname", pdto.getPname());
        map.put("pprice", odto.getOprice());
        map.put("mno", odto.getMno());
        map.put("odate", odate);
        // ostatus 필드 추가
        map.put("ostatus", "PAID");
        // opayment 필드 추가
        map.put("opayment", odto.getOpayment());
        // mage 필드 추가
        map.put("mage", member.getMage());
        // mgender 필드 추가
        map.put("mgender", member.getMgender());

        // 3.ES에 저장
        // 인덱스명은 "pass", 도큐먼트 ID는 주문 고유 번호(ono)
        IndexRequest request = new IndexRequest("pass")
                .id(odto.getOno())
                .source(map);

        client.index(request, RequestOptions.DEFAULT);

        // 로그
		System.out.println("주문 번호: " + odto.getOno());
	}
	
	// 환불 성공 시 ES pass 인덱스 정보 동기화
	public void refundStatusUpdate(String ono, String reason, String customText) {
		try {
			if (ono == null || ono.isBlank()) {
				throw new IllegalStateException("주문 번호(ono)가 유효하지 않습니다.");
			}
			
			// 1. 업데이트할 필드
			Map<String, Object> map = new HashMap<>();
			map.put("ostatus", "REFUND");
			// 환불 사유 및 환불 상세(기타용) 추가
			map.put("refund_reason", reason);
			if ("기타".equals(reason)) {
				map.put("refund_detail", customText);
			}
			
			// 2. UpdateRequest 생성 (인덱스: pass, _id: ono)
			UpdateRequest request = new UpdateRequest("pass", ono)
					.doc(map)
					.docAsUpsert(true);
			
			// 3. ES 부분 갱신 요청
			UpdateResponse response = client.update(request, RequestOptions.DEFAULT);
			
			System.out.println("ES 환불 상태 동기화 완료. 주문번호: " + ono + ", 결과: " + response.getResult());
		} catch(Exception e) {
			System.err.println("Elastic Search 환불 상태 업데이트 실패: " + e.getMessage());
			e.printStackTrace();
		}
	}
}
