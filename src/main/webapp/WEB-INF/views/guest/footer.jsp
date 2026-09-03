<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    html, body {
        height: 100%;
        margin: 0;
    }

    body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    header {
        flex-shrink: 0;
    }

    header ~ *:not(footer) {
        flex: 1 0 auto;
    }

    footer {
        background-color: #FAF0E6;
        color: #7A6A60;
        padding: 35px 20px 25px 20px;
        border-top: 1px solid #EFE0D3;
        flex-shrink: 0;
        width: 100%;
        box-sizing: border-box;
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
    }

    .footer-content {
        max-width: 1100px;
        margin: 0 auto;
        font-size: 13px;
        line-height: 1.6;
    }

    .footer-links {
        margin-bottom: 18px;
        padding-bottom: 15px;
        border-bottom: 1px solid #EFE0D3;
    }

    .footer-links a {
        color: #5A4A40;
        text-decoration: none;
        margin-right: 18px;
        font-weight: 500;
    }

    .footer-links a:hover {
        text-decoration: underline;
    }

    .footer-links a.bold-link {
        font-weight: bold;
        color: #2b221c;
    }

    .footer-info-wrap {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 20px;
    }

    .footer-company-info {
        color: #8C7B70;
    }

    .footer-cs-info {
        text-align: right;
    }

    .footer-cs-info .cs-number {
        font-size: 18px;
        font-weight: bold;
        color: #4A3B32;
        margin-bottom: 4px;
    }

    .footer-copyright {
        color: #A09085;
        font-size: 12px;
        margin-top: 15px;
    }
</style>

<footer>
    <div class="footer-content">
        
        <div class="footer-links">
            <a href="/#">이집어때 소개</a>
            <a href="/#">이용약관</a>
            <a href="/#" class="bold-link">개인정보처리방침</a>
            <a href="/#">고객센터</a>
        </div>

        <div class="footer-info-wrap">
            <div class="footer-company-info">
                <strong>(주) 이집어때</strong> | 대표자: KH아카데미 | 사업자등록번호: 123-45-67890<br>
    			통신판매업신고: 2026-부산진구-0000호 | 개인정보보호책임자: KH아카데미<br>
                주소: 부산광역시 부산진구 중앙대로 627 삼비빌딩 12층
            </div>

            <div class="footer-cs-info">
                <div class="cs-number">🎧 1588-0000</div>
                <div>평일 09:00 - 18:00 (주말/공휴일 휴무)</div>
                <div>이메일: pageland12@gmail.com</div>
            </div>
        </div>

        <div class="footer-copyright">
            Copyright © Ijib Corp. All rights reserved.
        </div>

    </div>
</footer>