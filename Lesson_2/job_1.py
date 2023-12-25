import fastavro, os, json

path_avro = "\\path\\to\\my_dir\\stg\\sales\\2022-08-09\\"
myjson_file = os.path.abspath(os.curdir) + "\\path\\to\\my_dir\\raw\\sales\\2022-08-09\\" + "sales_2022-08-09.json"
def main():
    #беру шлях до поточного файлу
    code_dir = os.path.abspath(os.curdir)
    print(code_dir)
    # повний шлях де буде зберігатися файл
    full_path_avro = code_dir + path_avro
    print(full_path_avro)
    #створити директорію для збереження файлу, якщо її немає, якщо є - пропустити
    try:
        os.makedirs(full_path_avro)
    except FileExistsError:
        pass
    with open(myjson_file, "r") as json_file:
        json_data = json.load(json_file)

    resula_avro = os.path.join(path_avro + "sales_2022-08-09.avro")
#    avro_schema = fastavro.parse_schema(json_data)

    with open(resula_avro, "wb") as avro_file:
        fastavro.writer(resula_avro, schemaless=True, records=[json_data])


if __name__ == '__main__':
    main()
