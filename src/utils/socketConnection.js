const ws = new WebSocket("ws://localhost:5000");

ws.onopen = () => {
  console.log("WebSocket connection established");
};

ws.onmessage = (event) => {
  console.log("WebSocket message received:", event.data);
};

ws.onerror = (error) => {
  console.error("WebSocket error:", error);
};

ws.onclose = (event) => {
  console.log("WebSocket connection closed:", event.code, event.reason);
};

export default ws;
