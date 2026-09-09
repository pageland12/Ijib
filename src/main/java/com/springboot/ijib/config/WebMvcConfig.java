package com.springboot.ijib.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 사용자 업로드 이미지 (외부 경로)
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:///C:/Ijib/ijib_images/");

        // 프로젝트 내장 정적 이미지 (로고 등)
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("classpath:/static/images/");
    }
}