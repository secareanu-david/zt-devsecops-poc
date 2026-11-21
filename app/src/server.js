const express = require('express');
const helmet = require('helmet');

const app = express();
app.disable('x-powered-by');
app.use(helmet());

const escapeHtml = (s) =>
  String(s).replace(/[&<>"']/g, (c) =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

app.get('/', (req, res) => {
  const build = escapeHtml(process.env.BUILD_SHA || 'local');
  res.send(`<!doctype html><html><head><meta charset="utf-8"><title>ZT DevSecOps POC</title></head>
<body><h1>Zero Trust DevSecOps POC</h1><p>Build: ${build}</p></body></html>`);
});

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/api/greet', (req, res) => {
  const name = typeof req.query.name === 'string' ? req.query.name.slice(0, 50) : 'world';
  res.json({ message: `Hello, ${name}` });
});

module.exports = app;

if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Listening on ${port}`));
}
