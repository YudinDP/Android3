import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart'; 

void main() {
  runApp(const MyApp()); 
}


class MyApp extends StatelessWidget {
  
  const MyApp(); //Конструктор класса MyApp

  @override
  Widget build(BuildContext context) {
    //Метод build создает визуальное представление виджета. BuildContext содержит информацию о местоположении виджета в дереве виджетов
    return MaterialApp(
      //MaterialApp - это виджет, который предоставляет основные функции приложения, такие как навигация, темы и локализация
      title: 'Калькулятор ускорения свободного падения', 
      home: const InputScreen(), //Задает домашний экран приложения, в данном случае это виджет InputScreen
    );
  }
}

///InputScreen - это виджет, который предоставляет интерфейс для ввода данных о небесном теле (масса и радиус)
class InputScreen extends StatefulWidget {
  //StatefulWidget - базовый класс для виджетов, которые могут изменять свое состояние(extends означает, что InputScreen расширяет базовый класс для релизации ввода инфы)
  const InputScreen(); //Конструктор класса InputScreen

  @override
  _InputScreenState createState() => _InputScreenState(); //Создает состояние для виджета InputScreen(вызов конструктора)
}

///_InputScreenState - это состояние для виджета InputScreen, которое содержит данные и логику для работы с формой ввода
class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>(); //Глобальный ключ для доступа к состоянию формы и валидации введенных данных
  final _massController = TextEditingController(); //Контроллер для поля ввода массы
  final _radiusController = TextEditingController(); //Контроллер для поля ввода радиуса
  bool _agreeToProcessData = false; //Флаг, указывающий, согласен ли пользователь на обработку данных

  @override
  void dispose() {
    //Метод вызывается при удалении виджета из дерева виджетов.  Здесь освобождаются ресурсы, связанные с контроллерами
    _massController.dispose(); //Освобождает ресурсы, связанные с контроллером массы
    _radiusController.dispose(); //Освобождает ресурсы, связанные с контроллером радиуса
    super.dispose(); //Вызывает метод dispose родительского класса
  }

  @override
  Widget build(BuildContext context) {
    //Метод build создает визуальное представление виджета
    return Scaffold(
      //Scaffold - это виджет, который предоставляет базовую структуру экрана приложения, такую как AppBar и Body
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Юдин Данила ВМК-22'), // Заголовок экрана
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), 
        child: Form(
          //Form - это виджет, который управляет формой ввода данных
          key: _formKey, //Задает ключ для доступа к состоянию формы
          child: Column(
            children: [
              TextFormField(
                controller: _massController, //Задает контроллер для текстового поля массы
                keyboardType: const TextInputType.numberWithOptions(decimal: true), //Задает тип клавиатуры, позволяющий вводить числа с десятичной точкой
                decoration: const InputDecoration(
                  //InputDecoration - это виджет, который оформляет текстовое поле
                  labelText: 'Масса (кг)', // Задает лейбл текстового поля
                  border: OutlineInputBorder(), // Задает рамку вокруг текстового поля
                ),
                validator: (value) {
                  //Валидатор
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите массу'; 
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйства, введите корректное число'; 
                  }
                  if (double.parse(value) <= 0) {
                    return 'Масса должна быть больше нуля'; 
                  }
                  return null; //Возвращает null, если валидация прошла успешно
                },
                inputFormatters: [
                  //Задает форматтеры ввода, которые ограничивают допустимые символы через регулярные выражения
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), //Разрешает ввод только цифр и одной десятичной точки
                ],
              ),
              const SizedBox(height: 16), //SizedBox - это виджет, который создает пустое пространство между виджетами
              TextFormField(
                controller: _radiusController, // Задает контроллер для текстового поля радиуса
                keyboardType: const TextInputType.numberWithOptions(decimal: true), 
                decoration: const InputDecoration(
                  labelText: 'Радиус(метры)', //Задает лейбл текстового поля
                  border: OutlineInputBorder(), //Задает рамку вокруг текстового поля
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите радиус'; 
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста введите корректное число'; 
                  }
                  if (double.parse(value) <= 0) {
                    return 'Радиус должен быть больше 0'; 
                  }
                  return null; 
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), 
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToProcessData, //Задает состояние флажка
                    onChanged: (value) {
                      //Callback-функция, вызываемая при изменении состояния флажка
                      setState(() {
                        //Метод setState перестраивает виджет с новым состоянием
                        _agreeToProcessData = value!; //Меняет состояние флажка
                      });
                    },
                  ),
                  const Text('Соглашаюсь на обработку данных'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                //ElevatedButton - это виджет, который предоставляет кнопку
                onPressed: () {
                  //Callback-функция, вызываемая при нажатии на кнопку
                  if (_formKey.currentState!.validate() && _agreeToProcessData) {
                    //Проверяет, что форма прошла валидацию и пользователь согласился на обработку данных
                    final double mass = double.parse(_massController.text); //Получает введенную массу из контроллера и преобразует ее в число
                    final double radius = double.parse(_radiusController.text); //Получает введенный радиус из контроллера и преобразует его в число

                    showDialog(
                      //Отображает диалоговое окно
                      context: context, //Контекст текущего виджета
                      builder: (BuildContext context) {
                        //Builder - функция, которая создает содержимое диалогового окна
                        const double gravitationalConstant = 6.67430e-11; 
                        final double acceleration = (gravitationalConstant * mass) / (radius * radius); 

                        return AlertDialog(
                          //AlertDialog - это виджет, который предоставляет диалоговое окно с заголовком, содержимым и кнопками
                          title: const Text('Ускорение свободного падения'), //Заголовок диалогового окна
                          content: Text(
                            'Ускорение свободного падения: ${acceleration} м/с²',
                          ),
                          actions: [
                            TextButton(
                              //TextButton - это виджет, который предоставляет текстовую кнопку
                              onPressed: () {
                                //Callback-функция, вызываемая при нажатии на кнопку
                                Navigator.of(context).pop(); //Закрывает диалоговое окно
                              },
                              child: const Text('Закрыть'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    //Если пользователь не согласился на обработку данных
                    if (!_agreeToProcessData) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        //Отображает SnackBar (небольшое всплывающее уведомление)
                        const SnackBar(content: Text('Пожалуйста, подтвердите согласие на обработку данных')),
                      );
                    }
                  }
                },
                child: const Text('Вычислить'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}