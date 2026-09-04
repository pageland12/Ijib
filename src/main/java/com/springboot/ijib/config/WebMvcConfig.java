package com.springboot.ijib.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 웹에서의 요청 주소: http://localhost:8080/images/파일명
        // 매핑될 실제 C드라이브 경로: C:\ijib_images\파일명
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:///C:/ijib_images/");
    }
}