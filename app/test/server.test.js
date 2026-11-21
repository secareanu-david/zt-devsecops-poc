const { test, before, after } = require('node:test');
const assert = require('node:assert');
const app = require('../src/server');

let server;
let base;

before(() => new Promise((resolve) => {
  server = app.listen(0, () => {
    base = `http://127.0.0.1:${server.address().port}`;
    resolve();
  });
}));

after(() => server.close());

test('health returns ok', async () => {
  const res = await fetch(`${base}/health`);
  assert.strictEqual(res.status, 200);
  assert.deepStrictEqual(await res.json(), { status: 'ok' });
});

test('greet answers as plain text', async () => {
  const res = await fetch(`${base}/api/greet?name=<b>x</b>`);
  assert.match(res.headers.get('content-type'), /text\/plain/);
});

test('security headers are set', async () => {
  const res = await fetch(`${base}/`);
  assert.ok(res.headers.get('content-security-policy'));
  assert.strictEqual(res.headers.get('x-powered-by'), null);
});
