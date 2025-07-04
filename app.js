const http = require('http');
const PORT = 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end('<h1>🐥 Big Bird from Node.js!</h1>');
}).listen(PORT, () => {
  console.log(`Node app listening at http://localhost:${PORT}`);
});
