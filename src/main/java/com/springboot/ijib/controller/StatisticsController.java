package com.springboot.ijib.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StatisticsController {
	@RequestMapping("/admin/storeStatistics")
    public String storeStatistics() {
        return "admin/storeStatistics";
    }
	
	@RequestMapping("/admin/memberStatistics")
    public String memberStatistics() {
        return "admin/memberStatistics";
    }
	
	@RequestMapping("/admin/passStatistics")
    public String passStatistics() {
        return "admin/passStatistics";
    }
}
