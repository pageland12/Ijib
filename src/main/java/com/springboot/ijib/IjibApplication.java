package com.springboot.ijib;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class IjibApplication {

	public static void main(String[] args) {
		SpringApplication.run(IjibApplication.class, args);
	}

}
