<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 중복 확인</title>

<script>
    function useEmail() {
        opener.emailCallBack("${memail}");
        window.close();
    }

    function check() {
        let memail = document.emailCheck.memail;

        let memailExp =
            /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        if (!memail.value) {
            alert("이메일을 입력해주세요.");
            memail.focus();
            return false;
        }

        if (!memailExp.test(memail.value)) {
            alert("이메일을 올바르게 입력해주세요.");
            memail.focus();
            return false;
        }

        return true;
    }
</script>
</head>

<body>

    <div class="popup-card">

        <h3 class="popup-title">이메일 중복 확인</h3>

        <form name="emailCheck"
              method="post"
              action="/guest/emailCheck">

            <div class="input-group">

                <input type="text"
                       name="memail"
                       value="${memail}"
                       placeholder="이메일을 입력하세요"
                       required
                       autocomplete="off">

                <button type="submit"
                        class="btn-check"
                        onclick="return check()">
                    중복확인
                </button>

            </div>
        </form>

        <c:if test="${checked}">

            <c:choose>

                <c:when test="${isDuplicated}">

                    <div class="result-box danger">
                        <strong>"${memail}"</strong><br>
                        이미 사용 중인 이메일입니다.
                    </div>

                </c:when>

                <c:otherwise>

                    <div class="result-box success">
                        <strong>"${memail}"</strong><br>
                        사용 가능한 이메일입니다.

                        <button type="button"
                                class="btn-use"
                                onclick="useEmail()">
                            이메일 사용하기
                        </button>
                    </div>

                </c:otherwise>

            </c:choose>

        </c:if>

    </div>

</body>
</html>