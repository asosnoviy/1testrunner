Перем СписокТестов;

Процедура ПриСозданииОбъекта()

	СписокТестов = Новый Массив;

КонецПроцедуры


Процедура ЗагрузитьТесты(Пути) Экспорт
	Перем НомерТестаСохр;
	Перем Рез;
	
	Рез = Истина;
	
	Для Каждого ПутьТеста Из Пути Цикл
		Файл = Новый Файл(ПутьТеста);
		Если Файл.ЭтоКаталог() Тогда
			ВызватьИсключение "Пока не умею обрабатывать каталоги тестов";
		Иначе
			ПолноеИмяТестовогоСлучая = Файл.ПолноеИмя;
			ИмяКлассаТеста = СтрЗаменить(Файл.ИмяБезРасширения,"-","")+СтрЗаменить(Строка(Новый УникальныйИдентификатор),"-","");
			Попытка
				ПодключитьСценарий(Файл.ПолноеИмя, ИмяКлассаТеста);
				Тест = Новый(ИмяКлассаТеста);
			Исключение
				ИнфоОшибки = ИнформацияОбОшибке();
					текстОшибки = ОписаниеОшибки();
				Сообщить("Не удалось загрузить тест " + ПолноеИмяТестовогоСлучая + Символы.ПС + текстОшибки);
				Рез = Ложь;
				РезультатТестирования = Перечисления.ЗначенияСостоянияТестов.Сломался;
				Продолжить;
			КонецПопытки;
			// Лог.Отладка("Подключили сценарий теста %1", ПолноеИмяТестовогоСлучая);

			МассивТестовыхСлучаев = ПолучитьТестовыеСлучаи(Тест, ПолноеИмяТестовогоСлучая);
			Если МассивТестовыхСлучаев = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТестовыйСлучай Из МассивТестовыхСлучаев Цикл
			
				ОписаниеТеста = Новый ОписаниеТеста(Тест, ТестовыйСлучай, ИмяКлассаТеста, ПолноеИмяТестовогоСлучая);
				СписокТестов.Добавить(ОписаниеТеста);
				
				НомерТеста = СписокТестов.Количество()-1;

				// fixme
				КомандаЗапуска = Перечисления.СтруктураПараметровЗапуска.Запустить; 
				НаименованиеТестаДляЗапуска = Неопределено;

				Если КомандаЗапуска = Перечисления.СтруктураПараметровЗапуска.ПоказатьСписок Тогда
					Сообщить("    Имя теста <"+ ОписаниеТеста.Представление() + ">, №теста <" + НомерТеста + ">");

				ИначеЕсли КомандаЗапуска = Перечисления.СтруктураПараметровЗапуска.Запустить 
					ИЛИ КомандаЗапуска = Перечисления.СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда
					Если НаименованиеТестаДляЗапуска = Неопределено Тогда
						// Если НомерТеста = НомерТестаДляЗапуска Тогда
							НомерТестаСохр = НомерТеста;
						// КонецЕсли;
					Иначе
						Если НРег(НаименованиеТестаДляЗапуска) = НРег(ОписаниеТеста.ИмяМетода()) Тогда
							НомерТестаСохр = НомерТеста;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
	
	Если НомерТестаСохр <> Неопределено Тогда
		ОписаниеТеста = СписокТестов[НомерТестаСохр];
		СписокТестов.Очистить();
		СписокТестов.Добавить(ОписаниеТеста);
	КонецЕсли;
	
КонецПроцедуры