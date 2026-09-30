import sys # получить параметры от пользователя при запуске программы
import requests
import logging
import json
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
LOG_FILE = ROOT_DIR / "error.log"
DATA_DIR = ROOT_DIR / "data"

# Создаем директорию для данных, если она не существует
DATA_DIR.mkdir(exist_ok=True)

def save_to_json(data, from_currency, to_currency, date):
    filename = f"{from_currency}_{to_currency}_{date}.json"
    file_path = DATA_DIR / filename

    with open(file_path, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4)

    print(f"Data saved to: {file_path}")

logging.basicConfig(
    filename=LOG_FILE,
    level=logging.ERROR,
    format="%(asctime)s - %(levelname)s - %(message)s",
    encoding="utf-8"
)


def log_error(message):
    print(message)
    logging.error(message)


# Функция для получения курса валют
def get_exchange_rate(from_currency, to_currency, date):
    url = "http://localhost:8080/"

    params = {
        "from": from_currency,
        "to": to_currency,
        "date": date
    }

    data = {
        "key": "EXAMPLE_API_KEY"
    }

    # Пытаемся отправить POST-запрос на сервер и получить ответ в формате JSON.
    # Если возникает ошибка запроса, выводим сообщение об ошибке и возвращаем None.
    try:
        response = requests.post(url, params=params, data=data)

        return response.json()

    except requests.RequestException as error: # базовый тип ошибок библиотеки requests.
        log_error(f"Request error: {error}")
        return None


if len(sys.argv) != 4: # sys.argv — обычный Python-список.
    log_error("Usage: python currency_exchange_rate.py <from> <to> <date>")
    sys.exit(1) # останавливает программу.


# Сохраняем параметры в переменные
from_currency = sys.argv[1]
to_currency = sys.argv[2]
date = sys.argv[3]


# берёт JSON-ответ сервера:
result = get_exchange_rate(from_currency, to_currency, date)

if result is None:
    sys.exit(1)


if result["error"]:
    log_error(f"API error: {result['error']}")
    sys.exit(1)
else:
    print("Request successful")
    print(result["data"])

    save_to_json(
        result,
        from_currency,
        to_currency,
        date
    )