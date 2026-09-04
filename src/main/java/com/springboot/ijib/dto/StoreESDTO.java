package com.springboot.ijib.dto;

import java.util.List;

import lombok.Data;

@Data
public class StoreESDTO {
	private int sno;
	private String sname;
	private String scategory;
	private String skeyword;
	private String scontent;
	private String saddr;
	private String ssido;
	private String ssigungu;
	private double slat;
	private double slong;
	private String sinfo;
	private String sparking;
	private String sstatus;
	
	private List<MenuESDTO> menu;
}
