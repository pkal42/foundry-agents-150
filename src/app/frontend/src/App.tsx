import { useLightbulb } from "./hooks/useLightbulb";
import Lightbulb from "./components/Lightbulb";

function App() {
  const { isOn, color, loading, error } = useLightbulb();

  return (
    <div
      style={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        backgroundColor: "#1a1a2e",
        color: "#ffffff",
        fontFamily: "system-ui, sans-serif",
        textAlign: "center",
        padding: "2rem",
      }}
    >
      <h1 style={{ fontSize: "2.4rem", margin: 0 }}>Foundry Agents 150</h1>
      <p style={{ fontSize: "1.2rem", color: "#94a3b8", marginTop: "0.25rem" }}>
        Lightbulb Demo
      </p>

      {loading ? (
        <p style={{ marginTop: "3rem", color: "#94a3b8" }}>Loading…</p>
      ) : error ? (
        <div style={{ marginTop: "3rem", color: "#f87171" }}>
          <p>⚠️ Could not reach the API</p>
          <p style={{ fontSize: "0.85rem", color: "#94a3b8" }}>
            Make sure the backend is running. ({error})
          </p>
        </div>
      ) : (
        <>
          <div style={{ margin: "2rem 0" }}>
            <Lightbulb isOn={isOn} color={color} />
          </div>
          <p style={{ fontSize: "1.1rem" }}>
            Status: <strong>{isOn ? "ON" : "OFF"}</strong>
          </p>
          <p style={{ fontSize: "1.1rem", color: "#94a3b8" }}>
            Color: <span style={{ color }}>{color}</span>
          </p>
        </>
      )}
    </div>
  );
}

export default App;
