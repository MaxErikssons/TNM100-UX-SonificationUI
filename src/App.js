import { useEffect, useState } from "react";
import "./App.css";
import Layout from "./components/layout";
import WebSocketContext from "./utils/websocketContext";
import { Provider } from "react-redux";
import store from "./redux/store";

function App() {
  const [ws, setWs] = useState(null);

  useEffect(() => {
    const newWs = new WebSocket("ws://localhost:5000");

    newWs.onopen = () => {
      console.log("WebSocket connection established");
    };

    newWs.onmessage = (event) => {
      console.log("WebSocket message received:", event.data);
    };

    newWs.onerror = (error) => {
      console.error("WebSocket error:", error);
    };

    newWs.onclose = (event) => {
      console.log("WebSocket connection closed:", event.code, event.reason);
    };

    setWs(newWs);

    return () => {
      if (newWs.readyState === 1) {
        newWs.close();
      }
    };
  }, []);

  return (
    <Provider store={store}>
      <WebSocketContext.Provider value={ws}>
        <Layout />
      </WebSocketContext.Provider>
    </Provider>
  );
}

export default App;
