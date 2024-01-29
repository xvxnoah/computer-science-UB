//React
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { AuthProvider } from "./AuthContext";

//Bootstrap
import { Container } from "react-bootstrap";

//Components
import KasulaNavbar from "./KasulaNavbar";
import Login from "./Login";
import Signup from "./Signup";
import PasswordRecovery from "./PasswordRecovery";
import PasswordChange from "./PasswordChange";
import UserFeed from "./UserFeed";
import RecipeDetail from "./RecipeDetail";
import UserProfile from "./UserProfile";
import Collections from "./Collections";
import CollectionView from "./CollectionView";

//CSS
import "../css/Transitions.css";
import "../css/Root.css";
import "../css/common.css";
import "../css/slider.css";

function Root() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route
            path="/"
            element={
              <>
                <KasulaNavbar></KasulaNavbar>
                <Container fluid className="bg-lightest min-vh-100">
                  <UserFeed></UserFeed>
                </Container>
              </>
            }
          ></Route>
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route
            path="/RecipeDetail/:id"
            element={
              <>
                <KasulaNavbar></KasulaNavbar>
                <Container fluid className="bg-lightest min-vh-100">
                  <RecipeDetail></RecipeDetail>
                </Container>
              </>
            }
          ></Route>
          <Route path="/passwordrecovery" element={<PasswordRecovery />} />
          <Route path="/passwordrecovery/set" element={<PasswordChange />} />
          <Route
            path="userprofile/:userId"
            element={
              <>
                <KasulaNavbar></KasulaNavbar>
                <Container fluid className="bg-lightest min-vh-100">
                  <UserProfile></UserProfile>
                </Container>
              </>
            }
          ></Route>
          <Route
            path="/collections"
            element={
              <>
                <KasulaNavbar></KasulaNavbar>
                <Container fluid className="bg-lightest min-vh-100">
                  <Collections></Collections>
                </Container>
              </>
            }
          />
          <Route
            path="/collections/:id/:name"
            element={
              <>
                <KasulaNavbar></KasulaNavbar>
                <Container fluid className="bg-lightest min-vh-100">
                  <CollectionView></CollectionView>
                </Container>
              </>
            }
          />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default Root;
