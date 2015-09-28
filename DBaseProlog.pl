:-dynamic
        trains/4.
/* Запуск программы */
run:-
     retractall(trains/4),
     consult('db.txt'),
     menu.
     
/* Формирование меню */
menu:-
      repeat,
      write('*******************************'),nl,
      write('* Расписание движения поездов *'),nl,
      write('*******************************'),nl,
      write('1 – просмотр записей в БД'),nl,
      write('2 – добавить запись'),nl,
      write('3 - удалить запись'),nl,
      write('4 - сохранить базу в файл'),nl,
      write('5 - поиск ближайшего поезда до Москвы'),nl,
      write('6 – выход'),nl,nl,
      write('Выберите пункт меню: (1-6) '),
      read(X),
      X<7,
      process(X),
      X=6,!.

process(1):-viewing_trains.
process(2):-to_add,!.
process(3):-to_remove,!.
process(4):-db_save,!.
process(5):-to_find,!.
process(6):-retractall(trains/4),!.
     
/* Чтение файла и просмотр базы данных */
viewing_trains:-
                trains(Num,Destination,Time_otpr,Time_prib),
                write('№ рейса: '), write(Num),nl,
                write('Пункт назначения: '), write(Destination),nl,
                write('Время отправки: '), write(Time_otpr),nl,
                write('Время прибытия: '), write(Time_prib),nl,
                write('-------------------------------'),nl.

/* Добавление записи в БД */
to_add:-
        write('*******************'),nl,
        write('* Добавить запись *'),nl,
        write('*******************'),nl,
        repeat,
        write('Номер поезда: '),
        read(Num),
        write('Пункт назначения: '),
        read(Destination),
        write('Время отправки: '),
        read(Time_otpr),
        write('Время прибытия: '),
        read(Time_prib),
        assertz(trains(Num,Destination,Time_otpr,Time_prib)),
        quest,!.

/* Вопрос */        
quest:-
       write('Продолжить ввод? y/n '),
       read(A),
       answer(A).

answer(_):-fail.
answer(y):-fail.
answer(n).

/* Сохранение динамической БД в файл */
db_save:-
        tell('db.txt'),
        listing(trains/4),
        told,
        write('Файл базы данных db.txt сохранен!'),nl,nl.

/* Удаление записи из БД */
to_remove:-
           write('******************'),nl,
           write('* Удаление записи *'),nl,
           write('******************'),nl,
           write('Введите № рейса: '),
           read(Num),
           retract(trains(Num,_,_,_)),
           write('Запись удалена!!!'),nl,nl.

/* Поиск ближайшего рейса до Москвы */
to_find:-
         write('-------------------------------------------------------'),nl,
         write('Введите текущее время: '),
         read(Time),
         go('Москва',Time,Go),
         write('Ближайший рейс до Москвы: '),
         write(Go),nl,
         write('-------------------------------------------------------'),nl,
         fail.

/* Перебор всех записей по полю "Время отправки" и сравнение его с текущим временем */
go(Destination,Time,Go):-
                         setof(trains(Num,Destination,Time_otpr,Time_prib),
                         (trains(Num, Destination, Time_otpr, Time_prib),Time @< Time_otpr),
                         [Go|_]).
