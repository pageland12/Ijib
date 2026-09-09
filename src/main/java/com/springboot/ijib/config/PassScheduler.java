package com.springboot.ijib.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.springboot.ijib.service.PassOrderService;

@Component
public class PassScheduler {

    private final SubscriptionInterceptor subscriptionInterceptor;
	@Autowired
	private	PassOrderService poservice;

    PassScheduler(SubscriptionInterceptor subscriptionInterceptor) {
        this.subscriptionInterceptor = subscriptionInterceptor;
    }
	
	// cron = "초 분 시 일 월 요일", 매일 자정 (00:00): "0 0 0 * * *"
	@Scheduled(cron = "0 0 0 * * *")
	public void runMidnightPassExpiration() {
		try {
			int downgradedCount = poservice.expireAllOverduePasses();
			System.out.println("[배치 실행] 자정 구독권 만료 처리 완료. 강등된 회원 수: " + downgradedCount);
		} catch(Exception e) {
			System.err.println("[배치 오류] 구독권 만료 처리 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
		}
	}
}
