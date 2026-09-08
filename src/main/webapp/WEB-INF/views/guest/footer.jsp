<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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

/* header는 크기 유지 */
header {
    flex-shrink: 0;
}

/* footer를 제외한 영역이 남은 공간을 차지 */
header ~ *:not(footer) {
    flex: 1 0 auto;
}

/* =========================
   Footer
   ========================= */

footer {
    background-color: #333333;
    color: #777777;

    width: 100%;
    box-sizing: border-box;

    padding: 25px 20px 20px;

    font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;

    flex-shrink: 0;

    text-align: center;
}

/* footer 전체 내용 */
.footer-content {
    max-width: 1100px;
    margin: 0 auto;

    font-size: 12px;
    line-height: 1.8;
}

/* =========================
   상단 링크
   ========================= */

.footer-links {
    margin-bottom: 8px;
}

.footer-links a {
    color: #888888;

    text-decoration: none;

    font-size: 12px;

    margin: 0;
}

/* 링크 사이 | 표시 */
.footer-links a:not(:last-child)::after {
    content: "|";

    color: #666666;

    margin: 0 12px;
}

/* 마우스 올렸을 때 */
.footer-links a:hover {
    color: #aaaaaa;
    text-decoration: none;
}

/* 개인정보처리방침 */
.footer-links .bold-link {
    font-weight: bold;
    color: #999999;
}

/* =========================
   회사 정보
   ========================= */

.footer-info-wrap {
    display: block;

    margin-bottom: 0;
}

/* 회사 정보 */
.footer-company-info {
    color: #777777;

    font-size: 12px;

    line-height: 1.9;
}

/* 회사명 */
.footer-company-info strong {
    color: #888888;
    font-weight: normal;
}

/* 고객센터 */
.footer-cs-info {
    margin-top: 0;

    text-align: center;

    color: #777777;

    font-size: 12px;

    line-height: 1.8;
}

/* 전화번호 */
.footer-cs-info .cs-number {
    font-size: 12px;

    font-weight: normal;

    color: #777777;

    margin-bottom: 0;
}

/* =========================
   Copyright
   ========================= */

.footer-copyright {
    color: #666666;

    font-size: 11px;

    margin-top: 5px;
}
</style>


<footer>

    <div class="footer-content">

        <!-- 상단 메뉴 -->
        <div class="footer-links">

            <a href="/#">이용약관</a>

            <a href="/#">기업회원 이용약관</a>

            <a href="/#">위치기반서비스 이용약관</a>

            <a href="/#">개인정보처리방침</a>

            <a href="/#">사이트맵</a>

        </div>


        <!-- 회사 정보 -->
        <div class="footer-info-wrap">

            <div class="footer-company-info">

                상호 : 이집어때 |
                대표이사 : 홍길동 |
                개인정보관리책임자 : KH아카데미
                <br>

                문의 : pageland12\@gmail.com |
                제휴문의 |
                사업자등록번호: 123-45-67890 |
                통신판매업신고: 2026-부산진구-0000호
                <br>

                부산광역시 부산진구 중앙대로 627 삼비빌딩 12층

            </div>


            <!-- 고객센터 -->
            <div class="footer-cs-info">

                <div class="cs-number">
                    대표전화 : 010-1234-5678
                </div>

            </div>

        </div>


        <!-- Copyright -->
        <div class="footer-copyright">

            Copyright © Ijib Corp. All rights reserved.

        </div>

    </div>

</footer>