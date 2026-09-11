package com.springboot.ijib.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StatisticsController {
	@RequestMapping("/admin/statistics")
    public String statistics() {
        return "admin/statistics";
    }
}
