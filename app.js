// app.js
const http = require('http');

const server = http.createServer((req, res) => {
  res.end('👋 Welcome to the Matrix.\n');
});

server.listen(3000, () => {
  console.log('Server running at http://localhost:3000');
});
