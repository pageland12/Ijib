package com.springboot.ijib.dto;

import java.util.Date;

import lombok.Data;

@Data
public class MemberESDTO {

    private int mno;
    private String mname;
    private String mgender;
    private int mage;
    private String maddr;
    private String mauth;
    private Date mdate;
    private String memail;
    private String mtel;
}