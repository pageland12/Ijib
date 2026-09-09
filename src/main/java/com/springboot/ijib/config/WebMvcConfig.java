package com.springboot.ijib.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
	@Autowired
	private SubscriptionInterceptor sInterceptor;
	
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 웹에서의 요청 주소: http://localhost:8080/images/파일명
        // 매핑될 실제 C드라이브 경로: C:\Ijib\ijib_images\파일명
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:///C:/Ijib/ijib_images/");
    }
    
    @Override
    public void  addInterceptors(InterceptorRegistry regist) {
    	regist.addInterceptor(sInterceptor)
    		  // 구독권 권한 확인이 필요한 uri 패턴 
    		  .addPathPatterns("/subscriber/**")
    		  // 예외 uri 패턴
    		  .excludePathPatterns("/guest/**", "/css/**", "/js/**", "/images/**");
    }
}