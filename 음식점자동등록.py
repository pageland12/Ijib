# time.sleep()을 사용하기 위함
import csv
import json
import os
import time

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
# 키보드 입력을 전송해야하는 경우
from selenium.webdriver import Keys
# 요소를 찾을 때 By 클래스를 사용하기 위함
from selenium.webdriver.common.by import By

chrome_options = Options()
# WebDriver 실행 후 자동 꺼짐 방지
chrome_options.add_experimental_option("detach", True)
# 크롬 브라우저의 secret창 모드
chrome_options.add_argument("--incognito")
driver = webdriver.Chrome(options=chrome_options)
driver.maximize_window()

# ==========================================
# 1. 로그인 수행
# ==========================================
url = "http://localhost:8080/loginForm"
driver.get(url)
driver.find_element(By.CSS_SELECTOR, "#memail").send_keys("admin")
driver.find_element(By.CSS_SELECTOR, "#mpasswd").send_keys("qwer1234")
time.sleep(0.5)
driver.find_element(By.CSS_SELECTOR, ".btn-submit").click()
time.sleep(1)

# ==========================================
# 2. 음식점 등록
# ==========================================
csv_file = os.path.join(os.getcwd(), "100year_restaurants_final_keywords.csv")

target_url = "http://localhost:8080/admin/storeWriteForm"

with open(csv_file, mode = 'r', encoding = "utf-8-sig") as file:
    reader = csv.DictReader(file)

    for idx, row in enumerate(reader, start = 1):
        try:
            # 만약 음식점 입력 폼이 아니라면 해당 폼으로 이동
            if driver.current_url != target_url:
                driver.get(target_url)
                time.sleep(0.5)

            # 음식점명 등록
            name = driver.find_element(By.NAME, "sname")
            name.clear()
            name.send_keys(row['name'])
            time.sleep(0.1)

            # 이미지 등록
            image = driver.find_element(By.NAME, "sfiles")
            image.clear()

            raw_images = row.get("images", "")
            if raw_images and raw_images != "정보 없음":
                try:
                    img_list = json.loads(raw_images)
                    img_val = ",".join(img_list)
                except:
                    img_val = ""
            else:
                img_val = ""

            if img_val:
                image.send_keys(img_val)
            time.sleep(0.1)

            # 카테고리 등록
            category = driver.find_element(By.NAME, "scategory")
            category.clear()
            category.send_keys(row['category'])
            time.sleep(0.1)

            # 키워드 등록
            for cb in driver.find_elements(By.CSS_SELECTOR, "input[name='skeyword']:checked"):
                cb.click()

            raw_keywords = row.get("keywords", "")
            if raw_keywords and raw_keywords != "정보 없음":
                try:
                    keyword_list = json.loads(raw_keywords)
                    for data_keyword in keyword_list:
                        checkbox = driver.find_element(By.CSS_SELECTOR, f"input[name='skeyword'][value='{data_keyword}']")
                        if not checkbox.is_selected():
                            checkbox.click()
                except Exception as e:
                    print(f"[{row.get('name')}] 키워드 등록 실패: {e}")

            # 설명 등록
            description = driver.find_element(By.NAME, "scontent")
            description.clear()
            description.send_keys(row['rest_description'])
            time.sleep(0.1)

            # 주소 등록
            addr = driver.find_element(By.NAME, "saddr")
            addr.clear()
            addr.send_keys(row['addr'])
            time.sleep(0.1)

            # 시도 등록
            sido = driver.find_element(By.NAME, "ssido")
            sido.clear()
            sido.send_keys(row['sido'])
            time.sleep(0.1)

            # 시군구 등록
            sigungu = driver.find_element(By.NAME, "ssigungu")
            sigungu.clear()
            sigungu.send_keys(row['sigungu'])
            time.sleep(0.1)

            # 위도 등록
            lat = driver.find_element(By.NAME, "slat")
            lat.clear()
            lat.send_keys(f"{float(row['mapy']):.8f}")
            time.sleep(0.1)

            # 경도 등록
            long = driver.find_element(By.NAME, "slong")
            long.clear()
            long.send_keys(f"{float(row['mapx']):.8f}")
            time.sleep(0.1)

            # 전화번호 등록
            tel = driver.find_element(By.NAME, "stel")
            tel.clear()
            tel.send_keys(row['tel'])
            time.sleep(0.1)

            # 영업 정보 등록
            info = driver.find_element(By.NAME, "sinfo")
            info.clear()

            raw_infos = row.get("business_hours", "")
            if raw_infos and raw_infos != "정보 없음":
                lines = []
                try:
                    info_list = json.loads(raw_infos)
                    for day, hours in info_list.items():
                        lines.append(f"{day}: {hours}")
                    formatted_info = "\n".join(lines)
                    info.send_keys(formatted_info)
                except Exception as e:
                    print(f"[{row.get('name')}] 영업 정보 등록 실패: {e}")
                    info.send_keys("정보 없음")
            else:
                info.send_keys("정보 없음")

            time.sleep(0.1)

            # 주차 여부 등록
            parking = driver.find_element(By.NAME, "sparking")
            parking.clear()
            parking.send_keys(row['parking'])
            time.sleep(0.1)

            # 메뉴 등록
            raw_menus = row.get("detailed_menus", "")
            if raw_menus:
                try:
                    menu_list = json.loads(raw_menus)
                    # 메뉴 가지수 - 1 만큼 메뉴 추가 버튼 누르기
                    if len(menu_list) > 1:
                        for _ in range(len(menu_list) - 1):
                            driver.find_element(By.CSS_SELECTOR, "input[type='button'][value='메뉴 추가']").click()
                            time.sleep(0.05)
                    # 메뉴 등록하기
                    menu_name = driver.find_elements(By.CSS_SELECTOR, "input[type='text'][name='mnname']")
                    menu_price = driver.find_elements(By.CSS_SELECTOR, "input[type='text'][name='mnprice']")
                    for m_idx, menu in enumerate(menu_list):
                        menu_name[m_idx].clear()
                        menu_name[m_idx].send_keys(str(menu.get("menu", "정보 없음")))
                        menu_price[m_idx].clear()
                        menu_price[m_idx].send_keys(str(menu.get("price", 0)))
                        time.sleep(0.1)
                except Exception as e:
                    print(f"[{row.get('name')}] 메뉴 등록 실패: {e}")
            else:
                driver.find_element(By.NAME, "mnname").send_keys("정보 없음")
                driver.find_element(By.NAME, "mnprice").send_keys("0")

            # 등록
            driver.find_element(By.CSS_SELECTOR, "input[type='submit'][value='등록']").click()
            time.sleep(1)

            # [테스트용 제어 코드] 3건 등록 후 즉시 종료
            if idx >= 3:
                print("테스트 3건 등록 완료! 스크립트를 종료합니다.")
                break

        except Exception as e:
            # 음식점 입력 실패
            print(f"[{idx}번] 등록 실패 ({row.get('name', '제목없음')}): {e}")
            driver.get(target_url)
            time.sleep(1)
