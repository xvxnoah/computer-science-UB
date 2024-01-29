import React from "react";
import ReactDOM from "react-dom/client";
import reportWebVitals from "./reportWebVitals";
import Root from "./components/Root";
import 'bootstrap/dist/css/bootstrap.min.css';
import './css/index.css';

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <div className="App">
      <Root></Root>
    </div>
  </React.StrictMode>
); 

reportWebVitals();