document.addEventListener("DOMContentLoaded", function() {

    const menuButton = document.getElementById("menuButton");
    const menuDropdown = document.getElementById("menuDropdown");

    // 햄버거 버튼 클릭
    menuButton.addEventListener("click", function(event) {

        event.stopPropagation();

        menuButton.classList.toggle("active");
        menuDropdown.classList.toggle("active");

    });


    // 메뉴 바깥을 클릭하면 닫기
    document.addEventListener("click", function(event) {

        if (!menuDropdown.contains(event.target) &&
            !menuButton.contains(event.target)) {

            menuButton.classList.remove("active");
            menuDropdown.classList.remove("active");

        }

    });

});