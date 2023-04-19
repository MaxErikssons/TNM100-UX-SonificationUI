import Setting from "./settings/setting";
import Graph from "./graph/graph";
import ProfileMenu from "./profiles/profileMenu";

const Layout = () => {
  const container = {
    display: "flex",
    flexDirection: "column",
    height: "100vh",
    width: "100%",
    backgroundColor: "#DBDBDB",
  };

  return (
    <div style={container}>
      <div style={{ background: "orange", padding: "1%" }}>
        <div style={{ fontWeight: "bold", fontSize: 24 }}>
          UTFORSKA SONIFIERING
        </div>
        <div style={{ width: "59%" }}>
          <text>
            Sonifiering innebär att datavärden kopplas till ljud och när de
            förändras förändras också ljudet. Det innebär att ljudet kan
            användas som en ljudversion av visualisering och hjälpa till att
            förtydliga och förenkla förståelsen av förändringar i data.
          </text>
          <div style={{ marginTop: "1%" }}>
            <text>Nedan visas data över....</text>
          </div>
        </div>
      </div>
      <div style={{ display: "flex" }}>
        <Graph />
        <ProfileMenu active={2} />
      </div>

      <Setting />
    </div>
  );
};

export default Layout;
