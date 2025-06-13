import telebot
from telebot import types
import mysql.connector
from mysql.connector import Error

# Инициализация бота (замени на свой токен)
bot = telebot.TeleBot('7981493236:AAE7-HGvQzROPoXo2fXCTYDpmjYxASiH-Yo')

# Создание подключения к БД
def create_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        port=3306,
        user="root",
        password="12345",
        database="sport_equipment"
    )

@bot.message_handler(commands=['start'])
def start(message):
    markup = types.InlineKeyboardMarkup(row_width=2)
    markup.add(
        types.InlineKeyboardButton('Категории оборудования', callback_data='menu_categories'),
        types.InlineKeyboardButton('Поставщики', callback_data='menu_suppliers'),
        types.InlineKeyboardButton('Оборудование', callback_data='menu_equipment')
    )
    bot.send_message(message.chat.id, "Выберите таблицу:", reply_markup=markup)

# Главное меню по таблицам
@bot.callback_query_handler(func=lambda call: call.data.startswith('menu_'))
def main_menu(call):
    chat_id = call.message.chat.id
    table = call.data.split('_')[1]
    markup = types.InlineKeyboardMarkup(row_width=2)
    markup.add(
        types.InlineKeyboardButton('Посмотреть все', callback_data=f'view_{table}'),
        types.InlineKeyboardButton('Добавить', callback_data=f'add_{table}'),
        types.InlineKeyboardButton('Обновить', callback_data=f'update_{table}'),
        types.InlineKeyboardButton('Удалить', callback_data=f'delete_{table}'),
        types.InlineKeyboardButton('Назад', callback_data='back_to_main')
    )
    bot.edit_message_text(f"Выберите действие с {table}:", chat_id, call.message.message_id, reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'back_to_main')
def back_to_main(call):
    start(call.message)

# ================== CRUD КАТЕГОРИИ ==================

@bot.callback_query_handler(func=lambda call: call.data == 'view_categories')
def view_categories(call):
    conn = create_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM EquipmentCategories")
    rows = cur.fetchall()
    msg = "<b>Категории:</b>\n"
    for row in rows:
        msg += f"ID {row[0]}: {row[1]} - {row[2]}\n"
    bot.send_message(call.message.chat.id, msg, parse_mode='HTML')
    cur.close()
    conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'add_categories')
def add_categories(call):
    msg = bot.send_message(call.message.chat.id, "Введите данные (id;название;описание):")
    bot.register_next_step_handler(msg, insert_category)

def insert_category(message):
    try:
        cid, name, desc = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO EquipmentCategories VALUES (%s, %s, %s)", (cid, name, desc))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Категория добавлена.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'update_categories')
def update_categories(call):
    msg = bot.send_message(call.message.chat.id, "Введите id категории для обновления:")
    bot.register_next_step_handler(msg, update_category_step2)

def update_category_step2(message):
    cid = message.text
    msg = bot.send_message(message.chat.id, "Введите новые данные (название;описание):")
    bot.register_next_step_handler(msg, update_category_final, cid)

def update_category_final(message, cid):
    try:
        name, desc = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE EquipmentCategories SET name=%s, description=%s WHERE category_id=%s", (name, desc, cid))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Категория обновлена.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'delete_categories')
def delete_categories(call):
    msg = bot.send_message(call.message.chat.id, "Введите id категории для удаления:")
    bot.register_next_step_handler(msg, delete_category_final)

def delete_category_final(message):
    try:
        cid = message.text
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM EquipmentCategories WHERE category_id=%s", (cid,))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Категория удалена.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

# ================== CRUD ПОСТАВЩИКИ ==================

@bot.callback_query_handler(func=lambda call: call.data == 'view_suppliers')
def view_suppliers(call):
    conn = create_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM Suppliers")
    rows = cur.fetchall()
    msg = "<b>Поставщики:</b>\n"
    for row in rows:
        msg += f"ID {row[0]}: {row[1]}, Тел: {row[2]}, Email: {row[3]}\n"
    bot.send_message(call.message.chat.id, msg, parse_mode='HTML')
    cur.close()
    conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'add_suppliers')
