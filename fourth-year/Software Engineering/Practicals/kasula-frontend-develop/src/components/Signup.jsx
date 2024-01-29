//Logic packages
import { useState } from "react";
import { useNavigate } from "react-router-dom";

//React Components
import {
  Container,
  Row,
  Col,
  Button,
  Form,
  Image,
  InputGroup,
  Modal,
} from "react-bootstrap";
import { ArrowLeft, CheckCircleFill, Eye, EyeSlash, ExclamationTriangleFill } from "react-bootstrap-icons";

//Styles
import "../css/common.css";

//Assets
import logo from "../assets/logo.png";
import terms from "../assets/jsonData/terms.json";

function Signup() {
  /* Variables */

  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [bio, setBio] = useState("");
  const [acceptTerms, setAcceptTerms] = useState(false);

  const [usernameValid, setUsernameValid] = useState(false);
  const [usernameValidated, setUsernameValidated] = useState(false);
  const [emailValid, setEmailValid] = useState(false);
  const [emailValidated, setEmailValidated] = useState(false);
  const [passwordValid, setPasswordValid] = useState(false);
  const [passwordValidated, setPasswordValidated] = useState(false);
  const [passwordsMatch, setPasswordsMatch] = useState(false);
  const [confirmPasswordValidated, setConfirmPasswordValidated] =
    useState(false);
  const [acceptTermsValidated, setAcceptTermsValidated] = useState(false);

  const [usernameValidationMessage, setUsernameValidationMessage] =
    useState("");
  const [emailValidationMessage, setEmailValidationMessage] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const [confirmPasswordError, setConfirmPasswordError] = useState("");

  const [submitMessage, setSubmitMessage] = useState("");

  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [showTerms, setShowTerms] = useState(false);
  const [showRegisterConfirmation, setShowRegisterConfirmation] = useState(false);

  const [isDoingRequest, setIsDoingRequest] = useState(false);
  const [registrationSuccess, setRegistrationSuccess] = useState(false);

  const navigate = useNavigate();

  /* Functions */

  /* Validations */

  const isUsernameValid = (username = "") => {
    if (username.length === 0) {
      setUsernameValidationMessage("This field is required");
      setUsernameValid(false);
    } else if (
      username.search(/[ !@#$%^&\*-\.,;ºª\\/()~?¿¡:="·<>{}[\]+]/) >= 0
    ) {
      setUsernameValidationMessage(
        "Username can only contain letters, numbers and underscores"
      );
      setUsernameValid(false);
    } else if (username.length < 4) {
      setUsernameValidationMessage("Username must be at least 4 characters");
      setUsernameValid(false);
    } else if (username.length > 20) {
      setUsernameValidationMessage("Username must be less than 20 characters");
      setUsernameValid(false);
    } else {
      isUsernameAvailable(username);
    }
    setUsernameValidated(true);
  };

  const isEmailValid = (email = "") => {
    if (email.length === 0) {
      setEmailValidationMessage("This field is required");
      setEmailValid(false);
    } else if (email.search(/^[^\s@]+@[^\s@]+\.[^\s@]+$/) < 0) {
      setEmailValidationMessage("Please enter a valid email address");
      setEmailValid(false);
    } else {
      isEmailAvailable(email);
    }
    setEmailValidated(true);
  };

  const isPasswordSecure = (pwd = "") => {
    setPasswordValid(false);

    if (pwd.length === 0) {
      setPasswordError("This field is required");
    } else if (pwd.length < 8) {
      setPasswordError("Password must be at least 8 characters long");
    } else if (pwd.search(/[a-z]/i) < 0) {
      setPasswordError("Password must contain at least one letter");
    } else if (pwd.search(/[A-Z]/) < 0) {
      setPasswordError("Password must contain at least one capital letter");
    } else if (pwd.search(/[0-9]/) < 0) {
      setPasswordError("Password must contain at least one number");
    } else if (pwd.search(/[ !@#$%^&\*-\._,;ºª\\/()~?¿¡:="·<>{}[\]+]/) < 0) {
      setPasswordError("Password must contain at least one special character");
    } else {
      setPasswordError("");
      setPasswordValid(true);
    }

    setPasswordValidated(true);
  };

  const checkPasswordsMatch = (pwd = "", confirmPwd = "") => {
    setPasswordsMatch(false);
    if (pwd.length === 0) {
      setConfirmPasswordError("This field is required");
    } else if (pwd !== confirmPwd) {
      setConfirmPasswordError("Passwords do not match");
    } else {
      setConfirmPasswordError("");
      setPasswordsMatch(true);
    }

    setConfirmPasswordValidated(true);
  };

  /* Requests */

  const isUsernameAvailable = async (username = "") => {
    if (!isDoingRequest) {
      setIsDoingRequest(true);
      try {
        const response = await fetch(
          process.env.REACT_APP_API_URL + "/user/check_username/".concat(username),
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        if (!response.ok) {
          const data = await response.json();
          if (data && data.detail) {
            setUsernameValidationMessage(data.detail);
          } else {
            setUsernameValidationMessage(
              "Could not check if username is available. Please try again later."
            );
          }
        } else {
          const data = await response.json();
          setUsernameValidationMessage(data.message);
          setUsernameValid(data.status);
        }
      } catch (error) {
        setUsernameValidationMessage(
          "Could not check if username is available. Please try again later."
        );
      } finally {
        setIsDoingRequest(false);
      }
    }
  };

  const isEmailAvailable = async (email = "") => {
    if (!isDoingRequest) {
      setIsDoingRequest(true);
      try {
        const response = await fetch(process.env.REACT_APP_API_URL + "/user/check_email/".concat(email),
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        if (!response.ok) {
          const data = await response.json();
          if (data && data.detail) {
            setEmailValidationMessage(data.detail);
          } else {
            setEmailValidationMessage(
              "Could not check if email is available. Please try again later."
            );
          }
        } else {
          const data = await response.json();
          setEmailValidationMessage(data.message);
          setEmailValid(data.status);
        }
      } catch (error) {
        setEmailValidationMessage(
          "Could not check if email is available. Please try again later."
        );
      } finally {
        setIsDoingRequest(false);
      }
    }
  };

  const registerUser = async () => {
    if (!isDoingRequest) {
      setIsDoingRequest(true);
      try {
        const response = await fetch(process.env.REACT_APP_API_URL + "/user/", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            username: username,
            email: email,
            password: password,
            bio: bio || "",
          }),
        });
        if (!response.ok) {
          const data = await response.json();
          if (data && data.detail) {
            setSubmitMessage(data.detail);
          } else {
            setSubmitMessage(
              "There has been an unexpected error. Please try again later."
            );
          }
          setRegistrationSuccess(false);
        } else {
          const data = await response.json();
          setSubmitMessage("User registered successfully!");
          setRegistrationSuccess(true);
        }
      } catch (error) {
        setSubmitMessage(error.JSON.stringify);
        setRegistrationSuccess(false);
      } finally {
        setIsDoingRequest(false);
        setShowRegisterConfirmation(true);
      }
    }
  };

  /* Events */

  const onUsernameChange = ({ target: { value } }) => {
    setUsername(value);
    isUsernameValid(value);
    if (value.length === 0) {
      setUsernameValidated(false);
    }
  };

  const onEmailChange = ({ target: { value } }) => {
    setEmail(value);
    isEmailValid(value);
    if (value.length === 0) {
      setEmailValidated(false);
    }
  };

  const onPasswordChange = ({ target: { value } }) => {
    setPassword(value);
    isPasswordSecure(value);
    if (value.length === 0) {
      setPasswordValidated(false);
    }
  };

  const onConfirmPasswordChange = ({ target: { value } }) => {
    setConfirmPassword(value);
    checkPasswordsMatch(password, value);
    if (value.length === 0) {
      setConfirmPasswordValidated(false);
    }
  };

  const handleTermsShow = () => setShowTerms(true);
  const handleTermsClose = () => setShowTerms(false);
  const handleTermsAccept = () => {
    setAcceptTerms(true);
    setShowTerms(false);
  };

  const handleRegisterConfirmationClose = () => {
    setShowRegisterConfirmation(false);
    if (registrationSuccess) {
      navigate("/login");
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    isUsernameValid(username);
    isEmailValid(email);
    isPasswordSecure(password);
    checkPasswordsMatch(password, confirmPassword);
    setAcceptTermsValidated(true);

    if (
      !usernameValid ||
      !emailValid ||
      !passwordValid ||
      !passwordsMatch ||
      !acceptTerms
    ) {
      return;
    } else {
      registerUser();
    }
  };

  /* Render */

  return (
    <div>
      <Container className="py-5 min-vh-100">
        <Row>
          <Col sm={3}></Col>
          <Col sm={6} className="form-container rounded">
            <Row>
                <Col sm={1}>
                    <Button variant="link" className="text-decoration-none fs-3 text-reset my-2" onClick={() => navigate("/login")}>
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
                <h1 className="fw-bold text-center">Register</h1>
              </Col>
            </Row>
            <Row>
              <Col>
                <p className="mx-4 mb-4 fs-6 fw-normal text-center">
                  Register and enjoy the benefits of Posting your own recipes
                  and providing feedback to others! You will also be able to
                  save your favourite recipes!
                </p>
              </Col>
            </Row>
            <Row className="px-4">
              <Form noValidate onSubmit={handleSubmit}>
                <Form.Group className="mb-4" controlId="formUsername">
                  <Form.Label>User</Form.Label>
                  <Form.Control
                    className={
                      usernameValidated
                        ? usernameValid
                          ? "is-valid"
                          : "is-invalid"
                        : ""
                    }
                    type="text"
                    placeholder="Type your username"
                    onChange={onUsernameChange}
                    value={username}
                  />
                  <Form.Control.Feedback
                    type={usernameValid ? "valid" : "invalid"}
                  >
                    {usernameValidationMessage}
                  </Form.Control.Feedback>
                </Form.Group>
                <Form.Group className="mb-4" controlId="formEmail">
                  <Form.Label>Email</Form.Label>
                  <Form.Control
                    className={
                      emailValidated
                        ? emailValid
                          ? "is-valid"
                          : "is-invalid"
                        : ""
                    }
                    type="email"
                    placeholder="Type your email"
                    onChange={onEmailChange}
                    value={email}
                  />
                  <Form.Control.Feedback
                    type={emailValid ? "valid" : "invalid"}
                  >
                    {emailValidationMessage}
                  </Form.Control.Feedback>
                </Form.Group>
                <Form.Group className="mb-4" controlId="formPassword">
                  <Form.Label>Password</Form.Label>
                  <InputGroup>
                    <Form.Control
                      className={
                        passwordValidated
                          ? passwordValid
                            ? "is-valid"
                            : "is-invalid"
                          : ""
                      }
                      type={showPassword ? "text" : "password"}
                      placeholder="Type your password"
                      onChange={onPasswordChange}
                      value={password}
                    />
                    <InputGroup.Text
                      className="password-icon"
                      onClick={() => setShowPassword(!showPassword)}
                    >
                      {showPassword ? <EyeSlash /> : <Eye />}
                    </InputGroup.Text>
                    <Form.Control.Feedback type="invalid">
                      {passwordError}
                    </Form.Control.Feedback>
                  </InputGroup>
                </Form.Group>
                <Form.Group className="mb-4" controlId="formConfirmPassword">
                  <Form.Label>Confirm Password</Form.Label>
                  <InputGroup>
                    <Form.Control
                      className={
                        confirmPasswordValidated
                          ? passwordsMatch
                            ? "is-valid"
                            : "is-invalid"
                          : ""
                      }
                      type={showConfirmPassword ? "text" : "password"}
                      placeholder="Type your password again"
                      onChange={onConfirmPasswordChange}
                      value={confirmPassword}
                    />
                    <InputGroup.Text
                      className="password-icon"
                      onClick={() =>
                        setShowConfirmPassword(!showConfirmPassword)
                      }
                    >
                      {showConfirmPassword ? <EyeSlash /> : <Eye />}
                    </InputGroup.Text>
                    <Form.Control.Feedback type="invalid">
                      {confirmPasswordError}
                    </Form.Control.Feedback>
                  </InputGroup>
                </Form.Group>
                <Form.Group className="mb-4" controlId="formBio">
                  <Form.Label>Bio</Form.Label>
                  <Form.Control
                    as="textarea"
                    placeholder="Describe yourself (optional)"
                  />
                </Form.Group>
                <Form.Group className="mb-5" controlId="formAcceptTerms">
                  <Form.Check type="checkbox">
                    <Form.Check.Input
                      type="checkbox"
                      isInvalid={acceptTermsValidated && !acceptTerms}
                      isValid={acceptTermsValidated && acceptTerms}
                      checked={acceptTerms}
                      onChange={() => {
                        setAcceptTerms(!acceptTerms);
                        setAcceptTermsValidated(false);
                      }}
                    />
                    <Form.Check.Label className="mt-1 ms-2">
                      I accept the{" "}
                      <a
                        href="#"
                        className="text-decoration-none"
                        onClick={handleTermsShow}
                      >
                        Terms of Use and Privacy Policy
                      </a>
                    </Form.Check.Label>
                    <Form.Control.Feedback type="invalid">
                      You must accept the Terms of Use and Privacy Policy
                    </Form.Control.Feedback>
                  </Form.Check>
                </Form.Group>
                <Row>
                  <Col sm={3}></Col>
                  <Col sm={6}>
                    <Button className="w-100 mb-4 border-0" variant="primary" type="submit" id="mainButton">
                    REGISTER NOW
                    </Button>
                  </Col>
                  <Col sm={3}></Col>
                </Row>
              </Form>
            </Row>
          </Col>
          <Col sm={3}></Col>
        </Row>
      </Container>

      <Modal show={showTerms} size="lg" onHide={handleTermsClose}>
        <Modal.Header closeButton className="mb-2">
          <Modal.Title>Terms of Use and Privacy Policy</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {terms.policies.map((policy, index) => (
            <Container key={index} fluid>
              <h3 className="mb-4 fw-semibold">{policy.title}</h3>
              {policy.sections.map((section, sectionIndex) => (
                <Container key={sectionIndex} fluid>
                  <h5 className="mb-3">{section.name}</h5>
                  <p className="text-right mb-4 fw-light">{section.body}</p>
                </Container>
              ))}
              {index == 0 ? <hr className="mb-4" /> : <></>}
            </Container>
          ))}
        </Modal.Body>
        <Modal.Footer>
          <Container fluid>
            <Row>
              <Col sm={7}></Col>
              <Col sm={2}>
                <Button variant="secondary" onClick={handleTermsClose}>
                  Close
                </Button>
              </Col>
              <Col sm={3}>
                <Button variant="success" onClick={handleTermsAccept}>
                  Accept
                </Button>
              </Col>
            </Row>
          </Container>
        </Modal.Footer>
      </Modal>
      
      <Modal show={showRegisterConfirmation} size="sm" onHide={handleRegisterConfirmationClose}>
        <Modal.Header closeButton>
          <Modal.Title>{registrationSuccess ? "Confirm Registration" : "Registration Error"}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Row>
            <Col className="text-center mb-4">
              {registrationSuccess ? <CheckCircleFill className="text-success" size={100} /> : <ExclamationTriangleFill className="text-warning" size={100} />}
            </Col>
          </Row>
          <Row>
            <Col className="text-center">
              <p>{submitMessage}</p>
            </Col>
          </Row>
        </Modal.Body>
        <Modal.Footer>
          <Button variant={registrationSuccess ? "success" : "secondary"} onClick={handleRegisterConfirmationClose}>
            {registrationSuccess ? "Go to login" : "Close"}
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}

export default Signup;
