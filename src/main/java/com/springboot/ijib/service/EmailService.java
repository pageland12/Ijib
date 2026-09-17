package com.springboot.ijib.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendWelcomeEmail(String toEmail, String mname) {

        String subject = "[이집어때] 회원가입을 축하드립니다! 🎉";

        String htmlContent =
                "<div style='font-family: Arial, sans-serif; "
                + "padding: 30px; "
                + "max-width: 600px; "
                + "margin: 0 auto; "
                + "border: 1px solid #eeeeee; "
                + "border-radius: 10px;'>"

                + "<h2 style='margin-bottom: 20px;'>"
                + mname + "님, 환영합니다! 🎉"
                + "</h2>"

                + "<p>안녕하세요, <strong>"
                + mname
                + "</strong>님!</p>"

                + "<p>"
                + "이집어때 회원가입을 축하드립니다 😊"
                + "</p>"

                + "<p>"
                + "이제 맛집을 찾아보고 다양한 서비스를 이용해보세요!"
                + "</p>"

                + "<p style='margin-top: 30px;'>"
                + "이집어때를 이용해주셔서 감사합니다."
                + "</p>"

                + "<hr style='border: none; border-top: 1px solid #eeeeee;'>"

                + "<p style='color: #888888; font-size: 12px;'>"
                + "© 이집어때. All Rights Reserved."
                + "</p>"

                + "</div>";

        try {
            // HTML 메일 전송을 위한 MimeMessage 생성
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom("admin@ijib.com"); // 가상 발신자 주소 (아무거나 적어도 됨)
            helper.setTo(toEmail);              // 팀원이 입력한 이메일
            helper.setSubject(subject);
            helper.setText(htmlContent, true);  // true: HTML 형식 사용

            // Mailtrap 가상 서버로 메일 발송
            mailSender.send(message);

            System.out.println("가상 환영 이메일 전송 성공 (Mailtrap) : " + toEmail);

        } catch (Exception e) {
            System.err.println("환영 이메일 전송 실패 : " + toEmail);
            System.err.println("오류 내용 : " + e.getMessage());
        }
    }
    
    public void sendAuthCodeEmail(String toEmail, String authCode) {
        String subject = "[이집어때] 비밀번호 찾기 인증번호 안내 🔑";
        
        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 30px; max-width: 600px; margin: 0 auto; border: 1px solid #eeeeee; border-radius: 10px;'>"
                + "<h2 style='margin-bottom: 20px;'>비밀번호 찾기 인증 안내 🔑</h2>"
                + "<p>요청하신 인증번호는 아래와 같습니다.</p>"
                + "<div style='font-size: 24px; font-weight: bold; color: #ff5722; margin: 20px 0;'>" + authCode + "</div>"
                + "<p>화면에 인증번호를 정확히 입력해 주세요.</p>"
                + "</div>";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom("admin@ijib.com");
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            System.out.println("인증번호 메일 전송 성공 (Mailtrap) : " + toEmail);

        } catch (Exception e) {
            System.err.println("인증번호 메일 전송 실패 : " + e.getMessage());
        }
    }
}