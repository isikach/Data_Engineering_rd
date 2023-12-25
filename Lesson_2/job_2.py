import os
import requests
import json
from flask import Flask

#Токен збережено у змінній оточення
#AUTH_TOKEN = os.environ.get("AUTH_TOKEN")
AUTH_TOKEN = "2b8d97ce57d401abd89f45b0079d8790edd940e6"
# шлях до папки де зберігатиметься файл
path = "\\path\\to\\my_dir\\raw\\sales\\2022-08-09\\"
# лінк де будуть збиратися данні
link = 'https://fake-api-vycpfa6oca-uc.a.run.app/sales'
def main():
    #беру шлях до поточного файлу
    code_dir = os.path.abspath(os.curdir)
    # повний шлях де буде зберігатися файл
    full_path = code_dir + path
    #створити директорію для збереження файлу, якщо її немає, якщо є - пропустити
    try:
        os.makedirs(full_path)
    except FileExistsError:
        pass
    result = []
    i = 1
    while True:
    # перебираю сторінки допоки status = 200 (є дані), все додаю в один файл
        response = requests.get(
            url=link,
            params={'date': '2022-08-09', 'page': i},
            headers={'Authorization': AUTH_TOKEN}
            )
        if response.status_code != 200:
            break
        print("Response status code:", response.status_code)
        print("Response JSON", response.json())
#       якщо потрібно кожну сторінку зберігати окремим файлом:
#       with open(full_path + f"sales_2022-08-09 {i}.json", "w+") as f:
#            json.dump(result, f)
        result += response.json()
        i += 1
    with open(full_path + "sales_2022-08-09.json", "w+") as f:
        json.dump(result, f)



if __name__ == '__main__':
    main()
