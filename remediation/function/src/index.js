const { app } = require('@azure/functions');

const WATCHED = [
  'microsoft.web/sites/write',
  'microsoft.web/sites/config/write',
  'microsoft.storage/storageaccounts/write',
];
const OID_CLAIM = 'http://schemas.microsoft.com/identity/claims/objectidentifier';

app.eventGrid('driftRelay', {
  handler: async (event, context) => {
    const data = event.data || {};
    const op = String(data.operationName || '').toLowerCase();
    const caller = (data.claims && data.claims[OID_CLAIM]) || '';
    const ignored = (process.env.IGNORE_PRINCIPAL_IDS || '')
      .split(',').map((s) => s.trim()).filter(Boolean);

    if (!WATCHED.includes(op)) {
      context.log(`Skipped operation ${op}`);
      return;
    }
    if (ignored.includes(caller)) {
      context.log(`Skipped change made by pipeline identity ${caller}`);
      return;
    }

    const res = await fetch(`https://api.github.com/repos/${process.env.GITHUB_REPO}/dispatches`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.DISPATCH_TOKEN}`,
        Accept: 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
        'User-Agent': 'zt-remediation-relay',
      },
      body: JSON.stringify({
        event_type: 'drift-detected',
        client_payload: {
          resource: event.subject,
          operation: op,
          caller,
          eventTime: event.eventTime,
          eventId: event.id,
        },
      }),
    });

    if (res.status !== 204) {
      throw new Error(`GitHub dispatch failed: ${res.status} ${await res.text()}`);
    }
    context.log(`Dispatched remediation for ${event.subject} (event ${event.id})`);
  },
});