def add_suppliers(call):
    msg = bot.send_message(call.message.chat.id, "Введите данные (id;название;телефон;email):")
    bot.register_next_step_handler(msg, insert_supplier)

def insert_supplier(message):
    try:
        sid, name, phone, email = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO Suppliers VALUES (%s, %s, %s, %s)", (sid, name, phone, email))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Поставщик добавлен.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'update_suppliers')
def update_suppliers(call):
    msg = bot.send_message(call.message.chat.id, "Введите id поставщика для обновления:")
    bot.register_next_step_handler(msg, update_supplier_step2)

def update_supplier_step2(message):
    sid = message.text
    msg = bot.send_message(message.chat.id, "Введите новые данные (название;телефон;email):")
    bot.register_next_step_handler(msg, update_supplier_final, sid)

def update_supplier_final(message, sid):
    try:
        name, phone, email = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE Suppliers SET name=%s, phone=%s, email=%s WHERE supplier_id=%s", (name, phone, email, sid))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Поставщик обновлён.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'delete_suppliers')
def delete_suppliers(call):
    msg = bot.send_message(call.message.chat.id, "Введите id поставщика для удаления:")
    bot.register_next_step_handler(msg, delete_supplier_final)

def delete_supplier_final(message):
    try:
        sid = message.text
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM Suppliers WHERE supplier_id=%s", (sid,))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Поставщик удалён.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

# ================== CRUD ОБОРУДОВАНИЕ ==================

@bot.callback_query_handler(func=lambda call: call.data == 'view_equipment')
def view_equipment(call):
    conn = create_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT e.item_id, e.name, c.name, s.name
        FROM EquipmentItems e
        JOIN EquipmentCategories c ON e.category_id = c.category_id
        JOIN Suppliers s ON e.supplier_id = s.supplier_id
    """)
    rows = cur.fetchall()
    msg = "<b>Оборудование:</b>\n"
    for row in rows:
        msg += f"ID {row[0]}: {row[1]}, Категория: {row[2]}, Поставщик: {row[3]}\n"
    bot.send_message(call.message.chat.id, msg, parse_mode='HTML')
    cur.close()
    conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'add_equipment')
def add_equipment(call):
    msg = bot.send_message(call.message.chat.id, "Введите данные (id;название;category_id;supplier_id):")
    bot.register_next_step_handler(msg, insert_equipment)

def insert_equipment(message):
    try:
        eid, name, catid, sid = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO EquipmentItems VALUES (%s, %s, %s, %s)", (eid, name, catid, sid))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Оборудование добавлено.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'update_equipment')
def update_equipment(call):
    msg = bot.send_message(call.message.chat.id, "Введите id оборудования для обновления:")
    bot.register_next_step_handler(msg, update_equipment_step2)

def update_equipment_step2(message):
    eid = message.text
    msg = bot.send_message(message.chat.id, "Введите новые данные (название;category_id;supplier_id):")
    bot.register_next_step_handler(msg, update_equipment_final, eid)

def update_equipment_final(message, eid):
    try:
        name, catid, sid = message.text.split(';')
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE EquipmentItems SET name=%s, category_id=%s, supplier_id=%s WHERE item_id=%s", (name, catid, sid, eid))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Оборудование обновлено.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

@bot.callback_query_handler(func=lambda call: call.data == 'delete_equipment')
def delete_equipment(call):
    msg = bot.send_message(call.message.chat.id, "Введите id оборудования для удаления:")
    bot.register_next_step_handler(msg, delete_equipment_final)

def delete_equipment_final(message):
    try:
        eid = message.text
        conn = create_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM EquipmentItems WHERE item_id=%s", (eid,))
        conn.commit()
        bot.send_message(message.chat.id, "✅ Оборудование удалено.")
    except Exception as e:
        bot.send_message(message.chat.id, f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    bot.polling(non_stop=True)
