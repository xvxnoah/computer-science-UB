//Logic packages
import { useAuth } from "./AuthContext";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import queryString from "query-string";

//React components
import {
  Container,
  Row,
  Col,
  Button,
  Form,
  Image,
  InputGroup,
} from "react-bootstrap";
import { ArrowLeft, Eye, EyeSlash } from "react-bootstrap-icons";

//Styles
import "../css/common.css";

//Assets
import logo from "../assets/logo.png";

function Login() {
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const { token, setToken } = useAuth();

  const navigate = useNavigate();

  const [showPassword, setShowPassword] = useState(false);

  const [identifierFilled, setIdentifierFilled] = useState(false);
  const [passwordFilled, setPasswordFilled] = useState(false);

  const [identifierValidated, setIdentifierValidated] = useState(false);
  const [passwordValidated, setPasswordValidated] = useState(false);

  const [loginError, setLoginError] = useState(false);
  const [loginErrorMessage, setLoginErrorMessage] = useState("");

  /* Requests */

  useEffect(() => {
    if (localStorage.getItem("logged") === "true") {
      navigate("/");
    }
  }, [localStorage.getItem("logged"), navigate]);

  const loginRequest = async (identifier, password) => {
    const api_url = process.env.REACT_APP_API_URL + "/user/token";
    const requestBody = queryString.stringify({
      grant_type: "",
      username: identifier,
      password,
      scope: "",
      client_id: "",
      client_secret: "",
    });

    try {
      const response = await fetch(api_url, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          accept: "application/json",
        },
        body: requestBody,
      });

      if (!response.ok) {
        setLoginError(true);
        setIdentifierValidated(true);
        setPasswordValidated(true);
        const data = await response.json();
        if (data && data.detail) {
          setLoginErrorMessage(data.detail);
        } else {
          setLoginErrorMessage("Something went wrong. Please try again later.");
        }
      } else {
        const data = await response.json();
        setToken(data.access_token);
        localStorage.setItem("logged", true); 
        localStorage.setItem("token", data.access_token);
        navigate("/");
      }
    } catch (error) {
      setLoginError(true);
      setLoginErrorMessage("Something went wrong. Please try again later.");
    }
  };

  /* Events */

  const onIdentifierChange = (e) => {
    setIdentifier(e.target.value);
    setIdentifierFilled(e.target.value.length > 0);
    setIdentifierValidated(false);
  };

  const onPasswordChange = (e) => {
    setPassword(e.target.value);
    setPasswordFilled(e.target.value.length > 0);
    setPasswordValidated(false);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (identifier.length === 0) {
      setIdentifierFilled(false);
      setIdentifierValidated(true);
    }
    if (password.length === 0) {
      setPasswordFilled(false);
      setPasswordValidated(true);
    }

    if (identifierFilled && passwordFilled) {
      try {
        loginRequest(identifier, password);
      } catch (error) {
        console.log(error);
      }
    }
  };

  return (
    <div>
      <Container className="py-5 min-vh-100">
        <Row>
          <Col sm={4}></Col>
          <Col sm={4} className="form-container rounded">
            <Row>
              <Col sm={1}>
                <Button
                  variant="link"
                  className="text-decoration-none fs-3 text-reset my-2 colorless-span-button"
                  onClick={() => navigate("/")}
                >
                  <ArrowLeft></ArrowLeft>
                </Button>
              </Col>
              <Col sm={11}></Col>
            </Row>
            <Row>
              <Col sm={4}></Col>
              <Col sm={4}>
                <Image className="mb-4" src={logo} fluid />
              </Col>
              <Col sm={4}></Col>
            </Row>
            <Row className="mb-4">
              <Col>
                <h1 className="fw-bold text-center">Login</h1>
              </Col>
            </Row>
            <Row className="px-4">
              <Form noValidate onSubmit={handleSubmit}>
                <Form.Group className="mb-4" controlId="formUserIdentifier">
                  <Form.Label>Username or Email</Form.Label>
                  <Form.Control
                    className={
                      identifierValidated && (!identifierFilled || loginError)
                        ? "is-invalid"
                        : ""
                    }
                    type="text"
                    placeholder="Type your username or email"
                    value={identifier}
                    onChange={onIdentifierChange}
                  />
                  <Form.Control.Feedback type="invalid">
                    {loginError
                      ? ""
                      : "Please provide a valid username or email."}
                  </Form.Control.Feedback>
                </Form.Group>
                <Form.Group className="mb-1" controlId="formUserPassword">
                  <Form.Label>Password</Form.Label>
                  <InputGroup>
                    <Form.Control
                      className={
                        passwordValidated && (!passwordFilled || loginError)
                          ? "is-invalid"
                          : ""
                      }
                      type={showPassword ? "text" : "password"}
                      placeholder="Type your password"
                      value={password}
                      onChange={onPasswordChange}
                    />
                    <InputGroup.Text
                      className="password-icon"
                      onClick={() => setShowPassword(!showPassword)}
                    >
                      {showPassword ? <EyeSlash></EyeSlash> : <Eye></Eye>}
                    </InputGroup.Text>
                    <Form.Control.Feedback type="invalid">
                      {loginError ? "" : "Please provide a valid password."}
                    </Form.Control.Feedback>
                  </InputGroup>
                </Form.Group>
                <Row className="mb-5">
                  <Col sm={12}>
                    <a
                      href="/passwordrecovery"
                      className="text-decoration-none fs-6"
                    >
                      Forgot your password?
                    </a>
                  </Col>
                </Row>
                {loginError ? (
                  <Row className="mb-1">
                    <Col sm={12}>
                      <p className="text-danger text-center fs-6">
                        {loginErrorMessage}
                      </p>
                    </Col>
                  </Row>
                ) : (
                  ""
                )}
                <Row>
                  <Col sm={3}></Col>
                  <Col sm={6}>
                    <Button
                      className="w-100 mb-5 border-0"
                      variant="primary"
                      type="submit"
                      id="mainButton"
                    >
                      LOG IN
                    </Button>
                  </Col>
                  <Col sm={3}></Col>
                </Row>
                <Row>
                  <Col sm={12} className="text-center">
                    Don't have an account?
                  </Col>
                </Row>
                <Row className="mb-4">
                  <Col sm={12} className="text-center">
                    <a href="/signup" className="text-decoration-none fw-bold">
                      Sign up
                    </a>
                  </Col>
                </Row>
              </Form>
            </Row>
          </Col>
          <Col sm={4}></Col>
        </Row>
      </Container>
    </div>
  );
}

export default Login;
