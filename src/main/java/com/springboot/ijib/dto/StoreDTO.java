package com.springboot.ijib.dto;

import java.util.List;

import lombok.Data;

@Data
public class StoreDTO {
	private int sno;
    private String sname;
    private String sfiles;
    private String scategory;
    private String skeyword;
    private String scontent;
    private String saddr;
    private double slat;
    private double slong;
    private String stel;
    private String sinfo;
    private String sparking;
    private String sstatus;
    private List<MenuDTO> menus;
}
