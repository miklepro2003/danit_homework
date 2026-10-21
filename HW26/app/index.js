const express = require('express'); // подключаем express
const app = express(); // создаём приложение
const PORT = process.env.PORT || 10000; // порт из переменной окружения, если её нет, то 10000

app.get('/', (req, res) => { // маршрут главной страницы
  console.log('Home route accessed, path: ' + req.path); // пишем в лог, какой путь запросили
  res.send('Home route accessed, Hello from NodeJS!'); // отвечаем клиенту текстом
});

app.get('/error', (req, res) => { // маршрут /error, имитация ошибки
  console.error('An error occurred with NodeJS!, path: ' + req.path); // пишем ошибку в stderr
  res.status(500).send('An error occured!'); // отвечаем кодом 500 и текстом
});

app.listen(PORT, '0.0.0.0', () => { // запускаем сервер, слушаем на всех интерфейсах
  console.log('Server is running on port ' + PORT); // сообщение при старте
});