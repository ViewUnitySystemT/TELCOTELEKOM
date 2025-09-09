export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    if (url.pathname !== "/ws") {
      return new Response("PeerLink Signaling Worker", { status: 200 });
    }
    if (request.headers.get("Upgrade") !== "websocket") {
      return new Response("Expected WebSocket", { status: 426 });
    }

    const pair = new WebSocketPair();
    const [client, server] = Object.values(pair);

    server.accept();
    server.addEventListener("message", (evt) => {
      // Simple relay-ready: echo back ping/pong and forward type-only checks
      try {
        const msg = JSON.parse(typeof evt.data === 'string' ? evt.data : "{}");
        if (msg.type === 'ping') {
          server.send(JSON.stringify({ type: 'pong' }));
          return;
        }
        // For production: attach to Durable Object room by msg.room
        server.send(JSON.stringify({ type: 'ack', echo: msg?.type || 'unknown' }));
      } catch (_) {
        server.send(JSON.stringify({ type: 'error', message: 'invalid json' }));
      }
    });

    server.addEventListener("close", () => {
      try { server.close(); } catch {}
    });

    return new Response(null, { status: 101, webSocket: client });
  }
};
