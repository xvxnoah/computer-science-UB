//Logic packages
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useLocation } from "react-router-dom";

//React components
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
import {
  ArrowLeft,
  CheckCircleFill,
  ExclamationTriangleFill,
  Eye,
  EyeSlash,
} from "react-bootstrap-icons";

//Styles
import "../css/common.css";

//Assets
import logo from "../assets/logo.png";

function PasswordChange() {
  const location = useLocation();
  const { email } = location.state;

  const [verificationCode, setVerificationCode] = useState("");
  const [verificationCodeValid, setVerificationCodeValid] = useState(false);
  const [verificationCodeValidated, setVerificationCodeValidated] =
    useState(false);
  const [verificationCodeErrorMessage, setVerificationCodeErrorMessage] =
    useState("This field is required");

  const [password, setPassword] = useState("");
  const [passwordValid, setPasswordValid] = useState(false);
  const [passwordValidated, setPasswordValidated] = useState(false);
  const [passwordErrorMessage, setPasswordErrorMessage] = useState(
    "This field is required"
  );
  const [showPassword, setShowPassword] = useState(false);

  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordsMatch, setPasswordsMatch] = useState(false);
  const [confirmPasswordValidated, setConfirmPasswordValidated] =
    useState(false);
  const [confirmPasswordErrorMessage, setConfirmPasswordErrorMessage] =
    useState("This field is required");
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const [updateSuccess, setUpdateSuccess] = useState(false);
  const [showUpdateConfirmation, setShowUpdateConfirmation] = useState(false);
  const [updateConfirmationMessage, setUpdateConfirmationMessage] =
    useState("");

  const navigate = useNavigate();

  const isPasswordSecure = (pwd = "") => {
    setPasswordValid(false);

    if (pwd.length === 0) {
      setPasswordErrorMessage("This field is required");
    } else if (pwd.length < 8) {
      setPasswordErrorMessage("Password must be at least 8 characters long");
    } else if (pwd.search(/[a-z]/i) < 0) {
      setPasswordErrorMessage("Password must contain at least one letter");
    } else if (pwd.search(/[A-Z]/) < 0) {
      setPasswordErrorMessage(
        "Password must contain at least one capital letter"
      );
    } else if (pwd.search(/[0-9]/) < 0) {
      setPasswordErrorMessage("Password must contain at least one number");
    } else if (pwd.search(/[ !@#$%^&\*-\._,;ºª\\/()~?¿¡:="·<>{}[\]+]/) < 0) {
      setPasswordErrorMessage(
        "Password must contain at least one special character"
      );
    } else {
      setPasswordErrorMessage("");
      setPasswordValid(true);
    }

    setPasswordValidated(true);
  };

  const checkPasswordsMatch = (pwd = "", confirmPwd = "") => {
    setPasswordsMatch(false);
    if (pwd.length === 0) {
      setConfirmPasswordErrorMessage("This field is required");
    } else if (pwd !== confirmPwd) {
      setConfirmPasswordErrorMessage("Passwords do not match");
    } else {
      setConfirmPasswordErrorMessage("");
      setPasswordsMatch(true);
    }

    setConfirmPasswordValidated(true);
  };

  const isVerificationCodeValid = (code = "") => {
    if (code.length === 0) {
      setVerificationCodeErrorMessage("This field is required");
      setVerificationCodeValid(false);
    } else if (code.search(/[0-9]/) < 0) {
      setVerificationCodeErrorMessage("Verification code must be a number");
      setVerificationCodeValid(false);
    } else if (code.length !== 6) {
      setVerificationCodeErrorMessage("Verification code must be 6 digits");
      setVerificationCodeValid(false);
    } else {
      setVerificationCodeErrorMessage("");
      setVerificationCodeValid(true);
    }
    setVerificationCodeValidated(true);
  };

  const requestPasswordChange = async () => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/user/password_recovery/"
          .concat(email)
          .concat("?verification_code=")
          .concat(verificationCode),
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ password: password }),
        }
      );
      if (!response.ok) {
        setVerificationCodeValid(false);
        const data = await response.json();
        if (data && data.detail) {
          setUpdateConfirmationMessage(data.detail);
        } else {
          setUpdateConfirmationMessage(
            "Could not check verification code. Please try again later."
          );
          setShowUpdateConfirmation(true);
        }
      } else {
        const data = await response.json();
        setVerificationCodeValid(data.status);
        if (!data.status) {
          setVerificationCodeErrorMessage("Verification code is incorrect.");
        } else {
          setVerificationCodeErrorMessage("");
          setUpdateConfirmationMessage("Password updated successfully.");
          setUpdateSuccess(true);
          setShowUpdateConfirmation(true);
        }
      }
    } catch (error) {
      setUpdateConfirmationMessage(
        "Could not check verification code. Please try again later."
      );
      setVerificationCodeValid(false);
      setShowUpdateConfirmation(true);
    }
    setVerificationCodeValidated(true);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();

    isPasswordSecure(password);
    checkPasswordsMatch(password, confirmPassword);
    isVerificationCodeValid(verificationCode);

    if (passwordValid && passwordsMatch && verificationCodeValid) {
      requestPasswordChange();
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
                  className="text-decoration-none fs-3 text-reset my-2"
                  onClick={() => navigate("/login")}
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
                <h1 className="text-center fs-3">Set New Password</h1>
              </Col>
            </Row>
            <Row>
              <Col>
                <p className="mx-4 mb-4 fs-6 fw-normal text-center">
                  We have sent a verification code to your email address. Please
                  enter it below and set your new password.
                </p>
              </Col>
            </Row>
            <Row className="px-4">
              <Col>
                <Form noValidate onSubmit={handleSubmit}>
                  <Form.Group className="mb-4" controlId="formVerificationCode">
                    <Form.Label>Verification Code</Form.Label>
                    <Form.Control
                      className={
                        verificationCodeValidated && !verificationCodeValid
                          ? "is-invalid"
                          : ""
                      }
                      type="text"
                      placeholder="Type your verification code"
                      onChange={(e) => {
                        setVerificationCode(e.target.value);
                        isVerificationCodeValid(e.target.value);
                        if (e.target.value.length === 0) {
                          setVerificationCodeValidated(false);
                        }
                      }}
                      value={verificationCode}
                    />
                    <Form.Control.Feedback type="invalid">
                      {verificationCodeErrorMessage}
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
                        onChange={(e) => {
                          setPassword(e.target.value);
                          isPasswordSecure(e.target.value);
                          if (e.target.value.length === 0) {
                            setPasswordValidated(false);
                          }
                        }}
                        value={password}
                      />
                      <InputGroup.Text
                        className="password-icon"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? <EyeSlash /> : <Eye />}
                      </InputGroup.Text>
                      <Form.Control.Feedback type="invalid">
                        {passwordErrorMessage}
                      </Form.Control.Feedback>
                    </InputGroup>
                  </Form.Group>
                  <Form.Group className="mb-5" controlId="formConfirmPassword">
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
                        onChange={(e) => {
                          setConfirmPassword(e.target.value);
                          checkPasswordsMatch(password, e.target.value);
                          if (e.target.value.length === 0) {
                            setConfirmPasswordValidated(false);
                          }
                        }}
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
                        {confirmPasswordErrorMessage}
                      </Form.Control.Feedback>
                    </InputGroup>
                  </Form.Group>
                  <Row>
                    <Col sm={3}></Col>
                    <Col sm={6}>
                      <Button
                        className="w-100 mb-4 border-0"
                        variant="primary"
                        type="submit"
                        id="mainButton"
                      >
                        Set Password
                      </Button>
                    </Col>
                    <Col sm={3}></Col>
                  </Row>
                </Form>
              </Col>
            </Row>
          </Col>
          <Col sm={4}></Col>
        </Row>
      </Container>
      <Modal
        show={showUpdateConfirmation}
        size="sm"
        onHide={() => navigate("/login")}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            {updateSuccess
              ? "Password update success"
              : "Password update Error"}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Row>
            <Col className="text-center mb-4">
              {updateSuccess ? (
                <CheckCircleFill className="text-success" size={100} />
              ) : (
                <ExclamationTriangleFill className="text-warning" size={100} />
              )}
            </Col>
          </Row>
          <Row>
            <Col className="text-center">
              <p>{updateConfirmationMessage}</p>
            </Col>
          </Row>
        </Modal.Body>
        <Modal.Footer>
          <Button
            variant={updateSuccess ? "success" : "secondary"}
            onClick={() => navigate("/login")}
          >
            {updateSuccess ? "Go to login" : "Close"}
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}

export default PasswordChange;
